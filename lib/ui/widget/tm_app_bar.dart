import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_coltrollers.dart';
import 'package:task_manager/ui/screen/cancelled_task_list_screen.dart';
import 'package:task_manager/ui/screen/sign_in_screen.dart';
import 'package:task_manager/ui/screen/sign_up_screen.dart';
import 'package:task_manager/ui/screen/update_profile_screen.dart';
import 'package:task_manager/ui/utlis/app_color.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key,
    this.fromUpdateProfile = false,
  });
final bool fromUpdateProfile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: AppColor.themeColor,
      foregroundColor: Colors.white,
      title: Row(
        children: [
           CircleAvatar(
             radius: 16,
            backgroundImage: MemoryImage(
             base64Decode(AuthController.userModel?.photo ?? ''),
            ),
             onBackgroundImageError: (_,__)=> const Icon(Icons.person),
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
                  Text(
                    AuthController.userModel?.fullName ?? '',
                    style: textTheme.titleSmall?.copyWith(color: Colors.white),
                  ),
                  Text(AuthController.userModel?.email ?? '',
                      style: textTheme.bodySmall?.copyWith(color: Colors.white)),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Close the dialog
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Perform logout actions
                          await AuthController.clearData();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            SignInScreen.name,
                                (predicate) => false,
                          );
                        },
                        child: Text("Logout"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.logout),
          ),

        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
