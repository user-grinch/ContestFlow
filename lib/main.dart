import 'package:contest_flow/constants/routes.dart';
import 'package:contest_flow/services/backgroundservice.dart';
import 'package:contest_flow/services/notificationservice.dart';
import 'package:contest_flow/services/dataservice.dart';
import 'package:contest_flow/services/prefservice.dart';
import 'package:contest_flow/theme.dart';
import 'package:contest_flow/views/home.dart';
import 'package:contest_flow/views/home/settings.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

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

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: DynamicColorBuilder(builder: (
      ColorScheme? lightDynamic,
      ColorScheme? darkDynamic,
    ) {
      return BlocProvider(
        create: (context) => DataService(),
        lazy: false,
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: getTheme(lightDynamic, themeProvider, false),
              darkTheme: getTheme(darkDynamic, themeProvider, true),
              themeMode: ThemeMode.system,
              routes: {
                homeRoute: (context) => HomeView(),
                settingsRoute: (context) => SettingsView(),
              },
            );
          },
        ),
      );
    }),
  ));
}
