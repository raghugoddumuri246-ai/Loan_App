import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00D09C), // themeGreen
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Clean Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    ),
                  ),
                  const Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                    child: const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            
            // Body
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2FBF6),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Today'),
                      _buildNotificationCard(
                        icon: Icons.notifications_active,
                        title: 'Reminder!',
                        subtitle: 'Set up your automatic EMI payments to meet your repayment goals.',
                        time: '17:00',
                        isUrgent: true,
                      ),
                      _buildNotificationCard(
                        icon: Icons.verified_user,
                        title: 'Profile Verified',
                        subtitle: 'Your loan application profile has been successfully verified by our team.',
                        time: '14:30',
                      ),
                      
                      const SizedBox(height: 16),
                      _buildSectionHeader('Yesterday'),
                      _buildNotificationCard(
                        icon: Icons.receipt_long,
                        title: 'EMI Payment Received',
                        subtitle: 'Thank you! Your EMI payment of ₹450.00 was successful.',
                        time: '09:15',
                      ),
                      _buildNotificationCard(
                        icon: Icons.warning_amber_rounded,
                        title: 'Document Required',
                        subtitle: 'Please upload your latest bank statements to proceed with the Auto Loan.',
                        time: '10:00',
                        isUrgent: true,
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    bool isUrgent = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUrgent ? Colors.orange.withOpacity(0.1) : const Color(0xFF00D09C).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isUrgent ? Colors.orange : const Color(0xFF00D09C), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark))),
                    Text(time, style: const TextStyle(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.textLight, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
