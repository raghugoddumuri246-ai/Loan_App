import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../../utils/loan_state.dart';
import 'widgets/eligibility_step_widget.dart';
import 'widgets/emi_calculator_widget.dart';
import 'widgets/bank_step_widget.dart';
import 'widgets/declaration_step_widget.dart';
import 'widgets/selfie_step_widget.dart';
import 'widgets/review_step_widget.dart';

class ApplyLoanFlowScreen extends StatefulWidget {
  final String loanTitle;
  final String maxAmount;
  final String defaultRate;

  const ApplyLoanFlowScreen({
    Key? key,
    required this.loanTitle,
    required this.maxAmount,
    required this.defaultRate,
  }) : super(key: key);

  @override
  State<ApplyLoanFlowScreen> createState() => _ApplyLoanFlowScreenState();
}

class _ApplyLoanFlowScreenState extends State<ApplyLoanFlowScreen> {
  int _currentStep = 0; // 0..5 (Steps 1..6), 6: Success

  // State across steps
  double _calculatedMaxEligible = 500000;
  double _selectedLoanAmount = 200000;
  int _selectedTenureMonths = 24;
  double _annualInterestRate = 10.5;
  double _monthlyEmi = 9276;
  double _totalRepayment = 222624;
  double _netDisbursement = 196460;

  String _bankName = 'State Bank of India';
  String _accountNumber = '987654321098';
  String _ifscCode = 'SBIN0001234';
  String _bankHolderName = 'Aditi Sharma';
  String _cibilScore = '752';

  @override
  void initState() {
    super.initState();
    double? parsedRate = double.tryParse(widget.defaultRate.replaceAll(RegExp(r'[^0-9.]'), ''));
    if (parsedRate != null && parsedRate > 0) {
      _annualInterestRate = parsedRate;
    }
  }

  void _submitFinalApplication() {
    final generatedId = '#EZ-${Random().nextInt(8999) + 1000}';
    final newLoan = AppliedLoanModel(
      title: widget.loanTitle,
      amount: '₹${_formatAmount(_selectedLoanAmount)}',
      date: 'Today',
      status: 'Applied',
      id: generatedId,
      tenure: '$_selectedTenureMonths months',
      rate: '$_annualInterestRate%',
      emi: '₹${_formatAmount(_monthlyEmi)}',
      bank: _bankName,
      accountNumber: _accountNumber,
    );

    LoanState().addAppliedLoan(newLoan);

    setState(() {
      _currentStep = 6;
    });
  }

  String _formatAmount(double amt) {
    return amt.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?'),
      (Match m) => '${m[1]},',
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Check Eligibility';
      case 1:
        return 'Configure EMI & Term';
      case 2:
        return 'Disbursal Bank Account';
      case 3:
        return 'Declaration & Consent';
      case 4:
        return 'Photo Verification';
      case 5:
        return 'Review Application';
      default:
        return 'Application Status';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _currentStep == 6
            ? null
            : AppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
                scrolledUnderElevation: 0,
                surfaceTintColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textDark),
                  onPressed: () {
                    if (_currentStep > 0) {
                      setState(() => _currentStep--);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                title: Text(
                  _getStepTitle(),
                  style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700, fontSize: 17),
                ),
                centerTitle: true,
                actions: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        'Step ${_currentStep + 1}/6',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  )
                ],
              ),
        body: SafeArea(
          child: Column(
            children: [
              if (_currentStep < 6)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_currentStep + 1) / 6,
                      backgroundColor: AppColors.primary.withOpacity(0.15),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      minHeight: 6,
                    ),
                  ),
                ),
              Expanded(child: _buildCurrentStepContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return EligibilityStepWidget(
          loanTitle: widget.loanTitle,
          onEligibleConfirmed: (maxEligible, reqAmount) {
            setState(() {
              _calculatedMaxEligible = maxEligible;
              _selectedLoanAmount = reqAmount;
              _currentStep = 1;
            });
          },
        );
      case 1:
        return EmiCalculatorWidget(
          maxEligible: _calculatedMaxEligible,
          initialAmount: _selectedLoanAmount,
          annualRate: _annualInterestRate,
          onTermsConfirmed: (amount, tenure, emi, totalRepay, netDisburse) {
            setState(() {
              _selectedLoanAmount = amount;
              _selectedTenureMonths = tenure;
              _monthlyEmi = emi;
              _totalRepayment = totalRepay;
              _netDisbursement = netDisburse;
              _currentStep = 2;
            });
          },
        );
      case 2:
        return BankStepWidget(
          onBankConfirmed: (bankName, accountNumber, ifsc, holderName) {
            setState(() {
              _bankName = bankName;
              _accountNumber = accountNumber;
              _ifscCode = ifsc;
              _bankHolderName = holderName;
              _currentStep = 3;
            });
          },
        );
      case 3:
        return DeclarationStepWidget(
          onDeclarationAccepted: () => setState(() => _currentStep = 4),
        );
      case 4:
        return SelfieStepWidget(
          onSelfieVerified: () => setState(() => _currentStep = 5),
        );
      case 5:
        return ReviewStepWidget(
          loanTitle: widget.loanTitle,
          loanAmount: _selectedLoanAmount,
          tenureMonths: _selectedTenureMonths,
          annualRate: _annualInterestRate,
          monthlyEmi: _monthlyEmi,
          netDisbursement: _netDisbursement,
          totalRepayment: _totalRepayment,
          applicantName: _bankHolderName,
          cibilScore: _cibilScore,
          bankName: _bankName,
          accountNumber: _accountNumber,
          onSubmit: _submitFinalApplication,
        );
      case 6:
        return _buildSuccessStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildSuccessStep() {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 60),
          ),
          const SizedBox(height: 24),
          const Text(
            'Application Submitted!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF6A623).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Status: Waiting for Admin Review',
              style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your application for ${widget.loanTitle} of ₹${_formatAmount(_selectedLoanAmount)} has been placed.\nOur verification team will review your application within 2 hours.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.textGrey, height: 1.5),
          ),
          const Spacer(),
          AppButton(
            label: 'Go to Dashboard',
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
