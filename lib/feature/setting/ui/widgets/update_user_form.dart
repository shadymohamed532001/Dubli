import 'package:dupli/core/helper/local_services.dart';
import 'package:dupli/core/helper/validators_helper.dart';
import 'package:dupli/core/utils/app_styles.dart';
import 'package:dupli/core/widgets/app_text_formfield.dart';
import 'package:dupli/feature/setting/logic/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var userName = LocalServices.getData(key: 'userName');
var userEmail = LocalServices.getData(key: 'userEmail');
var userPhone = LocalServices.getData(key: 'userPhone');

class UpdateUserForm extends StatefulWidget {
  const UpdateUserForm({super.key});

  @override
  State<UpdateUserForm> createState() => _UpdateUserFormState();
}

class _UpdateUserFormState extends State<UpdateUserForm> {
  String errorMessage = '';
  bool isPasswordShow = true;

  @override
  Widget build(BuildContext context) {
    var settingsCubit = context.read<SettingsCubit>();
    return Form(
      key: settingsCubit.formKey,
      autovalidateMode: settingsCubit.autovalidateMode,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 4),
              child: Text(
                'Username',
                style: AppStyle.font18Primaryregular,
              ),
            ),
            CustomTextFormField(
              obscureText: false,
              hintText: userName,
              keyboardType: TextInputType.text,
              controller: settingsCubit.nameController,
              validator: (text) {
                if (text == null || text.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 4),
              child: Text(
                'Password',
                style: AppStyle.font18Primaryregular,
              ),
            ),
            CustomTextFormField(
              obscureText: isPasswordShow,
              suffixIcon: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    isPasswordShow = !isPasswordShow;
                  });
                },
                child: isPasswordShow
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              ),
              hintText: 'Min 8 Cyfr',
              keyboardType: TextInputType.visiblePassword,
              controller: settingsCubit.passwordController,
              validator: (text) {
                return MyValidatorsHelper.passwordValidator(text);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 4),
              child: Text(
                'Phone Number',
                style: AppStyle.font18Primaryregular,
              ),
            ),
            CustomTextFormField(
              obscureText: false,
              hintText: userPhone,
              keyboardType: TextInputType.phone,
              controller: settingsCubit.phoneController,
              validator: (text) {
                return MyValidatorsHelper.phoneValidator(text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
