import 'package:brainmri/auth/signin/signin_screen.dart';
import 'package:brainmri/screens/observation/components/primary_custom_button.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class OrganizationScreen extends StatefulWidget {
  
  const OrganizationScreen({super.key});

  @override
  State<OrganizationScreen> createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {

  @override
  Widget build(BuildContext context) {
      
      final User user = FirebaseAuth.instance.currentUser!;

    String photoUrl = user.photoURL ?? defaultProfileImage;
    String displayName = user.displayName ?? 'No Name';
    String email = user.email ?? 'No Email';
    return 
StoreConnector<GlobalState, UserState>(
  onDidChange: (prev, next) {
    if (!next.isLoggedIn) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignInScreen()));
    }
  },
        converter: (store) => store.state.appState.userState,
        builder: (context, userState) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      color: const Color.fromARGB(255, 31, 33, 38),
      child: 
    Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(photoUrl),
              radius: 50.0, // Size of the profile image
            ),
            SizedBox(height: 16), // Spacing between elements
            Text(
              displayName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4), // Spacing between elements
            Text(
              email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[300],
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Expanded(child: SizedBox(),),
        PrimaryCustomButton(
          label: 'Sign Out',
          onPressed: () {
            store.dispatch(SignOutAction());
          },
          loading: userState.isLoading,
          isDisabled: userState.isLoading,
        ),
        SizedBox(height: 40,),
          ]
        ),
        ),
    );

        }
    );
  }
}