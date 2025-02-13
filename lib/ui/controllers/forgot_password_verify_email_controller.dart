import 'package:get/get.dart';
import 'package:task_manager/data/Urls/urls.dart';
import 'package:task_manager/data/service/network_caller.dart';

class ForgotPasswordVerifyEmailController extends GetxController {
  bool _forgotPasswordEmailVerifyInProgress = false;
  bool get forgotPasswordEmailVerifyInProgress => _forgotPasswordEmailVerifyInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> forgotPasswordEmail(String email) async {
    bool isSuccess = false;
    _forgotPasswordEmailVerifyInProgress = true;
    update();
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.verifyEnailUrl(email));
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _forgotPasswordEmailVerifyInProgress = false;
    update();
    return isSuccess;
  }

}
