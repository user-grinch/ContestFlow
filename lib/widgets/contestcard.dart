import 'package:contest_flow/modal/contestdata.dart';
import 'package:contest_flow/util.dart';
import 'package:flutter/material.dart';
import 'package:contest_flow/extentions/theme.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

const String codechefRegisterURL = "https://www.codechef.com/";
const String codeforcesRegisterURL =
    "https://codeforces.com/contestRegistration/";
const String leetcodeRegisterURL = "https://leetcode.com/contest/";

class ContestCard extends StatelessWidget {
  final ContestData data;
  const ContestCard({super.key, required this.data});

  ImageProvider _getProviderImage(ContestProvider provider) {
    switch (provider) {
      case ContestProvider.cc:
        return AssetImage('assets/source-icons/cc.png');
      case ContestProvider.cf:
        return AssetImage('assets/source-icons/cf.png');
      case ContestProvider.lc:
        return AssetImage('assets/source-icons/lc.png');
      default:
        return AssetImage('assets/source-icons/default.png');
    }
  }

  String _getProviderLabel(ContestProvider provider) {
    switch (provider) {
      case ContestProvider.cc:
        return 'CodeChef';
      case ContestProvider.cf:
        return 'Codeforces';
      case ContestProvider.lc:
        return 'LeetCode';
      default:
        return 'OnlineJudge';
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime startTime =
        DateTime.fromMillisecondsSinceEpoch(data.startTimeSeconds * 1000);
    final DateTime endTime =
        startTime.add(Duration(seconds: data.durationSeconds));

    final String formattedDate = DateFormat('EE, dd MMM').format(startTime);
    final String formattedTime =
        "${DateFormat('h:mm a ').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.secondaryContainer.withAlpha(100),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: context.colorScheme.secondaryContainer
                            .withAlpha(150),
                        child: Image(
                          image: _getProviderImage(data.provider),
                          width: 50,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getProviderLabel(data.provider),
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontSize: 18,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              HugeIcons.strokeRoundedCalendar03,
                              color: context.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              formattedDate,
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              HugeIcons.strokeRoundedClock01,
                              size: 20,
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              formattedTime,
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton.tonal(
                    onPressed: () {
                      if (data.provider == ContestProvider.cc) {
                        Util.launchURL("$codechefRegisterURL${data.id}");
                      } else if (data.provider == ContestProvider.cf) {
                        Util.launchURL("$codeforcesRegisterURL${data.id}");
                      } else if (data.provider == ContestProvider.lc) {
                        Util.launchURL("$leetcodeRegisterURL${data.id}");
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          HugeIcons.strokeRoundedUserAdd01,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () async {
                      await Util.addEvent(data.name, startTime, endTime);
                    },
                    child: Row(
                      children: [
                        Icon(
                          HugeIcons.strokeRoundedAlarmClock,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Reminder',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
