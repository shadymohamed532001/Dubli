import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/feature/setting/ui/widgets/settings_option_item.dart';
import 'package:flutter/material.dart';

class AboutUsWidget extends StatelessWidget {
  const AboutUsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'About us',
            style: AppStyle.font18Whitemedium,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        const SettingsOptionItem(
          tittle: 'Privacy policy',
        ),
        const SizedBox(
          height: 25,
        ),
        const SettingsOptionItem(
          tittle: 'Terms and conditions',
        ),
        const SizedBox(
          height: 25,
        ),
        const SettingsOptionItem(
          tittle: 'Copyrights ©2024',
        ),
      ],
    );
  }
}
