import 'package:dubli/core/helper/helper_const.dart';
import 'package:dubli/core/helper/naviagtion_extentaions.dart';
import 'package:dubli/core/routing/routes.dart';
import 'package:dubli/feature/splash/logic/cubit/splash_cubit.dart';
import 'package:dubli/core/widgets/app_logo_and_app_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashScreanBodyState();
}

class _SplashScreanBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    context.read<SplashCubit>().navigateToHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigatedToHome) {
          if (usertoken != null) {
            context.navigateAndRemoveUntil(newRoute: Routes.intorViewsRoute);
          }
          context.navigateAndRemoveUntil(newRoute: Routes.layOutViewsRoute);
        }
      },
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppLogoAndAppName(
            subtittle: 'Your Digital Twin',
          ),
        ],
      ),
    );
  }
}
