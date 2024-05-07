import 'package:dubli/core/routing/app_routes.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DubliApp extends StatelessWidget {
  const DubliApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      theme: ThemeData(
        scaffoldBackgroundColor: ColorManager.primaryColor, // Set primary color
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: ColorManager.whiteColor,
          ),
        ),
      ),
    );
  }
}
