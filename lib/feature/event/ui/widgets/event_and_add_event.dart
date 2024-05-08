import 'package:dubli/core/helper/naviagtion_extentaions.dart';
import 'package:dubli/core/routing/routes.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/core/widgets/app_bottom.dart';
import 'package:flutter/material.dart';
class EventAndAddEvent extends StatelessWidget {
  const EventAndAddEvent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Events',
            style: AppStyle.font18Whitemedium.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          CustomBottom(
            bottomHeight: 40,
            bottomWidth: 80,
            bottomtext: 'Add Event',
            backgroundColor: ColorManager.darkyellowColor,
            textBottomStyle: const TextStyle(
              fontSize: 13,
              fontFamily: 'Raleway',
              color: ColorManager.primaryColor,
            ),
            onPressed: () {
              context.navigateTo(routeName: Routes.addEventViewsRoute);
            },
          )
        ],
      ),
    );
  }
}
