
class Urls {
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';
  static const String registrationUrls = '$_baseUrl/registration';
  static const String loginUrls = '$_baseUrl/login';
  static const String createUrls = '$_baseUrl/createTask';
  static const String taskCountByStatusUrl = '$_baseUrl/taskStatusCount';
  static String taskListByStatusUrl(String status) =>
      '$_baseUrl/listTaskByStatus/$status';
  static String statusUpdateTaskUrl(String id,String status) =>
      '$_baseUrl/updateTaskStatus/$id/$status';
  static String deleteTaskUrl(String id) =>
      '$_baseUrl/deleteTask/$id';
  static const String updateProfile = '$_baseUrl/profileUpdate';
 static  String verifyEnailUrl(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
 static  String verifyOtpEnailUrl(String email,String otp) => '$_baseUrl/RecoverVerifyOTP/$email/$otp';
 static const String recoverPassword = '$_baseUrl/RecoverResetPass';
}
