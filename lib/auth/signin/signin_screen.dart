import 'package:brainmri/auth/components/google_provider.dart';
import 'package:brainmri/auth/signup/signup_screen.dart';
import 'package:brainmri/screens/mainlayout/main_layout_screen.dart';
import 'package:brainmri/screens/observation/components/custom_textformfield.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


class SignInScreen extends StatefulWidget {
  static String routeName = "/signIn";
  
  final VoidCallback? onSignUpRequested;
  final VoidCallback? onForgotPasswordRequested;
  
  const SignInScreen({
    Key? key, 
    this.onSignUpRequested,
    this.onForgotPasswordRequested,
  }) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool showOnce = true;

    List<String> errors = [];

  @override
  void initState() {
    super.initState();

    initErrors();
  }

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void initErrors() {
    setState(() {
      errors = [];
    });
  }


  void fillErrorList() {
  // Reinitialize errors
  initErrors();

  // Add errors
  if (_emailController.text.isEmpty) {
    addError(error: 'Email is required');
  }

  if (_passwordController.text.isEmpty) {
    addError(error: 'Password is required');
  }

  }

  void _performLogin() async {
    print('Performing login.');
    
    fillErrorList();
    
    if (errors.isNotEmpty) {
  showErrorBottomSheet(context, errors);
} else {

    StoreProvider.of<GlobalState>(context).dispatch(
      LoginAction(_emailController.text, _passwordController.text),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 33, 38),
      appBar: AppBar(
        title: const Text(
          'Sign In',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
        ),
        backgroundColor: const Color.fromARGB(255, 23, 24, 28),
      ),
      body: StoreConnector<GlobalState, UserState>(
        converter: (store) => store.state.appState.userState,
        builder: (context, userState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child:
            Column(
              children: [
                      const SizedBox(height: 20,),
                      const SizedBox(height: 20,),

                      CustomTextFormField(
  labelText: 'Email',
  isInputEmpty: _emailController.text.isEmpty,
  onChanged: (value) => setState(() => _emailController.text = value),
  onClear: () => setState(() => _emailController.text = ''),
  initialValue: _emailController.text,
),

                const SizedBox(height: 20,),
                      CustomTextFormField(
  labelText: 'Password',
  isInputEmpty: _passwordController.text.isEmpty,
                  onChanged: (value) => setState(() => _passwordController.text = value),
  onClear: () => setState(() => _passwordController.text = ''),
  initialValue: _passwordController.text,
  obscureText: true
),


                const SizedBox(height: 60,),

                SizedBox(
                  width: double.infinity,
                  child:
                ElevatedButton(
  onPressed: _performLogin,
  style: ElevatedButton.styleFrom(
    // elevation: 5,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent, // Set the background color
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
  child: userState.isLoading ? 
      CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF232428)), // Change the progress color
    backgroundColor: Color(0xFFC3C3C3), // Change the background color
  ) :
  Text(
    'Sign In'
  ),
),
),
                const SizedBox(height: 20,),
                
                Text("Or".toUpperCase(), style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),),
                const SizedBox(height: 20,),
SignInWithGoogleWidget(),
                const SizedBox(height: 20,),

                Text("Don't have an account?".toUpperCase(), style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),),
                const SizedBox(height: 20,),
                                SizedBox(
                  width: double.infinity,
                  child:
                ElevatedButton(
                        onPressed: () {
                                                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                      },
  style: ElevatedButton.styleFrom(
    // elevation: 5,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent, // Set the background color
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
  child: userState.isLoading ? 
      CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF232428)), // Change the progress color
    backgroundColor: Color(0xFFC3C3C3), // Change the background color
  ) :
  Text(
    'Sign Up'
  ),
),
),
              ],
            ),
            ),
          );
        },
        onDidChange: (prev, next) {
          if (next.isLoggedIn && next.user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainLayout()),
            );
          }
        },
        onDispose: (store) {},
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
