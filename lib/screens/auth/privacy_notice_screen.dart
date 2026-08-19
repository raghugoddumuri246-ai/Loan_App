import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'success_screen.dart';

class PrivacyNoticeScreen extends StatelessWidget {
  const PrivacyNoticeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainGreen,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 24.0, top: 10.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Data Security', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.white, letterSpacing: -0.5)),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreenSurface,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.shield_outlined, size: 80, color: AppColors.mainGreen),
                      ),
                      const SizedBox(height: 32),
                      
                      const Text(
                        'Your trust is our priority',
                        style: AppTextStyles.heading,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      
                      const Text(
                        'We use bank-level 256-bit encryption to secure your personal and financial data. We never sell your data to third parties. Your information is stored locally and securely transmitted strictly following RBI guidelines.',
                        style: AppTextStyles.bodyText,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      
                      _buildSecurityFeature(Icons.lock_outline, 'End-to-End Encryption'),
                      const SizedBox(height: 16),
                      _buildSecurityFeature(Icons.gavel_outlined, '100% Regulatory Compliant'),
                      const SizedBox(height: 16),
                      _buildSecurityFeature(Icons.data_usage, 'Data Deletion on Request'),
                      
                      const SizedBox(height: 48),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainGreen,
                            elevation: 4,
                            shadowColor: AppColors.mainGreen.withOpacity(0.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SuccessScreen()),
                            );
                          },
                          child: const Text('I Agree & Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityFeature(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.mainGreen, size: 28),
        const SizedBox(width: 16),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
      ],
    );
  }
}
