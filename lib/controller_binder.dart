import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/add_new_task_controller.dart';
import 'package:task_manager/ui/controllers/auth_controllers.dart';
import 'package:task_manager/ui/controllers/cancelled_task_controller.dart';
import 'package:task_manager/ui/controllers/complete_task_controller.dart';
import 'package:task_manager/ui/controllers/forgot_password_verify_email_controller.dart';
import 'package:task_manager/ui/controllers/forgot_password_verify_otp_controller.dart';
import 'package:task_manager/ui/controllers/new_task_controller.dart';
import 'package:task_manager/ui/controllers/progress_task_controller.dart';
import 'package:task_manager/ui/controllers/reset_password_controller.dart';
import 'package:task_manager/ui/controllers/sign_in_controller.dart';
import 'package:task_manager/ui/controllers/sign_up_controller.dart';
import 'package:task_manager/ui/controllers/task_list_summary_controller.dart';
import 'package:task_manager/ui/controllers/update_profile_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => SignInController());
    Get.put(NewTaskController());
    Get.put(ProgressTaskController());
    Get.put(CompleteTaskController());
    Get.put(CancelledTaskController());
    Get.put(TaskListSummaryController());
    Get.lazyPut(() => AddNewTaskController());
    Get.lazyPut(() => UpdateProfileController());
    Get.put(AuthController());
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => ForgotPasswordVerifyEmailController());
    Get.lazyPut(() => ForgotPasswordVerifyOtpController());
    Get.lazyPut(() => ResetPasswordController());
  }

}