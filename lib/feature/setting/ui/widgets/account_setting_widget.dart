import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/feature/setting/ui/widgets/settings_option_item.dart';
import 'package:flutter/material.dart';

class AccountSettingWidget extends StatelessWidget {
  const AccountSettingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Account Settings',
            style: AppStyle.font18Whitemedium,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        const SettingsOptionItem(
          tittle: 'Edit profile',
        ),
        const SizedBox(
          height: 25,
        ),
        const SettingsOptionItem(
          tittle: 'Update faces',
        ),
        const SizedBox(
          height: 25,
        ),
        const SettingsOptionItem(
          tittle: 'Push notifications',
        ),
      ],
    );
  }
}
