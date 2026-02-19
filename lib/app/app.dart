import 'package:cse_edge/core/theme/app_theme.dart';
import 'package:cse_edge/features/auth/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';

class CseEdgeApp extends StatelessWidget {
  const CseEdgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSE EDGE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashPage(),
    );
  }
}
