import 'package:firebase_core/firebase_core.dart';

class FirebaseBootstrap {
  FirebaseBootstrap._();

  static bool isAvailable = false;
  static String? errorMessage;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      isAvailable = true;
      errorMessage = null;
    } catch (error) {
      isAvailable = false;
      errorMessage = error.toString();
    }
  }
}
