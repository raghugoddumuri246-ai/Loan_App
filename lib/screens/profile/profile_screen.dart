import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Text('Profile & Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.white)),
        ),
        
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF2FBF6),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFF00D09C).withOpacity(0.2),
                          child: const Icon(Icons.person, size: 50, color: Color(0xFF00D09C)),
                        ),
                        const SizedBox(height: 16),
                        const Text('John Doe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        const Text('+1 (555) 123-4567', style: TextStyle(fontSize: 14, color: AppColors.textLight)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  const Text('Personal Details', style: AppTextStyles.heading),
                  const SizedBox(height: 16),
                  _buildProfileCard([
                    _buildRow('Email', 'john.doe@gmail.com'),
                    const Divider(),
                    _buildRow('Date of Birth', '12 Jan 1990'),
                    const Divider(),
                    _buildRow('KYC Status', 'Verified', isVerified: true),
                  ]),
                  
                  const SizedBox(height: 32),
                  const Text('Bank Details', style: AppTextStyles.heading),
                  const SizedBox(height: 16),
                  _buildProfileCard([
                    _buildRow('Bank Name', 'State Bank of India'),
                    const Divider(),
                    _buildRow('Account No', '**** **** 1234'),
                    const Divider(),
                    _buildRow('IFSC Code', 'SBIN0001234'),
                  ]),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey)
      ),
      child: Column(children: children),
    );
  }

  Widget _buildRow(String label, String value, {bool isVerified = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textLight)),
          Row(
            children: [
              Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isVerified ? const Color(0xFF00D09C) : AppColors.textDark)),
              if (isVerified) ...[
                const SizedBox(width: 4),
                const Icon(Icons.verified, color: Color(0xFF00D09C), size: 16),
              ]
            ],
          )
        ],
      ),
    );
  }
}
