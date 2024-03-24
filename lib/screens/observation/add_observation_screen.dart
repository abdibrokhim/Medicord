import 'package:brainmri/screens/observation/brain/brain_observation_form.dart';
import 'package:brainmri/screens/observation/components/custom_dropdown.dart';
import 'package:brainmri/screens/observation/components/custom_dropdown_button.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../utils/refreshable.dart';

class AddObservationScreen extends StatefulWidget {
  const AddObservationScreen({super.key});

  @override
  State<AddObservationScreen> createState() => _AddObservationScreenState();
}

class _AddObservationScreenState extends State<AddObservationScreen> {
  String _selectedOption = '';


      void reFetchData()  {
          print('refetching');
          if (_selectedOption == 'Brain')
            {
              store.dispatch(FetchAllPatientNamesAction());

          }
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
      body:

    // Refreshable(
    //         refreshController: _refreshController,
    //         onRefresh: _onRefresh,
    //         onLoading: _onLoading,
    //         child: 

    Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              color: const Color.fromARGB(255, 31, 33, 38),
              child:

    SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                          Expanded(
                            flex: 3,
              child: 
            Text('Select scan type'
            , style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            ),
            ),
                        Expanded(
                          flex: 2,
              child: 
                  CustomDropdownWithSearch( 
          items: [
            {'name': 'Brain', 'id': '1'},
          ],
          itemName: 'Select',
          dState: 0
        ),
        ),
        ],
      ),
          const BrainObservationForm(),
          ],)
      ),
      ),
    );
  }
}
