import 'package:brainmri/models/observation_model.dart';
import 'package:brainmri/models/patients_model.dart';
import 'package:brainmri/screens/observation/components/custom_text_field.dart';
import 'package:brainmri/screens/observation/components/custom_textformfield.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/refreshable.dart';
import 'package:brainmri/utils/shared.dart';
import 'package:brainmri/utils/toast.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';



  int calculateLines(BuildContext context, String text) {
    final TextSpan span = TextSpan(text: text);
    final TextPainter tp = TextPainter(
      text: span,
      maxLines: null,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: MediaQuery.of(context).size.width);
    print(tp.computeLineMetrics().length);
    return tp.computeLineMetrics().length;
  }

  void showObservationBottomSheet(BuildContext context, ObservationModel observation, String labelText, String pId) {

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return StoreConnector<GlobalState, UserState>(
      onInit: (store) {
        store.dispatch(FetchAllPatientNamesAction());
      },
      converter: (appState) => appState.state.appState.userState,
      builder: (context, userState) {
        return
      Container(
        height: 800,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        color: const Color.fromARGB(255, 31, 33, 38),
        child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24.0),
         Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        labelText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      Container(
        alignment: Alignment.center,
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Color.fromARGB(200, 255, 255, 255), // Add your background color here
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, color: Colors.black, size: 20),
        ),
      ),
    ],
),
                            // const Divider(color: Colors.white),
const SizedBox(height: 32.0),
Expanded(
              child: 
 ListView(
          children: [

CustomTextField(
  labelText: 'Observation',
  initialValue: observation.text!,
  maxLines: calculateLines(context, observation.text!),
),
const SizedBox(height: 24.0),
CustomTextField(
  labelText: 'Conclusion',
  initialValue: observation.conclusion!.text!,
  maxLines: calculateLines(context, observation.conclusion!.text!),
),
const SizedBox(height: 24.0),
CustomTextField(
  labelText: 'Radiologist',
  initialValue: observation.radiologistName!,
  maxLines: calculateLines(context, observation.radiologistName!),
),
const SizedBox(height: 24.0),
CustomTextField(
  labelText: 'Observed on',
  initialValue: formatDate(observation.observedAt!),
  maxLines: 1
),
const SizedBox(height: 24.0),
CustomTextField(
  labelText: 'Status',
  initialValue: observation.conclusion!.isApproved! ? 'Approved' : 'Pending',
  maxLines: 1,
  onTap: () {
    showConfirmationBottomSheet(context, observation, pId);
  },
),

  const SizedBox(height: 32.0),

  SizedBox(
                  width: double.infinity,
                  child:
          ElevatedButton(
  onPressed: () {

    StoreProvider.of<GlobalState>(context).dispatch(
        SimulateGenerateReport(),
      );

    showReportActionBottomSheet(context);
  },
  style: ElevatedButton.styleFrom(
    elevation: 5,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white, // Set the text color (applies to foreground)
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700, 
    ),
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Set the padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)), // Set the border radius
            side: BorderSide(
        color: Colors.white,
        width: 2,
      ),
    ),
  ),
  child: Text(
    'Generate Report',
  ),
),
),
const SizedBox(height: 60.0),
          ],
),
 ),
          ],
        ),
      );
    },
  );
}
  );
}


  void showConfirmationBottomSheet(BuildContext context, ObservationModel observation, String pId) {

    final bool isApproved = !observation.conclusion!.isApproved!;
    final TextEditingController _dController = TextEditingController();
    
    _dController.text = isApproved ? observation.conclusion!.headDoctorName! : '';

    bool loading = false;

  showModalBottomSheet(
    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return 
                      StoreConnector<GlobalState, UserState>(
      onInit: (store) {
        // store.dispatch(FetchAllPatientNamesAction());
      },
      converter: (appState) => appState.state.appState.userState,
      builder: (context, userState) {
        return
          Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 400,
        color: const Color.fromARGB(255, 31, 33, 38),
                      child:
                      Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: 
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
                            Text(
                              'Approve Observation',
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
      Container(
        alignment: Alignment.center,
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Color.fromARGB(200, 255, 255, 255), // Add your background color here
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, color: Colors.black, size: 18,),
        ),
      ),
    ],
),
const SizedBox(height: 16),
                      Text(
                        isApproved ? 'Observation is already approved.' :
                              'You are about to approve the observation. Make sure the observation is correct and the conclusion is accurate.',
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24),
                            CustomTextFormField(
  labelText: 'Head Doctor Name',
  isInputEmpty: _dController.text.isEmpty,
  onChanged: (value) => _dController.text = value,
  onClear: () => _dController.text = '',
  initialValue: _dController.text,
  isReadOnly: isApproved
),

const SizedBox(height: 32.0),

isApproved ? const SizedBox() :

  SizedBox(
                  width: double.infinity,
                  child:
          ElevatedButton(
  onPressed: userState.isApprovingConclusion ? () {} : () async {
print('Approving conclusion...');
    //                                 if (!isApproved) {
    //   StoreProvider.of<GlobalState>(context).dispatch(
    //     ApprovePatientConclusionAction(pId, observation.id!, _dController.text),
    //   );
    // }

        // simulate download

        if (_dController.text.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showToast(message: 'Head Doctor name required.', bgColor: Colors.red[900]);
          });
          return;
        } else {

      StoreProvider.of<GlobalState>(context).dispatch(
          SimulateApprovePatientConclusionAction(),
        );
        }

  },
  style: ElevatedButton.styleFrom(
    elevation: 5,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white, // Set the text color (applies to foreground)
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700, 
    ),
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Set the padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)), // Set the border radius
            side: BorderSide(
        color: Colors.white,
        width: 2,
      ),
    ),
  ),
  child: 
    userState.isApprovingConclusion ? 
      CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF232428)), // Change the progress color
    backgroundColor: Color(0xFFC3C3C3), // Change the background color
  ) :
  Text(
    'Approve'
  ),
),
),
                          ],
                        ),
                        ),
                      );
                    },
                  );
                    },
  );
}




  void showReportActionBottomSheet(BuildContext context) {

    var state = StoreProvider.of<GlobalState>(context).state.appState.userState;

    String path = state.reportPath;

  showModalBottomSheet(
    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return 
                      StoreConnector<GlobalState, UserState>(
      onInit: (store) {
        // store.dispatch();
      },
      converter: (appState) => appState.state.appState.userState,
      builder: (context, userState) {
        return
          Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 400,
        color: const Color.fromARGB(255, 31, 33, 38),
                      child:
                      Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: 
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
                            Text(
                              'Share or Download Report',
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
      Container(
        alignment: Alignment.center,
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Color.fromARGB(200, 255, 255, 255), // Add your background color here
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, color: Colors.black, size: 18,),
        ),
      ),
    ],
),
const SizedBox(height: 16),
                      Text(
                              'You may share the report with the patient or download it.',
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24),

userState.isGeneratingReport ?
  const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 8.0),
  CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF232428)), // Change the progress color
    backgroundColor: Color(0xFFC3C3C3), // Change the background color
  ),
      const SizedBox(height: 8.0),
          Text(
            'Generating report. Please wait...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
  SizedBox(height: 32,),
    ],
  ) : SizedBox(height: 32,),


  SizedBox(
                  width: double.infinity,
                  child:
          ElevatedButton(
  onPressed: (userState.isGeneratingReport || userState.isDownloadingReport) ? () {} : () async {
    
    // if (path.isNotEmpty) {
    // StoreProvider.of<GlobalState>(context).dispatch(
    //     DownloadReportAction(path),
    //   );
    // } else {
    //   print('No report to download.');
    // }

    // simulate download
    StoreProvider.of<GlobalState>(context).dispatch(
        SimulateDownloadReport(),
      );
  },
  style: ElevatedButton.styleFrom(
    elevation: 5,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white, // Set the text color (applies to foreground)
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700, 
    ),
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Set the padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)), // Set the border radius
            side: BorderSide(
        color: Colors.white,
        width: 2,
      ),
    ),
  ),
  child: userState.isDownloadingReport ? 
    CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF232428)), // Change the progress color
    backgroundColor: Color(0xFFC3C3C3), // Change the background color
  ) :
  Text(
    'Download',
  ),
),
),
                          ],
                        ),
                        ),
                      );
                    },
                  );
                    },
  );
  }