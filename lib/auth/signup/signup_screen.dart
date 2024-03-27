import 'package:brainmri/screens/mainlayout/main_layout_screen.dart';
import 'package:brainmri/screens/observation/components/custom_textformfield.dart';
import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


class SignUpScreen extends StatefulWidget {
  static const String routeName = "/signUp";

  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
  if (_nameController.text.isEmpty) {
    addError(error: 'Company Name is required');
  }

  if (_emailController.text.isEmpty) {
    addError(error: 'Email is required');
  }

  if (_passwordController.text.isEmpty) {
    addError(error: 'Password is required');
  }

  }


  void _performSignUp() {

    fillErrorList();
    
    if (errors.isNotEmpty) {
  showErrorBottomSheet(context, errors);
} else {

    StoreProvider.of<GlobalState>(context).dispatch(
      SignUpAction(_nameController.text, _emailController.text, _passwordController.text),
    );
  }
} 

  @override
  Widget build(BuildContext context) {
    var state = StoreProvider.of<GlobalState>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 33, 38),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Sign Up', 
        style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
        ),
        backgroundColor: const Color.fromARGB(255, 23, 24, 28),
        ),
      body: StoreConnector<GlobalState, UserState>(
        onDidChange: (prev, next) {
          if (next.isSignedUp) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainLayout()),
            );
          }
        },
              onInit: (store) {
              },
              converter: (store) => store.state.appState.userState,
              builder: (context, userState) {
                return
      SingleChildScrollView(
        child: Padding(
              padding: const EdgeInsets.all(20),
              child:
        Column(
          children: [
                                  const SizedBox(height: 20,),
                      const SizedBox(height: 20,),
                      CustomTextFormField(
  labelText: 'Company Name',
  isInputEmpty: _nameController.text.isEmpty,
                  onChanged: (value) => setState(() => _nameController.text = value),
  onClear: () => setState(() => _nameController.text = ''),
  initialValue: _nameController.text,
),
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
  onPressed: _performSignUp,
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
  child: Text(
    'Sign Up'
  ),
),
),
          ],
        ),
        ),
      );
              },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
