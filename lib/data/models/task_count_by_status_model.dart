import 'package:task_manager/data/models/task_count_model.dart';

class TaskCountByStatusModel {
  String? status;
  List<TaskCountModel>? TaskByStatusList;

  TaskCountByStatusModel({this.status, this.TaskByStatusList});

  TaskCountByStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      TaskByStatusList = <TaskCountModel>[];
      json['data'].forEach((v) {
        TaskByStatusList!.add(TaskCountModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =<String, dynamic>{};
    data['status'] = status;
    if (this.TaskByStatusList != null) {
      data['data'] = this.TaskByStatusList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

