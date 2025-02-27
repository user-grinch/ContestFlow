import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:contest_flow/constants/pref.dart';
import 'package:contest_flow/modal/contestdata.dart';
import 'package:contest_flow/services/notificationservice.dart';
import 'package:contest_flow/services/prefservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:intl/intl.dart';

class BackgroundService {
  static Future<void> init() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        autoStart: true,
        onStart: onStart,
        isForegroundMode: false,
        autoStartOnBoot: true,
      ),
    );
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

void scheduleDailyNotification() {
  Timer.periodic(const Duration(hours: 20), (timer) {
    if (SharedPrefService().getBool(PREF_DAILY_UPDATE, def: true)) {
      String? contestsJson = SharedPrefService().getString(PREF_STORE_CONTEST);
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

          final String formattedDate =
              DateFormat('EE, dd MMM').format(startTime);
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
  });
}

void scheduleContestReminders() {
  Timer.periodic(const Duration(minutes: 30), (timer) async {
    if (SharedPrefService().getBool(PREF_CONTEST_REMINDER, def: true)) {
      String? contestsJson = SharedPrefService().getString(PREF_STORE_CONTEST);
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
  });
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  service.on("stop").listen((event) {
    service.stopSelf();
  });

  await SharedPrefService().init();
  scheduleDailyNotification();
  scheduleContestReminders();
}
