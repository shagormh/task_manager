import 'package:flutter/material.dart';
import 'package:task_manager/data/Urls/urls.dart';
import 'package:task_manager/data/models/task_count_by_status_model.dart';
import 'package:task_manager/data/models/task_count_model.dart';
import 'package:task_manager/data/models/task_list_by_status_model.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/ui/controllers/auth_coltrollers.dart';
import 'package:task_manager/ui/screen/add_new_task_screen.dart';
import 'package:task_manager/ui/widget/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widget/screen_background.dart';
import 'package:task_manager/ui/widget/snack_bar_message.dart';
import 'package:task_manager/ui/widget/task_item_widget.dart';
import 'package:task_manager/ui/widget/task_status_summery_counter_widget.dart';
import 'package:task_manager/ui/widget/tm_app_bar.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});
  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  bool _getTaskCountByStatusInProgress = false;
  bool _getTaskListByStatusInProgress = false;
  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? newTaskListByStatusModel;
  TaskListModel? taskListModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskListSummeryDelayed();
    _taskListDelayed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
          child: Column(
            children: [
              _buildTaskSummeryByStatus(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Visibility(
                  visible: _getTaskListByStatusInProgress == false,
                    replacement: const CenterCircularProgressIndicator(),
                    child: _buildTaskListView()
                ),
              )
            ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddNewTaskScreen.name);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ListView _buildTaskListView() {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: newTaskListByStatusModel?.taskList?.length ?? 0,
        itemBuilder: (context, index) {
          return TaskItemWidget(
            status: 'New',
            color: Color(0xff17C1E8),
            taskListModel: newTaskListByStatusModel!.taskList![index],
          );
        });
  }

  Widget _buildTaskSummeryByStatus() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Visibility(
        visible: _getTaskCountByStatusInProgress == false,
        replacement: const CenterCircularProgressIndicator(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 98,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount:
                    taskCountByStatusModel?.TaskByStatusList?.length ?? 0,
                itemBuilder: (context, index) {
                  final TaskCountModel model =
                      taskCountByStatusModel!.TaskByStatusList![index];
                  return TaskStatusSummeryCounterWidget(
                    title: model.sId ?? '',
                    count: model.sum.toString(),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Future<void> _getTaskCountByStatus() async {
    _getTaskCountByStatusInProgress = true;
    setState(() {});
    final NetworkResponse response =
        await NetworkCaller.getRequest(url: Urls.taskCountByStatusUrl);

    if (response.isSuccess) {
      taskCountByStatusModel =
          TaskCountByStatusModel.fromJson(response.responseData!);
    } else {
      ShowSnackBarMessage(context, response.errorMessage);
    }
    _getTaskCountByStatusInProgress = false;
    setState(() {});
  }
  Future<void> _getListCountByStatus() async {
    _getTaskListByStatusInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('New'));

    if (response.isSuccess) {
      newTaskListByStatusModel =
          TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      ShowSnackBarMessage(context, response.errorMessage);
    }
    _getTaskListByStatusInProgress = false;
    setState(() {});
  }

  Future<void> _taskListSummeryDelayed() async{
    await Future.delayed(Duration(seconds: 1));
  bool isUserLogin = await AuthController.isUserLoggedIn();
  if(isUserLogin){

    _getTaskCountByStatus();
  }
  }
  Future<void> _taskListDelayed() async{
    await Future.delayed(Duration(seconds: 2));
    bool isUserLogin = await AuthController.isUserLoggedIn();
    if(isUserLogin){

      _getListCountByStatus();
    }
  }
}
