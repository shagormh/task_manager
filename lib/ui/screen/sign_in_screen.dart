import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/Urls/urls.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/ui/controllers/auth_coltrollers.dart';
import 'package:task_manager/ui/screen/forgot_password_verify_email_screen.dart';
import 'package:task_manager/ui/screen/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/screen/sign_up_screen.dart';
import 'package:task_manager/ui/widget/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widget/screen_background.dart';
import 'package:task_manager/ui/widget/snack_bar_message.dart';
import '../utlis/app_color.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const String name = 'sign_in_screen';
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEControlar = TextEditingController();
  final TextEditingController _passwordTEControlar = TextEditingController();
  final GlobalKey<FormState>  _formKey = GlobalKey<FormState>();
  bool _signInProgress= false;
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Text('Get Started With', style: textTheme.titleLarge),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: _emailTEControlar,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                      validator: (String? value){
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter a valid email address';
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
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter your valid password';
                      }
                      return null;
                    },

                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Visibility(
                    visible: _signInProgress == false,
                    replacement: Center(
                      child: CenterCircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                        onPressed: () {
                          _onTapSignInButton();
                        },
                        child: const Icon(Icons.arrow_circle_right_rounded)),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Center(
                      child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, ForgotPasswordVerifyEmailScreen.name);
                          }, child: Text('Forgot Password',style: TextStyle(
                        color: AppColor.themeColor,fontWeight: FontWeight.bold,
                      ),))),
                  Center(
                    child: Column(
                      children: [
                        buitlSignUpSection(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
 void _onTapSignInButton(){
    if(_formKey.currentState!.validate()){
      _signIn();
    }

 }
 Future<void> _signIn()async{
   _signInProgress =true;
   setState(() {});
    Map<String,dynamic> RequestBody={
      "email":_emailTEControlar.text.trim(),
   "password": _passwordTEControlar.text
    };
  final  NetworkResponse response = await NetworkCaller.getPost(url: Urls.loginUrls,body: RequestBody);
  if(response.isSuccess){
    String token = response.responseData!['token'];
    UserModel userModel = UserModel.fromJson(response.responseData!['data']);
    await AuthController.saveUserData(token, userModel);
    Navigator.pushReplacementNamed(context, MainBottomNavScreen.name);
  }else{
    _signInProgress =false;
    setState(() {});
    if(response.statusCode == 401){
      ShowSnackBarMessage(context, 'Email/Password is invalid! Try again');
    }else{
      ShowSnackBarMessage(context, response.errorMessage);
    }
  }
 }
  Widget buitlSignUpSection() {
    return RichText(
      text: TextSpan(
          text: "'Don't have an Account? ",
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
          children: [
            TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: AppColor.themeColor,
                  fontWeight: FontWeight.bold
                ),
                recognizer: TapGestureRecognizer()..onTap = () {
                  Navigator.pushNamed(context, SignUpScreen.name);
                }),
          ]),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _emailTEControlar.dispose();
    _passwordTEControlar.dispose();
    super.dispose();
  }
}
