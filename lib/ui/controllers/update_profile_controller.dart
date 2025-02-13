import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/Urls/urls.dart';
import 'package:task_manager/data/service/network_caller.dart';

class UpdateProfileController extends GetxController{
  bool _updateProfileInProgress = false;
  bool get updateProfileInProgress => _updateProfileInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  XFile? _pickedImage;
  XFile? get pickedImage => _pickedImage;
  Future<void> pickImage() async {
    ImagePicker picker= ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      _pickedImage = image;
      update();
    }
  }

  Future<bool> updateProfile(String email,String firstName,String lastName,String mobile, String password) async{
    bool isSuccess = false;
    _updateProfileInProgress = true;
    update();
    Map<String,dynamic> requestBody = {
      'email' : email,
      'firstName' : firstName,
      'lastName' : lastName,
      'mobile' : mobile,
    };
    if(_pickedImage != null){
      List<int> imageBytes= await _pickedImage!.readAsBytes();
      requestBody['photo']= base64Encode(imageBytes);
    }
    if(password.isNotEmpty){
      requestBody['password'] = password;
    }
    final NetworkResponse response = await NetworkCaller.getPost(url: Urls.updateProfile,body: requestBody);

    if(response.isSuccess){
     isSuccess = true;
     _errorMessage = null;
    } else{
      _errorMessage = response.errorMessage;
    }
    _updateProfileInProgress = false;
    update();
    return isSuccess;
  }
}