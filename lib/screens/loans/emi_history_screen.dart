import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class EmiHistoryScreen extends StatefulWidget {
  const EmiHistoryScreen({Key? key}) : super(key: key);

  @override
  _EmiHistoryScreenState createState() => _EmiHistoryScreenState();
}

class _EmiHistoryScreenState extends State<EmiHistoryScreen> {
  String _selectedLoan = 'Personal Loan - APP-10293';
  final List<String> _loans = [
    'Personal Loan - APP-10293',
    'Auto Loan - APP-10142',
    'Home Loan - APP-09921',
    'Education Loan - APP-08812',
    'Medical Loan - APP-07754'
  ];
  
  int _selectedFilter = 1; // 0: Weekly, 1: Monthly, 2: Yearly

  @override
  Widget build(BuildContext context) {
    const Color themeGreen = Color(0xFF00D09C);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Text('EMI Payment History', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.white)),
        ),
        
        // White Body
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF2FBF6),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: Column(
              children: [
                // Dropdown Filter for Loan
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 32.0, bottom: 16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.white, 
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderGrey)
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedLoan,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF00D09C)),
                        items: _loans.map((type) => DropdownMenuItem(
                          value: type, 
                          child: Text(type, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark))
                        )).toList(),
                        onChanged: (value) => setState(() => _selectedLoan = value!),
                      ),
                    ),
                  ),
                ),
                
                // Filters (Weekly, Monthly, Yearly)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(color: themeGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      children: [
                        _buildFilterTab(0, 'Weekly'),
                        _buildFilterTab(1, 'Monthly'),
                        _buildFilterTab(2, 'Yearly'),
                      ],
                    ),
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      children: [
                        // Stats Card with redesigned circular progress
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))
                            ],
                          ),
                          child: Row(
                            children: [
                              // Redesigned Circular Progress Bar
                              SizedBox(
                                height: 120, 
                                width: 120,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const CircularProgressIndicator(
                                      value: 1.0,
                                      backgroundColor: Colors.transparent,
                                      color: Color(0xFFF2FBF6),
                                      strokeWidth: 12,
                                    ),
                                    const CircularProgressIndicator(
                                      value: 0.5,
                                      backgroundColor: Colors.transparent,
                                      color: Color(0xFF00D09C),
                                      strokeWidth: 12,
                                      strokeCap: StrokeCap.round,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text('12/24', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark)),
                                        SizedBox(height: 2),
                                        Text('Paid', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Amount Remaining', style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    const Text('₹5,000.00', style: TextStyle(color: AppColors.textDark, fontSize: 20, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Next EMI', style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                                        const Text('₹450.00', style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Past Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        ),
                        const SizedBox(height: 16),
                        
                        // Dynamic list of transactions based on filter
                        if (_selectedFilter == 1 || _selectedFilter == 2)
                           _buildHistoryItem('EMI Payment', '15 Sept 2026', '-₹450.00', true),
                        if (_selectedFilter == 1 || _selectedFilter == 2)
                           _buildHistoryItem('EMI Payment', '15 Aug 2026', '-₹450.00', true),
                        if (_selectedFilter == 2)
                           _buildHistoryItem('EMI Payment', '15 July 2026', '-₹450.00', true),
                        if (_selectedFilter == 0) 
                           _buildHistoryItem('Late Fee Penalty', '10 Sept 2026', '-₹20.00', false),
                           
                        const SizedBox(height: 40),
                      ],
                    ),
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

  Widget _buildHistoryItem(String title, String date, String amount, bool isSuccess) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
              color: isSuccess ? const Color(0xFF00D09C).withOpacity(0.1) : Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSuccess ? Icons.done_all : Icons.receipt_long,
              color: isSuccess ? const Color(0xFF00D09C) : Colors.orange,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(fontSize: 14, color: AppColors.textLight)),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
        ],
      ),
    );
  }
}
