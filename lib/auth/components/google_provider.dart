import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SignInWithGoogleWidget extends StatelessWidget {
  const SignInWithGoogleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<GlobalState, UserState>(
        converter: (store) => store.state.appState.userState,
        builder: (context, userState) {
          return
    SizedBox(
                  child:

          ElevatedButton(
  onPressed: () {
    print('Sign in with Google');
    store.dispatch(SignInWithGoogle());
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
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8), // Set the padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(1000)), // Set the border radius
            side: BorderSide(
        color: Colors.white,
        width: 2,
      ),
    ),
  ),
  child: 
    userState.isLoading ? 
      CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF232428)), // Change the progress color
    backgroundColor: Color(0xFFC3C3C3), // Change the background color
  ) :

          Image.asset(
            googleIcon,
            height: 40,
          ),
),
);
        });
  }
}