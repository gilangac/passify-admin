import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:passify_admin/routes/pages.dart';
import 'package:passify_admin/services/service_notification.dart';
import 'package:passify_admin/services/service_preference.dart';
import 'package:passify_admin/themes/light_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await Firebase.initializeApp();
  await PreferenceService.init();
  await NotificationService.init();
  initializeDateFormatting('id', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Passify Admin',
      theme: lightTheme(context),
      initialRoute: PreferenceService.getStatus() == "logged"
          ? AppPages.HOME
          : AppRoutes.INITIAL,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.cupertino,
    );
  }
}
