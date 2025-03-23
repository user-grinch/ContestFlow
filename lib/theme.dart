import 'package:contest_flow/constants/pref.dart';
import 'package:contest_flow/services/prefservice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData getTheme(
  ColorScheme? dynamicCol,
  ThemeProvider provider,
  bool isDark,
) {
  ColorScheme defScheme = ColorScheme.fromSeed(
    seedColor: Colors.blueAccent.shade100,
    brightness:
        isDark || provider.isForceDark ? Brightness.dark : Brightness.light,
  );
  if (provider.isAmoled) {
    return _getAmoledTheme();
  }

  return ThemeData(
    colorScheme: provider.isDynamic ? dynamicCol ?? defScheme : defScheme,
    useMaterial3: true,
    textTheme: GoogleFonts.cabinTextTheme(),
  );
}

ThemeData _getAmoledTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.black,
    cardColor: Colors.black,
    dialogBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF000000),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF121212),
      secondary: Color(0xFF1C1C1C),
      onSecondary: Color(0xFFD3D3D3),
      secondaryContainer: Color(0xFF2B2B2B),
      onSecondaryContainer: Color(0xFFFFFFFF),
      background: Color(0xFF000000),
      surface: Color(0xFF121212),
      onSurface: Color(0xFFE0E0E0),
      surfaceContainer: Color(0xFF1A1A1A),
    ),
    textTheme: GoogleFonts.cabinTextTheme(),
  );
}

class ThemeProvider extends ChangeNotifier {
  bool _isAmoled = false;
  bool _isDynamic = false;
  bool _isForceDark = false;

  bool get isAmoled => _isAmoled;
  bool get isDynamic => _isDynamic;
  bool get isForceDark => _isForceDark;

  Future<void> initTheme() async {
    await SharedPrefService().init();
    _isAmoled = SharedPrefService().getBool(PREF_AMOLED_DARK_MODE, def: false);
    _isDynamic = SharedPrefService().getBool(PREF_MATERIAL_THEMING, def: false);
    _isForceDark =
        SharedPrefService().getBool(PREF_AMOLED_FORCE_DARK_MODE, def: false);
    notifyListeners();
  }

  void toggleDynamicColors() {
    _isDynamic = !_isDynamic;
    SharedPrefService().saveBool(PREF_MATERIAL_THEMING, _isDynamic);
    notifyListeners();
  }

  void toggleAmoledColors() {
    _isAmoled = !_isAmoled;
    SharedPrefService().saveBool(PREF_AMOLED_DARK_MODE, _isAmoled);
    notifyListeners();
  }

  void toggleForceDarkColors() {
    _isForceDark = !_isForceDark;
    SharedPrefService().saveBool(PREF_AMOLED_FORCE_DARK_MODE, _isForceDark);
    notifyListeners();
  }
}
