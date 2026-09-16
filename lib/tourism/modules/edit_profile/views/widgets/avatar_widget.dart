import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/global_widgets/custom_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/modules/edit_profile/controllers/edit_profile_controller.dart';

class AvatarWidget extends StatelessWidget {
  final bool useAPIAvatar;
  final String avatarURL;

  AvatarWidget({super.key, required this.avatarURL, required this.useAPIAvatar});

  final editProfileController = Get.find<EditProfileController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );
        editProfileController.avatar_pic = File(image!.path);
        editProfileController.useFileAvatar = true;
        editProfileController.useAPIAvatar = false;
        editProfileController.update();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(width: 250.0.w),
          Container(
            height: 200.0.h,
            width: 200.0.w,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey,
                width: 1.3,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            child: Builder(
              builder: (_) {
                if (useAPIAvatar) {
                  return CustomNetworkImage(url: avatarURL, fit: BoxFit.fill);
                } else if (editProfileController.useFileAvatar) {
                  return Image.file(
                    editProfileController.avatar_pic!,
                    fit: BoxFit.fill,
                  );
                } else {
                  return Image.asset("assets/images/pngs/avatar.png");
                }
              },
            ),
          ),
          PositionedDirectional(
            start: 170.0.w,
            top: 140.0.h,
            child: TextButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                editProfileController.avatar_pic = File(image!.path);
                editProfileController.useFileAvatar = true;
                editProfileController.useAPIAvatar = false;
                editProfileController.update();
              },
              child: Icon(Icons.add_a_photo, color: AppColors.blue, size: 50.0),
            ),
          ),
        ],
      ),
    );
  }
}
