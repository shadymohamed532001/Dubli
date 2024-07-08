import 'package:dupli/feature/chat/data/repositories/chat_repo.dart';
import 'package:dupli/feature/chat/logic/cubit/chat_cubit.dart';
import 'package:dupli/feature/layout/data/repositories/layout_repo.dart';
import 'package:dupli/feature/layout/logic/cubit/layout_cubit.dart';
import 'package:dupli/feature/login/data/repositories/login_repo.dart';
import 'package:dupli/feature/login/logic/cubit/login_cubit.dart';
import 'package:dupli/service_locator.dart';

class SetupForCubits {
  void setUpForCubits() {
    serviceLocator.registerFactory<LoginCubit>(
        () => LoginCubit(loginRepo: serviceLocator.get<LoginRepo>()));
    // serviceLocator.registerFactory<SignUpCubit>(
    //     () => SignUpCubit(signUpRepo: serviceLocator.get<SignUpRepo>()));
    serviceLocator.registerFactory<LayoutCubit>(
        () => LayoutCubit(layOutRepo: serviceLocator.get<LayOutRepo>()));
    serviceLocator.registerFactory<ChatCubit>(
        () => ChatCubit(chatRepo: serviceLocator.get<ChatRepo>()));
  }
}
