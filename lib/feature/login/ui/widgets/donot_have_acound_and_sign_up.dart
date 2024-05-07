import 'package:dubli/core/helper/naviagtion_extentaions.dart';
import 'package:dubli/core/routing/routes.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class DonotHaveAcoundAndSignUp extends StatelessWidget {
  const DonotHaveAcoundAndSignUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don’t have an account?',
          style: AppStyle.font16Whitesemibold,
        ),
        TextButton(
          onPressed: () {
            context.navigateAndRemoveUntil(newRoute: Routes.signUpViewsRoute);
          },
          child: Text(
            'Sign Up',
            style: AppStyle.font15Whiteregular.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
