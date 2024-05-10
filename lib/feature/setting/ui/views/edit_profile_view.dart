import 'dart:io';
import 'package:dubli/core/helper/naviagtion_extentaions.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/core/widgets/app_bottom.dart';
import 'package:dubli/feature/setting/logic/cubit/settings_cubit.dart';
import 'package:dubli/feature/setting/ui/widgets/update_user_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

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
        title: const Row(
          children: [
            Text(
              'Edit Profile',
            ),
          ],
        ),
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
                    height: 20,
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
                    bottomtext: 'Update User',
                    onPressed: () async {
                      if (context
                          .read<SettingsCubit>()
                          .formKey
                          .currentState!
                          .validate()) {
                        // await cubit.signUpUser(
                        //   email: cubit.emailController.text,
                        //   password: cubit.passwordController.text,
                        //   phone: cubit.phoneController.text,
                        //   username: cubit.nameController.text,
                        // );
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
