import 'package:dubli/core/helper/validators_helper.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/core/widgets/app_text_formfield.dart';
import 'package:dubli/feature/login/logic/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String errorMessage = '';

  bool ispassword = true;

  @override
  Widget build(BuildContext context) {
    var logincubite = context.read<LoginCubit>();
    return Form(
      key: logincubite.formKey,
      autovalidateMode: context.read<LoginCubit>().autovalidateMode,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Text(
                'Username',
                style: AppStyle.font18Primaryregular,
              ),
            ),
            CustomTextFormField(
              obscureText: false,
              hintText: 'Patient@self.com',
              keyboardType: TextInputType.emailAddress,
              controller: logincubite.emailController,
              validator: (text) {
                return MyValidatorsHelper.emailValidator(text);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Text(
                'Password',
                style: AppStyle.font18Primaryregular,
              ),
            ),
            CustomTextFormField(
              
              obscureText: ispassword,
              suffixIcon: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    ispassword = !ispassword;
                  });
                },
                child: ispassword
                    ? const Icon(
                        Icons.visibility_off,
                        color: ColorManager.primaryColor,
                      )
                    : const Icon(
                        Icons.visibility,
                        color: ColorManager.primaryColor,
                      ),
              ),
              hintText: 'Min 6 Cyfr',
              keyboardType: TextInputType.visiblePassword,
              controller: logincubite.passwordController,
              validator: (text) {
                return MyValidatorsHelper.passwordValidator(text);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                textAlign: TextAlign.right,
                'Forgot your password?',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: ColorManager.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
