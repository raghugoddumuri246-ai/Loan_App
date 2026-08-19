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
  // Clean, empty text controllers (user enters their real values)
  final _monthlyIncomeCtrl = TextEditingController();
  final _reqAmountCtrl = TextEditingController();
  final _cibilScoreCtrl = TextEditingController();
  final _currentDebtsCtrl = TextEditingController();
  final _employerCtrl = TextEditingController();
  final _designationCtrl = TextEditingController();

  bool _isEligible = true;
  String _eligibilityMessage = 'Enter your financial details to calculate loan limit.';
  double _calculatedMaxEligible = 500000;
  double _dtiRatio = 0.0;

  double get _loanTypeCeiling {
    final title = widget.loanTitle.toLowerCase();
    if (title.contains('home')) return 7500000;
    if (title.contains('education')) return 2000000;
    if (title.contains('auto') || title.contains('car')) return 1500000;
    if (title.contains('business')) return 2500000;
    if (title.contains('medical')) return 500000;
    return 500000; // Personal Loan
  }

  @override
  void initState() {
    super.initState();
    _calculatedMaxEligible = _loanTypeCeiling;
    _evaluateEligibility();
  }

  void _evaluateEligibility() {
    double income = double.tryParse(_monthlyIncomeCtrl.text.replaceAll(',', '')) ?? 0;
    double debts = double.tryParse(_currentDebtsCtrl.text.replaceAll(',', '')) ?? 0;
    int cibil = int.tryParse(_cibilScoreCtrl.text) ?? 740;
    double reqAmount = double.tryParse(_reqAmountCtrl.text.replaceAll(',', '')) ?? 0;

    double dti = income > 0 ? (debts / income) : 0.0;

    setState(() {
      _dtiRatio = dti;

      if (income == 0) {
        _isEligible = true;
        _calculatedMaxEligible = _loanTypeCeiling;
        _eligibilityMessage = 'Estimated maximum limit up to ₹${_formatAmount(_loanTypeCeiling)} for ${widget.loanTitle}.';
        return;
      }

      if (cibil >= 700 && dti <= 0.55) {
        _isEligible = true;
        _calculatedMaxEligible = min(income * 10, _loanTypeCeiling);
        _eligibilityMessage = 'Pre-Approved! Eligible for instant disbursal up to ₹${_formatAmount(_calculatedMaxEligible)} with prime rates.';
      } else if (cibil >= 620 && dti <= 0.7) {
        _isEligible = true;
        _calculatedMaxEligible = min(income * 6, _loanTypeCeiling * 0.6);
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

          // Real-time Health Metrics Card (Exact Brand Primary Green Gradient)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00C48C), Color(0xFF00966C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00C48C).withOpacity(0.35),
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
                            color: Colors.white.withOpacity(0.2),
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
                      _dtiRatio > 0 ? '${(_dtiRatio * 100).toStringAsFixed(1)}% (Healthy < 50%)' : '0.0% (Enter Income)',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _dtiRatio > 0 ? _dtiRatio.clamp(0.0, 1.0) : 0.05,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _dtiRatio <= 0.4 ? Colors.white : const Color(0xFFFBBF24),
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
                  hint: 'e.g. 65000',
                  controller: _monthlyIncomeCtrl,
                  keyboardType: TextInputType.number,
                  prefix: const Icon(Icons.currency_rupee_rounded, size: 18, color: AppColors.primary),
                  onChanged: (_) => _evaluateEligibility(),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Requested Loan Amount (₹)',
                  hint: 'e.g. 200000',
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
                        hint: 'e.g. 750',
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
                        hint: 'e.g. 10000',
                        controller: _currentDebtsCtrl,
                        keyboardType: TextInputType.number,
                        prefix: const Icon(Icons.receipt_long_outlined, size: 18, color: AppColors.primary),
                        onChanged: (_) => _evaluateEligibility(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Employer / Company Name',
                  hint: 'e.g. TechCorp Solutions Pvt Ltd',
                  controller: _employerCtrl,
                  prefix: const Icon(Icons.business_outlined, size: 18, color: AppColors.primary),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Designation / Role',
                  hint: 'e.g. Senior Software Engineer',
                  controller: _designationCtrl,
                  prefix: const Icon(Icons.badge_outlined, size: 18, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Status & Next Action Button
          AppButton(
            label: 'Check Eligibility & Continue',
            onTap: () {
              double income = double.tryParse(_monthlyIncomeCtrl.text.replaceAll(',', '')) ?? 50000;
              double req = double.tryParse(_reqAmountCtrl.text.replaceAll(',', '')) ?? (_calculatedMaxEligible > 0 ? _calculatedMaxEligible * 0.6 : 100000);
              widget.onEligibleConfirmed(_calculatedMaxEligible, req);
            },
          ),
        ],
      ),
    );
  }
}
