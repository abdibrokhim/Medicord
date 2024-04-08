import 'package:brainmri/models/observation_model.dart';
import 'package:brainmri/models/patients_model.dart';
import 'package:brainmri/screens/observation/components/custom_search.dart';
import 'package:brainmri/screens/observation/components/observation_card.dart';
import 'package:brainmri/screens/observation/components/single_observation_bottom_sheet.dart';
import 'package:brainmri/screens/user/user_epics.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/refreshable.dart';
import 'package:brainmri/utils/shared.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';


class ObservationsScreen extends StatefulWidget {
  // final String pId;
  // final List<ObservationModel> observations;

  // required this.pId, required this.observations
  const ObservationsScreen({Key? key, 
  }) : super(key: key);

  @override
  State<ObservationsScreen> createState() => _ObservationsScreenState();
}

class _ObservationsScreenState extends State<ObservationsScreen> {
  late List<ObservationModel> observations;
  List<ObservationModel> filteredObservations = [];
  String labelText = "Brain MRI";

  var state = store.state.appState.userState;

  @override
  void initState() {
    super.initState();
    // observations = widget.observations;
    // filteredObservations = widget.observations;
    observations = store.state.appState.userState.patientsAllObservations!.observations!;
    filteredObservations = store.state.appState.userState.patientsAllObservations!.observations!;
  }

  void update() {
    observations = store.state.appState.userState.patientsAllObservations!.observations!;
    filteredObservations = store.state.appState.userState.patientsAllObservations!.observations!;
  }

  void reFetchData()  {
      StoreProvider.of<GlobalState>(context).dispatch(FetchPatientAllObservations(store.state.appState.userState.patientsAllObservations!.id!));
      print('ObservationsScreen store.state.appState.userState.patientsAllObservations!.id!, ${store.state.appState.userState.patientsAllObservations!.id!}');
      update();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    reFetchData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
  }

  void showObservation(o) {
    showObservationBottomSheet(context, o, labelText, state.patientsAllObservations!.id!);
  }

  void updateFilteredObservations(String filter) {
    setState(() {
      filteredObservations = observations.where((observation) {
        final observationDateStr = formatDate(DateTime.parse(observation.observedAt!.toString())).toLowerCase();
        final radiologistNameLower = observation.radiologistName!.toLowerCase();
        final labelTextLower = labelText.toLowerCase();
        final isApprovedStr = observation.conclusion!.isApproved! ? 'approved' : 'pending';
        final filterLower = filter.toLowerCase();

        return observationDateStr.contains(filterLower) ||
            radiologistNameLower.contains(filterLower) ||
            labelTextLower.contains(filterLower) ||
            isApprovedStr.contains(filterLower);
      }).toList();
    });
  }

    TextEditingController conclusionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 33, 38),
      appBar: AppBar(
        surfaceTintColor: const Color.fromARGB(255, 23, 24, 28),
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

      StoreConnector<GlobalState, UserState>(
      onInit: (store) {
        store.dispatch(FetchPatientAllObservations(store.state.appState.userState.patientsAllObservations!.id!));
        print('ObservationsScreen onInit store.state.appState.userState.patientsAllObservations!.id!, ${store.state.appState.userState.patientsAllObservations!.id!}');
      },
      converter: (appState) => appState.state.appState.userState,
      builder: (context, userState) {
        
        return
              Padding(padding: 
      const EdgeInsets.all(16),
      child:
        Column(children: [
          // Search input
              CustomSearchInput(
                    onSearchChanged: updateFilteredObservations,
                  ),
    const SizedBox(height: 16),

    Expanded(child: 
    Refreshable(
            refreshController: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: 
            
            userState.isObservationsListLoading ?

            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF232428)), // Change the progress color
                backgroundColor: Color(0xFFC3C3C3), // Change the background color
              ),
            ) :


  GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 1,
    ),
    itemCount: filteredObservations.length,
    itemBuilder: (context, index) {
      print('filteredObservations.length, ${filteredObservations.length}');

      return ObservationCard(
                        observationDate: filteredObservations[index].observedAt!.toString(),
                        radiologistName: filteredObservations[index].radiologistName!,
                        labelText: labelText,
                        isApproved: filteredObservations[index].conclusion!.isApproved!,
                        onTap: () {
                          showObservation(filteredObservations[index]); // Use filteredObservations
                        },
                      );
    },
  ),
  ),
  ),
        ],)
      );
  }
    ),
      // ),
    );
  }
}
