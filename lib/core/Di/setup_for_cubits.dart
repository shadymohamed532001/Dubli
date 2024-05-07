
import 'package:dubli/feature/layout/data/repositories/layout_repo.dart';
import 'package:dubli/feature/layout/logic/cubit/layout_cubit.dart';
import 'package:dubli/service_locator.dart';

class SetupForCubits {
  void setUpForCubits() {
  
    // serviceLocator.registerFactory<LoginCubit>(
    //     () => LoginCubit(loginRepo: serviceLocator.get<LoginRepo>()));
    // serviceLocator.registerFactory<SignUpCubit>(
    //     () => SignUpCubit(signUpRepo: serviceLocator.get<SignUpRepo>()));
    serviceLocator.registerFactory<LayoutCubit>(
        () => LayoutCubit(layOutRepo: serviceLocator.get<LayOutRepo>()));

  }
}