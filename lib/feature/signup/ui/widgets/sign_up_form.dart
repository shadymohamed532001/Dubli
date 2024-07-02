import 'package:dupli/core/helper/validators_helper.dart';
import 'package:dupli/core/utils/app_colors.dart';
import 'package:dupli/core/utils/app_styles.dart';
import 'package:dupli/core/widgets/app_text_formfield.dart';
import 'package:dupli/feature/signup/logic/cubit/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String errorMessage = '';
  bool isPasswordShow = true;
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    var signUpCubit = context.read<SignUpCubit>();
    return Form(
      key: signUpCubit.formKey,
      autovalidateMode: signUpCubit.autovalidateMode,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
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
              hintText: 'Username',
              keyboardType: TextInputType.text,
              controller: signUpCubit.nameController,
              validator: (text) {
                if (text == null || text.trim().isEmpty || text.length > 20) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 4),
              child: Text(
                'Email',
                style: AppStyle.font18Primaryregular,
              ),
            ),
            CustomTextFormField(
              obscureText: false,
              hintText: 'Username@address.com',
              keyboardType: TextInputType.emailAddress,
              controller: signUpCubit.emailController,
              validator: (text) {
                return MyValidatorsHelper.emailValidator(text);
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
              hintText: 'Password',
              keyboardType: TextInputType.visiblePassword,
              controller: signUpCubit.passwordController,
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
              hintText: 'Phone Number',
              keyboardType: TextInputType.phone,
              controller: signUpCubit.phoneController,
              validator: (text) {
                return MyValidatorsHelper.phoneValidator(text);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 4),
              child: Text(
                'Age',
                style: AppStyle.font18Primaryregular,
              ),
            ),
            CustomTextFormField(
              obscureText: false,
              hintText: 'Age',
              keyboardType: TextInputType.number,
              controller: signUpCubit.ageController,
              validator: (text) {
                if (text == null || text.trim().isEmpty) {
                  return 'Please enter your age';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, bottom: 4),
              child: Text(
                'Gender',
                style: AppStyle.font18Primaryregular,
              ),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hoverColor: ColorManager.primaryColor,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: ColorManager.primaryColor,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: ColorManager.primaryColor,
                    width: 1,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: ColorManager.primaryColor,
                    width: 1,
                  ),
                ),
              ),
              hint: const Text('Gender'),
              value: selectedGender,
              items: ['Male', 'Female'].map((gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                  signUpCubit.genderController.text = value ?? '';
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your gender';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
