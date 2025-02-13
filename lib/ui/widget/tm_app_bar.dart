import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:task_manager/ui/controllers/auth_controllers.dart';
import 'package:task_manager/ui/screen/cancelled_task_list_screen.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/screen/sign_up_screen.dart';
import 'package:task_manager/ui/screen/update_profile_screen.dart';
import 'package:task_manager/ui/utlis/app_color.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
   TMAppBar({
    super.key,
    this.fromUpdateProfile = false,
  });
final bool fromUpdateProfile;
final AuthController _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: AppColor.themeColor,
      title: Row(
        children: [
           GetBuilder<AuthController>(
             builder: (controller) {
               return CircleAvatar(
                 radius: 16,
                backgroundImage: MemoryImage(
                 base64Decode(controller.userInfo?.photo ?? ''),
                ),
                 onBackgroundImageError: (_,__)=> const Icon(Icons.person),
                         );
             }
           ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: GestureDetector(
              onTap: (){
                if(!fromUpdateProfile){
                  Navigator.pushNamed(context, UpdateProfileScreen.name);
                }

                },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    GetBuilder<AuthController>(
                      builder: (controller) {
                        return Text(
                          controller.userInfo?.fullName ?? '',
                            style: textTheme.titleSmall?.copyWith(color: Colors.white),
                          );
                      }
                    ),
                  GetBuilder<AuthController>(
                    builder: (controller) {
                      return Text(controller.userInfo?.email ?? '',
                          style: textTheme.bodySmall?.copyWith(color: Colors.white));
                    }
                  ),
                ],
              ),
            ),
          ),
          IconButton(onPressed: () {
            AuthController.clearData();
            // Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (predicate) => false);
            Get.offAllNamed(SignInScreen.name);
          }, icon: Icon(Icons.logout))
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
