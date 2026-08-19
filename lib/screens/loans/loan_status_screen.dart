import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class LoanStatusScreen extends StatelessWidget {
  final String loanId;
  final String status;
  final String type;
  const LoanStatusScreen({Key? key, required this.loanId, required this.status, required this.type})
      : super(key: key);

  int get _step {
    switch (status) {
      case 'Approved': return 3;
      case 'Cancelled': return 1;
      default: return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Loan Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status strip
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(loanId,
                                    style: const TextStyle(
                                        fontSize: 13, color: AppColors.textGrey)),
                                const SizedBox(height: 2),
                                Text(type,
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.w700,
                                        color: AppColors.textDark)),
                              ],
                            ),
                            _StatusBadge(status: status),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _StepTracker(currentStep: _step),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Amount card
                  Row(
                    children: [
                      Expanded(child: _InfoCard(label: 'Sanctioned', value: '₹1,00,000')),
                      const SizedBox(width: 12),
                      Expanded(child: _InfoCard(label: 'Tenure', value: '24 months')),
                      const SizedBox(width: 12),
                      Expanded(child: _InfoCard(label: 'Rate', value: '10.5% p.a.')),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Text('Fee Breakdown',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: const [
                        _FeeRow('Processing Fee', '₹500', false),
                        _FeeRow('Onboarding Fee', '₹500', false),
                        _FeeRow('Agreement Fee', '₹500', false),
                        _FeeRow('GST (18% on fees)', '₹270', false),
                        _FeeRow('Total Interest', '₹11,340', false),
                        _FeeRow('First EMI Date', '7 Aug 2024', true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 16),
                  _SummaryRow('Disbursal Amount', '₹97,730'),
                  const SizedBox(height: 12),
                  _SummaryRow('Total Repayment', '₹1,12,570'),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            child: AppButton(label: 'Setup Auto Debit', onTap: () {}),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});
  Color get _color {
    switch (status) {
      case 'Approved': return AppColors.primary;
      case 'Cancelled': return AppColors.error;
      default: return AppColors.warning;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _color)),
    );
  }
}

class _StepTracker extends StatelessWidget {
  final int currentStep;
  const _StepTracker({required this.currentStep});
  static const _labels = ['Applied', 'In Review', 'Approved', 'Disbursed'];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(_labels.length * 2 - 1, (i) {
            if (i.isOdd) {
              // Line
              final passed = (i ~/ 2) < currentStep;
              return Expanded(child: Container(height: 2,
                  color: passed ? AppColors.primary : AppColors.border));
            } else {
              // Node
              final nodeIdx = i ~/ 2;
              final reached = nodeIdx < currentStep;
              return Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: reached ? AppColors.primary : AppColors.background,
                  border: Border.all(
                      color: reached ? AppColors.primary : AppColors.border,
                      width: 2),
                  shape: BoxShape.circle,
                ),
                child: reached
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                    : null,
              );
            }
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _labels.map((l) => SizedBox(
            width: 64,
            child: Text(l,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
          )).toList(),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label, value;
  const _InfoCard({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        ],
      ),
    );
  }
}

class _FeeRow extends StatelessWidget {
  final String label, value;
  final bool isLast;
  const _FeeRow(this.label, this.value, this.isLast);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(
            bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textGrey)),
          ),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  const _SummaryRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        Text(value, style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
      ],
    );
  }
}
