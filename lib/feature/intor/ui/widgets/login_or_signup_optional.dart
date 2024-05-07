import 'package:dubli/core/helper/naviagtion_extentaions.dart';
import 'package:dubli/core/routing/routes.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/core/widgets/app_bottom.dart';
import 'package:flutter/material.dart';

class LoginOrSignUpOptional extends StatelessWidget {
  const LoginOrSignUpOptional({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomBottom(
          bottomHeight: 70,
          onPressed: () {
            context.navigateTo(routeName: Routes.loginViewsRoute);
          },
          bottomtext: 'Login',
          textBottomStyle: AppStyle.font30Primarymedium,
          backgroundColor: ColorManager.darkyellowColor,
        ),
        const SizedBox(
          height: 10,
        ),
        CustomBottom(
          bottomHeight: 70,
          onPressed: () {
            context.navigateTo(routeName: Routes.signUpViewsRoute);
          },
          bottomtext: 'Sign Up',
          textBottomStyle: AppStyle.font30Primarymedium,
          backgroundColor: ColorManager.darkyellowColor,
        ),
      ],
    );
  }
}
