import 'package:cse_edge/core/firebase/firebase_bootstrap.dart';
import 'package:cse_edge/features/auth/data/auth_service.dart';
import 'package:cse_edge/features/auth/presentation/pages/auth_page.dart';
import 'package:cse_edge/features/navigation/presentation/pages/main_nav_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGatePage extends StatefulWidget {
  const AuthGatePage({super.key});

  @override
  State<AuthGatePage> createState() => _AuthGatePageState();
}

class _AuthGatePageState extends State<AuthGatePage> {
  AuthService? _authService;

  AuthService get authService => _authService ??= AuthService();

  @override
  Widget build(BuildContext context) {
    if (!FirebaseBootstrap.isAvailable) {
      return Scaffold(
        appBar: AppBar(title: const Text('Firebase Setup Required')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Firebase is not configured yet.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                FirebaseBootstrap.errorMessage ??
                    'Unknown Firebase initialization error.',
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const MainNavPage()),
                  );
                },
                child: const Text('Continue in Offline Demo Mode'),
              ),
            ],
          ),
        ),
      );
    }

    return StreamBuilder<User?>(
      stream: authService.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data != null) {
          return const MainNavPage();
        }

        return AuthPage(authService: authService);
      },
    );
  }
}
