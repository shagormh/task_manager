import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/ui/controllers/auth_controllers.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';

class NetworkResponse {
  final int statusCode;
  final Map<String, dynamic>? responseData;
  final bool isSuccess;
  final String errorMessage;
  NetworkResponse(
      {required this.statusCode,
      required this.isSuccess,
      this.responseData,
      this.errorMessage = 'something went wrong'});
}

class NetworkCaller {
  static Future<NetworkResponse> getRequest(
      {required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      debugPrint('URL => $url');
      Response response = await get(
          uri,
          headers: {
        'token': AuthController.accessToken ?? '',
      }
      );
      debugPrint('Response Code => ${response.statusCode}');
      debugPrint('Response data => ${response.body}');
      if (response.statusCode == 200) {
        final decodeResponse = jsonDecode(response.body);
        return NetworkResponse(
            statusCode: response.statusCode,
            isSuccess: true,
            responseData: decodeResponse
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      }
    } catch (e) {
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
      );
    }
  }

  static Future<NetworkResponse> getPost(
      {required String url, Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      debugPrint('Url => $url');
      debugPrint('Url => $body');
      Response response = await post(
        uri,
        headers: {
          'content-type': 'application/json',
          'token': AuthController.accessToken ?? '',
        },
        body: jsonEncode(body),
      );
      debugPrint('Response Code => ${response.statusCode}');
      debugPrint('Response data => ${response.body}');
      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          responseData: decodeData,
        );
      } else if (response.statusCode == 401) {
        await _logOut();
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      } else {
        return NetworkResponse(
            statusCode: response.statusCode, isSuccess: false);
      }
    } catch (e) {
      return NetworkResponse(
          statusCode: -1, isSuccess: false, errorMessage: e.toString());
    }
  }

  static Future<void> _logOut() async {
    await AuthController.clearData();
    Navigator.pushNamedAndRemoveUntil(TaskManager.navigatorKey.currentContext!,
        SignInScreen.name, (context) => false);
  }
}
