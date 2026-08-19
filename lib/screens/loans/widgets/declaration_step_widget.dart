import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class DeclarationStepWidget extends StatefulWidget {
  final VoidCallback onDeclarationAccepted;

  const DeclarationStepWidget({
    Key? key,
    required this.onDeclarationAccepted,
  }) : super(key: key);

  @override
  State<DeclarationStepWidget> createState() => _DeclarationStepWidgetState();
}

class _DeclarationStepWidgetState extends State<DeclarationStepWidget> {
  bool _declarationAccepted = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Declaration & Terms', style: AppTextStyles.heading),
          const SizedBox(height: 6),
          const Text('Please review and agree to the statutory lending declarations.', style: AppTextStyles.subheading),
          const SizedBox(height: 24),

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
                const Text('Customer Undertakings', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark)),
                const SizedBox(height: 14),
                _buildDeclarationBullet('All information, financial figures, and identity credentials submitted are true and verifiable.'),
                _buildDeclarationBullet('I hereby grant consent to EZFINANZ to fetch and check my credit bureau records (CIBIL / Experian).'),
                _buildDeclarationBullet('I authorize auto-debit (e-NACH) of monthly EMI from my registered bank account on the scheduled due date.'),
                _buildDeclarationBullet('I agree to the applicable interest rates, charges, and standard repayment policies as outlined.'),
                _buildDeclarationBullet('I understand that intentional misrepresentation may lead to immediate cancellation and legal consequences.'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Interactive Checkbox Box
          GestureDetector(
            onTap: () => setState(() => _declarationAccepted = !_declarationAccepted),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _declarationAccepted ? AppColors.primary.withOpacity(0.08) : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _declarationAccepted ? AppColors.primary : AppColors.border),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: _declarationAccepted,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (v) => setState(() => _declarationAccepted = v ?? false),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'I have read, understood, and accept all the declaration terms & consent for verification.',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),
          AppButton(
            label: 'Continue to Photo Verification',
            onTap: _declarationAccepted ? widget.onDeclarationAccepted : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDeclarationBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
