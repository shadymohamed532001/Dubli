import 'package:dubli/feature/layout/data/repositories/layout_repo.dart';
import 'package:dubli/feature/layout/data/repositories/layout_repo_impl.dart';
import 'package:dubli/service_locator.dart';


class SetupForRepos {
  void setupForRepos() {
 
    // serviceLocator.registerLazySingleton<LoginRepo>(() => LoginRepoImpl());
    // serviceLocator.registerLazySingleton<SignUpRepo>(() => SignUpRepoImpl());



    serviceLocator.registerLazySingleton<LayOutRepo>(() => LayoutRepoImpl(
  ));

  
  }
}