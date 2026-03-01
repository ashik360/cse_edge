import 'package:firebase_core/firebase_core.dart';
import 'package:cse_edge/firebase_options.dart';

class FirebaseBootstrap {
  FirebaseBootstrap._();

  static bool isAvailable = false;
  static String? errorMessage;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      isAvailable = true;
      errorMessage = null;
    } catch (error) {
      isAvailable = false;
      errorMessage = error.toString();
    }
  }
}
