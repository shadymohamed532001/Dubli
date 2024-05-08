
import 'package:dubli/core/utils/app_image_assets.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class UserImageAndName extends StatelessWidget {
  const UserImageAndName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          'Shady Mohamed',
          style: AppStyle.font18Whitemedium,
        ),
      ],
    );
  }
}
