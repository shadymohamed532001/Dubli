import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/feature/setting/ui/widgets/about_us_widget.dart';
import 'package:dubli/feature/setting/ui/widgets/account_setting_widget.dart';
import 'package:dubli/feature/setting/ui/widgets/user_image_and_name.dart';
import 'package:flutter/material.dart';

class SettingsViewBody extends StatelessWidget {
  const SettingsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: ColorManager.darkGreyColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    const UserImageAndName(),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: ColorManager.primaryColor.withOpacity(0.4),
                      height: 40,
                    ),
                    const AccountSettingWidget(),
                    Divider(
                      color: ColorManager.primaryColor.withOpacity(0.4),
                      height: 40,
                    ),
                    const AboutUsWidget(),
                    Divider(
                      color: ColorManager.primaryColor.withOpacity(0.4),
                      height: 40,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Logout',
                        style: AppStyle.font22Whitesemibold.copyWith(
                          fontFamily: 'Raleway',
                          color: ColorManager.redColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
