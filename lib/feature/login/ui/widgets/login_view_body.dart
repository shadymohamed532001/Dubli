// ignore_for_file: use_build_context_synchronously
import 'package:dubli/core/helper/naviagtion_extentaions.dart';
import 'package:dubli/core/networking/local_services.dart';
import 'package:dubli/core/routing/routes.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/core/widgets/app_bottom.dart';
import 'package:dubli/core/widgets/app_logo_and_app_name.dart';
import 'package:dubli/core/widgets/shows_toust_color.dart';
import 'package:dubli/feature/login/logic/cubit/login_cubit.dart';
import 'package:dubli/feature/login/ui/widgets/donot_have_acound_and_sign_up.dart';
import 'package:dubli/feature/login/ui/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          showDialog(
            context: context,
            builder: (_) => const Center(
              child: CircularProgressIndicator(
                color: ColorManager.whiteColor,
              ),
            ),
          );
        } else {
          Navigator.pop(context);
        }
        if (state is LoginSuccess) {
          showTouster(
            massage: 'Login Success',
            state: ToustState.SUCCESS,
          );
          LocalServices.saveData(
            key: 'token',
            value: 'true',
          ).then(
            (value) {
              context.navigateAndRemoveUntil(
                newRoute: Routes.layOutViewsRoute,
              );
            },
          );
        } else if (state is LoginFailure) {
          Navigator.pop(context);
          showTouster(
            massage: state.error,
            state: ToustState.ERROR,
          );
        }
      },
      builder: (context, state) {
        var cubit = BlocProvider.of<LoginCubit>(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const AppLogoAndAppName(
                    logoHeight: 140,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorManager.darkGreyColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Column(
                      children: [
                        SizedBox(height: 35),
                        LoginForm(),
                        SizedBox(height: 35),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomBottom(
                    bottomHeight: 60,
                    onPressed: () async {
                      if (cubit.formKey.currentState!.validate() == true) {
                        await cubit.loginUser(
                            email: cubit.emailController.text,
                            password: cubit.passwordController.text);

                        context.navigateTo(routeName: Routes.layOutViewsRoute);
                      } else {
                        cubit.autovalidateMode = AutovalidateMode.always;
                        setState(() {});
                      }
                    },
                    bottomtext: 'Login',
                    textBottomStyle: AppStyle.font30Primarymedium,
                    backgroundColor: ColorManager.darkyellowColor,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Or',
                    style: AppStyle.font18Whitemedium,
                  ),
                  const DonotHaveAcoundAndSignUp()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
