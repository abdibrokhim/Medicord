import 'package:brainmri/models/observation_mode.dart';
import 'package:brainmri/models/patients_model.dart';
import 'package:brainmri/screens/observation/components/observation_card.dart';
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
  GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
    ),
    itemCount: observations.length,
    itemBuilder: (context, index) {
      return ObservationCard(
        observationDate: observations[index].observedAt!.toString(),
        radiologistName: observations[index].radiologistName!,
        labelText: "Brain MRI",
        isApproved: observations[index].conclusion!.isApproved!,
      );
    },
  ),
      ),
    );
  }
}
