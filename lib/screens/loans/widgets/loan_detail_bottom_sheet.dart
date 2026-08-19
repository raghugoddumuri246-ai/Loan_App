import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../apply_loan_flow_screen.dart';
import 'loan_card_widget.dart';

class LoanDetailBottomSheet extends StatelessWidget {
  final LoanItemModel loan;

  const LoanDetailBottomSheet({Key? key, required this.loan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.all(28),
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: loan.accentColor.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(loan.icon, color: loan.accentColor, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          loan.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loan.description,
                    style: const TextStyle(fontSize: 14, color: AppColors.textGrey, height: 1.6),
                  ),
                  const SizedBox(height: 20),
                  _Row('Max Eligible Amount', loan.amount),
                  _Row('Interest Rate', loan.rate),
                  _Row('Max Tenure', loan.tenure),
                  _Row('Processing Fee', '1.5% + GST'),
                  _Row('Min. CIBIL Score', '700+'),
                  _Row('Min. Monthly Income', '₹15,000/month'),
                  const Divider(height: 32, color: AppColors.border),
                  const Text(
                    'Documents Required',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 12),
                  ...[
                    'Aadhaar Card / Passport',
                    'PAN Card',
                    'Last 3 months bank statement',
                    'Latest salary slips',
                  ].map(
                    (d) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_rounded, size: 16, color: loan.accentColor),
                          const SizedBox(width: 8),
                          Text(d, style: const TextStyle(fontSize: 14, color: AppColors.textDark)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Apply Now',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ApplyLoanFlowScreen(
                            loanTitle: loan.title,
                            maxAmount: loan.amount,
                            defaultRate: loan.rate,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label, value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textGrey)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          ],
        ),
      );
}
