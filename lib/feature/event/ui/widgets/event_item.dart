import 'package:dupli/core/utils/app_colors.dart';
import 'package:dupli/core/utils/app_styles.dart';
import 'package:dupli/feature/event/data/models/get_all_event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventItem extends StatelessWidget {
  final Event event;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const EventItem({
    super.key,
    required this.event,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final startTime = DateTime.parse(event.startTime.toString());
    final endTime = DateTime.parse(event.endTime.toString());

    final startTimeFormatted = DateFormat.Hm().format(startTime);
    final endTimeFormatted = DateFormat.Hm().format(endTime);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ColorManager.darkGreyColor,
            width: 2,
          ),
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event.name,
                    style: AppStyle.font16Whitesemibold,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/calendar.png',
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${event.startTime.toString().split(' ')[0].toString()} | ${event.endTime.toString().split(' ')[0].toString()}',
                              style: AppStyle.font14Greyregular,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              event.description,
                              style: AppStyle.font16Whitesemibold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        event.reminder,
                        style: AppStyle.font14Greyregular,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '$startTimeFormatted | $endTimeFormatted',
                        style: AppStyle.font14Greyregular,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                GestureDetector(
                  onTap: onUpdate,
                  child: const Icon(
                    Icons.edit,
                    color: ColorManager.whiteColor,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(
                    Icons.delete,
                    color: ColorManager.whiteColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
