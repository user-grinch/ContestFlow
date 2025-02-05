import 'package:contest_flow/extentions/theme.dart';
import 'package:contest_flow/services/notificationservice.dart';
import 'package:contest_flow/services/prefservice.dart';
import 'package:contest_flow/util.dart';
import 'package:flutter/material.dart';
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
              'Notification Settings',
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
                color: context.colorScheme.secondaryContainer.withAlpha(50),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: context.colorScheme.surfaceTint,
                    title: const Text('Contest Reminders'),
                    subtitle:
                        const Text('Sends out notifications before contests'),
                    value: SharedPrefService().getBool('contest_reminder'),
                    onChanged: (value) async {
                      SharedPrefService().saveBool('contest_reminder', value);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    activeColor: context.colorScheme.surfaceTint,
                    title: const Text('Daily Updates'),
                    subtitle: const Text(
                        'Sends out notifications for upcoming contests'),
                    value: SharedPrefService().getBool('daily_update'),
                    onChanged: (value) async {
                      SharedPrefService().saveBool('daily_update', value);
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
                color: context.colorScheme.secondaryContainer.withAlpha(50),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Source Code'),
                    subtitle: const Text('View the source code on GitHub'),
                    leading: Icon(
                      HugeIcons.strokeRoundedSourceCodeCircle,
                      color: Theme.of(context).colorScheme.surfaceTint,
                    ),
                    onTap: () async => await Util.launchURL(
                        'https://github.com/user-grinch/Rivo'),
                  ),
                  ListTile(
                    title: const Text('Support Us on Patreon'),
                    subtitle: const Text('Contribute to our development'),
                    leading: Icon(HugeIcons.strokeRoundedFavourite,
                        color: Theme.of(context).colorScheme.surfaceTint),
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
