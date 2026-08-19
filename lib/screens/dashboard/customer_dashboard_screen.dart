import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import 'home_dashboard_view.dart';
import '../loans/loans_screen.dart';
import '../loans/applied_loans_screen.dart';
import '../loans/emi_history_screen.dart';
import '../profile/profile_screen.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({Key? key}) : super(key: key);
  @override
  State<CustomerDashboardScreen> createState() => _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  int _idx = 0;

  List<Widget> get _pages => [
    HomeDashboardView(
      onNavigateToLoans: () => setState(() => _idx = 1),
      onNavigateToHistory: () => setState(() => _idx = 3),
    ),
    const LoansScreen(),
    const AppliedLoansScreen(),
    const EmiHistoryScreen(),
    const ProfileScreen(),
  ];

  static const _navItems = [
    _NavItem(icon: Icons.home_outlined,    activeIcon: Icons.home_rounded,    label: 'Home'),
    _NavItem(icon: Icons.explore_outlined, activeIcon: Icons.explore_rounded,  label: 'Loans'),
    _NavItem(icon: Icons.receipt_outlined, activeIcon: Icons.receipt_rounded,  label: 'Applied'),
    _NavItem(icon: Icons.history_outlined, activeIcon: Icons.history_rounded,  label: 'History'),
    _NavItem(icon: Icons.person_outline,   activeIcon: Icons.person_rounded,   label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Main content (full screen, bottom padding for nav) ──
          Positioned.fill(
            child: _pages[_idx],
          ),

          // ── Floating Bottom Nav ────────────────────────────────
          Positioned(
            left: 20, right: 20, bottom: 24,
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(34),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.15),
                    blurRadius: 24, spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12, offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_navItems.length, (i) {
                  final sel = _idx == i;
                  return GestureDetector(
                    onTap: () => setState(() => _idx = i),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(
                          horizontal: sel ? 14 : 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppColors.primary.withOpacity(0.10)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            sel ? _navItems[i].activeIcon : _navItems[i].icon,
                            color: sel ? AppColors.primary : const Color(0xFFB0BAC9),
                            size: 22,
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 250),
                            child: sel
                                ? Row(children: [
                                    const SizedBox(width: 6),
                                    Text(_navItems[i].label,
                                        style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13)),
                                  ])
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon, activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}
