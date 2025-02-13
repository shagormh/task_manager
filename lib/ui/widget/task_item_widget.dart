import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager/data/Urls/urls.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/ui/controllers/auth_controllers.dart';
import 'package:task_manager/ui/widget/snack_bar_message.dart';

class TaskItemWidget extends StatefulWidget {

  const TaskItemWidget({
    super.key,
    required this.taskListModel,
    required this.color,
    required this.status,
  });
  final TaskListModel taskListModel;
  final Color color;
  final String status;

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  final TextEditingController _statusTEControlar = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _statusTEControlar.text = widget.taskListModel.status ?? 'Null';
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        title: Text(widget.taskListModel.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskListModel.description ?? ''),
            Text(widget.taskListModel.createdDate ?? ''),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16), color: widget.color),
                  child: Text(
                    widget.status,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: Text('Delete Task!'),
                              content: Text('Are You Sure Delete Task!'),
                              actions: [
                                TextButton(
                                    onPressed: (){
                                      _getStatusDelete();
                                      Navigator.pop(context);
                                    },
                                    child: Text('Yes')
                                ),
                                TextButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: Text('No')
                                )
                              ],
                            );
                          }
                      );
                    }, icon: Icon(Icons.delete)),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Form(
                                    key: _formKey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                            TextFormField(
                                              controller: _statusTEControlar,
                                              decoration: const InputDecoration(
                                                  hintText: 'Status',
                                                  contentPadding: EdgeInsets.symmetric(
                                                      vertical:24,
                                                      horizontal: 16
                                                  )
                                              ),
                                              validator: (String? value){
                                                if(value?.trim().isEmpty ?? true){
                                                  return 'Enter Your Status';
                                                }
                                                return null;
                                              },
                                            ),
                                          SizedBox(height: 10,),
                                          ElevatedButton(onPressed: (){
                                            if(_formKey.currentState!.validate()){
                                              _getStatusUpdate();
                                              Navigator.pop(context);
                                            }
                                          }, child: const Icon(Icons.arrow_circle_right_rounded)),
                                        ],
                                      ),
                                  ),
                                );
                              });
                        },
                        icon: Icon(Icons.edit)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getStatusUpdate()async{
    final userValue = widget.taskListModel.status= _statusTEControlar.text;
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.statusUpdateTaskUrl(widget.taskListModel.sId!,userValue),
    );

    if(response.isSuccess){
      ShowSnackBarMessage(context, 'Status Update Success');
    }else{
      ShowSnackBarMessage(context, 'Status Update Not Success');
    }
  }

  Future<void> _getStatusDelete()async{
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.deleteTaskUrl(widget.taskListModel.sId.toString()),
    );
    Uri uri = Uri.parse(Urls.deleteTaskUrl(widget.taskListModel.sId.toString()));
    if(response.isSuccess){
      delete(uri);
      ShowSnackBarMessage(context, 'Status Delete Success');
    }else{
      ShowSnackBarMessage(context, 'Status Delete Not Success');
    }
  }
  @override
  void dispose() {
    _statusTEControlar.dispose();
    super.dispose();
  }
}
