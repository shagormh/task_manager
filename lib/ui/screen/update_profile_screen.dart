import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/auth_controllers.dart';
import 'package:task_manager/ui/controllers/update_profile_controller.dart';
import 'package:task_manager/ui/widget/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widget/screen_background.dart';
import 'package:task_manager/ui/widget/snack_bar_message.dart';
import 'package:task_manager/ui/widget/tm_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});
  static const String name = '/update-profile';
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileNumberTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 final UpdateProfileController _updateProfileController = Get.find<UpdateProfileController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailTEController.text = AuthController.userModel?.email ?? '';
    _firstNameTEController.text = AuthController.userModel?.firstName ?? '';
    _lastNameTEController.text = AuthController.userModel?.lastName ?? '';
    _mobileNumberTEController.text = AuthController.userModel?.mobile ?? '';
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: TMAppBar(
        fromUpdateProfile: true,
      ),
      body: ScreenBackground(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 32,
                ),
                Text('Update Profile', style: textTheme.titleLarge),
                const SizedBox(
                  height: 24,
                ),
                _buildPhotoPicker(),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  enabled: false,
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Email')),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(hintText: 'First Name'),
                  validator: (String? value){
                      if(value?.trim().isEmpty ?? true){
                        return 'Enter Your FirstName';
                      }
                      return null;
                  },
                ),

                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                    controller: _lastNameTEController,
                    decoration: const InputDecoration(hintText: 'Last Name'),
                  validator: (String? value){
                    if(value?.trim().isEmpty ?? true){
                      return 'Enter Your LastName';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                    controller: _mobileNumberTEController,
                    decoration:
                        const InputDecoration(hintText: 'Mobile Number'),
                  validator: (String? value){
                    if(value?.trim().isEmpty ?? true){
                      return 'Enter Your Phone Number';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: 'Password')),
                const SizedBox(
                  height: 24,
                ),
                GetBuilder<UpdateProfileController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.updateProfileInProgress == false,
                      replacement: const CenterCircularProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: () {
                            if(_formKey.currentState!.validate()){
                              _updateProfile();
                            }
                          },
                          child: const Icon(Icons.arrow_circle_right_rounded)),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _updateProfileController.pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: GetBuilder<UpdateProfileController>(
          builder: (controller) {
            return Row(
              children: [
                Container(
                  height: 50,
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Photos',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                 Text( controller.pickedImage== null ?  'No Item Selected': controller.pickedImage!.name,maxLines: 1,),
              ],
            );
          }
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    final bool isSuccess = await _updateProfileController.updateProfile(
        _emailTEController.text.trim(),
        _firstNameTEController.text.trim(),
        _lastNameTEController.text.trim(),
        _mobileNumberTEController.text.trim(),
        _passwordTEController.text);
    if(isSuccess){
      _passwordTEController.clear();
      ShowSnackBarMessage(context, 'Profile Photo Updated');
    }else{
      ShowSnackBarMessage(context, 'Profile Photo Not Updated');
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileNumberTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
