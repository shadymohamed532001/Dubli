

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());


  void navigateToHome() {
    Future.delayed(const Duration(seconds: 1), () {
      emit(SplashNavigatedToHome());
    });
}}
