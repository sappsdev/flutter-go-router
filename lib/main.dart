import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/auth_provider.dart';
import 'config/cafe_api.dart';
import 'config/constants.dart';
import 'config/local_storage.dart';
import 'config/notifications_service.dart';
import 'routes/router.dart';

void main() async {
  await LocalStorage.configurePrefs();
  CafeApi.configureDio();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final authProvider = AuthProvider();
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<AuthProvider>.value(
    value: authProvider,
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      scaffoldMessengerKey: NotificationsService.messengerKey,
      title: appName,
    )
  );
  
}
