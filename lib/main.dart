import 'package:dubli/bloc_observer.dart.dart';
import 'package:dubli/core/helper/helper_const.dart';
import 'package:dubli/core/networking/api_services.dart';
import 'package:dubli/core/networking/local_services.dart';
import 'package:dubli/dubli_app.dart';
import 'package:dubli/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  ServiceLocator().setUpServiceLocator();
  await LocalServices.init();
  await fetchDataFromLocalStorage();
  ApiServices.init();
  runApp(const DubliApp());
}
