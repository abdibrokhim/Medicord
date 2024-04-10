import 'package:brainmri/auth/signin/signin_screen.dart';
import 'package:brainmri/screens/observation/components/custom_text_field.dart';
import 'package:brainmri/screens/observation/components/custom_textformfield.dart';
import 'package:brainmri/screens/observation/components/primary_custom_button.dart';
import 'package:brainmri/screens/profile/organization_model.dart';
import 'package:brainmri/screens/user/user_epics.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/constants.dart';
import 'package:brainmri/utils/refreshable.dart';
import 'package:brainmri/utils/shared.dart';
import 'package:brainmri/utils/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

  int calculateLines(BuildContext context, String text) {
    final TextSpan span = TextSpan(text: text);
    final TextPainter tp = TextPainter(
      text: span,
      maxLines: null,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: MediaQuery.of(context).size.width*0.7);
    print(tp.computeLineMetrics().length);
    return tp.computeLineMetrics().length;
  }

  void showEditBottomSheet(BuildContext context, String content, int maxLines, int toUpdate, String name) {

    final TextEditingController _dController = TextEditingController();
    
    _dController.text = content ?? '';

    final bool loading = false;

  showModalBottomSheet(
    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return 
                      StoreConnector<GlobalState, OrganizationModel>(
      onInit: (store) {
      },
      converter: (appState) => appState.state.appState.userState.organization!,
      builder: (context, o) {
        final userState = StoreProvider.of<GlobalState>(context).state.appState.userState;
        return
          Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 800,
        color: const Color.fromARGB(255, 31, 33, 38),
                      child:
                      Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: SingleChildScrollView(child: 
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
                            Text(
                              'Edit ${name}',
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
      Container(
        alignment: Alignment.center,
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Color.fromARGB(200, 255, 255, 255), // Add your background color here
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, color: Colors.black, size: 18,),
        ),
      ),
    ],
),
const SizedBox(height: 16),
                      Text(
                              'After editing, make sure to save the changes.',
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24),
                            CustomTextFormField(
  labelText: name,
  isInputEmpty: _dController.text.isEmpty,
  onChanged: (value) => _dController.text = value,
  onClear: () => _dController.text = '',
  initialValue: _dController.text,
  isReadOnly: false,
  maxLines: maxLines,
),

const SizedBox(height: 32.0),

  SizedBox(
                  width: double.infinity,
                  child:
          ElevatedButton(
  onPressed: (userState.isFetchingOrganization || userState.isSavingOrganizationDetails) ? () {} : () async {
print('Updating ${name}...');


        if (_dController.text.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showToast(message: '${name} is required.', bgColor: Colors.red[900]);
          });
          return;
        } else {

        // simulate approval
      // StoreProvider.of<GlobalState>(context).dispatch(
      //     SimulateApprovePatientConclusionAction(),
      //   );

        final OrganizationModel updatedOrganization = o.copyWith();

        StoreProvider.of<GlobalState>(context).dispatch(
          SaveOrganizationDetailsAction(
            updatedOrganization.copyWith(
              fullName: toUpdate == 0 ? _dController.text : o.fullName,
              phoneNumber: toUpdate == 1 ? _dController.text : o.phoneNumber,
              fullAddress: toUpdate == 2 ? _dController.text : o.fullAddress,
            ),
          ),
        );
        }

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
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Set the padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)), // Set the border radius
            side: BorderSide(
        color: Colors.white,
        width: 2,
      ),
    ),
  ),
  child: 
    (userState.isFetchingOrganization || userState.isSavingOrganizationDetails) ? 
      CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF232428)), // Change the progress color
    backgroundColor: Color(0xFFC3C3C3), // Change the background color
  ) :
  Text(
    'Save'
  ),
),
),
const SizedBox(height: 60,),
                          ],
),
                        ),
                        ),
                      );
                    },
                  );
                    },
  );
}

class OrganizationScreen extends StatefulWidget {
  
  const OrganizationScreen({super.key});

  @override
  State<OrganizationScreen> createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {
  // OrganizationModel organization = OrganizationModel();

    String fullName = '';
    String phoneNumber = '';
    String fullAddress = '';
    String displayName = 'No name';

  @override
  Widget build(BuildContext context) {
      
      final User user = FirebaseAuth.instance.currentUser!;

      final state = StoreProvider.of<GlobalState>(context).state;

          final String photoUrl = defaultProfileImage;
    final String email = user.email!;

    void updateValues() {
      setState(() {
        print('Updating values...');
        print('user.photoURL: ${user.photoURL}');
        
        // if (user.photoURL != null) {
        //   photoUrl = user.photoURL!;
        // } 
        if (state.appState.userState.organization!.name != null) {
          displayName = state.appState.userState.organization!.name!;
        }
        // if (user.email != null) {
        //   email = user.email!;
        // }
        if (state.appState.userState.organization!.fullName != null) {
          fullName = state.appState.userState.organization!.fullName!;
        }
        if (state.appState.userState.organization!.phoneNumber != null) {
          phoneNumber = state.appState.userState.organization!.phoneNumber!;
        }
        if (state.appState.userState.organization!.fullAddress != null) {
          fullAddress = state.appState.userState.organization!.fullAddress!;
        }

      });
    }

    @override
    void initState() {
      super.initState();
    }

    void reFetchData()  {
      StoreProvider.of<GlobalState>(context).dispatch(FetchOrganizationAction());
      print('FetchOrganizationAction orgId: ${store.state.appState.userState.organization!.id!}');
      
        updateValues();
  }

  final RefreshController _refreshController =
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

    return 
StoreConnector<GlobalState, UserState>(
  onInit: (store) {
    print('Fetching organization...');
    store.dispatch(FetchOrganizationAction());
    print('FetchOrganizationAction orgId: ${store.state.appState.userState.organization!.id!}');
    print('Details...');
    print('store.state.appState.userState.organization!.name: ${store.state.appState.userState.organization!.name}');
    print('store.state.appState.userState.organization!.email: ${store.state.appState.userState.organization!.email}');
    print('store.state.appState.userState.organization!.fullName: ${store.state.appState.userState.organization!.fullName}');
    print('store.state.appState.userState.organization!.phoneNumber: ${store.state.appState.userState.organization!.phoneNumber}');
    print('store.state.appState.userState.organization!.fullAddress: ${store.state.appState.userState.organization!.fullAddress}');

        if (state.appState.userState.organization!.name != null) {
          displayName = state.appState.userState.organization!.name!;
        }
            if (state.appState.userState.organization!.fullName != null) {
          fullName = state.appState.userState.organization!.fullName!;
        }
                if (state.appState.userState.organization!.phoneNumber != null) {
          phoneNumber = state.appState.userState.organization!.phoneNumber!;
        }
        if (state.appState.userState.organization!.fullAddress != null) {
          fullAddress = state.appState.userState.organization!.fullAddress!;
        }
  },
  onDidChange: (prev, next) {
    if (!next.isLoggedIn) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignInScreen()));
    }
    // if (next.organization != null) {
    //   updateValues();
    // }
  },
        converter: (store) => store.state.appState.userState,
        builder: (context, userState) {

    return 
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      color: const Color.fromARGB(255, 31, 33, 38),
      child: 
    Center(
        child: 
        Refreshable(
            refreshController: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: 
            
            (userState.isFetchingOrganization || userState.isSavingOrganizationDetails) ?

            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF232428)), // Change the progress color
                backgroundColor: Color(0xFFC3C3C3), // Change the background color
              ),
            ) :

            ListView(
              children: [

        // Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // children: <Widget>[
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

        const SizedBox(height: 32.0),
        // info

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [ 
          IconButton(
            onPressed: () {
              List<String> content = [
                'If you updated information, and do not see the changes, please refresh the screen.',
                'Updates may take a few seconds to reflect. Usually from 5 to 10 seconds.',
                'If you face any issues, like; lagging, freezing, or any other, please go to another screen, then back again.',
                'We are always working to improve the app.',
              ];
              int state = 0; // 0 => info
              String label = 'Quick Info';
              String infoText = 'Please read the following information carefully. It applies to the whole app.';
              Color bgColor = Color(0xFFCBF3FF);
              Color txtColor = Colors.blue[900]!;
              showMixedBottomSheet(context, content, state, label, infoText, bgColor, txtColor);
            }, 
            icon: Icon(Icons.info_outline_rounded, color: Colors.white),
          ),
        ],
        ),
        // form
        const SizedBox(height: 16.0),
        CustomTextField(
  labelText: 'Full name (tap to edit)',
  initialValue: fullName,
  maxLines: fullName.isEmpty ? 1 : calculateLines(context, fullName),
  onTap: () {
    final int toUpdate = 0;
    showEditBottomSheet(context, fullName, fullName.isEmpty ? 1 : calculateLines(context, fullName), toUpdate, 'Full Name');
  },
),
  const SizedBox(height: 24.0),
        CustomTextField(
  labelText: 'Phone number (tap to edit)',
  initialValue: phoneNumber,
  maxLines: phoneNumber.isEmpty ? 1 : calculateLines(context, phoneNumber),
  onTap: () {
    final int toUpdate = 1;
    showEditBottomSheet(context, phoneNumber, phoneNumber.isEmpty ? 1 : calculateLines(context, phoneNumber), toUpdate, 'Phone Number');
  },
),
  const SizedBox(height: 24.0),
        CustomTextField(
  labelText: 'Full Address (tap to edit)',
  initialValue: fullAddress,
  maxLines: fullAddress.isEmpty ? 1 : calculateLines(context, fullAddress),
  onTap: () {
    final int toUpdate = 2;
    showEditBottomSheet(context, fullAddress, fullAddress.isEmpty ? 1 : calculateLines(context, fullAddress), toUpdate, 'Full Address');
  },
),
  const SizedBox(height: 40.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
        PrimaryCustomButton(
          label: 'Sign Out',
          onPressed: () {
            store.dispatch(SignOutAction());
          },
          loading: userState.isLoading,
          isDisabled: userState.isLoading,
        ),
        SizedBox(height: 40,),
                  ],
        )
          ]
        ),
        ),
        ),
    );

        }
    );
  }
}