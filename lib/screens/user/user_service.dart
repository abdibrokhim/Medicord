import 'dart:io';
import 'dart:typed_data';

import 'package:brainmri/auth/components/secure_storage.dart';
import 'package:brainmri/utils/constants.dart';
import 'package:brainmri/utils/shared.dart';
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
      showToast(message: 'An error has occured', bgColor: getColor(AppColors.error));
      AppLog.log().e('Error while fetching patients: $e');
      return Future.error('Error while fetching patients: $e');
    }
  }


  static Future<PatientModel> fetchPatientAllObservations(String patientId) async {
  try {
    print('Fetching patient with ID: $patientId');

    String? organizationId = await _getOrganizationId();
    if (organizationId == null) {
      return Future.error('No organization ID found');
    }

    DatabaseReference patientRef = _firebaseDatabase.ref().child('organizations').child(organizationId).child('patients').child(patientId);
    DataSnapshot snapshot = (await patientRef.once()).snapshot;

    if (snapshot.exists) {
      print('snapshot.value: ${snapshot.value}');

      Map<dynamic, dynamic> patientData = snapshot.value as Map<dynamic, dynamic>;
      patientData['id'] = patientId;
      print('patientData: $patientData');

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

        print('observationsList: $observationsList');

        patientData['observations'] = observationsList;
      }

      print('patientData: $patientData');

      return PatientModel.fromJson(patientData);
    } else {
      AppLog.log().e('No patient found with ID: $patientId');
      return PatientModel();
    }
  } catch (e) {
    showToast(message: 'An error has occurred', bgColor: getColor(AppColors.error));
    AppLog.log().e('Error while fetching patient by ID: $e');
    return Future.error('Error while fetching patient by ID: $e');
  }
}


  static Future<Map<String, dynamic>> fetchPatientSingleObservation(String patientId, String observationId) async {
  try {
    print('Fetching observation with ID: $observationId for patient with ID: $patientId');

    String? organizationId = await _getOrganizationId();
    if (organizationId == null) {
      return Future.error('No organization ID found');
    }

    DatabaseReference observationRef = _firebaseDatabase.ref().child('organizations').child(organizationId).child('patients').child(patientId).child('observations').child(observationId);
    DataSnapshot snapshot = (await observationRef.once()).snapshot;

    if (snapshot.exists) {
      print('snapshot.value: ${snapshot.value}');

      Map<dynamic, dynamic> observationData = snapshot.value as Map<dynamic, dynamic>;
      observationData['id'] = observationId;
      print('observationData: $observationData');

      if (observationData.containsKey('conclusion')) {
        Map<dynamic, dynamic> conclusionData = observationData['conclusion'] as Map<dynamic, dynamic>;
        observationData['conclusion'] = ConclusionModel.fromJson(conclusionData);
      }

      Map<String, dynamic> result = {
        'patientId': patientId,
        'observation': observationData,
      };

      print('result: $result');
      return result;

    } else {
      print('No observation found with ID: $observationId for patient with ID: $patientId');
      return {};
    }
  } catch (e) {
    showToast(message: 'An error has occurred', bgColor: getColor(AppColors.error));
    AppLog.log().e('Error while fetching observation by ID: $e');
    return Future.error('Error while fetching observation by ID: $e');
  }
}



  static Future<Map<String, String>> updatePatientConclusion(String patientId, String observationId, String conclusion) async {
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
      showToast(message: 'Observation updated successfully', bgColor: getColor(AppColors.success));

      try {

      await conclusionRef.update(jsonObject);
        return {'patientId': patientId, 'observationId': observationId, 'conclusion': conclusion};

      } catch (e) {
        AppLog.log().e('An error has occured: $e');
        return Future.error('An error has occured');
      }

    } catch (e) {
      showToast(message: 'An error has occured', bgColor: getColor(AppColors.error));
      AppLog.log().e('Error while updating patient conclusion: $e');
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

      showToast(message: 'Observation approved successfully', bgColor: getColor(AppColors.success));

      return true;
    } catch (e) {
      showToast(message: 'An error has occured', bgColor: getColor(AppColors.error));
      AppLog.log().e('Error while approving patient conclusion: $e');
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
      showToast(message: 'An error has occured', bgColor: getColor(AppColors.error));
      AppLog.log().e('Error while validating patient conclusion: $e');
      return Future.error('Error while approving patient conclusion: $e');
    }
  }


  static Future<void> savePatientObservation(String patientId, ObservationModel observationModel) async {

    try {

      print('Saving patient observation: $patientId, ${observationModel.toJson()}');

      String? organizationId = await _getOrganizationId();
      if (organizationId == null) {
        showToast(message: 'No organization found', bgColor: getColor(AppColors.error));
        return Future.error('No organization ID found');
      }

      DatabaseReference patientRef = _firebaseDatabase.ref().child('organizations').child(organizationId).child('patients').child(patientId);
      DataSnapshot snapshot = (await patientRef.once()).snapshot;

      if (!snapshot.exists) {
        // If patient does not exist, return an error
        showToast(message: 'No patient found', bgColor: getColor(AppColors.error));

        return Future.error('Patient with ID $patientId does not exist');
      } else {
        print('snapshot.value: ${snapshot.value}');
        // If patient exists, add a new observation under the patient record with a unique ID
        DatabaseReference observationRef = patientRef.child('observations').push();  // Generate a unique ID for the new observation
        
        showToast(message: 'Observation saved successfully', bgColor: getColor(AppColors.success));
        await observationRef.set(observationModel.toJson());
      }
    } catch (e) {
      showToast(message: 'An error has occured', bgColor: getColor(AppColors.error));
      AppLog.log().e('Error while saving patient observation: $e');
      return Future.error('Error while saving patient observation: $e');
    }
  }

  static Future<void> saveNewPatient(String fullName, String birthYear) async {
    try {
      String? organizationId = await _getOrganizationId();

      AppLog.log().i('Organization ID: $organizationId');
      AppLog.log().i('Saving new patient: $fullName, $birthYear');

      if (organizationId == null) {
        showToast(message: 'No organization ID found', bgColor: getColor(AppColors.error));

        return Future.error('No organization ID found');
      }
      DatabaseReference patientsRef = _firebaseDatabase.ref().child('organizations').child(organizationId).child('patients').push();
      await patientsRef.set({
        'fullName': fullName,
        'birthYear': birthYear,
      });

      showToast(message: 'New patient saved', bgColor: getColor(AppColors.success));

      AppLog.log().i('New patient saved');
    } catch (e) {
      showToast(message: 'An error has occured', bgColor: getColor(AppColors.error));
      AppLog.log().e('Error while saving new patient: $e');
      return Future.error('Error while saving new patient: $e');
    }
  }

  static Future<List<Map<String, String>>> fetchAllPatientNames() async {
    try {
      AppLog.log().i('Fetching patient names');

      String? organizationId = await _getOrganizationId();
      if (organizationId == null) {
        showToast(message: 'No organization found', bgColor: getColor(AppColors.error));
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
      showToast(message: 'An error has occured', bgColor: getColor(AppColors.error));
      AppLog.log().e('Error while fetching patient names: $e');
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
      showToast(message: 'An error has occured', bgColor: getColor(AppColors.error));
      AppLog.log().e('Failed to generate conclusion: $e');
      return Future.error('Failed to generate conclusion: $e');
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
      showToast(message: 'An error has occured', bgColor: getColor(AppColors.error));
      AppLog.log().e('Failed to generate conclusion: $e');
      return Future.error('Failed to generate conclusion');
    }
  }

  static String _formatDate(DateTime date) {
    // 12/12/2023
    return '${date.month}/${date.day}/${date.year}';
  }


static Future<String> generatePatientReport(String pName, String bYear, ObservationModel observation) async {
  try {
    print('Generating patient report: ${pName}');

    
    String hospitalName = 'SI "REPUBLICAN SPECIALIZED CENTER FOR SURGERY NAMED AFTER ACADEMICIAN V. VAKHIDOV"';
    String mriDepartment = 'DEPARTMENT OF MAGNETIC RESONANCE AND COMPUTED TOMOGRAPHY';
    String phoneNumber = '+1234567890';
    String disclaimerA = 'This conclusion is not a final diagnosis and requires comparison with clinical and laboratory data.';
    String disclaimerB = 'In case of typos, contact phone: ${phoneNumber}';
    String address = 'Uzbekistan, Tashkent, ul. Farkhadskaya 10. Phone: ${phoneNumber}';


    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        header: (context) => pw.Header(
          level: 0,
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.SizedBox(height: 16),
              pw.Header(
                level: 1,
                child: pw.Center(child: 
                  pw.Text(hospitalName, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Header(
                level: 1,
                child: pw.Center(child: 
                  pw.Text(mriDepartment, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                ),
              ),
              pw.SizedBox(height: 24),
              pw.Center(child: 
                pw.Text(address, style: const pw.TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
        build: (context) => [
          pw.SizedBox(height: 24),
          pw.Text('Full Name: ${pName}', style: const pw.TextStyle(fontSize: 16)),
          pw.Text('Birth Year: ${bYear}', style: const pw.TextStyle(fontSize: 16)),
          pw.Text('Observed At: ${observation.observedAt != null ? '${_formatDate(observation.observedAt!)} OR ${formatDate(observation.observedAt!)}' : ''}', style: const pw.TextStyle(fontSize: 16)),
          pw.Text('Radiologist Name: ${observation.radiologistName!}', style: const pw.TextStyle(fontSize: 16)),
          pw.Text('Signed By (Head Doctor Name): ${observation.conclusion!.headDoctorName!}', style: const pw.TextStyle(fontSize: 16)),
          pw.SizedBox(height: 16),
          pw.Header(
            level: 1,
            child: pw.Center(child: 
              pw.Text('PROTOCOL OF MRI STUDY OF THE BRAIN', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Text('${observation.text!}', style: const pw.TextStyle(fontSize: 14)),
          pw.SizedBox(height: 16),
          pw.Header(
            level: 1,
            child: pw.Center(child: 
              pw.Text('Conclusion'.toUpperCase(), style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Text(observation.conclusion!.text!, style: const pw.TextStyle(fontSize: 14)),
          pw.SizedBox(height: 48),
          pw.Center(child: 
            pw.Text(disclaimerA, style: const pw.TextStyle(fontSize: 12)),
          ),
          pw.SizedBox(height: 8),
          pw.Center(child: 
            pw.Text(disclaimerB, style: const pw.TextStyle(fontSize: 12)),
          ),
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
    final filePath = '${directory.path}/PatientReport_${pName}_$formattedDateTime.pdf';

    // Save the PDF file
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    print('File path: $filePath');
    print('File name: ${file.path}');

    String fileUrl = await upload(filePath);

    showToast(message: 'Report generated successfully', bgColor: getColor(AppColors.success));

    return fileUrl;

  } catch (e) {
    showToast(message: 'An error has occured', bgColor: getColor(AppColors.error));
    print('Failed to generate patient report due to an exception: $e');
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

    AppLog.log().i('File uploaded to firebase storage: $fileUrl');

    return fileUrl;
  } catch (e) {
    showToast(message: 'An error has occured', bgColor: getColor(AppColors.error));
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

    AppLog.log().e('File downloaded to: $filePath');

    // Open the file (optional)
    await OpenFile.open(filePath);

  } catch (e) {
    showToast(message: 'An error has occured', bgColor: getColor(AppColors.error));
    AppLog.log().e('Error while downloading file: $e');
    throw Exception('Error while downloading file: $e');
  }
}




//==== simulations for testing purposes only ====//

static Future<String> simulateGen() async {
  try {
    print('Simulating generating conclusion');

    await Future.delayed(Duration(seconds: 4));

    showToast(message: 'Conclusion generated successfully', bgColor: Colors.green[900]);

    return 'This is a simulated conclusion';

  } catch (e) {
    return Future.error('Failed to simulate generating conclusion: $e');
  }
}


static Future<void> simulateS() async {
  try {
    print('Simulating submission');

    await Future.delayed(Duration(seconds: 4));

    showToast(message: 'Observation submitted successfully', bgColor: Colors.green[900]);

  } catch (e) {
    return Future.error('Failed to simulate generating conclusion: $e');
  }
}
static Future<void> simulateA() async {
  try {
    print('Simulating submission');

    await Future.delayed(Duration(seconds: 4));

    showToast(message: 'Observation approved successfully', bgColor: Colors.green[900]);

  } catch (e) {
    return Future.error('Failed to simulate generating conclusion: $e');
  }
}
static Future<void> simulateD() async {
  try {
    print('Simulating submission');

    await Future.delayed(Duration(seconds: 4));

    showToast(message: 'Report downloaded successfully', bgColor: Colors.green[900]);

  } catch (e) {
    return Future.error('Failed to simulate generating conclusion: $e');
  }
}
static Future<void> simulateR() async {
  try {
    print('Simulating submission');

    await Future.delayed(Duration(seconds: 4));

    showToast(message: 'Report generated successfully', bgColor: Colors.green[900]);

  } catch (e) {
    return Future.error('Failed to simulate generating conclusion: $e');
  }
}


}
