import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/reset_password_controller.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/widget/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widget/screen_background.dart';
import 'package:task_manager/ui/widget/snack_bar_message.dart';
import '../utlis/app_color.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key,required this.emailOtp});
  static const String name = 'forgot_password/reset_password';
  final emailOtp;
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final GlobalKey<FormState>  _formKey = GlobalKey<FormState>();
final ResetPasswordController _resetPasswordController = Get.find<ResetPasswordController>();
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
                  Text('Set Password', style: textTheme.titleLarge),
                  const SizedBox(height: 4,),
                  Text('Minimum length password 6 character with Latter and number combination',style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),),
                  const SizedBox(
                    height: 24,
                  ),
              TextFormField(
                  controller: _newPasswordTEController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'New Password'),
                  validator: (String? value){
                    if(value?.trim().isEmpty ?? true){
                      return 'Please give 6 digit password';
                    } else if(value!.length < 6){
                      return 'Minimum Password Should Be 6 Digit';
                    }
                    return null;
                  },
              ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                      controller: _confirmPasswordTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Confrim Password'),
                      validator: (String? value){
                        if(value?.trim().isEmpty ?? true){
                          return 'Please give 6 digit password';
                        } else if(value!.length < 6){
                          return 'Minimum Password Should Be 6 Digit';
                        } else if(value != _newPasswordTEController.text){
                          return 'Password do not match';
                        }
                        return null;
                      }
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GetBuilder<ResetPasswordController>(
                    builder: (controller) {
                      return Visibility(
                        visible: controller.resetPasswordInProgress == false,
                        replacement:  const CenterCircularProgressIndicator(),
                        child: ElevatedButton(
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
                                _resetPasswordScreen();

                              }
                            },
                            child: const Text('Confirm')),
                      );
                    }
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Center(
                    child: buitlSignInSection(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buitlSignInSection() {
    return RichText(
      text: TextSpan(
          text: "have an Account? ",
          style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
          children: [
            TextSpan(
                text: 'Sign In',
                style: const TextStyle(
                  color: AppColor.themeColor,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {
                  // Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name , (value) => false);
                  Get.offAllNamed(SignInScreen.name);
                }),
          ]),
    );
  }
  Future<void> _resetPasswordScreen()async{
 final bool isSuccess = await _resetPasswordController.resetPassword(
     widget.emailOtp['email'],
     widget.emailOtp['otp'],
     _newPasswordTEController.text);
    if(isSuccess){
      _clearTextFields();
      ShowSnackBarMessage(context, 'Password Update Success');
    }else{
      ShowSnackBarMessage(context, 'Password Not Update Success');
    }
  }
  void _clearTextFields(){
    _newPasswordTEController.clear();
    _confirmPasswordTEController.clear();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _newPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
