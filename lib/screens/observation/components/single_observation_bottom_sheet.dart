import 'package:brainmri/models/observation_mode.dart';
import 'package:brainmri/models/patients_model.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/refreshable.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';


class ObservationsScreen extends StatefulWidget {
  final String pId;
  final List<ObservationModel> observations;

  const ObservationsScreen({Key? key, required this.pId, required this.observations}) : super(key: key);

  @override
  State<ObservationsScreen> createState() => _ObservationsScreenState();
}

class _ObservationsScreenState extends State<ObservationsScreen> {
  late List<ObservationModel> observations;

  @override
  void initState() {
    super.initState();
    observations = widget.observations;
  }

    String headDoctorName = '';
    String obId = '';

    void showDialoga() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Head Doctor Name'),
            content: TextField(
              onChanged: (value) => setState(() => headDoctorName = value),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: _submitForm,
                child: const Text('Approve'),
              ),
            ],
          );
        },
      );
    }

    void _submitForm() {

      var state = StoreProvider.of<GlobalState>(context).state.appState.userState;

      StoreProvider.of<GlobalState>(context).dispatch(
        ApprovePatientConclusionAction(widget.pId, obId, headDoctorName),
      );

      Navigator.of(context).pop();
    }

    void showDialogb() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Approved'),
            content: Text('This observation has already been approved.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

  

    TextEditingController conclusionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 33, 38),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 24, 28),
        title: const Text(
          'Observations',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: 
      Padding(padding: 
      const EdgeInsets.all(20),
      child:
      SingleChildScrollView(
  scrollDirection: Axis.vertical,
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
        child: 
        DataTable(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          columns: const [
            DataColumn(label: Text('Observation')),
            DataColumn(label: Text('Observed At')),
            DataColumn(label: Text('Radiologist Name')),
            DataColumn(label: Text('Conclusion')),
            DataColumn(label: Text('Approved')),
          ],
          rows: observations
              .map(
                (observation) => DataRow(cells: [
                  DataCell(InkWell(
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Observation'),
                          content: SingleChildScrollView(
  scrollDirection: Axis.vertical,
  child:Text(observation.text!),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    ),
                    child:
                    Text(
                    observation.text!,
                    overflow: TextOverflow.ellipsis,
                  )),
                  ),
                  DataCell(Text(observation.observedAt!.toString())),
                  DataCell(Text(observation.radiologistName!)),
                  DataCell(
                   InkWell(
  onTap: () => showDialog(
    context: context,
    builder: (BuildContext context) {
      bool isEdited = false;
      TextEditingController conclusionController = TextEditingController(text: observation.conclusion!.text!);

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Conclusion'),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: TextField(
                controller: conclusionController,
                onChanged: (value) {
                  setState(() {
                    isEdited = value != observation.conclusion!.text!;
                  });
                },
              ),
            ),
            actions: <Widget>[
              if (isEdited)
                ElevatedButton(
                  onPressed: () {
                    print('update conclusion');

                    StoreProvider.of<GlobalState>(context).dispatch(
                      UpdatePatientConclusion(
                        widget.pId,
                        observation.id!,
                        conclusionController.text,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    },
  ),
  child: Text(observation.conclusion!.text!),
),
),

                  DataCell(
                    IconButton(
                      icon: observation.conclusion!.isApproved! ? 
                      const Icon(Icons.check_circle_outline) :
                      const Icon(Icons.cancel_outlined),
                      onPressed: () {
                        setState(() {
                          obId = observation.id!;
                        });
                        !observation.conclusion!.isApproved! ? 
                        showDialoga() : showDialogb();
                      },
                    ),
                  ),
                ]),
              )
              .toList(),
        ),
      ),
      ),
      ),
    );
  }
}
