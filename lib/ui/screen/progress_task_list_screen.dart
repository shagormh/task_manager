import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/ui/controllers/progress_task_controller.dart';
import 'package:task_manager/ui/widget/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widget/screen_background.dart';
import 'package:task_manager/ui/widget/snack_bar_message.dart';
import 'package:task_manager/ui/widget/task_item_widget.dart';
import 'package:task_manager/ui/widget/tm_app_bar.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  final ProgressTaskController _progressTaskController = Get.find<ProgressTaskController>();
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
                child: GetBuilder<ProgressTaskController>(
                  builder: (controller) {
                    return Visibility(
                      visible:  controller.getTaskListInProgress == false,
                        replacement: const CenterCircularProgressIndicator(),
                        child: _buildTaskListView(controller.taskList)
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
            status: 'Progress',
            color: const Color(0xffCE19A4),
            taskListModel: taskList[index],
          );
        });
  }
  Future<void> _getListCountByStatus() async {
   final bool isSuccess = await _progressTaskController.getProgressTaskList();
   if(!isSuccess){
     ShowSnackBarMessage(context, _progressTaskController.errorMessage!);
   }
   }
}
