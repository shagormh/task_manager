import 'package:flutter/material.dart';
import 'package:task_manager/data/Urls/urls.dart';
import 'package:task_manager/data/models/task_list_by_status_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
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
  bool _getTaskListByStatusInProgress = false;
  TaskListByStatusModel? newTaskListByStatusModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getListCountByStatus();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Visibility(
                    visible:  _getTaskListByStatusInProgress == false,
                    replacement: const CenterCircularProgressIndicator(),
                    child: _buildTaskListView()
                ),
              )
            ],
          ),
        ),
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
            status: 'Cancelled',
            color: Color(0xffF15056),
            taskListModel: newTaskListByStatusModel!.taskList![index],
          );
        });
  }
  Future<void> _getListCountByStatus() async {
    _getTaskListByStatusInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('Cancelled'));

    if (response.isSuccess) {
      newTaskListByStatusModel =
          TaskListByStatusModel.fromJson(response.responseData!);
    } else {
      ShowSnackBarMessage(context, response.errorMessage);
    }
    _getTaskListByStatusInProgress = false;
    setState(() {});
  }

}
