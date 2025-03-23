import 'package:contest_flow/constants/pref.dart';
import 'package:contest_flow/extentions/theme.dart';
import 'package:contest_flow/services/dataservice.dart';
import 'package:contest_flow/services/prefservice.dart';
import 'package:contest_flow/theme.dart';
import 'package:contest_flow/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Notification',
              style: GoogleFonts.raleway(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.secondaryContainer.withAlpha(100),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: context.colorScheme.onSurface,
                    title: const Text('Contest Reminders'),
                    subtitle:
                        const Text('Sends out notifications before contests'),
                    value: SharedPrefService()
                        .getBool(PREF_CONTEST_REMINDER, def: true),
                    onChanged: (value) async {
                      SharedPrefService()
                          .saveBool(PREF_CONTEST_REMINDER, value);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    activeColor: context.colorScheme.onSurface,
                    title: const Text('Daily Updates'),
                    subtitle: const Text(
                        'Sends out notifications for upcoming contests'),
                    value: SharedPrefService()
                        .getBool(PREF_DAILY_UPDATE, def: true),
                    onChanged: (value) async {
                      SharedPrefService().saveBool(PREF_DAILY_UPDATE, value);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Provider',
              style: GoogleFonts.raleway(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.secondaryContainer.withAlpha(100),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: context.colorScheme.onSurface,
                    title: const Text('Codechef'),
                    subtitle: const Text('Fetches data for Codechef contests'),
                    value: SharedPrefService()
                        .getBool(PREF_PROVIDER_CODECHEF, def: true),
                    onChanged: (value) async {
                      SharedPrefService()
                          .saveBool(PREF_PROVIDER_CODECHEF, value);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    activeColor: context.colorScheme.onSurface,
                    title: const Text('Codeforces'),
                    subtitle:
                        const Text('Fetches data for Codeforces contests'),
                    value: SharedPrefService()
                        .getBool(PREF_PROVIDER_CODEFORCES, def: true),
                    onChanged: (value) async {
                      SharedPrefService()
                          .saveBool(PREF_PROVIDER_CODEFORCES, value);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    activeColor: context.colorScheme.onSurface,
                    title: const Text('Leetcode'),
                    subtitle: const Text('Fetches data for Leetcode contests'),
                    value: SharedPrefService()
                        .getBool(PREF_PROVIDER_LEETCODE, def: true),
                    onChanged: (value) async {
                      SharedPrefService()
                          .saveBool(PREF_PROVIDER_LEETCODE, value);
                      setState(() {});
                    },
                  ),
                  ListTile(
                      title: const Text('Refresh Sources'),
                      subtitle:
                          const Text('Fetches data from the providers again'),
                      leading: Icon(
                        HugeIcons.strokeRoundedRefresh,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onTap: () async {
                        Util.showToast("Refreshing data");
                        await context.read<DataService>().refresh();
                      }),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Interface',
              style: GoogleFonts.raleway(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.secondaryContainer.withAlpha(100),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: context.colorScheme.onSurface,
                    title: const Text('Amoled Mode'),
                    subtitle: const Text('Enable dark mode for AMOLED screens'),
                    value: context.read<ThemeProvider>().isAmoled,
                    onChanged: (value) async {
                      setState(() {
                        context.read<ThemeProvider>().toggleAmoledColors();
                        setState(() {});
                      });
                    },
                  ),
                  SwitchListTile(
                    activeColor: context.colorScheme.onSurface,
                    title: const Text('Force Dark Mode'),
                    subtitle: const Text(
                        'Forces the app to use dark mode regardless of system settings'),
                    value: context.read<ThemeProvider>().isForceDark,
                    onChanged: (value) async {
                      setState(() {
                        context.read<ThemeProvider>().toggleForceDarkColors();
                        setState(() {});
                      });
                    },
                  ),
                  SwitchListTile(
                    activeColor: context.colorScheme.onSurface,
                    title: const Text('Material You Colors'),
                    subtitle: const Text('Enable Material You colors'),
                    value: context.read<ThemeProvider>().isDynamic,
                    onChanged: (value) async {
                      context.read<ThemeProvider>().toggleDynamicColors();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Information',
              style: GoogleFonts.raleway(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.secondaryContainer.withAlpha(100),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Version $APP_VERSION'),
                    subtitle: const Text('Author: Grinch_'),
                    leading: Icon(
                      HugeIcons.strokeRoundedInformationCircle,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onTap: () async => await Util.launchURL(
                        'https://github.com/user-grinch/ContestFlow'),
                  ),
                  ListTile(
                    title: const Text('Source Code'),
                    subtitle: const Text('View the source code on GitHub'),
                    leading: Icon(
                      HugeIcons.strokeRoundedSourceCodeCircle,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onTap: () async => await Util.launchURL(
                        'https://github.com/user-grinch/ContestFlow'),
                  ),
                  ListTile(
                    title: const Text('Support Us on Patreon'),
                    subtitle: const Text('Contribute to our development'),
                    leading: Icon(HugeIcons.strokeRoundedFavourite,
                        color: Theme.of(context).colorScheme.onSurface),
                    onTap: () async => await Util.launchURL(
                        'https://www.patreon.com/c/grinch_'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                '© Copyright Grinch_ 2025',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
