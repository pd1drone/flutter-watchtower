import 'package:flutter/material.dart';
import 'package:watchtower/Login/login_page.dart';
import 'package:watchtower/Logout/loading_page.dart';
import 'package:watchtower/Register/register_user.dart';

import 'Admin/create_userpage.dart';
import 'Common/dashboard_page.dart';
import 'Settings/device_config.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> main() async{
  await AwesomeNotifications().initialize('resource://drawable/ic_launcher', [
    NotificationChannel(
      channelKey: 'waterlvl',
      channelName: 'waterlvl',
      channelDescription: 'Notification channels',
      defaultColor: Colors.blue,
      ledColor: Colors.white,
      importance: NotificationImportance.High,
      playSound: true,
      enableLights: true,
      enableVibration: true,
      channelShowBadge: true,
    )
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupName: 'waterlevel', channelGroupKey: 'waterlevel'),
  ]);


  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: snackbarKey,
      title: 'Watchtower',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const LoginPage(),
      routes: {
        'settings': (context) => DeviceConfigPage(),
        'register': (context) => RegisterUserPage(),
        'dashboard': (context) => DashBoardPage(),
        'loadingpage': (context) => WhiteBackgroundScreen(),
        'login': (context) => const LoginPage(),
      },
    );
  }
}
