import 'package:dubli/core/routing/app_routes.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/feature/chat/logic/cubit/chat_cubit.dart';
import 'package:dubli/feature/event/logic/event_cubit.dart';
import 'package:dubli/feature/reminder/logic/reminder_cubit.dart';
import 'package:dubli/feature/setting/logic/cubit/settings_cubit.dart';
import 'package:dubli/feature/tasks/logic/tasks_cubit.dart';
import 'package:dubli/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DubliApp extends StatelessWidget {
  const DubliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsCubit(),
        ),
        BlocProvider(
          create: (context) => TasksCubit(),
        ),
        BlocProvider(
          create: (context) => ReminderCubit(),
        ),
        BlocProvider(
          create: (context) => serviceLocator.get<ChatCubit>(),
        ),
        BlocProvider(
          create: (context) => EventCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        theme: ThemeData(
          scaffoldBackgroundColor: ColorManager.primaryColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            titleTextStyle: TextStyle(
              fontSize: 24,
              color: ColorManager.whiteColor,
            ),
            iconTheme: IconThemeData(
              color: ColorManager.whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
