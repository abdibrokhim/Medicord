import 'package:brainmri/models/observation_model.dart';
import 'package:brainmri/models/patients_model.dart';
import 'package:brainmri/screens/observation/single_observation_screen.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/refreshable.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';


class AllObservationsScreen extends StatefulWidget {
  const AllObservationsScreen({super.key});

  @override
  State<AllObservationsScreen> createState() => _AllObservationsScreenState();
}

class _AllObservationsScreenState extends State<AllObservationsScreen> {

  @override
  void initState() {
    super.initState();
  }

  void reFetchData()  {
      StoreProvider.of<GlobalState>(context).dispatch(FetchAllPatients());
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 33, 38),
      body: Refreshable(
            refreshController: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: 
      StoreConnector<GlobalState, UserState>(
      onInit: (store) {
        store.dispatch(FetchAllPatients());
      },
      converter: (appState) => appState.state.appState.userState,
      builder: (context, userState) {
        
        return
        userState.isPatientsListLoading ? 
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(height: 8.0),
  CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF232428)), // Change the progress color
    backgroundColor: Color(0xFFC3C3C3), // Change the background color
  ),
      const SizedBox(height: 16.0),
          Text(
            'Fetching data...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
    ],
  ) :
  userState.patientsList.isEmpty ?
  const Center(
    child: Text(
      'No patients found',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  )
  :

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child:
      SingleChildScrollView(
  scrollDirection: Axis.vertical,
  child: 
  
  Column(
  children: [
    // Header row
    Row(
      children: const [
        Expanded(
          child: Text(
            'Full Name',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            'Birth Year',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            'Observations',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
    const SizedBox(height: 4),
    const Divider(color: Colors.white),
    const SizedBox(height: 8),
    // Data rows
    ...userState.patientsList.asMap().entries.map((entry) {
  int index = entry.key;
  PatientModel patient = entry.value;

  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              patient.fullName!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              patient.birthYear!.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              splashColor: Colors.transparent, // Removes the splash color
              child: Row(
                children: [
                  Text(
                    'expand',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18,),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ObservationsScreen(
                      pId: patient.id!,
                      observations: patient.observations!,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Add a divider except for the last item
      if (index != userState.patientsList.length - 1) 
        Column(children: [
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFAAAAAA)),
          const SizedBox(height: 8),
        ],),
    ],
  );
}).toList(),

  ],
),

        ),
      );
      }
      ),
      ),
    );
  }
}
