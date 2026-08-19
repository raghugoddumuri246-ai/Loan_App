import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Text('EMI Payment History', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.white)),
        ),
        
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF2FBF6),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              children: [
                _buildHistoryItem('Personal Loan EMI', '15 Sept 2026', '-\$450.00', true),
                _buildHistoryItem('Personal Loan EMI', '15 Aug 2026', '-\$450.00', true),
                _buildHistoryItem('Personal Loan EMI', '15 July 2026', '-\$450.00', true),
                _buildHistoryItem('Personal Loan EMI', '15 June 2026', '-\$450.00', true),
                _buildHistoryItem('Personal Loan EMI', '15 May 2026', '-\$450.00', true),
                _buildHistoryItem('Personal Loan EMI', '15 April 2026', '-\$450.00', true),
                _buildHistoryItem('Processing Fee', '01 April 2026', '-\$200.00', false),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String date, String amount, bool isSuccess) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey)
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSuccess ? const Color(0xFF00D09C).withOpacity(0.1) : Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSuccess ? Icons.done_all : Icons.receipt_long,
              color: isSuccess ? const Color(0xFF00D09C) : Colors.orange,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(fontSize: 14, color: AppColors.textLight)),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
        ],
      ),
    );
  }
}
