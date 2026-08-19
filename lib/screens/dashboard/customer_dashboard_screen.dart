import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'home_dashboard_view.dart';
import '../loans/loans_screen.dart';
import '../loans/applied_loans_screen.dart'; 
import '../loans/emi_history_screen.dart'; 
import '../profile/profile_screen.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({Key? key}) : super(key: key);

  @override
  _CustomerDashboardScreenState createState() => _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  int _navIndex = 0;
  
  List<Widget> get _pages => [
    const HomeDashboardView(),
    const LoansScreen(),
    const AppliedLoansScreen(),
    const EmiHistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color themeGreen = Color(0xFF00D09C);
    const Color paleGreen = Color(0xFFF2FBF6);
    
    return Scaffold(
      backgroundColor: themeGreen,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(child: _pages[_navIndex]),
            
            // Floating Creative Bottom Navigation Bar
            Container(
              color: paleGreen,
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 10),
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(0, Icons.home_rounded, 'Home', themeGreen),
                    _buildNavItem(1, Icons.explore_rounded, 'Explore', themeGreen),
                    _buildNavItem(2, Icons.analytics_rounded, 'Loans', themeGreen),
                    _buildNavItem(3, Icons.receipt_long_rounded, 'History', themeGreen),
                    _buildNavItem(4, Icons.person_rounded, 'Profile', themeGreen),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Color themeGreen) {
    bool isSelected = _navIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _navIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 12 : 8, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? themeGreen.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon, 
              color: isSelected ? themeGreen : AppColors.textLight,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: themeGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
