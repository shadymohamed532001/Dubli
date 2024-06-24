import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imageAssetName,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  final String imageAssetName;
  final String title, subtitle;
  final void Function()? onTap;
  final Widget? trailing; 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
          trailing: trailing, // Add trailing widget to the ListTile
        ),
      ),
    );
  }
}
