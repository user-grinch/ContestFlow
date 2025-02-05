import 'dart:convert';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:contest_flow/constants/routes.dart';
import 'package:contest_flow/modal/contestdata.dart';
import 'package:contest_flow/services/notificationservice.dart';
import 'package:contest_flow/services/dataservice.dart';
import 'package:contest_flow/services/prefservice.dart';
import 'package:contest_flow/views/home.dart';
import 'package:contest_flow/views/home/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

@pragma('vm:entry-point')
void setupTasks(int id) async {
  await SharedPrefService().init();

  NotificationService.showFullScreenNotification(
    title: "Contest Reminder TEST",
    body: "A contest is going to start soon.\n",
    payload: "payload",
  );

  if (id == 0 && SharedPrefService().getBool('contest_reminder')) {
    String? contestsJson = SharedPrefService().getString('contests');
    if (contestsJson != null) {
      List<dynamic> contestsData = jsonDecode(contestsJson);
      List<ContestData> contests =
          contestsData.map((e) => ContestData.fromJson(e)).toList();

      DateTime now = DateTime.now();

      for (var e in contests) {
        final DateTime startTime = DateTime.fromMillisecondsSinceEpoch(
            e.startTimeSeconds * 1000 - 45 * 60 * 1000); // before 45 mins
        final DateTime endTime =
            startTime.add(Duration(seconds: e.durationSeconds));
        final String formattedTime =
            "${DateFormat('h:mm a ').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}";

        if (now.isAfter(startTime) && now.isBefore(endTime)) {
          NotificationService.showFullScreenNotification(
            title: "Contest Reminder",
            body:
                "A contest is going to start soon.\n ${e.name}\n$formattedTime",
            payload: "payload",
          );
        }
      }
    }
  }
  if (id == 1 && SharedPrefService().getBool('daily_update')) {
    String? contestsJson = SharedPrefService().getString('contests');
    if (contestsJson != null) {
      List<dynamic> contestsData = jsonDecode(contestsJson);
      List<ContestData> contests =
          contestsData.map((e) => ContestData.fromJson(e)).toList();

      String str = "";
      for (var e in contests) {
        final DateTime startTime =
            DateTime.fromMillisecondsSinceEpoch(e.startTimeSeconds * 1000);
        final DateTime endTime =
            startTime.add(Duration(seconds: e.durationSeconds));

        final String formattedDate = DateFormat('EE, dd MMM').format(startTime);
        final String formattedTime =
            "${DateFormat('h:mm a ').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}";
        str += "$formattedDate ($formattedTime)\n";
      }
      NotificationService.showSimpleNotification(
        id: 2000,
        title: "Upcoming Contests",
        body: str,
        payload: "payload",
      );
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  await NotificationService.init();
  await SharedPrefService().init();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));

  final darkColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blueAccent,
    brightness: Brightness.dark,
  );

  runApp(
    BlocProvider(
      create: (context) => DataService(),
      lazy: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: darkColorScheme,
          useMaterial3: true,
          textTheme: GoogleFonts.ralewayTextTheme().apply(
            bodyColor: darkColorScheme.onSurface,
            displayColor: darkColorScheme.onSurface,
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
            },
          ),
        ),
        themeMode: ThemeMode.dark,
        initialRoute: homeRoute,
        routes: {
          homeRoute: (context) => HomeView(),
          settingsRoute: (context) => SettingsView(),
        },
      ),
    ),
  );

  await AndroidAlarmManager.periodic(
    allowWhileIdle: true,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
    const Duration(minutes: 29),
    0, // contest reminder
    setupTasks,
  );

  await AndroidAlarmManager.periodic(
    allowWhileIdle: true,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
    const Duration(hours: 23),
    1, // daily update
    setupTasks,
  );

  await AndroidAlarmManager.periodic(
    allowWhileIdle: true,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
    const Duration(seconds: 2),
    2,
    setupTasks,
  );
}
