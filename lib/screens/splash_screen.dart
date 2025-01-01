import 'package:flutter/material.dart';
import 'package:kaliko/services/firebase_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final user = await _firebaseService.getCurrentUser();

    if (user != null) {
      Navigator.pushReplacementNamed(
        context,
        user.roleId == 'admin' ? '/admin/dashboard' : '/user/dashboard',
        arguments: user,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/auth/sign_in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash-logo.png',
              width: 235,
            ),
          ],
        ),
      ),
    );
  }
}
