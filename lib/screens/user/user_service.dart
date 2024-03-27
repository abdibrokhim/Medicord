import 'dart:io';
import 'dart:typed_data';

import 'package:brainmri/auth/components/secure_storage.dart';
import 'package:brainmri/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:brainmri/models/observation_model.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:brainmri/models/conclusion_model.dart';
import 'package:brainmri/models/patients_model.dart';
import 'package:brainmri/store/app_logs.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';


class UserService {
  static final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  static Future<String?> _getOrganizationId() async {
    return await StorageService.readItemsFromToKeyChain().then((value) {
      return value['uuid'];
    });
  }

  
  static Future<List<PatientModel>> fetchPatients() async {
    try {
      print('Fetching patients');

      String? organizationId = await _getOrganizationId();
      if (organizationId == null) {
        return Future.error('No organization ID found');
      }

      DatabaseReference patientsRef = _firebaseDatabase.ref().child('organizations').child(organizationId).child('patients');
      DataSnapshot snapshot = (await patientsRef.once()).snapshot;

      if (snapshot.exists) {
        print('snapshot.value: ${snapshot.value}');

        List<PatientModel> patients = [];

        Map<dynamic, dynamic> patientsData = snapshot.value as Map<dynamic, dynamic>;
        print('patientsData: $patientsData');

        patientsData.forEach((patientId, patientValue) {
          Map<dynamic, dynamic> patientData = patientValue as Map<dynamic, dynamic>;
          patientData['id'] = patientId;
          print('patientId: $patientId');

          if (patientData.containsKey('observations')) {
            Map<dynamic, dynamic> observationsData = patientData['observations'] as Map<dynamic, dynamic>;
            List<ObservationModel> observationsList = [];
            
            observationsData.forEach((observationId, observationValue) {
              Map<dynamic, dynamic> observationData = observationValue as Map<dynamic, dynamic>;
              observationData['id'] = observationId;
              print('observationId: $observationId');

              if (observationData.containsKey('conclusion')) {
                Map<dynamic, dynamic> conclusionData = observationData['conclusion'] as Map<dynamic, dynamic>;
                observationData['conclusion'] = ConclusionModel.fromJson(conclusionData);
              }

              observationsList.add(ObservationModel.fromJson(observationData));
            });

            print('conclusion: ${observationsList.first.conclusion!.text}');

            patientData['observations'] = observationsList;
          }

          print('patientData: $patientData');
          patients.add(PatientModel.fromJson(patientData));
        });

        print('patients: $patients');

        return patients;
      } else {
        return [];
      }
    } catch (e) {
      return Future.error('Error while fetching patients: $e');
    }
  }




  static Future<void> updatePatientConclusion(String patientId, String observationId, String conclusion) async {
    try {
      print('Updating patient conclusion: $patientId, $observationId, $conclusion');
      
      String? organizationId = await _getOrganizationId();
      if (organizationId == null) {
        return Future.error('No organization ID found');
      }
      DatabaseReference conclusionRef = _firebaseDatabase.ref().child('organizations').child(organizationId).child('patients').child(patientId).child('observations').child(observationId).child('conclusion');
      final Map<String, Object?> jsonObject = {
        'text': conclusion,
        'updatedAt': DateTime.now().toIso8601String(),
      };
      await conclusionRef.update(jsonObject);
    } catch (e) {
      return Future.error('Error while updating patient conclusion: $e');
    }
  }

  static Future<bool> approvePatientConclusion(String patientId, String observationId, String name) async {
    try {
      print('Approving patient conclusion: $patientId, $observationId, $name');

      String? organizationId = await _getOrganizationId();
      if (organizationId == null) {
        return Future.error('No organization ID found');
      }
      DatabaseReference conclusionRef = _firebaseDatabase.ref().child('organizations').child(organizationId).child('patients').child(patientId).child('observations').child(observationId).child('conclusion');
      Map<String, Object?> jsonObject = {
        'isApproved': true,
        'headDoctorName': name,
        'updatedAt': DateTime.now().toIso8601String(),
      };
      await conclusionRef.update(jsonObject);

      return true;
    } catch (e) {
      return Future.error('Error while approving patient conclusion: $e');
    }
  }

  static Future<bool> validatePatientConclusion(String patientId, String observationId) async {
    try {
      String? organizationId = await _getOrganizationId();
      if (organizationId == null) {
        return Future.error('No organization ID found');
      }
      DatabaseReference conclusionRef = _firebaseDatabase.ref().child('organizations').child(organizationId).child('patients').child(patientId).child('observations').child(observationId).child('conclusion');
      Map<String, Object?> jsonObject = {
        'isValidated': true,
        'updatedAt': DateTime.now().toIso8601String(),
      };
      await conclusionRef.update(jsonObject);

      return true;
    } catch (e) {
      return Future.error('Error while approving patient conclusion: $e');
    }
  }


  static Future<void> savePatientObservation(String patientId, ObservationModel observationModel) async {

    try {

      print('Saving patient observation: $patientId, ${observationModel.toJson()}');

      String? organizationId = await _getOrganizationId();
      if (organizationId == null) {
        return Future.error('No organization ID found');
      }

      DatabaseReference patientRef = _firebaseDatabase.ref().child('organizations').child(organizationId).child('patients').child(patientId);
      DataSnapshot snapshot = (await patientRef.once()).snapshot;

      if (!snapshot.exists) {
        // If patient does not exist, return an error
        return Future.error('Patient with ID $patientId does not exist');
      } else {
        print('snapshot.value: ${snapshot.value}');
        // If patient exists, add a new observation under the patient record with a unique ID
        DatabaseReference observationRef = patientRef.child('observations').push();  // Generate a unique ID for the new observation
        await observationRef.set(observationModel.toJson());
      }
    } catch (e) {
      return Future.error('Error while saving patient observation: $e');
    }
  }

  static Future<void> saveNewPatient(String fullName, String birthYear) async {
    try {
      String? organizationId = await _getOrganizationId();

      AppLog.log().i('Organization ID: $organizationId');
      AppLog.log().i('Saving new patient: $fullName, $birthYear');

      if (organizationId == null) {
        return Future.error('No organization ID found');
      }
      DatabaseReference patientsRef = _firebaseDatabase.ref().child('organizations').child(organizationId).child('patients').push();
      await patientsRef.set({
        'fullName': fullName,
        'birthYear': birthYear,
      });

      AppLog.log().i('New patient saved');
    } catch (e) {
      return Future.error('Error while saving new patient: $e');
    }
  }

  static Future<List<Map<String, String>>> fetchAllPatientNames() async {
    try {
      AppLog.log().i('Fetching patient names');

      String? organizationId = await _getOrganizationId();
      if (organizationId == null) {
        return Future.error('No organization ID found');
      }
      DatabaseReference patientsRef = _firebaseDatabase.ref().child('organizations').child(organizationId).child('patients');
      print(patientsRef);
      DataSnapshot snapshot = (await patientsRef.once()).snapshot;
      if (snapshot.exists) {
        print('snapshot.value: ${snapshot.value}');
        List<Map<String, String>> patientList = [];
        Map<dynamic, dynamic> patientsData = snapshot.value as Map<dynamic, dynamic>;
        patientsData.forEach((key, value) {
          print('key: ${key}');
          print('value: ${value}');
          Map<dynamic, dynamic> patient = value as Map<dynamic, dynamic>;
          if (patient.containsKey('fullName')) {
            print('fullName: ${patient['fullName'].toString()}');
            patientList.add({'id': key, 'name': patient['fullName'].toString()});
            print('patientList: $patientList');
          }
        });

        AppLog.log().i('Patient names fetched: $patientList');
        
        return patientList;
      } else {
        return [];
      }
    } catch (e) {
      return Future.error('Error while fetching patient names: $e');
    }
  }


  static Future<String> gemini(String observation) async {
    try {
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/gemini-fine-tuned/conclusion'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'query': observation}),
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        print('Generated conclusion: $data');
        String conclusion = data['conclusion'];
        return conclusion;
      } else {
        return Future.error('Failed to generate conclusion');
      }
    } catch (e) {
      AppLog.log().e("Failed to generate conclusion: $e");
      return Future.error('Failed to generate conclusion');
    }
  }

  static Future<String> gemma(String observation) async {
    try {
      final response = await http.post(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/gemma-fine-tuned/conclusion'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'query': observation}),
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        print('Generated conclusion: $data');
        String conclusion = data['conclusion'];
        return conclusion;
      } else {
        return Future.error('Failed to generate conclusion');
      }
    } catch (e) {
      AppLog.log().e("Failed to generate conclusion: $e");
      return Future.error('Failed to generate conclusion');
    }
  }

  static String _formatDate(DateTime date) {
    // 12/12/2023
    return '${date.month}/${date.day}/${date.year}';
  }


static Future<String> generatePatientReport(PatientModel patientModel) async {
  try {
    print('Generating patient report: ${patientModel.fullName}');

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Patient Report: ${patientModel.fullName!}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Text('Full Name: ${patientModel.fullName!}', style: const pw.TextStyle(fontSize: 14)),
          pw.Text('Birth Year: ${patientModel.birthYear!}', style: const pw.TextStyle(fontSize: 14)),
          pw.Header(
            level: 1,
            child: pw.Text('Observations', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ),
          ...patientModel.observations!.map((observation) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Observation: \n${observation.text!}', style: const pw.TextStyle(fontSize: 14)),
                  pw.Text('Observed At: ${observation.observedAt != null ? _formatDate(observation.observedAt!) : ''}', style: const pw.TextStyle(fontSize: 14)),
                  pw.Text('Radiologist Name: ${observation.radiologistName!}', style: const pw.TextStyle(fontSize: 14)),
                  pw.Text('Conclusion: \n${observation.conclusion!.text!}', style: const pw.TextStyle(fontSize: 14)),
                  pw.SizedBox(height: 10),
                  pw.Text('Signed By: ${observation.conclusion!.headDoctorName!}', style: const pw.TextStyle(fontSize: 14)),
                  pw.SizedBox(height: 10),
                ],
              )).toList(),
        ],
      ),
    );

    // Get the current date and time
    DateTime now = DateTime.now();

    // Format the date and time into a string (for example, 'yyyy-MM-dd_HH-mm-ss')
    String formattedDateTime = DateFormat('yyyy-MM-dd_HH-mm-ss').format(now);

    // Get the temporary directory
    final directory = await getTemporaryDirectory();
    
    // Create the file path with the date and time appended
    final filePath = '${directory.path}/PatientReport_${patientModel.fullName}_$formattedDateTime.pdf';

    // Save the PDF file
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    print("File path: $filePath");
    print("File name: ${file.path}");

    String fileUrl = await upload(filePath);

    return fileUrl;

  } catch (e) {
    print("Error while generating patient report: $e");
    return Future.error('Failed to generate patient report due to an exception: $e');
  }
}


static Future<String> upload(String path) async {
  try {
    AppLog.log().i('Uploading file to firebase storage.');

    // Read the file data
    File file = File(path);
    Uint8List fileData = await file.readAsBytes();

    // Generate a unique file name
    String fileName = 'post_${DateTime.now().millisecondsSinceEpoch}.pdf';

    // Create a reference to the Firebase Storage location
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');

    // Set metadata for the file
    final metadata = SettableMetadata(
      contentType: 'application/pdf',
      customMetadata: {'picked-file-path': fileName},
    );

    // Upload the file to Firebase Storage
    UploadTask uploadTask = firebaseStorageRef.putData(fileData, metadata);
    // firebaseStorageRef.putFile(io.File(_imageFile!.path), metadata);
    TaskSnapshot taskSnapshot = await uploadTask;

    // Get the download URL of the uploaded file
    final fileUrl = await taskSnapshot.ref.getDownloadURL();

    AppLog.log().i('File uploaded to firebase storage.');

    return fileUrl;
  } catch (e) {
    AppLog.log().e('Failed to upload file to firebase storage: $e');
    throw Exception('Failed to upload file to firebase storage: $e');
  }
}


static Future<void> downloadFile(String reportUrl) async {
  try {
    print('Downloading file from URL: $reportUrl');

    // Get the application documents directory
    Directory directory = await getApplicationDocumentsDirectory();

    // Set the file path to save the downloaded PDF
    String fileName = 'DownloadedReport.pdf';
    String filePath = '${directory.path}/$fileName';

    // Use Dio to download the file
    Dio dio = Dio();
    await dio.download(reportUrl, filePath);

    print('File downloaded to: $filePath');

    // Open the file (optional)
    await OpenFile.open(filePath);

  } catch (e) {
    print('Error while downloading file: $e');
  }
}




//==== simulations for testing purposes only ====//

static Future<String> simulateGen() async {
  try {
    print('Simulating generating conclusion');

    await Future.delayed(Duration(seconds: 4));

    showToast(message: 'Conclusion generated successfully', bgColor: Colors.green);

    return 'This is a simulated conclusion';

  } catch (e) {
    return Future.error('Failed to simulate generating conclusion: $e');
  }
}


static Future<void> simulateS() async {
  try {
    print('Simulating submission');

    await Future.delayed(Duration(seconds: 4));

    showToast(message: 'Observation submitted successfully', bgColor: Colors.green);

  } catch (e) {
    return Future.error('Failed to simulate generating conclusion: $e');
  }
}
static Future<void> simulateA() async {
  try {
    print('Simulating submission');

    await Future.delayed(Duration(seconds: 4));

    showToast(message: 'Observation approved successfully', bgColor: Colors.green);

  } catch (e) {
    return Future.error('Failed to simulate generating conclusion: $e');
  }
}
static Future<void> simulateD() async {
  try {
    print('Simulating submission');

    await Future.delayed(Duration(seconds: 4));

    showToast(message: 'Report downloaded successfully', bgColor: Colors.green);

  } catch (e) {
    return Future.error('Failed to simulate generating conclusion: $e');
  }
}
static Future<void> simulateR() async {
  try {
    print('Simulating submission');

    await Future.delayed(Duration(seconds: 4));

    showToast(message: 'Report generated successfully', bgColor: Colors.green);

  } catch (e) {
    return Future.error('Failed to simulate generating conclusion: $e');
  }
}


}
