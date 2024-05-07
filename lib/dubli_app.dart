import 'package:dubli/core/routing/app_routes.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DubliApp extends StatelessWidget {
  const DubliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
