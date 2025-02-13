import 'package:get/get.dart';
import 'package:task_manager/data/Urls/urls.dart';
import 'package:task_manager/data/service/network_caller.dart';

class AddNewTaskController extends GetxController {
  bool _addTaskInProgress = false;
  bool get addTaskInProgress => _addTaskInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> addNewTask(String title, String description) async {
    bool isSuccess = false;
    _addTaskInProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "title": title,
      "description": description,
      "status": "New"
    };
    NetworkResponse response =
        await NetworkCaller.getPost(url: Urls.createUrls, body: requestBody);
    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _addTaskInProgress = false;
    update();
    return isSuccess;
  }
}
