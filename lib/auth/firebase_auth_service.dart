
import 'package:brainmri/auth/components/secure_storage.dart';
import 'package:brainmri/store/app_logs.dart';
import 'package:brainmri/utils/constants.dart';
import 'package:brainmri/utils/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';


class FirebaseAuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
      }

      final User? user = _firebaseAuth.currentUser;

      if (user != null) {
        final String? email = user.email;

        bool isAlreadySaved = await isOrganizationSavedToRealtimeDatabase(email ?? '');

        if (!isAlreadySaved) {
          await saveOrganizationToRealtimeDatabase(user.uid, email ?? '');
          showToast(message: 'Successfully saved organization to Realtime Database', bgColor: colors['success']!,);
        } else {
          showToast(message: 'Organization is already saved to Realtime Database', bgColor: colors['success']!, );
        }

        await StorageService.storeAccess(user.uid);
        AppLog.log().e('User uid: ${user.uid}');

        return user;
      } else {
        showToast(message: 'Error while signing in with google. Please try to sign in entering username and password', bgColor: colors['error']!,);
        return Future.error('Error while signing in with google');
      }
    } catch (e) {
      print("error while signing in with google: $e");
      return Future.error('Error while signing in with google');
    }
  }

  static Future<bool> isOrganizationSavedToRealtimeDatabase(String email) async {
    try {
      DatabaseReference orgRef = _firebaseDatabase.ref().child('organizations');
      DataSnapshot snapshot = (await orgRef.orderByChild('email').equalTo(email).once()).snapshot;
      return snapshot.exists;
    } catch (e) {
      print("Error while checking if organization is saved to Realtime Database: $e");
      return false;
    }
  }

  static Future<void> saveOrganizationToRealtimeDatabase(String organizationId, String email) async {
    try {
      DatabaseReference orgRef = _firebaseDatabase.ref().child('organizations').child(organizationId);
      await orgRef.set({
        'email': email,
      });
      print('Organization data saved successfully in Realtime Database');
    } catch (e) {
      print("Error while saving organization data to Realtime Database: $e");
    }
  }
}
