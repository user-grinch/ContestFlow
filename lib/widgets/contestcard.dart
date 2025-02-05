import 'package:contest_flow/modal/contestdata.dart';
import 'package:contest_flow/util.dart';
import 'package:flutter/material.dart';
import 'package:contest_flow/extentions/theme.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class ContestCard extends StatelessWidget {
  final ContestData data;
  const ContestCard({super.key, required this.data});

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
          color: context.colorScheme.secondaryContainer.withAlpha(50),
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
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: context.colorScheme.secondaryContainer,
                    child: Text(
                      data.type.name.toUpperCase(),
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: context.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
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
                      Util.launchURL(
                          "https://codeforces.com/contestRegistration/${data.id}");
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
