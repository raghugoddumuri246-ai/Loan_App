import 'dart:math';
import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class EligibilityStepWidget extends StatefulWidget {
  final String loanTitle;
  final Function(double maxEligible, double reqAmount) onEligibleConfirmed;

  const EligibilityStepWidget({
    Key? key,
    required this.loanTitle,
    required this.onEligibleConfirmed,
  }) : super(key: key);

  @override
  State<EligibilityStepWidget> createState() => _EligibilityStepWidgetState();
}

class _EligibilityStepWidgetState extends State<EligibilityStepWidget> {
  final _monthlyIncomeCtrl = TextEditingController(text: '65000');
  final _reqAmountCtrl = TextEditingController(text: '200000');
  final _cibilScoreCtrl = TextEditingController(text: '752');
  final _currentDebtsCtrl = TextEditingController(text: '12000');
  final _employerCtrl = TextEditingController(text: 'TechCorp Solutions Pvt Ltd');
  final _designationCtrl = TextEditingController(text: 'Senior Software Engineer');

  bool _isEligible = true;
  String _eligibilityMessage = 'Pre-Approved! You qualify for loans up to ₹5,00,000.';
  double _calculatedMaxEligible = 500000;
  double _dtiRatio = 0.18;

  @override
  void initState() {
    super.initState();
    _evaluateEligibility();
  }

  void _evaluateEligibility() {
    double income = double.tryParse(_monthlyIncomeCtrl.text.replaceAll(',', '')) ?? 50000;
    double debts = double.tryParse(_currentDebtsCtrl.text.replaceAll(',', '')) ?? 0;
    int cibil = int.tryParse(_cibilScoreCtrl.text) ?? 720;
    double reqAmount = double.tryParse(_reqAmountCtrl.text.replaceAll(',', '')) ?? 200000;

    double dti = income > 0 ? (debts / income) : 0.2;

    setState(() {
      _dtiRatio = dti;
      if (cibil >= 700 && dti <= 0.55) {
        _isEligible = true;
        _calculatedMaxEligible = min(income * 10, 1000000);
        _eligibilityMessage = 'Pre-Approved! Eligible for instant disbursal up to ₹${_formatAmount(_calculatedMaxEligible)} with prime rates.';
      } else if (cibil >= 620 && dti <= 0.7) {
        _isEligible = true;
        _calculatedMaxEligible = min(income * 6, 400000);
        _eligibilityMessage = 'Eligible for loan approval up to ₹${_formatAmount(_calculatedMaxEligible)}.';
      } else {
        _isEligible = false;
        _calculatedMaxEligible = 0;
        _eligibilityMessage = 'High Debt-to-Income or credit score requirements not met for instant approval.';
      }
    });
  }

  String _formatAmount(double amt) {
    return amt.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  void dispose() {
    _monthlyIncomeCtrl.dispose();
    _reqAmountCtrl.dispose();
    _cibilScoreCtrl.dispose();
    _currentDebtsCtrl.dispose();
    _employerCtrl.dispose();
    _designationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Intro
          const Text('Check Loan Eligibility', style: AppTextStyles.heading),
          const SizedBox(height: 4),
          Text(
            'Real-time automated credit underwriting for ${widget.loanTitle}.',
            style: AppTextStyles.subheading,
          ),
          const SizedBox(height: 20),

          // Real-time Health Metrics Card (Theme Green)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF044E38), Color(0xFF0D684E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF044E38).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Estimated Max Limit', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Text(
                              _isEligible ? '₹${_formatAmount(_calculatedMaxEligible)}' : 'Under Review',
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Text(
                        _isEligible ? 'INSTANT APPROVAL' : 'VERIFYING',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 12),

                // DTI Ratio progress bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Debt-to-Income (DTI)', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    Text(
                      '${(_dtiRatio * 100).toStringAsFixed(1)}% (Healthy < 50%)',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _dtiRatio.clamp(0.0, 1.0),
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _dtiRatio <= 0.4 ? const Color(0xFF34D399) : const Color(0xFFFBBF24),
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Form Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Financial & Employment Details',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textDark),
                ),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Monthly Net Take-Home Salary (₹)',
                  hint: '65,000',
                  controller: _monthlyIncomeCtrl,
                  keyboardType: TextInputType.number,
                  prefix: const Icon(Icons.currency_rupee_rounded, size: 18, color: AppColors.primary),
                  onChanged: (_) => _evaluateEligibility(),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Requested Loan Amount (₹)',
                  hint: '2,00,000',
                  controller: _reqAmountCtrl,
                  keyboardType: TextInputType.number,
                  prefix: const Icon(Icons.account_balance_wallet_outlined, size: 18, color: AppColors.primary),
                  onChanged: (_) => _evaluateEligibility(),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'CIBIL Credit Score',
                        hint: '752',
                        controller: _cibilScoreCtrl,
                        keyboardType: TextInputType.number,
                        prefix: const Icon(Icons.speed_rounded, size: 18, color: AppColors.primary),
                        onChanged: (_) => _evaluateEligibility(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextField(
                        label: 'Existing EMIs (₹)',
                        hint: '12,000',
                        controller: _currentDebtsCtrl,
                        keyboardType: TextInputType.number,
                        prefix: const Icon(Icons.receipt_outlined, size: 18, color: AppColors.primary),
                        onChanged: (_) => _evaluateEligibility(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Employer / Company Name',
                  hint: 'TechCorp Solutions Pvt Ltd',
                  controller: _employerCtrl,
                  prefix: const Icon(Icons.business_rounded, size: 18, color: AppColors.primary),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Current Designation',
                  hint: 'Senior Software Engineer',
                  controller: _designationCtrl,
                  prefix: const Icon(Icons.badge_outlined, size: 18, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Real-time Result Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isEligible ? AppColors.primary.withOpacity(0.08) : AppColors.error.withOpacity(0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _isEligible ? AppColors.primary.withOpacity(0.3) : AppColors.error.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isEligible ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                  color: _isEligible ? AppColors.primary : AppColors.error,
                  size: 26,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _eligibilityMessage,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _isEligible ? AppColors.textDark : AppColors.error,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),
          AppButton(
            label: 'Continue to Repayment Terms',
            onTap: _isEligible
                ? () {
                    double reqAmount = double.tryParse(_reqAmountCtrl.text.replaceAll(',', '')) ?? 200000;
                    widget.onEligibleConfirmed(_calculatedMaxEligible, reqAmount);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
