import 'package:flutter/material.dart';

String googleIcon = 'assets/Google_Icons-09-128.png';

String defaultProfileImage = 'https://cdn4.iconfinder.com/data/icons/glyphs/24/icons_user-128.png';


enum AppColors {
  primary,
  secondary,
  accent,
  error,
  warning,
  info,
  success,
}

Map<String, Color?> colors = {
  'primary': const Color(0xFF3F51B5),
  'secondary': const Color(0xFF303F9F),
  'accent': const Color(0xFFFFC107),
  'error': Colors.red[900],
  'warning': const Color(0xFFFFA000),
  'info': const Color(0xFF1976D2),
  'success': Colors.green[900],
};


Color getColor(AppColors color) {
  switch (color) {
    case AppColors.primary:
      return colors['primary']!;
    case AppColors.secondary:
      return colors['secondary']!;
    case AppColors.accent:
      return colors['accent']!;
    case AppColors.error:
      return colors['error']!;
    case AppColors.warning:
      return colors['warning']!;
    case AppColors.info:
      return colors['info']!;
    case AppColors.success:
      return colors['success']!;
  }
}



// Colors

Color primaryBgColor = Color(0x313338);
Color secondaryBgColor = Color(0x404249);
Color accentBgColor = Color.fromARGB(255, 23, 24, 28);
Color primaryInputFieldTextColor = Color(0x000000);
Color secondaryInputFieldTextColor = Color(0xDDDDDD);
Color inputFieldColor = Color(0xC3C3C3);
Color errorInputFieldColor = Color(0xFFFFCBCB);
Color mentionInputFieldColor = Color(0xFFFFEDCB);
Color infoInputFieldColor = Color(0xFFCBF3FF);
