import 'package:dubli/core/widgets/app_logo_and_app_name.dart';
import 'package:dubli/feature/intor/ui/widgets/login_or_signup_optional.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IntroViewBody extends StatelessWidget {
  const IntroViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(
            flex: 2,
          ),
          AppLogoAndAppName(
            subtittle: 'Your Digital Twin',
          ),
          Spacer(
            flex: 2,
          ),
          LoginOrSignUpOptional()
        ],
      ),
    );
  }
}
