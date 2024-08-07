import 'package:dupli/feature/chat/data/repositories/chat_repo.dart';
import 'package:dupli/feature/chat/data/repositories/chat_repo_impl.dart';
import 'package:dupli/feature/layout/data/repositories/layout_repo.dart';
import 'package:dupli/feature/layout/data/repositories/layout_repo_impl.dart';
import 'package:dupli/feature/login/data/repositories/login_repo.dart';
import 'package:dupli/feature/login/data/repositories/login_repo_impl.dart';
import 'package:dupli/feature/signup/data/repositories/sign_up_repo.dart';
import 'package:dupli/service_locator.dart';

import '../../feature/signup/data/repositories/sign)up_repo_impl.dart';

class SetupForRepos {
  void setupForRepos() {
    serviceLocator.registerLazySingleton<LoginRepo>(() => LoginRepoImpl());
    serviceLocator.registerLazySingleton<SignUpRepo>(() => SignUpRepoImpl());

    serviceLocator.registerLazySingleton<LayOutRepo>(() => LayoutRepoImpl());

    serviceLocator.registerLazySingleton<ChatRepo>(() => ChatRepoImpl());
  }
}
