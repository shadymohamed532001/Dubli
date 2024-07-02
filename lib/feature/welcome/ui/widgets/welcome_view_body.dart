import 'package:dupli/core/helper/naviagtion_extentaions.dart';
import 'package:dupli/core/routing/routes.dart';
import 'package:dupli/core/utils/app_colors.dart';
import 'package:dupli/core/utils/app_styles.dart';
import 'package:dupli/core/widgets/app_logo_and_app_name.dart';
import 'package:flutter/material.dart';

class WelcomeViewBody extends StatelessWidget {
  const WelcomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppLogoAndAppName(),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Meet Dupli, your AI-powered duplicate twin designed to assist you in managing your daily life with ease. Dupli helps you monitor your events and tasks, plan focus sessions, and even creates your study plan and university schedule by accessing your Moodle. With Dupli, staying organized and productive has never been simpler.',
              style: AppStyle.font16Greyregular.copyWith(
                color: ColorManager.whiteColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Let\'s play a game to determine your focus goal using AI! This game will flash a color, and you have to select the correct one. Level 1 starts with one color, and as you progress, more colors will be added. By level 5, you\'ll be selecting from five different colors. Ready to test your focus?',
              style: AppStyle.font16Greyregular.copyWith(
                color: ColorManager.whiteColor,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.navigateTo(routeName: Routes.gameViewsRoute);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Start Game',
                      style: AppStyle.font16Whitesemibold.copyWith(
                        color: ColorManager.darkyellowColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: ColorManager.darkyellowColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
