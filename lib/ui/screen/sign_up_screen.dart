import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/sign_up_controller.dart';
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
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileNumberTEController =
      TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignUpController _signUpController = Get.find<SignUpController>();
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
                    controller: _emailTEController,
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
                    controller: _firstNameTEController,
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
                    controller: _lastNameTEController,
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
                    controller: _mobileNumberTEController,
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
                    controller: _passwordTEController,
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
                  GetBuilder<SignUpController>(
                    builder: (controller) {
                      return Visibility(
                        visible: controller.signUpInProgress == false,
                        replacement:const CenterCircularProgressIndicator(),
                        child: ElevatedButton(
                            onPressed: _onTapSignupButton,
                            child: const Icon(Icons.arrow_circle_right_rounded)),
                      );
                    }
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
      _registratonUser();
    }
  }

  Future<void> _registratonUser() async {
   final bool isSuccess = await _signUpController.signUp(
       _emailTEController.text.trim(),
       _firstNameTEController.text.trim(),
       _lastNameTEController.text.trim(),
       _mobileNumberTEController.text.trim(),
       _passwordTEController.text);
   if(isSuccess){
     _clearTextFields();
     ShowSnackBarMessage(context, 'Registration Success');
   }else{
     ShowSnackBarMessage(context, 'Registration Not Success');
   }
  }

  void _clearTextFields() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileNumberTEController.clear();
    _passwordTEController.clear();
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
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileNumberTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
