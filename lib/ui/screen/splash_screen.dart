import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_coltrollers.dart';
import 'package:task_manager/ui/screen/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/widget/app_logo.dart';
import 'package:task_manager/ui/widget/screen_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String name = '/';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    moveToNextScreen();
  }

  Future<void> moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    bool isuserLoggedIn = await AuthController.isUserLoggedIn();
    if(isuserLoggedIn){
      Navigator.pushReplacementNamed(context, MainBottomNavScreen.name);
    }else{
      Navigator.pushReplacementNamed(context, SignInScreen.name);
    }

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenBackground(
        child: Center(
          child:  AppLogo(),
        ),
        ),
      );
  }
}
