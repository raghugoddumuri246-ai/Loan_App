import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class LoanStatusScreen extends StatelessWidget {
  final String loanId;
  final String status;
  final String type;

  const LoanStatusScreen({Key? key, required this.loanId, required this.status, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00D09C), // Theme green top
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        title: const Text(
          'Loan Tracker',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Status Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text('Application ID: $loanId', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(type, style: const TextStyle(color: AppColors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            
            // White Container Body
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2FBF6),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tracking Timeline Card
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Current Status: $status',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                            ),
                            const SizedBox(height: 32),
                            _buildTimelineTracking(status),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Loan Description Paragraph
                      const Text('About This Application', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      const SizedBox(height: 12),
                      Text(
                        'This $type application was initiated to provide you with the financial support necessary to achieve your personal goals. The requested loan features a competitive interest rate and a flexible repayment schedule tailored to your financial profile.',
                        style: const TextStyle(fontSize: 14, color: AppColors.textLight, height: 1.6),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Detailed Info Card
                      const Text('Application Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.borderGrey)
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow('Applicant Name', 'John Doe'),
                            const Divider(height: 24),
                            _buildInfoRow('Requested Amount', '₹10,000'),
                            const Divider(height: 24),
                            _buildInfoRow('Requested Tenure', '24 Months'),
                            const Divider(height: 24),
                            _buildInfoRow('Expected Date', '7-NOV-2026'),
                            const Divider(height: 24),
                            _buildInfoRow('Bank Account', 'SBI (**** 1234)'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
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
  
  Widget _buildTimelineTracking(String currentStatus) {
    int currentStep = 0;
    if (currentStatus == 'Processing') currentStep = 1;
    if (currentStatus == 'Verification') currentStep = 2; 
    if (currentStatus == 'Approved') currentStep = 3;
    if (currentStatus == 'Disbursed') currentStep = 4;
    
    return Row(
      children: [
        _buildTrackingNode('Submitted', Icons.assignment, currentStep >= 0, currentStep > 0, isFirst: true),
        _buildTrackingNode('Processing', Icons.settings, currentStep >= 1, currentStep > 1),
        _buildTrackingNode('Verified', Icons.verified_user, currentStep >= 2, currentStep > 2),
        _buildTrackingNode('Approved', Icons.check_circle, currentStep >= 3, currentStep > 3),
        _buildTrackingNode('Disbursed', Icons.account_balance_wallet, currentStep >= 4, false, isLast: true),
      ],
    );
  }

  Widget _buildTrackingNode(String label, IconData icon, bool isReached, bool isPassed, {bool isFirst = false, bool isLast = false}) {
    Color activeColor = const Color(0xFF00D09C);
    Color inactiveColor = const Color(0xFFE0E0E0);
    Color nodeColor = isReached ? activeColor : inactiveColor;
    
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Container(height: 4, color: isFirst ? Colors.transparent : (isReached ? activeColor : inactiveColor))),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: nodeColor, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              Expanded(child: Container(height: 4, color: isLast ? Colors.transparent : (isPassed ? activeColor : inactiveColor))),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isReached ? FontWeight.bold : FontWeight.normal,
              color: isReached ? AppColors.textDark : AppColors.textLight,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textLight))),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
        ),
      ],
    );
  }
}
