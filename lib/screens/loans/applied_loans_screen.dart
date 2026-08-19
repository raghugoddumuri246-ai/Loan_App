import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'loan_status_screen.dart';

class AppliedLoansScreen extends StatefulWidget {
  const AppliedLoansScreen({Key? key}) : super(key: key);

  @override
  _AppliedLoansScreenState createState() => _AppliedLoansScreenState();
}

class _AppliedLoansScreenState extends State<AppliedLoansScreen> {
  int _selectedFilter = 0; // 0: Applied, 1: Approved, 2: Cancelled

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Text('My Loans', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.white)),
        ),
        
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF2FBF6),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: Column(
              children: [
                // Filters
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(color: const Color(0xFF00D09C).withOpacity(0.1), borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      children: [
                        _buildFilterTab(0, 'Applied'),
                        _buildFilterTab(1, 'Approved'),
                        _buildFilterTab(2, 'Cancelled'),
                      ],
                    ),
                  ),
                ),
                
                // List View
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    children: [
                      if (_selectedFilter == 0 || _selectedFilter == 1)
                        _buildAppliedLoanCard(context, 'APP-10293', 'Personal Loan', '₹10,000', '15 Oct 2026', 'Processing', Icons.person),
                      if (_selectedFilter == 0 || _selectedFilter == 1)
                        _buildAppliedLoanCard(context, 'APP-10142', 'Auto Loan', '₹25,000', '01 Sept 2026', 'Approved', Icons.directions_car),
                      if (_selectedFilter == 0 || _selectedFilter == 2)
                        _buildAppliedLoanCard(context, 'APP-09921', 'Home Loan', '₹150,000', '12 Aug 2026', 'Cancelled', Icons.home),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTab(int index, String title) {
    bool isSelected = _selectedFilter == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00D09C) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.textDark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppliedLoanCard(BuildContext context, String id, String type, String amount, String date, String status, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoanStatusScreen(loanId: id, status: status, type: type)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderGrey)
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00D09C).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF00D09C)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  Text('ID: $id | $date', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: status == 'Cancelled' ? Colors.red : const Color(0xFF00D09C))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
