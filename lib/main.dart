import 'package:flutter/material.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EZFINANZ Personal Loan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundLight,
        primaryColor: AppColors.mainGreen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.mainGreen,
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}
