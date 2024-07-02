import 'package:dupli/bloc_observer.dart.dart';
import 'package:dupli/core/helper/helper_const.dart';
import 'package:dupli/core/helper/local_notification_services.dart';
import 'package:dupli/core/networking/api_services.dart';
import 'package:dupli/core/helper/local_services.dart';
import 'package:dupli/dupli_app.dart';
import 'package:dupli/firebase_options.dart';
import 'package:dupli/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalNotificationService.init();
  Bloc.observer = MyBlocObserver();
  ServiceLocator().setUpServiceLocator();
  await LocalServices.init();
  await fetchDataFromLocalStorage();
  ApiServices.init();
  runApp(const DupliApp());
}
