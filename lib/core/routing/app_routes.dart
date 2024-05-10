import 'package:dubli/core/helper/helper_const.dart';
import 'package:dubli/core/routing/routes.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/feature/event/logic/event_cubit.dart';
import 'package:dubli/feature/event/ui/views/add_event_view.dart';
import 'package:dubli/feature/intor/ui/views/intro_view.dart';
import 'package:dubli/feature/layout/logic/cubit/layout_cubit.dart';
import 'package:dubli/feature/layout/ui/views/layout_views.dart';
import 'package:dubli/feature/login/logic/cubit/login_cubit.dart';
import 'package:dubli/feature/login/ui/views/login_view.dart';
import 'package:dubli/feature/setting/ui/views/edit_profile_view.dart';
import 'package:dubli/feature/setting/ui/views/private_policy_view.dart';
import 'package:dubli/feature/setting/ui/views/terms_and_conditions.dart';
import 'package:dubli/feature/signup/logic/cubit/sign_up_cubit.dart';
import 'package:dubli/feature/signup/ui/views/signup_view.dart';
import 'package:dubli/feature/tasks/ui/views/tasks_details_view.dart';

import 'package:dubli/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  static Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.initialRoute:
        if (usertoken != null) {
          return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (context) => serviceLocator.get<LayoutCubit>(),
                child: const LayOutViews(),
              );
            },
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => const IntroView(),
          );
        }

      case Routes.intorViewsRoute:
        return MaterialPageRoute(
          builder: (context) => const IntroView(),
        );
      case Routes.loginViewsRoute:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginCubit(),
            child: const LoginView(),
          ),
        );
      case Routes.tasksViewsDetailsRoute:
        return MaterialPageRoute(
          builder: (context) => const TasksListView(),
        );

      case Routes.signUpViewsRoute:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => SignUpCubit(),
            child: const SignUpView(),
          ),
        );

      case Routes.layOutViewsRoute:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => serviceLocator.get<LayoutCubit>(),
              child: const LayOutViews(),
            );
          },
        );
      case Routes.addEventViewsRoute:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => EventCubit(),
              child: const AddEventView(),
            );
          },
        );
      case Routes.privatepolicyViewsRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const PrivatePolicyView();
          },
        );
      case Routes.termsAndConditionsViewsRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const TermsAndConditionsView();
          },
        );

      case Routes.editProfileViewsRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const EditProfileView();
          },
        );

      // case Routes.initialRoute:
      //   if (onBording != null) {
      //     if (usertoken != null) {
      //       return MaterialPageRoute(
      //         builder: (context) => BlocProvider(
      //           create: (context) => OnboardingCubit(),
      //           child: const HomeView(),
      //         ),
      //       );
      //     } else {
      //       return MaterialPageRoute(
      //         builder: (context) => BlocProvider(
      //           create: (context) => LoginCubit(),
      //           child: const LoginView(),
      //         ),
      //       );
      //     }
      //   } else {
      //     return MaterialPageRoute(
      //       builder: (context) => BlocProvider(
      //         create: (context) => OnboardingCubit(),
      //         child: const OnBordingView(),
      //       ),
      //     );
      //   }

      // case Routes.loginViewsRoute:
      //   return MaterialPageRoute(
      //     builder: (context) => BlocProvider(
      //       create: (context) => LoginCubit(),
      //       child: const LoginView(),
      //     ),
      //   );
      // case Routes.signUpViewsRoute:
      //   return MaterialPageRoute(
      //     builder: (context) => BlocProvider(
      //       create: (context) => SignUpCubit(),
      //       child: const SignUpView(),
      //     ),
      //   );

      // case Routes.homeViewsRoute:
      //   return MaterialPageRoute(
      //     builder: ((context) => BlocProvider(
      //           create: (context) => HomeCubit()..getUserData(),
      //           child: const HomeView(),
      //         )),
      //   );

      // case Routes.informationViewsRoute:
      //   return MaterialPageRoute(
      //     builder: ((context) => BlocProvider(
      //           create: (context) => InformationCubit()..getInformationData(),
      //           child: const InformationView(),
      //         )),
      //   );

      // case Routes.chatViewsRoute:
      //   return MaterialPageRoute(
      //     builder: ((context) => const ChatView()),
      //   );
      // case Routes.mechanicInfoViewsRoute:
      //   return MaterialPageRoute(
      //     builder: ((context) => BlocProvider(
      //           create: (context) => MechanicCubit(),
      //           child: const MechanicInfoView(),
      //         )),
      // );

      default:
        return _unFoundRoute();
    }
  }

  static Route<dynamic> _unFoundRoute() {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(
          child: Text('noRouteFounded',
              style: TextStyle(
                fontSize: 28,
                color: ColorManager.blackColor,
              )),
        ),
      ),
    );
  }
}
