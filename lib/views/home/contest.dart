import 'package:contest_flow/modal/contestdata.dart';
import 'package:contest_flow/services/dataservice.dart';
import 'package:contest_flow/widgets/contestcard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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

  Widget buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Modern Cupertino-style loader
          const CupertinoActivityIndicator(radius: 16),

          const SizedBox(height: 20),

          // Smooth fade-in text animation
          AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 800),
            child: Text(
              "Fetching Contests...",
              style: GoogleFonts.raleway(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataService, List<ContestData>>(
      builder: (BuildContext context, List<ContestData> state) {
        if (state.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Fetching contents...",
                style: GoogleFonts.raleway(
                  fontSize: 18,
                ),
              ),
            ],
          );
        }
        List<ContestData> runningContests =
            state.where((c) => c.phase == ContestPhase.coding).toList();
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
                    child: Text("Running",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  ...runningContests
                      .map((contest) => ContestCard(data: contest)),
                ],
                const SizedBox(
                  height: 20,
                ),
                if (upcomingContests.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Upcoming",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
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
