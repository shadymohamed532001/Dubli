import 'package:dupli/core/helper/helper_const.dart';
import 'package:dupli/core/routing/routes.dart';
import 'package:dupli/core/utils/app_colors.dart';
import 'package:dupli/feature/chat/logic/cubit/chat_cubit.dart';
import 'package:dupli/feature/chat/ui/views/chat_history.dart';
import 'package:dupli/feature/gamae/ui/view/game_view.dart';
import 'package:dupli/feature/intor/ui/views/intro_view.dart';
import 'package:dupli/feature/layout/logic/cubit/layout_cubit.dart';
import 'package:dupli/feature/layout/ui/views/layout_views.dart';
import 'package:dupli/feature/login/logic/cubit/login_cubit.dart';
import 'package:dupli/feature/login/ui/views/login_view.dart';
import 'package:dupli/feature/setting/ui/views/edit_profile_view.dart';
import 'package:dupli/feature/setting/ui/views/private_policy_view.dart';
import 'package:dupli/feature/setting/ui/views/terms_and_conditions.dart';
import 'package:dupli/feature/signup/logic/cubit/sign_up_cubit.dart';
import 'package:dupli/feature/signup/ui/views/signup_view.dart';
import 'package:dupli/feature/tasks/data/models/all_tasks_name_model.dart';
import 'package:dupli/feature/tasks/logic/tasks_cubit.dart';
import 'package:dupli/feature/tasks/ui/views/add_tasks_view.dart';
import 'package:dupli/feature/tasks/ui/views/tasks_details_view.dart';
import 'package:dupli/feature/tasks/ui/views/tasks_group_details_view.dart';
import 'package:dupli/feature/welcome/ui/views/welcome_view.dart';
import 'package:dupli/service_locator.dart';
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
            create: (context) => serviceLocator.get<LoginCubit>(),
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
            create: (context) => serviceLocator.get<SignUpCubit>(),
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

      case Routes.gameViewsRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const GameScreen();
          },
        );
      case Routes.addtasksViewsRoute:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => TasksCubit(),
              child: const AddTasksView(),
            );
          },
        );
      case Routes.privatepolicyViewsRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const PrivatePolicyView();
          },
        );
      case Routes.welcomeViewsRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const WelcomeView();
          },
        );
      case Routes.tasksGroupViewsDetailsRoute:
        return MaterialPageRoute(
          builder: (context) {
            return TaskGroupDetailsView(
              taskModel: routeSettings.arguments as TaskGroupModel,
            );
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
      case Routes.chatHistoryViewsRoute:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => serviceLocator.get<ChatCubit>(),
              child: const ChatHistory(),
            );
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
