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

/// Central State Manager for Applied Loans and Real-Time Activities.
/// Starts completely clean and receives live data when a user applies or syncs with the database.
class LoanState extends ChangeNotifier {
  static final LoanState _instance = LoanState._internal();
  factory LoanState() => _instance;
  LoanState._internal();

  final List<AppliedLoanModel> _appliedLoans = [];
  final List<RecentActivityModel> _activities = [];

  List<AppliedLoanModel> get appliedLoans => List.unmodifiable(_appliedLoans);
  List<RecentActivityModel> get activities => List.unmodifiable(_activities);

  /// Adds a newly applied loan and creates a corresponding recent activity item.
  void addAppliedLoan(AppliedLoanModel loan) {
    _appliedLoans.insert(0, loan);

    // Create real activity entry for the dashboard
    _activities.insert(
      0,
      RecentActivityModel(
        icon: Icons.schedule_rounded,
        color: const Color(0xFFD97706),
        title: '${loan.title} Applied',
        sub: 'Today · ${loan.id}',
        amount: loan.amount,
      ),
    );

    notifyListeners();
  }

  /// Updates loan status (e.g. When approved by admin)
  void updateLoanStatus(String loanId, String newStatus) {
    final idx = _appliedLoans.indexWhere((l) => l.id == loanId);
    if (idx != -1) {
      final old = _appliedLoans[idx];
      _appliedLoans[idx] = AppliedLoanModel(
        title: old.title,
        amount: old.amount,
        date: old.date,
        status: newStatus,
        id: old.id,
        tenure: old.tenure,
        rate: old.rate,
        emi: old.emi,
        bank: old.bank,
        accountNumber: old.accountNumber,
      );

      _activities.insert(
        0,
        RecentActivityModel(
          icon: Icons.verified_rounded,
          color: const Color(0xFF00C48C),
          title: '${old.title} $newStatus',
          sub: 'Today',
          amount: old.amount,
        ),
      );

      notifyListeners();
    }
  }

  /// Clears all loans (e.g. On user logout)
  void clear() {
    _appliedLoans.clear();
    _activities.clear();
    notifyListeners();
  }
}
