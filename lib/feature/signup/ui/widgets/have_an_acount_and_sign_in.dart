
import 'package:dubli/core/helper/naviagtion_extentaions.dart';
import 'package:dubli/core/routing/routes.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class HaveAnAcountAndSignIn extends StatelessWidget {
  const HaveAnAcountAndSignIn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have account?',
          style: AppStyle.font18Whitemedium,
        ),
        TextButton(
          onPressed: () {
            context.navigateAndRemoveUntil(
                newRoute: Routes.loginViewsRoute);
          },
          child: Text(
            'Sign In',
            style: AppStyle.font15Whiteregular.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
