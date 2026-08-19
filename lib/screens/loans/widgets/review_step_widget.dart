import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class ReviewStepWidget extends StatelessWidget {
  final String loanTitle;
  final double loanAmount;
  final int tenureMonths;
  final double annualRate;
  final double monthlyEmi;
  final double netDisbursement;
  final double totalRepayment;
  final String applicantName;
  final String cibilScore;
  final String bankName;
  final String accountNumber;
  final VoidCallback onSubmit;

  const ReviewStepWidget({
    Key? key,
    required this.loanTitle,
    required this.loanAmount,
    required this.tenureMonths,
    required this.annualRate,
    required this.monthlyEmi,
    required this.netDisbursement,
    required this.totalRepayment,
    required this.applicantName,
    required this.cibilScore,
    required this.bankName,
    required this.accountNumber,
    required this.onSubmit,
  }) : super(key: key);

  String _formatAmount(double amt) {
    return amt.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Review Loan Application', style: AppTextStyles.heading),
          const SizedBox(height: 6),
          const Text('Confirm all loan and disbursal details before final submission.', style: AppTextStyles.subheading),
          const SizedBox(height: 24),

          // Loan Amount & Tenure Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        loanTitle,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                      child: const Text('Pre-Approved', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ],
                ),
                const Divider(height: 24, color: AppColors.border),
                _buildReviewRow('Sanction Amount', '₹${_formatAmount(loanAmount)}'),
                _buildReviewRow('Tenure', '$tenureMonths Months'),
                _buildReviewRow('Interest Rate', '$annualRate% p.a.'),
                _buildReviewRow('Monthly EMI', '₹${_formatAmount(monthlyEmi)} / mo', isHighlight: true),
                _buildReviewRow('Net Disbursal', '₹${_formatAmount(netDisbursement)}'),
                _buildReviewRow('Total Repayment', '₹${_formatAmount(totalRepayment)}'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Applicant & Disbursal Bank Summary
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Disbursal & Verification Info', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                const SizedBox(height: 12),
                _buildReviewRow('Applicant Name', applicantName),
                _buildReviewRow('Credit Score', '$cibilScore (Verified)'),
                _buildReviewRow('Crediting Bank', bankName),
                _buildReviewRow('Account Number', accountNumber),
                _buildReviewRow('Selfie Liveness', 'Verified (Match 99.8%)'),
              ],
            ),
          ),

          const SizedBox(height: 28),
          AppButton(
            label: 'Submit Loan Application',
            onTap: onSubmit,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textGrey)),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isHighlight ? AppColors.primary : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
