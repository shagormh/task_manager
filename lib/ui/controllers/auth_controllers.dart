import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/models/user_model.dart';

class AuthController extends GetxController{
  static String? accessToken;
  static UserModel? userModel;
  UserModel? get userInfo => userModel;
  static const String _accessTokenKey= 'access-token';
  static const String _accessDataKey= 'user-data';

  static Future<void> saveUserData(String token,UserModel model)async{
  SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
  await sharedPreferences.setString(_accessTokenKey, token);
  await sharedPreferences.setString(_accessDataKey, jsonEncode(model.toJson()));
  }

  static Future<void> getUserData()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessTokenKey);
    String? userData = sharedPreferences.getString(_accessDataKey);
    accessToken = token;
    userModel = UserModel.fromJson(jsonDecode(userData!));
  }

  static Future<bool> isUserLoggedIn()async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token= sharedPreferences.getString(_accessTokenKey);
   if(token != null){
    await getUserData();
    return true;
   }
   return false;
   }

   static Future<void> clearData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
   }
}