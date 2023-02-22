import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  static final lightTheme = ThemeData.light().copyWith(
    primaryColor: AppColors.kDeepBlue,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(color: AppColors.kDeepBlue, fontSize: 25),
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.kDeepBlue),
      centerTitle: true,
    ),
    
  );

  static final darkTheme = ThemeData.dark().copyWith(
    primaryColor: AppColors.kDeepGray,
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(color: AppColors.kLightGray, fontSize: 25),
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.kLightGray),
      centerTitle: true,
    ),
  );
}