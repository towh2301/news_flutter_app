import 'package:flutter/material.dart';

ThemeData myTheme1 = ThemeData(
  colorScheme: ColorScheme.fromSeed(
      seedColor: Color.fromARGB(255, 255, 255, 255), background: Colors.white),
  useMaterial3: true,
  highlightColor: Colors.transparent,
  hoverColor: Colors.transparent,
  splashColor: Colors.transparent,
  splashFactory: NoSplash.splashFactory,
  appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white),
);
