import 'package:get/get.dart';
import 'package:task_manager/data/Urls/urls.dart';
import 'package:task_manager/data/models/task_count_by_status_model.dart';
import 'package:task_manager/data/models/task_count_model.dart';
import 'package:task_manager/data/service/network_caller.dart';

class TaskListSummaryController extends GetxController {
  bool _getTaskListCountSummary = false;
  bool get getTaskCountByStatusInProgress => _getTaskListCountSummary;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  TaskCountByStatusModel? _taskCountByStatusModel;
  List<TaskCountModel> get taskCount =>
      _taskCountByStatusModel?.TaskByStatusList ?? [];

  Future<bool> getTaskListCountSummary() async {
    bool isSuccess = false;
    _getTaskListCountSummary = true;
    update();
    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.taskCountByStatusUrl);
    if (response.isSuccess) {
      _taskCountByStatusModel =
          TaskCountByStatusModel.fromJson(response.responseData!);
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _getTaskListCountSummary = false;
    update();
    return isSuccess;
  }
}
