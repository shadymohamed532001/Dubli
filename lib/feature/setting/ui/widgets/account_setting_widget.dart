import 'package:dupli/core/helper/naviagtion_extentaions.dart';
import 'package:dupli/core/routing/routes.dart';
import 'package:dupli/core/utils/app_styles.dart';
import 'package:dupli/feature/setting/ui/widgets/settings_option_item.dart';
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
        SettingsOptionItem(
          tittle: 'Edit profile',
          onTap: () {
            context.navigateTo(routeName: Routes.editProfileViewsRoute);
          },
        ),
      ],
    );
  }
}
