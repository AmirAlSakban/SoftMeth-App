import 'package:flutter/material.dart';
import 'package:tutorial_management_app/theme/app_theme.dart';
import 'package:tutorial_management_app/screens/ui_showcase_screen.dart';

void main() {
  runApp(TutorialManagementApp());
}

class TutorialManagementApp extends StatelessWidget {
  const TutorialManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutorial Management App',
      theme: AppTheme.lightTheme,
      home: UIShowcaseScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
