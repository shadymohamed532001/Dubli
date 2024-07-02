import 'package:dupli/core/helper/local_services.dart';
import 'package:dupli/core/utils/app_image_assets.dart';
import 'package:dupli/core/utils/app_styles.dart';
import 'package:dupli/feature/setting/logic/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserImageAndName extends StatelessWidget {
  const UserImageAndName({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        var userName = state is SettingSuccess
            ? state.userName
            : LocalServices.getData(key: 'userName');
        return Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(ImagesAssetsManager.applogoImage),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              userName,
              style: AppStyle.font18Whitemedium,
            ),
          ],
        );
      },
    );
  }
}
