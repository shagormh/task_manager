import 'package:get/get.dart';
import 'package:task_manager/data/Urls/urls.dart';
import 'package:task_manager/data/service/network_caller.dart';

class ForgotPasswordVerifyOtpController extends GetxController {
  bool _forgotPasswordOtpVerifyInProgress = false;
  bool get forgotPasswordOtpVerifyInProgress => _forgotPasswordOtpVerifyInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> forgotPasswordOtp(String email,String otp) async {
    bool isSuccess = false;
    _forgotPasswordOtpVerifyInProgress = true;
    update();
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.verifyOtpEnailUrl(email, otp));
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _forgotPasswordOtpVerifyInProgress = false;
    update();
    return isSuccess;
  }

}
