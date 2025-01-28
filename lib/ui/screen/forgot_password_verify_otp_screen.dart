import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/data/Urls/urls.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/ui/screen/reset_password_screen.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/widget/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widget/screen_background.dart';
import 'package:task_manager/ui/widget/snack_bar_message.dart';
import '../utlis/app_color.dart';

class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
   ForgotPasswordVerifyOtpScreen({super.key, required this.emailAddress});
  static const String name = 'forgot_password_verify_otp_screen';
  final String emailAddress;
  @override
  State<ForgotPasswordVerifyOtpScreen> createState() => _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState extends State<ForgotPasswordVerifyOtpScreen> {
  final TextEditingController _otpTEControlar = TextEditingController();
  final GlobalKey<FormState>  _formKey = GlobalKey<FormState>();
  bool _forgotPasswordVerifyEmailOtpInProgress = false;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
       //appBar: AppBar(title: Text(receiveEmail)),
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
                  Text('Pin Verification', style: textTheme.titleLarge),
                  const SizedBox(height: 4,),
                  Text('A 6 digit vetification pin will sent to Your Email Address',style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),),
                  const SizedBox(
                    height: 24,
                  ),
                  _PinCodeTextField(),
                  const SizedBox(
                    height: 16,
                  ),
                  Visibility(
                    visible: _forgotPasswordVerifyEmailOtpInProgress == false,
                    replacement:  const CenterCircularProgressIndicator(),
                    child: ElevatedButton(
                        onPressed: () {
                          onTapForgetPasswordOtp();
                        },
                        child: const Icon(Icons.arrow_circle_right_rounded)),
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
void onTapForgetPasswordOtp(){
    if(_formKey.currentState!.validate()){
      _getForgotPassowrdOtpVerify();
    }
}

  Widget _PinCodeTextField() {
    return PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.blue.shade50,
                  enableActiveFill: true,
                  controller: _otpTEControlar,
                  appContext : context,
                  validator: (String? value){
                    if(value?.trim().isEmpty ?? true){
                      return 'Please 6 digit password Required';
                    }
                    return null;
                  },
                );
  }

  Widget buitlSignInSection() {
    return RichText(
      text: TextSpan(
          text: "have an Account? ",
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
          children: [
            TextSpan(
                text: 'Sign In',
                style: TextStyle(
                  color: AppColor.themeColor,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {
                  Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name , (value) => false);
                }),
          ]),
    );
  }

  Future<void> _getForgotPassowrdOtpVerify()async{
    _forgotPasswordVerifyEmailOtpInProgress =true;
    setState(() {});
    NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.verifyOtpEnailUrl(widget.emailAddress,_otpTEControlar.text)
    );
    _forgotPasswordVerifyEmailOtpInProgress = false;
    setState(() {});
    if(response.isSuccess){
      Navigator.pushNamed(context, ResetPasswordScreen.name,arguments: {'email': widget.emailAddress, 'otp': _otpTEControlar.text});
    }else{
      ShowSnackBarMessage(context, "Something Went Wrong");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _otpTEControlar.dispose();
    super.dispose();
  }
}
