import 'package:dubli/core/utils/app_image_assets.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class AppLogoAndAppName extends StatelessWidget {
  const AppLogoAndAppName({
    super.key,
    this.logoHeight,
    this.tittle,
    this.subtittle,
  });
  final double? logoHeight;
  final String? tittle;
  final String? subtittle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          ImagesAssetsManager.applogoImage,
          height: logoHeight ?? 200,
        ),
        subtittle != null
            ? const SizedBox(
                height: 10,
              )
            : Container(),
        Text(
          tittle ?? 'DUPLI',
          style: AppStyle.font80Whitesemibold,
        ),
        subtittle != null
            ? const SizedBox(
                height: 10,
              )
            : Container(),
        subtittle != null
            ? Text(
                subtittle ?? '',
                style: AppStyle.font40Whitesemibold,
              )
            : Container(),
      ],
    );
  }
}
