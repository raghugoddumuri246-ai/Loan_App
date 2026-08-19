import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'login_screen.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to Login Screen after 2 seconds
    Timer(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.darkAccent.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))
                ]
              ),
              child: const Icon(Icons.check_circle_outline, size: 80, color: AppColors.mainGreen),
            ),
            const SizedBox(height: 32),
            const Text(
              'Account Created\nSuccessfully!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.white, letterSpacing: -0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Redirecting you to login...',
              style: TextStyle(fontSize: 16, color: AppColors.white.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }
}
