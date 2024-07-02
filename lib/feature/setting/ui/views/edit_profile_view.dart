import 'dart:io';
import 'package:dupli/core/helper/local_services.dart';
import 'package:dupli/core/helper/naviagtion_extentaions.dart';
import 'package:dupli/core/utils/app_colors.dart';
import 'package:dupli/core/utils/app_styles.dart';
import 'package:dupli/core/widgets/app_bottom.dart';

import 'package:dupli/feature/setting/logic/cubit/settings_cubit.dart';
import 'package:dupli/feature/setting/ui/widgets/update_user_form.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

var userId = LocalServices.getData(key: 'userId');
String userName = LocalServices.getData(key: 'userName');
var userEmail = LocalServices.getData(key: 'userEmail');

class _EditProfileViewState extends State<EditProfileView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: const Text('Edit Profile'),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          SettingsCubit settingsCubit = BlocProvider.of<SettingsCubit>(context);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await settingsCubit.uploadImageFromGalleryModel(
                        picker: ImagePicker(),
                      );
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: ColorManager.darkGreyColor,
                      backgroundImage: settingsCubit.image != null
                          ? FileImage(File(settingsCubit.image!.path))
                          : null,
                      child: settingsCubit.image == null
                          ? const Icon(
                              Icons.add_photo_alternate,
                              color: ColorManager.blackColor,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorManager.darkGreyColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Column(
                      children: [
                        SizedBox(height: 15),
                        UpdateUserForm(),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  CustomBottom(
                    bottomHeight: 60,
                    bottomtext: 'Update Info',
                    onPressed: () async {
                      if (context
                          .read<SettingsCubit>()
                          .formKey
                          .currentState!
                          .validate()) {
                        await settingsCubit.editUser(
                          userId,
                          settingsCubit.nameController.text,
                          userEmail,
                          settingsCubit.phoneController.text,
                          settingsCubit.passwordController.text,
                        );
                        userName = settingsCubit.nameController.text;

                        // Ensure the state is updated before popping
                        settingsCubit.updateUserName(userName);

                        // Add a short delay to ensure the UI updates before popping
                        Future.delayed(const Duration(milliseconds: 100), () {
                          Navigator.of(context).pop();
                        });
                      } else {
                        context.read<SettingsCubit>().autovalidateMode =
                            AutovalidateMode.always;
                        setState(() {});
                      }
                    },
                    backgroundColor: ColorManager.darkyellowColor,
                    textBottomStyle: AppStyle.font18Primaryregular,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
