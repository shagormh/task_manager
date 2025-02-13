import 'package:get/get.dart';
import 'package:task_manager/data/Urls/urls.dart';
import 'package:task_manager/data/service/network_caller.dart';

class ResetPasswordController extends GetxController {
  bool _resetPasswordInProgress = false;
  bool get resetPasswordInProgress => _resetPasswordInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> resetPassword(String email,String otp,String password) async {
    bool isSuccess = false;
    _resetPasswordInProgress = true;
    update();
    Map<String,dynamic> requestBody = {
      "email":email,
      "OTP":otp,
      "password":password
    };
    final NetworkResponse response =
    await NetworkCaller.getPost(url:Urls.recoverPassword,body: requestBody );
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _resetPasswordInProgress = false;
    update();
    return isSuccess;
  }

}
