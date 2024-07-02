import 'package:dupli/core/routing/app_routes.dart';
import 'package:dupli/core/utils/app_colors.dart';
import 'package:dupli/feature/chat/logic/cubit/chat_cubit.dart';
import 'package:dupli/feature/event/logic/event_cubit.dart';
import 'package:dupli/feature/layout/logic/cubit/layout_cubit.dart';
import 'package:dupli/feature/reminder/logic/reminder_cubit.dart';
import 'package:dupli/feature/setting/logic/cubit/settings_cubit.dart';
import 'package:dupli/feature/tasks/logic/tasks_cubit.dart';
import 'package:dupli/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DupliApp extends StatelessWidget {
  const DupliApp({super.key});

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
        BlocProvider(
          create: (context) => serviceLocator.get<LayoutCubit>(),
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
