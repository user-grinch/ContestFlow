import 'package:contest_flow/extentions/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarView extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const AppBarView({super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: InkWell(
        borderRadius: BorderRadius.circular(50),
        splashColor: context.colorScheme.surfaceTint.withAlpha(50),
        child: Text(
          'Contest Flow',
          style: GoogleFonts.openSans(
            fontSize: 25,
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
      centerTitle: true,
    );
  }
}
