import 'package:brainmri/screens/observation/brain/brain_observation_form.dart';
import 'package:brainmri/screens/observation/components/custom_dropdown.dart';
import 'package:brainmri/screens/observation/components/custom_dropdown_button.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:flutter/material.dart';


class AddObservationScreen extends StatefulWidget {
  const AddObservationScreen({super.key});

  @override
  State<AddObservationScreen> createState() => _AddObservationScreenState();
}

class _AddObservationScreenState extends State<AddObservationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:

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
                    labelText: "Select scan type",
          items: [
            {'name': 'Brain', 'id': '1'},
          ],
          itemName: 'Select',
          dState: 1
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
