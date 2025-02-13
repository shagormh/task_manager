import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/ui/controllers/cancelled_task_controller.dart';
import 'package:task_manager/ui/widget/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widget/screen_background.dart';
import 'package:task_manager/ui/widget/snack_bar_message.dart';
import 'package:task_manager/ui/widget/task_item_widget.dart';
import 'package:task_manager/ui/widget/tm_app_bar.dart';

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
  final CancelledTaskController _cancelledTaskController = Get.find<CancelledTaskController>();

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
                child: GetBuilder<CancelledTaskController>(
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

  ListView _buildTaskListView(List<TaskListModel> tasklist) {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: tasklist.length,
        itemBuilder: (context, index) {
          return TaskItemWidget(
            status: 'Cancelled',
            color: Color(0xffF15056),
            taskListModel: tasklist[index],
          );
        });
  }
  Future<void> _getListCountByStatus() async {
   final bool isSuccess = await _cancelledTaskController.getCancelledTaskList();

   if(!isSuccess){
     ShowSnackBarMessage(context, _cancelledTaskController.errorMessage!);
   }
   }

}
