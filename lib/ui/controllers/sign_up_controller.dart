import 'package:get/get.dart';
import 'package:task_manager/data/Urls/urls.dart';
import 'package:task_manager/data/service/network_caller.dart';

class SignUpController extends GetxController{
  bool _signUpProgress = false;
  bool get signUpInProgress => _signUpProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> signUp(String email,String firstName,String lastName,String mobile,String password,)async{
    bool isSuccess = false;
    _signUpProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
      "photo": ""
    };
    final NetworkResponse response = await NetworkCaller.getPost(
        url: Urls.registrationUrls,
        body:requestBody
    );
    if(response.isSuccess){
      isSuccess = true;
      _errorMessage = null;
    }else{
        _errorMessage = response.errorMessage;
    }
    _signUpProgress=false;
    update();
    return isSuccess;
  }
}