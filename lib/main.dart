import 'package:contest_flow/constants/routes.dart';
import 'package:contest_flow/services/backgroundservice.dart';
import 'package:contest_flow/services/notificationservice.dart';
import 'package:contest_flow/services/dataservice.dart';
import 'package:contest_flow/services/prefservice.dart';
import 'package:contest_flow/views/home.dart';
import 'package:contest_flow/views/home/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();
  await SharedPrefService().init();
  await BackgroundService.init();

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
}
