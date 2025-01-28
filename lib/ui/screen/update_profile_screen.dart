import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/Urls/urls.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/ui/controllers/auth_coltrollers.dart';
import 'package:task_manager/ui/widget/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widget/screen_background.dart';
import 'package:task_manager/ui/widget/snack_bar_message.dart';
import 'package:task_manager/ui/widget/tm_app_bar.dart';
import 'package:image/image.dart' as img;

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});
  static const String name = '/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEControlar = TextEditingController();
  final TextEditingController _firstNameTEControlar = TextEditingController();
  final TextEditingController _lastNameTEControlar = TextEditingController();
  final TextEditingController _mobileNumberTEControlar = TextEditingController();
  final TextEditingController _passwordTEControlar = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _updateProfileInProgress = false;
  XFile? _pickedImage;
  bool _isPasswordEditable = false;

  @override
  void initState() {
    super.initState();
    _emailTEControlar.text = AuthController.userModel?.email ?? '';
    _firstNameTEControlar.text = AuthController.userModel?.firstName ?? '';
    _lastNameTEControlar.text = AuthController.userModel?.lastName ?? '';
    _mobileNumberTEControlar.text = AuthController.userModel?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const TMAppBar(fromUpdateProfile: true),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text('Update Profile', style: textTheme.titleLarge),
                  const SizedBox(height: 24),
                  _buildPhotoPicker(),
                  const SizedBox(height: 16),
                  TextFormField(
                    enabled: false,
                    controller: _emailTEControlar,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _firstNameTEControlar,
                    decoration: const InputDecoration(hintText: 'First Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your FirstName';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameTEControlar,
                    decoration: const InputDecoration(hintText: 'Last Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your LastName';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _mobileNumberTEControlar,
                    decoration: const InputDecoration(hintText: 'Mobile Number'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your Phone Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordTEControlar,
                    obscureText: true,
                    enabled: _isPasswordEditable,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordEditable = !_isPasswordEditable;
                      });
                    },
                    child: Text(
                      _isPasswordEditable ? 'Cancel Edit' : 'Edit Password',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Visibility(
                    visible: _updateProfileInProgress == false,
                    replacement: const CenterCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updateProfile();
                        }
                      },
                      child: Text("Update"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
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
            const SizedBox(width: 12),
            Text(_pickedImage == null ? 'No Item Selected' : _pickedImage!.name,
                maxLines: 1),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedImage = image;
      setState(() {});
    }
  }

  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      'email': _emailTEControlar.text.trim(),
      'firstName': _firstNameTEControlar.text.trim(),
      'lastName': _lastNameTEControlar.text.trim(),
      'mobile': _mobileNumberTEControlar.text.trim(),
    };

    if (_pickedImage != null) {
      List<int> imageBytes = await _pickedImage!.readAsBytes();
      img.Image? decodedImage = img.decodeImage(Uint8List.fromList(imageBytes));
      img.Image resizedImage = img.copyResize(decodedImage!, width: 300, height: 300);
      List<int> resizedImageBytes = img.encodeJpg(resizedImage);
      _pickedImage = XFile.fromData(Uint8List.fromList(resizedImageBytes), name: _pickedImage!.name);
      requestBody['photo'] = base64Encode(resizedImageBytes);
    }

    if (_passwordTEControlar.text.isNotEmpty) {
      requestBody['password'] = _passwordTEControlar.text;
    }

    final NetworkResponse response = await NetworkCaller.getPost(
        url: Urls.updateProfile, body: requestBody);

    _updateProfileInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      AuthController.userModel?.firstName = _firstNameTEControlar.text.trim();
      AuthController.userModel?.lastName = _lastNameTEControlar.text.trim();
      AuthController.userModel?.mobile = _mobileNumberTEControlar.text.trim();
      AuthController.userModel?.photo = _pickedImage?.name;

      _passwordTEControlar.clear();

      ShowSnackBarMessage(context, 'Update Profile Success');
      Navigator.pop(context); // Pop screen immediately after success
    } else {
      ShowSnackBarMessage(context, response.errorMessage);
    }
  }

  @override
  void dispose() {
    _emailTEControlar.dispose();
    _firstNameTEControlar.dispose();
    _lastNameTEControlar.dispose();
    _mobileNumberTEControlar.dispose();
    _passwordTEControlar.dispose();
    super.dispose();
  }
}
