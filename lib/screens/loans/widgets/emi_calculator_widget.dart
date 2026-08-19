import 'dart:math';
import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class EmiCalculatorWidget extends StatefulWidget {
  final double maxEligible;
  final double initialAmount;
  final double annualRate;
  final Function(double amount, int tenure, double emi, double totalRepay, double netDisburse) onTermsConfirmed;

  const EmiCalculatorWidget({
    Key? key,
    required this.maxEligible,
    required this.initialAmount,
    required this.annualRate,
    required this.onTermsConfirmed,
  }) : super(key: key);

  @override
  State<EmiCalculatorWidget> createState() => _EmiCalculatorWidgetState();
}

class _EmiCalculatorWidgetState extends State<EmiCalculatorWidget> {
  late double _selectedLoanAmount;
  int _selectedTenureMonths = 24;
  final List<int> _tenureOptions = [6, 12, 18, 24, 36, 48, 60];

  @override
  void initState() {
    super.initState();
    _selectedLoanAmount = min(widget.initialAmount, widget.maxEligible > 25000 ? widget.maxEligible : 500000);
    if (_selectedLoanAmount < 25000) _selectedLoanAmount = 25000;
  }

  double get _monthlyEmi {
    double r = (widget.annualRate / 12) / 100;
    int n = _selectedTenureMonths;
    double p = _selectedLoanAmount;
    if (r == 0) return p / n;
    return (p * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);
  }

  double get _totalRepayment => _monthlyEmi * _selectedTenureMonths;
  double get _totalInterest => _totalRepayment - _selectedLoanAmount;
  double get _processingFee => _selectedLoanAmount * 0.015; // 1.5%
  double get _gstOnFee => _processingFee * 0.18; // 18% GST
  double get _totalCharges => _processingFee + _gstOnFee;
  double get _netDisbursement => _selectedLoanAmount - _totalCharges;

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
          const Text('Customise your repayment', style: AppTextStyles.heading),
          const SizedBox(height: 6),
          const Text('Choose your required amount & comfortable tenure.', style: AppTextStyles.subheading),
          const SizedBox(height: 24),

          // Loan Amount Slider Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Required Amount', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
                    Text(
                      '₹${_formatAmount(_selectedLoanAmount)}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.primary.withOpacity(0.15),
                    thumbColor: AppColors.primary,
                    overlayColor: AppColors.primary.withOpacity(0.15),
                    trackHeight: 6,
                  ),
                  child: Slider(
                    value: _selectedLoanAmount,
                    min: 25000,
                    max: widget.maxEligible > 25000 ? widget.maxEligible : 500000,
                    divisions: 100,
                    onChanged: (val) {
                      setState(() {
                        _selectedLoanAmount = (val / 5000).round() * 5000;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Min: ₹25,000', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                    Text('Max: ₹${_formatAmount(widget.maxEligible)}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tenure Pills
          const Text('Select Repayment Tenure (Months)', style: AppTextStyles.label),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _tenureOptions.map((months) {
                final isSel = _selectedTenureMonths == months;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTenureMonths = months),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isSel ? AppColors.primary : AppColors.border),
                    ),
                    child: Text(
                      '$months Months',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: isSel ? Colors.white : AppColors.textDark,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Dynamic EMI Breakdown Box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text('Estimated Monthly EMI', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
                    ),
                    const SizedBox(width: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '₹${_formatAmount(_monthlyEmi)} / mo',
                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24, color: AppColors.border),
                _buildCalcRow('Interest Rate (p.a.)', '${widget.annualRate}% p.a.'),
                _buildCalcRow('Total Interest Payable', '₹${_formatAmount(_totalInterest)}'),
                _buildCalcRow('Processing Fee (1.5%)', '₹${_formatAmount(_processingFee)}'),
                _buildCalcRow('GST on Processing Fee (18%)', '₹${_formatAmount(_gstOnFee)}'),
                _buildCalcRow('Net Disbursal to Bank', '₹${_formatAmount(_netDisbursement)}', isHighlight: true),
                _buildCalcRow('Total Repayment Amount', '₹${_formatAmount(_totalRepayment)}'),
              ],
            ),
          ),
          const SizedBox(height: 28),
          AppButton(
            label: 'Confirm Terms & Continue',
            onTap: () {
              widget.onTermsConfirmed(_selectedLoanAmount, _selectedTenureMonths, _monthlyEmi, _totalRepayment, _netDisbursement);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalcRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isHighlight ? AppColors.textDark : AppColors.textGrey,
                fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
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
