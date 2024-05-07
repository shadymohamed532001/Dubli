import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imageAssetName,
    required this.title,
    required this.subtitle,
  });

  final String imageAssetName;
  final String title, subtitle;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: ColorManager.darkGreyColor,
      child: ListTile(
        leading: Image.asset(imageAssetName),
        title: Text(
          title,
          style: AppStyle.font15Whiteregular,
        ),
        subtitle: Text(
          subtitle,
          style: AppStyle.font15Whiteregular,
        ),
      ),
    );
  }
}
