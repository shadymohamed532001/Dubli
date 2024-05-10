import 'package:dubli/core/helper/naviagtion_extentaions.dart';
import 'package:dubli/core/routing/routes.dart';
import 'package:dubli/core/utils/app_image_assets.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_list_tile.dart';

class TaskGroupItem extends StatelessWidget {
  const TaskGroupItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: CustomListTile(
        onTap: () {
          context.navigateTo(routeName: Routes.tasksViewsDetailsRoute);
        },
        imageAssetName: ImagesAssetsManager.applogoImage,
        subtitle: 'Subtitle',
        title: 'Title',
      ),
    );
  }
}
