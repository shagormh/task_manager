import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/task_count_model.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/ui/controllers/auth_controllers.dart';
import 'package:task_manager/ui/controllers/new_task_controller.dart';
import 'package:task_manager/ui/controllers/task_list_summary_controller.dart';
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
  final NewTaskController _newTaskController = Get.find<NewTaskController>();
  final TaskListSummaryController _taskListSummaryController = Get.find<TaskListSummaryController>();
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
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<TaskListSummaryController>(
                builder: (controller) {
                  return _buildTaskSummeryByStatus(controller.taskCount);
                }
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GetBuilder<NewTaskController>(builder: (controller) {
                  return Visibility(
                      visible: controller.getTaskListInProgress == false,
                      replacement: const CenterCircularProgressIndicator(),
                      child: _buildTaskListView(controller.taskList));
                }),
              )
            ],
          ),
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

  ListView _buildTaskListView(List<TaskListModel> taskList) {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          return TaskItemWidget(
            status: 'New',
            color: Color(0xff17C1E8),
            taskListModel: taskList[index],
          );
        });
  }

  Widget _buildTaskSummeryByStatus(List<TaskCountModel> taskByStatusList) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: GetBuilder<TaskListSummaryController>(builder: (controller) {
        return Visibility(
          visible: controller.getTaskCountByStatusInProgress == false,
          replacement: const CenterCircularProgressIndicator(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 98,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: taskByStatusList.length,
                  itemBuilder: (context, index) {
                    final TaskCountModel model = taskByStatusList[index];
                    return TaskStatusSummeryCounterWidget(
                      title: model.sId ?? '',
                      count: model.sum.toString(),
                    );
                  }),
            ),
          ),
        );
      }),
    );
  }

  // Task Summary Api
  Future<void> _getTaskCountByStatus() async {
    final bool isSuccess =
        await _taskListSummaryController.getTaskListCountSummary();
    if (!isSuccess) {
      ShowSnackBarMessage(context, _newTaskController.errorMessage!);
    }
  }

  // TakList Api
  Future<void> _getTaskListByStatus() async {
    final bool isSuccess = await _newTaskController.getTaskList();
    if (!isSuccess) {
      ShowSnackBarMessage(context, _newTaskController.errorMessage!);
    }
  }

  Future<void> _taskListSummeryDelayed() async {
    await Future.delayed(const Duration(seconds: 1));
    bool isUserLogin = await AuthController.isUserLoggedIn();
    if (isUserLogin) {
      _getTaskCountByStatus();

    }
  }

  Future<void> _taskListDelayed() async {
    await Future.delayed(const Duration(seconds: 2));
    bool isUserLogin = await AuthController.isUserLoggedIn();
    if (isUserLogin) {
      _getTaskListByStatus();
    }
  }
}
