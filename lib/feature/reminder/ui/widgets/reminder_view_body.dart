// import 'package:dubli/core/helper/validators_helper.dart';
// import 'package:dubli/core/widgets/app_text_formfield.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dubli/core/utils/app_colors.dart';
// import 'package:dubli/core/utils/app_styles.dart';
// import 'package:dubli/core/widgets/app_bottom.dart';
// import 'package:dubli/feature/reminder/logic/reminder_cubit.dart';

// import 'dart:async';

// class ReminderViewBody extends StatefulWidget {
//   const ReminderViewBody({
//     super.key,
//   });

//   @override
//   State<ReminderViewBody> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<ReminderViewBody> {
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: SingleChildScrollView(
//         child: BlocBuilder<ReminderCubit, ReminderState>(
//           builder: (context, state) {
//             var cubit = BlocProvider.of<ReminderCubit>(context);
//             return Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Let’s get started',
//                       style: AppStyle.font22Whitesemibold,
//                     ),
//                     CustomBottom(
//                       bottomHeight: 40,
//                       bottomWidth: 70,
//                       bottomtext: 'Event',
//                       backgroundColor: ColorManager.darkyellowColor,
//                       textBottomStyle: const TextStyle(
//                         fontSize: 13,
//                         fontFamily: 'Raleway',
//                         color: ColorManager.primaryColor,
//                       ),
//                       onPressed: () {
//                         showDurationPicker(context, cubit: cubit);
//                       },
//                     )
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                     width: double.infinity,
//                     height: 400,
//                     decoration: BoxDecoration(
//                       color: ColorManager.darkGreyColor.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           '${cubit.digtalHour}:${cubit.digtalMinute}:${cubit.digtalSecond}',
//                           style: AppStyle.font80Whitesemibold,
//                         ),
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: cubit.laps.length,
//                             itemBuilder: (context, index) {
//                               return Padding(
//                                 padding: const EdgeInsets.all(16),
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       '${cubit.eventController.text} ${index + 1} :',
//                                       style: AppStyle.font12Greymedium,
//                                     ),
//                                     const SizedBox(
//                                       width: 10,
//                                     ),
//                                     Text(
//                                       cubit.laps[index],
//                                       style: AppStyle.font22Whitesemibold,
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     )),
//                 const SizedBox(
//                   height: 40,
//                 ),
//                 ElevatedButton(
//                   onPressed: () => showDurationPicker(context, cubit: cubit),
//                   child: Text(
//                     cubit.duration == Duration.zero
//                         ? 'Pick Duration'
//                         : 'Duration: ${cubit.duration.inHours.toString().padLeft(2, '0')}:${(cubit.duration.inMinutes % 60).toString().padLeft(2, '0')}:${(cubit.duration.inSeconds % 60).toString().padLeft(2, '0')}',
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     CustomBottom(
//                       onPressed: () {
//                         if (cubit.start) {
//                           if (cubit.duration != Duration.zero) {
//                             cubit.startTimer(cubit.duration);
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Please pick a duration first'),
//                               ),
//                             );
//                           }
//                         } else {
//                           cubit.stop();
//                         }
//                       },
//                       bottomtext: (cubit.start) ? 'start' : 'stop',
//                       bottomHeight: 50,
//                       bottomWidth: 100,
//                       backgroundColor: ColorManager.darkyellowColor,
//                     ),
//                     CustomBottom(
//                       onPressed: () {
//                         cubit.removeLaps();
//                       },
//                       bottomtext: 'remove laps',
//                       bottomHeight: 50,
//                       bottomWidth: 100,
//                       backgroundColor: ColorManager.greyColor,
//                     ),
//                     CustomBottom(
//                       onPressed: () {
//                         cubit.reset();
//                       },
//                       bottomtext: 'reset',
//                       bottomHeight: 50,
//                       bottomWidth: 100,
//                       backgroundColor: ColorManager.greyColor,
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void showDurationPicker(BuildContext context,
//       {required ReminderCubit cubit}) {
//     int tempHour = 0;
//     int tempMinute = 0;
//     int tempSecond = 0;

//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setModalState) {
//             return Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 4, bottom: 4),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'Evant',
//                           style: AppStyle.font18Primaryregular,
//                         ),
//                       ),
//                     ),
//                     CustomTextFormField(
//                       obscureText: false,
//                       hintText: 'Add your event',
//                       keyboardType: TextInputType.emailAddress,
//                       fillColor: Colors.transparent,
//                       controller: cubit.eventController,
//                       validator: (text) {
//                         return MyValidatorsHelper.emailValidator(text);
//                       },
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Column(
//                           children: [
//                             Text('Hours', style: AppStyle.font18Primaryregular),
//                             DropdownButton<int>(
//                               value: tempHour,
//                               items: List.generate(24, (index) => index)
//                                   .map((int value) {
//                                 return DropdownMenuItem<int>(
//                                   value: value,
//                                   child: Text(value.toString()),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                                 setModalState(() {
//                                   tempHour = value!;
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         Column(
//                           children: [
//                             Text('Minutes',
//                                 style: AppStyle.font18Primaryregular),
//                             DropdownButton<int>(
//                               value: tempMinute,
//                               items: List.generate(60, (index) => index)
//                                   .map((int value) {
//                                 return DropdownMenuItem<int>(
//                                   value: value,
//                                   child: Text(value.toString()),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                                 setModalState(() {
//                                   tempMinute = value!;
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         Column(
//                           children: [
//                             Text('Seconds',
//                                 style: AppStyle.font18Primaryregular),
//                             DropdownButton<int>(
//                               value: tempSecond,
//                               items: List.generate(60, (index) => index)
//                                   .map((int value) {
//                                 return DropdownMenuItem<int>(
//                                   value: value,
//                                   child: Text(value.toString()),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                                 setModalState(() {
//                                   tempSecond = value!;
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           cubit.duration = Duration(
//                             hours: tempHour,
//                             minutes: tempMinute,
//                             seconds: tempSecond,
//                           );
//                         });
//                         setState(() {
//                           BlocProvider.of<ReminderCubit>(context).start = true;
//                         });
//                         cubit.startTimer(cubit.duration);
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         'Set Duration',
//                         style: AppStyle.font14Primarysemibold,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 40,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
