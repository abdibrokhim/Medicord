import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


class ObservationCard extends StatelessWidget {
  final String observationDate;
  final String radiologistName;
  final String labelText;
  final bool isApproved;
  final Function() onTap;

  const ObservationCard({
    Key? key,
    required this.observationDate,
    required this.radiologistName,
    this.labelText = "Brain MRI",
    required this.isApproved,
    required this.onTap,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StoreConnector<GlobalState, UserState>(
      onInit: (store) {
        // store.dispatch(FetchAllPatientNamesAction());
      },
      converter: (appState) => appState.state.appState.userState,
      builder: (context, userState) {
        return
    GestureDetector(
        onTap: onTap,
        child: 
    Column(
      children: [
      
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      color: Color(0xFFC3C3C3),
      ),
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDate(DateTime.parse(observationDate)),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              labelText,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
                        Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                            Text(
                  radiologistName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ],
        ),
      ),
    ),

    Container(
            decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
            color: Color.fromARGB(255, 23, 24, 28)
      ),
      height: 40,
                alignment: Alignment.centerRight,
                child: Padding(padding: const EdgeInsets.only(right: 8),
      child:
                Text(
                    isApproved ? "approved" : "pending",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    ),
      ),
    ),

      ],
      ),
    );
  }
  );
  }
}
