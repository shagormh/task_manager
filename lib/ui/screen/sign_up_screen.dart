import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/Urls/urls.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/ui/widget/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widget/screen_background.dart';
import 'package:task_manager/ui/widget/snack_bar_message.dart';
import '../utlis/app_color.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String name = 'sign_up_screen';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEControlar = TextEditingController();
  final TextEditingController _firstNameTEControlar = TextEditingController();
  final TextEditingController _lastNameTEControlar = TextEditingController();
  final TextEditingController _mobileNumberTEControlar =
      TextEditingController();
  final TextEditingController _passwordTEControlar = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _signUpInProgress = false;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // appBar: AppBar(title: Text('SignIn'),),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Text('Join With Us', style: textTheme.titleLarge),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: _emailTEControlar,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _firstNameTEControlar,
                    decoration: const InputDecoration(hintText: 'First Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your First Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _lastNameTEControlar,
                    decoration: const InputDecoration(hintText: 'Last Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your Last Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _mobileNumberTEControlar,
                    decoration:
                        const InputDecoration(hintText: 'Mobile Number'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your Mobile Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passwordTEControlar,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: 'Password'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your Password';
                      }
                      if(value!.length < 6){
                        return 'Enter a password more than 6 letters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Visibility(
                    visible: _signUpInProgress == false,
                    replacement:const CenterCircularProgressIndicator(),
                    child: ElevatedButton(
                        onPressed: _onTapSignupButton,
                        child: const Icon(Icons.arrow_circle_right_rounded)),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Center(
                    child: builtSignInSection(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignupButton() {
    if (_formKey.currentState!.validate()) {
      _registeUser();
    }
  }

  Future<void> _registeUser() async {
    _signUpInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailTEControlar.text.trim(),
      "firstName": _firstNameTEControlar.text.trim(),
      "lastName": _lastNameTEControlar.text.trim(),
      "mobile": _mobileNumberTEControlar.text.trim(),
      "password": _passwordTEControlar.text,
      "photo": ""
    };
    final NetworkResponse response = await NetworkCaller.getPost(
        url: Urls.registrationUrls, body: requestBody);
    if (response.isSuccess) {
      _signUpInProgress=false;
      setState(() {});
      _clearTextFields();
      ShowSnackBarMessage(context, 'New User Registration Successful');
    } else {
      ShowSnackBarMessage(context, response.errorMessage);
    }
  }

  void _clearTextFields() {
    _emailTEControlar.clear();
    _firstNameTEControlar.clear();
    _lastNameTEControlar.clear();
    _mobileNumberTEControlar.clear();
    _passwordTEControlar.clear();
  }

  Widget builtSignInSection() {
    return RichText(
      text: TextSpan(
          text: "Already have an Account? ",
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
          children: [
            TextSpan(
                text: 'Sign In',
                style: TextStyle(
                  color: AppColor.themeColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pop(context);
                  }),
          ]),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTEControlar.dispose();
    _firstNameTEControlar.dispose();
    _lastNameTEControlar.dispose();
    _mobileNumberTEControlar.dispose();
    _passwordTEControlar.dispose();
    super.dispose();
  }
}
