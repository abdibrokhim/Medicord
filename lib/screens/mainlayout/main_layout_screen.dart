import 'package:brainmri/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/screens/observation/add_observation_screen.dart';
import 'package:brainmri/screens/observation/all_observations_screen.dart';
import 'package:brainmri/screens/profile/organization_screen.dart';


class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = const [
    AddObservationScreen(),
    AllObservationsScreen(),
    OrganizationScreen(),
  ];

  final List<String> _tabTitles = const [
    'Add Observation',
    'All Observations',
    'Organization',
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: const Color.fromARGB(255, 23, 24, 28),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(_tabTitles[_selectedIndex],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
        ),
        backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      ),
      drawer: Drawer(
  backgroundColor: const Color.fromARGB(255, 40, 42, 49),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns the main content and the version info
    children: [
      Expanded( // Wraps the main content in an Expanded widget
        child:
  ListView(
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    children: [

DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 23, 24, 28),
              ),
  // color: Color(0xff2B2D31),
  padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 24.0),
  child: Align(
    alignment: Alignment.center,
    child: 
        Container(
          padding: EdgeInsets.zero,
          alignment: Alignment.centerLeft,
          child:
                Text(
          'CoMed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        ),
  ),
),
      const SizedBox(height: 24), // Added space before ListTiles
      ListTile(
        leading: const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 26,),
        title: const Text(
          'Add Observation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = 0;
          });
          Navigator.pop(context);
        },
        tileColor: _selectedIndex == 0 ? const Color.fromARGB(255, 23, 24, 28) : null,
      ),
      const SizedBox(height: 10), // Added space before ListTiles
      ListTile(
        leading: const Icon(Icons.explore_outlined, color: Colors.white, size: 26,),
        title: const Text('All Observations', 
          style: TextStyle(
            color: Colors.white, 
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = 1;
          });
          Navigator.pop(context);
        },
        tileColor: _selectedIndex == 1 ? const Color.fromARGB(255, 23, 24, 28) : null,
      ),
      const SizedBox(height: 10), // Added space before ListTiles
      ListTile(
        leading: const Icon(
          Icons.account_circle_outlined, color: Colors.white,
          size: 26,
        ),
        title: const Text('Organization', 
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = 2;
          });
          Navigator.pop(context);
        },
        tileColor: _selectedIndex == 2 ? const Color.fromARGB(255, 23, 24, 28) : null, // Added blue color on select
      ),
      
      const SizedBox(height: 24), // Added space before app version

    ],
  ),
  ),
  
const SizedBox(height: 24),
  Padding(padding: const EdgeInsets.only(bottom: 20.0), // Added padding to version info
  child: 
      Text(
          textAlign: TextAlign.center,
          'version: 1.0.0', // Added app version
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        ),
    ],),
),

      body: _tabs[_selectedIndex],
    );
  }
}
