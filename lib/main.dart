import 'package:cse_edge/app/app.dart';
import 'package:cse_edge/core/firebase/firebase_bootstrap.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBootstrap.initialize();
  runApp(const CseEdgeApp());
}

