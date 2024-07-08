import 'package:dupli/core/helper/helper_const.dart';
import 'package:dupli/core/helper/local_services.dart';
import 'package:dupli/feature/login/data/repositories/login_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.loginRepo}) : super(LoginInitial());

  final LoginRepo loginRepo;
  var formKey = GlobalKey<FormState>();
  AutovalidateMode? autovalidateMode = AutovalidateMode.disabled;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    var response = await loginRepo.login(
      email: email,
      password: password,
    );

    response.fold(
      (failure) {
        if (failure.errMessage == "INVALID_LOGIN_CREDENTIALS") {
          emit(LoginFailure(
            error: 'Wrong Email Or Password',
          ));
        }
      },
      (login) async {
        await LocalServices.saveData(
          key: 'userId',
          value: login.localId,
        );
        await LocalServices.saveData(
          key: 'userEmail',
          value: email,
        );
        await LocalServices.saveData(
          key: 'tokenId',
          value: login.idToken,
        );

        await checkUserEmailInUniHelper(login.localId, email);
        final userDetails = await getUserNameById(userId, userEmail);
        if (userDetails != null) {
        LocalServices.saveData(
          key: 'userName',
          value: userDetails['name'],
        );
        LocalServices.saveData(
          key: 'userPhone',
          value: userDetails['phone'],
        );
        LocalServices.saveData(
          key: 'userPassword',
          value: userDetails['password'],
        );
      }

        emit(LoginSuccess());
      },
    );
  }
}
