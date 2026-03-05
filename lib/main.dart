import 'package:cse_edge/app/app.dart';
import 'package:cse_edge/core/firebase/firebase_bootstrap.dart';
import 'package:cse_edge/core/firebase/notification_service.dart'; // New Import
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await FirebaseBootstrap.initialize();
  
  // Start Notification Service
  if (FirebaseBootstrap.isAvailable) {
    await NotificationService.initialize();
  }
  
  runApp(const CseEdgeApp());
}
