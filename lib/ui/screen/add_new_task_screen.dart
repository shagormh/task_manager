import 'package:flutter/material.dart';
import 'package:task_manager/data/Urls/urls.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/ui/screen/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/widget/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widget/screen_background.dart';
import 'package:task_manager/ui/widget/snack_bar_message.dart';
import 'package:task_manager/ui/widget/tm_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});
  static const String name = '/add_new_task';
  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEControlar = TextEditingController();
  final TextEditingController _descriptionTEControlar = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addTaskInProgress = false;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Add New Task',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _titleTEControlar,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your Title Here';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _descriptionTEControlar,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your Description Here';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Visibility(
                    visible:  _addTaskInProgress == false,
                    replacement: const CenterCircularProgressIndicator(),
                    child: ElevatedButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            _createNewTask();

                          }
                        },
                        child: Text('Add')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createNewTask()async{
    _addTaskInProgress = true;
    setState(() {});
    Map<String,dynamic> requestBody = {
      "title":_titleTEControlar.text.trim(),
      "description":_descriptionTEControlar.text.trim(),
      "status":"New"
    };
    NetworkResponse response = await NetworkCaller.getPost(url: Urls.createUrls,body: requestBody);
    if(response.isSuccess){
      _addTaskInProgress = false;
      setState(() {});
      _clearTextFeilds();
      ShowSnackBarMessage(context, 'New Task Added');
      Navigator.pushNamedAndRemoveUntil(context, MainBottomNavScreen.name, (value)=> false);
    }else{
      ShowSnackBarMessage(context, response.errorMessage);
    }
  }
  void _clearTextFeilds(){
    _titleTEControlar.clear();
    _descriptionTEControlar.clear();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _titleTEControlar.dispose();
    _descriptionTEControlar.dispose();
    super.dispose();
  }
}
