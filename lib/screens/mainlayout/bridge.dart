import 'package:brainmri/auth/components/secure_storage.dart';
import 'package:brainmri/auth/signin/signin_screen.dart';
import 'package:brainmri/screens/mainlayout/main_layout_screen.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Bridge extends StatelessWidget {
  
  const Bridge({Key? key}) : super(key: key);

  static Future<bool> _getOrganizationId() async {
    return await StorageService.readItemsFromToKeyChain().then((value) {
      if (value['uuid'] != null) {
        return true;
      }
      return false;
    });
  }


  @override
  Widget build(BuildContext context) {
    bool isO = false;

    // _getOrganizationId().then((value) {
    //   isO = value;
    // });

    return StoreConnector<GlobalState, bool>(
        converter: (store) => store.state.appState.userState.isLoggedIn,
        builder: (context, isLoggedIn) {
          return (isLoggedIn || isO) ? const MainLayout() : const SignInScreen();
        }
    );
  }
}