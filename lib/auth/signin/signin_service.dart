import 'package:brainmri/auth/components/secure_storage.dart';
import 'package:brainmri/store/app_logs.dart';
import 'package:brainmri/utils/constants.dart';
import 'package:brainmri/utils/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignInService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  static Future<User?> registerOrganization(String name, String email, String password) async {
    print('Registering organization');

    try {
      // Register the new organization
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        // Save organization info in the realtime database
        DatabaseReference orgRef = _firebaseDatabase.ref().child('organizations').child(user.uid);
        await orgRef.set({
          'name': name,
          'email': email,
        });

        await _addOrganizationId(user.uid);
        await _getOrganizationId().then((value) {
          AppLog.log().i('Organization ID: $value');
        });

        showToast(message: 'Organization registered successfully', bgColor: getColor(AppColors.success));

        return user;
      } else {
        showToast(message: 'An error has occurred', bgColor: getColor(AppColors.error));
        return Future.error('An error occurred');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast(message: 'The password provided is too weak.', bgColor: getColor(AppColors.error));
        return Future.error('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showToast(message: 'The account already exists for that email. Please, Sign In', bgColor: getColor(AppColors.error));
        return Future.error('The account already exists for that email.');
      }
      showToast(message: 'An error has occurred', bgColor: getColor(AppColors.error));
      return Future.error('An error occurred');
    } catch (e) {
      showToast(message: 'An error has occurred', bgColor: getColor(AppColors.error));
      return Future.error('An error occurred');
    }
  }

  static Future<User> signIn(String email, String password) async {
    print('Signing in');

    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        await _addOrganizationId(user.uid);
        await _getOrganizationId().then((value) {
          AppLog.log().i('Organization ID: $value');
        });
        showToast(message: 'Signed in successfully', bgColor: getColor(AppColors.success));
        return user;
      } else {
        showToast(message: 'An error has occurred', bgColor: getColor(AppColors.error));
        return Future.error('An error occurred');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast(message: 'No user found for that email.', bgColor: getColor(AppColors.error));
        return Future.error('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showToast(message: 'Wrong password provided for that user.', bgColor: getColor(AppColors.error));
        return Future.error('Wrong password provided for that user.');
      }
      showToast(message: 'An error has occurred', bgColor: getColor(AppColors.error));
      return Future.error('An error occurred');
    } catch (e) {
      showToast(message: 'An error has occurred', bgColor: getColor(AppColors.error));
      return Future.error('An error occurred');
    }
  }

  static Future<void> signOut() async {
    print('Signing out');

    showToast(message: 'Signed out successfully', bgColor: getColor(AppColors.success));

    await _firebaseAuth.signOut();
  }

  static Future<void> _addOrganizationId(String uuid) async {
    await StorageService.addNewItemToKeyChain('uuid', uuid);
  }

  static Future<String?> _getOrganizationId() async {
    return await StorageService.readItemsFromToKeyChain().then((value) {
      return value['uuid'];
    });
  }
}
