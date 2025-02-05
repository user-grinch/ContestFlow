import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:manage_calendar_events/manage_calendar_events.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Util {
  static final CalendarPlugin _calendarPlugin = CalendarPlugin();

  static Future<void> addEvent(
    String name,
    DateTime start,
    DateTime end,
  ) async {
    PermissionStatus status = await Permission.calendarWriteOnly.request();

    if (status.isDenied) {
      await showToast("Calender permission denied");
      return;
    }

    List<Calendar>? calendars = await _calendarPlugin.getCalendars();
    if (calendars == null || calendars.isEmpty) {
      await showToast("No available calendars.");
      return;
    }

    Calendar selectedCalendar = calendars.first;
    CalendarEvent newEvent = CalendarEvent(
      title: name,
      description: "Join the upcoming coding contest!",
      location: "Online",
      hasAlarm: true,
      reminder: Reminder(minutes: 5),
      startDate: start.toUtc(),
      endDate: end.toUtc(),
    );

    String? event = await _calendarPlugin.createEvent(
      calendarId: selectedCalendar.id ?? "",
      event: newEvent,
    );

    await showToast("Reminder added to calender");
  }

  static showToast(String msg) async {
    await Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static Future<void> launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Cannot launch URL: $url');
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error occurred: $e');
    }
  }
}
