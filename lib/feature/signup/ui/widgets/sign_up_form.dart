import 'package:dubli/core/helper/validators_helper.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/core/widgets/app_text_formfield.dart';
import 'package:dubli/feature/signup/logic/cubit/sign_up_cubit.dart';
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

  @override
  Widget build(BuildContext context) {
    var signupCubite = context.read<SignUpCubit>();
    return Form(
      key: signupCubite.formKey,
      autovalidateMode: signupCubite.autovalidateMode,
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
              controller: signupCubite.nameController,
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
                  'Email',
                  style: AppStyle.font18Primaryregular,
                )),
            CustomTextFormField(
              obscureText: false,
              hintText: 'Patient@self.com',
              keyboardType: TextInputType.emailAddress,
              controller: signupCubite.emailController,
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
              hintText: 'Min 8 Cyfr',
              keyboardType: TextInputType.visiblePassword,
              controller: signupCubite.passwordController,
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
              controller: signupCubite.phoneController,
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
