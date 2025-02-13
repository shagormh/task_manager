import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/ui/controllers/complete_task_controller.dart';
import 'package:task_manager/ui/widget/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widget/screen_background.dart';
import 'package:task_manager/ui/widget/snack_bar_message.dart';
import 'package:task_manager/ui/widget/task_item_widget.dart';
import 'package:task_manager/ui/widget/tm_app_bar.dart';

class CompleteTaskListScreen extends StatefulWidget {
  const CompleteTaskListScreen({super.key});

  @override
  State<CompleteTaskListScreen> createState() => _CompleteTaskListScreenState();
}

class _CompleteTaskListScreenState extends State<CompleteTaskListScreen> {
  final CompleteTaskController _completeTaskController = Get.find<CompleteTaskController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getListCountByStatus();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GetBuilder<CompleteTaskController>(
                  builder: (controller) {
                    return Visibility(
                        visible:  controller.getTaskListInProgress == false,
                        replacement: const CenterCircularProgressIndicator(),
                        child: _buildTaskListView(_completeTaskController.taskList)
                    );
                  }
                ),
              )
            ],
          ),
        ),
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
            status: 'Completed',
            color: Color(0xff28C177),
            taskListModel: taskList[index],
          );
        });
  }
  Future<void> _getListCountByStatus() async {
    final bool isSuccess = await _completeTaskController.getCompleteTaskList();
    if(!isSuccess){
      ShowSnackBarMessage(context, _completeTaskController.errorMessage!);
    }
    }

}
