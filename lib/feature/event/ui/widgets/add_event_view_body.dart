import 'dart:developer';

import 'package:dubli/core/helper/validators_helper.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/core/widgets/app_bottom.dart';
import 'package:dubli/core/widgets/app_text_formfield.dart';
import 'package:dubli/feature/event/logic/event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddEventViewBody extends StatefulWidget {
  const AddEventViewBody({super.key});

  @override
  State<AddEventViewBody> createState() => _AddEventViewBodyState();
}

class _AddEventViewBodyState extends State<AddEventViewBody> {
  DateTime selectedDate = DateTime.now();
  String timeOfDay = DateFormat("hh:mm a").format(DateTime.now()).toString();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventCubit, EventState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var cubit = BlocProvider.of<EventCubit>(context);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: cubit.formKey,
            autovalidateMode: cubit.autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Event',
                  style: AppStyle.font22Whiteregular,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Title',
                  style: AppStyle.font18Whitemedium,
                ),
                const SizedBox(
                  height: 2,
                ),
                CustomTextFormField(
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  obscureText: false,
                  hintText: 'Enter Title here',
                  fillColor: ColorManager.whiteColor,
                  validator: (text) {
                    return MyValidatorsHelper.tittleValidator(text);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Note',
                  style: AppStyle.font18Whitemedium,
                ),
                const SizedBox(
                  height: 2,
                ),
                CustomTextFormField(
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  obscureText: false,
                  hintText: 'Enter Note here',
                  fillColor: ColorManager.whiteColor,
                  validator: (text) {
                    return MyValidatorsHelper.noteValidator(text);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Date',
                  style: AppStyle.font18Whitemedium,
                ),
                const SizedBox(
                  height: 2,
                ),
                CustomTextFormField(
                  obscureText: false,
                  hintText: DateFormat.yMd().format(selectedDate),
                  fillColor: ColorManager.whiteColor,
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      getDateFormUser();
                    },
                    child: Icon(
                      Icons.calendar_month,
                      color: Colors.grey.withOpacity(0.6),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Time',
                  style: AppStyle.font18Whitemedium,
                ),
                const SizedBox(
                  height: 2,
                ),
                CustomTextFormField(
                  obscureText: false,
                  hintText: timeOfDay,
                  fillColor: ColorManager.whiteColor,
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      getTimeFromUser();
                    },
                    child: Icon(
                      Icons.schedule,
                      color: Colors.grey.withOpacity(0.6),
                    ),
                  ),
                ),
                const Spacer(
                  flex: 3,
                ),
                CustomBottom(
                  onPressed: () {
                    if (cubit.formKey.currentState!.validate()) {
                      // cubit.addEvent();
                    } else {
                      setState(() {
                        cubit.autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  bottomtext: 'Add Event',
                  backgroundColor: ColorManager.darkyellowColor,
                  textBottomStyle: AppStyle.font18Whitemedium,
                ),
                const Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  getDateFormUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      initialDate: DateTime.now(),
    );

    if (pickerDate != null) {
      setState(() {
        selectedDate = pickerDate;
      });
    } else {
      log('Date is not selected');
    }
  }

  getTimeFromUser() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 21),
    );

    if (pickedTime != null) {
      setState(() {
        timeOfDay = pickedTime.format(context);
      });
    } else {
      log('Time is not selected');
    }
  }
}
