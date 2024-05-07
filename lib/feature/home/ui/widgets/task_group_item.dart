import 'package:dubli/core/utils/app_image_assets.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_list_tile.dart';

class TaskGroupItem extends StatelessWidget {
  const TaskGroupItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 80,
      child: CustomListTile(
        imageAssetName: ImagesAssetsManager.applogoImage,
        subtitle: 'Subtitle',
        title: 'Title',
      ),
    );
  }
}
