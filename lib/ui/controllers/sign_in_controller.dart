import 'package:get/get.dart';
import 'package:task_manager/data/Urls/urls.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/ui/controllers/auth_controllers.dart';

class SignInController extends GetxController{
  bool _signInProgress = false;
  bool get signInProgress => _signInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email,String password)async{
    bool isSuccess = false;
    _signInProgress = true;
    update();
    Map<String,dynamic> requestBody ={
      'email': email,
      'password': password
    };
    final NetworkResponse response = await NetworkCaller.getPost(
        url: Urls.loginUrls,
        body:requestBody
    );
    if(response.isSuccess){
      String token = response.responseData!['token'];
      UserModel userModel = UserModel.fromJson(response.responseData!['data']);
      await AuthController.saveUserData(token, userModel);
      isSuccess = true;
      _errorMessage = null;
    }else{
      if(response.statusCode == 401){
        _errorMessage = 'Username/password is incorrect';
      } else{
        _errorMessage = response.errorMessage;
      }
    }
    _signInProgress = false;
    update();
    return isSuccess;
  }
}