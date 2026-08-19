import 'package:flutter/material.dart';

class AppliedLoanModel {
  final String title;
  final String amount;
  final String date;
  final String status;
  final String id;
  final String tenure;
  final String rate;
  final String emi;
  final String bank;
  final String accountNumber;

  AppliedLoanModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
    required this.id,
    required this.tenure,
    required this.rate,
    required this.emi,
    this.bank = 'State Bank of India',
    this.accountNumber = '•••• •••• 1234',
  });
}

class RecentActivityModel {
  final IconData icon;
  final Color color;
  final String title;
  final String sub;
  final String amount;

  RecentActivityModel({
    required this.icon,
    required this.color,
    required this.title,
    required this.sub,
    required this.amount,
  });
}

class LoanState extends ChangeNotifier {
  static final LoanState _instance = LoanState._internal();
  factory LoanState() => _instance;
  LoanState._internal();

  final List<AppliedLoanModel> _appliedLoans = [
    AppliedLoanModel(
      title: 'Personal Loan',
      amount: '₹1,00,000',
      date: '12 Mar 2024',
      status: 'Applied',
      id: '#EZ-7821',
      tenure: '24 months',
      rate: '10.5%',
      emi: '₹4,638',
    ),
    AppliedLoanModel(
      title: 'Auto Loan',
      amount: '₹4,50,000',
      date: '5 Feb 2024',
      status: 'Approved',
      id: '#EZ-7654',
      tenure: '60 months',
      rate: '8.0%',
      emi: '₹9,124',
    ),
    AppliedLoanModel(
      title: 'Home Loan',
      amount: '₹22,00,000',
      date: '10 Jan 2024',
      status: 'Cancelled',
      id: '#EZ-7412',
      tenure: '20 years',
      rate: '7.5%',
      emi: '₹17,720',
    ),
    AppliedLoanModel(
      title: 'Education Loan',
      amount: '₹8,00,000',
      date: '2 Nov 2023',
      status: 'Applied',
      id: '#EZ-7189',
      tenure: '84 months',
      rate: '9.0%',
      emi: '₹12,890',
    ),
    AppliedLoanModel(
      title: 'Medical Loan',
      amount: '₹75,000',
      date: '15 Oct 2023',
      status: 'Approved',
      id: '#EZ-7001',
      tenure: '18 months',
      rate: '11.0%',
      emi: '₹4,538',
    ),
  ];

  final List<RecentActivityModel> _activities = [
    RecentActivityModel(
      icon: Icons.check_circle_outline_rounded,
      color: const Color(0xFF00C48C),
      title: 'EMI Paid',
      sub: '12 Jul',
      amount: '-₹7,200',
    ),
    RecentActivityModel(
      icon: Icons.arrow_circle_up_outlined,
      color: const Color(0xFF3D8EF0),
      title: 'Loan Disbursed',
      sub: '2 Jul',
      amount: '+₹85,000',
    ),
    RecentActivityModel(
      icon: Icons.schedule_rounded,
      color: const Color(0xFFF6A623),
      title: 'EMI Due',
      sub: '14 Aug',
      amount: '₹3,500',
    ),
  ];

  List<AppliedLoanModel> get appliedLoans => List.unmodifiable(_appliedLoans);
  List<RecentActivityModel> get activities => List.unmodifiable(_activities);

  void addAppliedLoan(AppliedLoanModel loan) {
    _appliedLoans.insert(0, loan);
    _activities.insert(
      0,
      RecentActivityModel(
        icon: Icons.hourglass_top_rounded,
        color: const Color(0xFFF6A623),
        title: '${loan.title} Applied',
        sub: 'Today (Under Review)',
        amount: loan.amount,
      ),
    );
    notifyListeners();
  }
}
