import 'package:contest_flow/constants/pref.dart';
import 'package:contest_flow/extentions/theme.dart';
import 'package:contest_flow/modal/contestdata.dart';
import 'package:contest_flow/services/dataservice.dart';
import 'package:contest_flow/services/prefservice.dart';
import 'package:contest_flow/util.dart';
import 'package:contest_flow/widgets/bannerad.dart';
import 'package:contest_flow/widgets/contestcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class ContestView extends StatefulWidget {
  const ContestView({super.key});

  @override
  State<ContestView> createState() => _ContestViewState();
}

class _ContestViewState extends State<ContestView> {
  late final ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataService, List<ContestData>>(
      builder: (BuildContext context, List<ContestData> state) {
        if (state.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (Util.isAnyProviderSelected()) CircularProgressIndicator(),
              const SizedBox(
                height: 20,
              ),
              if (Util.isAnyProviderSelected())
                Text(
                  "Fetching contents...",
                  style: GoogleFonts.raleway(
                    color: context.colorScheme.onSurfaceVariant,
                    fontSize: 18,
                  ),
                ),
              if (!Util.isAnyProviderSelected())
                Text(
                  "No provider selected in settings",
                  style: GoogleFonts.raleway(
                    color: context.colorScheme.onSurfaceVariant,
                    fontSize: 18,
                  ),
                ),
              FilledButton.tonal(
                onPressed: () async {
                  Util.showToast("Refreshing data");
                  await context.read<DataService>().refresh();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      HugeIcons.strokeRoundedRefresh,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Refresh',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        List<ContestData> runningContests =
            state.where((c) => c.phase == ContestPhase.running).toList();
        List<ContestData> upcomingContests =
            state.where((c) => c.phase == ContestPhase.before).toList();

        return RefreshIndicator(
          onRefresh: () async {
            await context.read<DataService>().refresh();
          },
          child: Scrollbar(
            thickness: 2,
            interactive: true,
            controller: _controller,
            child: ListView(
              controller: _controller,
              children: [
                if (runningContests.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Running",
                          style: TextStyle(
                            color: context.colorScheme.onSurfaceVariant,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () async {
                            Util.showToast("Refreshing data");
                            await context.read<DataService>().refresh();
                          },
                          icon: Icon(
                            HugeIcons.strokeRoundedRefresh,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                  ...runningContests
                      .map((contest) => ContestCard(data: contest)),
                ],
                const SizedBox(
                  height: 20,
                ),
                // BannerAdWidget(),
                if (upcomingContests.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Upcoming",
                          style: TextStyle(
                            color: context.colorScheme.onSurfaceVariant,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () async {
                            Util.showToast("Refreshing data");
                            await context.read<DataService>().refresh();
                          },
                          icon: Icon(
                            HugeIcons.strokeRoundedRefresh,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                  ...upcomingContests
                      .map((contest) => ContestCard(data: contest)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
