import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class AboutCompanyScreen extends StatelessWidget {
  const AboutCompanyScreen({Key? key}) : super(key: key);

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
                    child: Text('About EZFINANZ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.white, letterSpacing: -0.5)),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Empowering Your Financial Future',
                        style: AppTextStyles.heading,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'EZFINANZ is a premier digital lending platform dedicated to providing seamless, transparent, and instant financial solutions. Founded with the mission to democratize credit access, we leverage cutting-edge technology to offer personalized loan products.',
                        style: AppTextStyles.bodyText,
                      ),
                      const SizedBox(height: 32),
                      
                      const Text('Why Choose Us?', style: AppTextStyles.heading),
                      const SizedBox(height: 16),
                      _buildFeatureItem(Icons.speed, 'Instant Approvals', 'Get your loan approved in minutes, not days.'),
                      const SizedBox(height: 16),
                      _buildFeatureItem(Icons.percent, 'Competitive Rates', 'Industry-leading interest rates starting at 10.5% APR.'),
                      const SizedBox(height: 16),
                      _buildFeatureItem(Icons.phonelink_lock, '100% Digital', 'No physical paperwork required. Entirely app-based process.'),
                      
                      const SizedBox(height: 48),
                      Center(
                        child: Text('Version 1.0.0', style: TextStyle(color: AppColors.textLight.withOpacity(0.6), fontWeight: FontWeight.bold)),
                      )
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

  Widget _buildFeatureItem(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.lightGreenSurface, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.mainGreen),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 4),
              Text(desc, style: const TextStyle(fontSize: 14, color: AppColors.textLight)),
            ],
          ),
        )
      ],
    );
  }
}
