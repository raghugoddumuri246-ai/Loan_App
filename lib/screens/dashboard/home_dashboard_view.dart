import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../../utils/loan_state.dart';
import '../../utils/user_state.dart';
import '../dashboard/notification_screen.dart';
import '../loans/widgets/popular_loans_carousel.dart';
import '../loans/apply_loan_flow_screen.dart';

class HomeDashboardView extends StatelessWidget {
  final VoidCallback? onNavigateToLoans;
  final VoidCallback? onNavigateToHistory;

  const HomeDashboardView({
    Key? key,
    this.onNavigateToLoans,
    this.onNavigateToHistory,
  }) : super(key: key);

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: ListenableBuilder(
        listenable: UserProfileState(),
        builder: (context, _) {
          final user = UserProfileState();
          final firstName = user.fullName.isNotEmpty ? user.fullName.trim().split(' ').first : 'User';

          return Scaffold(
            backgroundColor: AppColors.background,
            body: Column(
              children: [
                // ── Green Header: encompasses greeting AND full credit score card ──
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x2500C48C),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Status bar top spacer
                      SizedBox(height: MediaQuery.of(context).padding.top + 8),

                      // Greeting row
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _greeting(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.85),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Hi, $firstName 👋',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const NotificationScreen()),
                          ),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Full Credit Score Card nested INSIDE the green header ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 18,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Gauge
                          SizedBox(
                            width: 90,
                            height: 90,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: CircularProgressIndicator(
                                    value: 1,
                                    strokeWidth: 7,
                                    color: AppColors.primary.withOpacity(0.12),
                                  ),
                                ),
                                const SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: CircularProgressIndicator(
                                    value: 0.74,
                                    strokeWidth: 7,
                                    color: AppColors.primary,
                                    strokeCap: StrokeCap.round,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      '742',
                                      style: TextStyle(
                                        color: AppColors.textDark,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      'Excellent',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Credit Score',
                                      style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text('Top 5%', style: TextStyle(color: AppColors.primary, fontSize: 9, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Eligible Amount',
                                  style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  '₹2,50,000',
                                  style: TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(child: _Seg(filled: true)),
                                    const SizedBox(width: 4),
                                    Expanded(child: _Seg(filled: true)),
                                    const SizedBox(width: 4),
                                    Expanded(child: _Seg(filled: false)),
                                    const SizedBox(width: 4),
                                    Expanded(child: _Seg(filled: false)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable Body with 100px bottom padding for floating bar ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dynamic Active Loan / Application Status Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Builder(
                        builder: (context) {
                          final appliedLoans = LoanState().appliedLoans;

                          if (appliedLoans.isEmpty) {
                            // No Loans Yet: Show Pre-Approved Loan Offer
                            return Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary.withOpacity(0.12),
                                    AppColors.primary.withOpacity(0.04),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: AppColors.primary.withOpacity(0.35)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.stars_rounded, color: AppColors.primary, size: 26),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text('Pre-Approved Offer', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 12)),
                                        SizedBox(height: 2),
                                        Text('Up to ₹5,00,000 Available', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.textDark)),
                                        SizedBox(height: 2),
                                        Text('Instant paperless disbursal at 10.5% p.a.', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: onNavigateToLoans ??
                                        () => Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => const ApplyLoanFlowScreen(
                                                  loanTitle: 'Personal Loan',
                                                  maxAmount: '5,00,000',
                                                  defaultRate: '10.5%',
                                                ),
                                              ),
                                            ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text('Apply', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          // Real user loan card
                          final latestLoan = appliedLoans.first;
                          final isReview = latestLoan.status.toLowerCase().contains('review') || latestLoan.status.toLowerCase().contains('applied');

                          return Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: AppColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            latestLoan.title,
                                            style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            latestLoan.amount,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w900,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isReview
                                            ? const Color(0xFFF59E0B).withOpacity(0.12)
                                            : AppColors.primary.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isReview ? Icons.hourglass_top_rounded : Icons.check_circle_rounded,
                                            size: 13,
                                            color: isReview ? const Color(0xFFD97706) : AppColors.primary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            latestLoan.status,
                                            style: TextStyle(
                                              color: isReview ? const Color(0xFFD97706) : AppColors.primary,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Divider(color: AppColors.border, height: 1),
                                const SizedBox(height: 12),

                                // Action Strip
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            isReview ? Icons.schedule_rounded : Icons.event_rounded,
                                            size: 16,
                                            color: isReview ? const Color(0xFFD97706) : AppColors.primary,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              isReview
                                                  ? 'Underwriting review in progress'
                                                  : 'Next EMI: ${latestLoan.emi}',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: onNavigateToHistory,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: isReview ? const Color(0xFF0F172A) : AppColors.primary,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          isReview ? 'View Status' : 'Pay Now',
                                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Quick Actions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text(
                        'Quick Actions',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: _ActionTile(
                              icon: Icons.add_circle_outline_rounded,
                              label: 'New Loan',
                              onTap: onNavigateToLoans,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ActionTile(
                              icon: Icons.sync_alt_rounded,
                              label: 'Repay EMI',
                              onTap: onNavigateToHistory,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ActionTile(
                              icon: Icons.receipt_long_rounded,
                              label: 'Statement',
                              onTap: onNavigateToHistory,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Featured Popular Loans Carousel ──
                    PopularLoansCarousel(
                      onApply: (title, amount, rate) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ApplyLoanFlowScreen(
                              loanTitle: title,
                              maxAmount: amount,
                              defaultRate: rate,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Recent Activity Title with View All Link
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Activity',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark),
                          ),
                          GestureDetector(
                            onTap: onNavigateToHistory,
                            child: const Text(
                              'View All',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Dynamic Recent Activity from LoanState
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListenableBuilder(
                        listenable: LoanState(),
                        builder: (context, _) {
                          final activities = LoanState().activities;

                          if (activities.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.notifications_none_rounded, color: AppColors.primary, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'No recent activity. Actions and applications will appear here.',
                                      style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Column(
                            children: activities.map((act) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _ActivityRow(
                                  icon: act.icon,
                                  color: act.color,
                                  title: act.title,
                                  sub: act.sub,
                                  amount: act.amount,
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Loan Calculation Formulas & Underwriting Section ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.calculate_rounded, color: AppColors.primary, size: 18),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Financial Calculation Formulas',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textDark),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Formulas Container Card
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: AppColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Formula 1: EMI Calculation
                                _buildFormulaItem(
                                  badge: 'EMI',
                                  title: 'Equated Monthly Installment',
                                  formula: 'EMI = [P × r × (1 + r)ⁿ] ÷ [(1 + r)ⁿ - 1]',
                                  description: 'P = Principal Amount, r = Monthly Interest (Annual Rate ÷ 12 ÷ 100), n = Tenure in Months.',
                                  accentColor: AppColors.primary,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(color: AppColors.border, height: 1),
                                ),

                                // Formula 2: Debt-to-Income (DTI)
                                _buildFormulaItem(
                                  badge: 'DTI',
                                  title: 'Debt-to-Income Ratio',
                                  formula: 'DTI = (Total Monthly EMIs ÷ Net Monthly Income) × 100%',
                                  description: 'Healthy score < 40%. Lower DTI unlocks higher loan eligibility and lowest interest rates.',
                                  accentColor: const Color(0xFF3D8EF0),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(color: AppColors.border, height: 1),
                                ),

                                // Formula 3: Loan Eligibility Limit
                                _buildFormulaItem(
                                  badge: 'LIMIT',
                                  title: 'Maximum Loan Eligibility',
                                  formula: 'Max Limit = Min(Monthly Income × 10, Product Ceiling)',
                                  description: 'Evaluated in real-time based on CIBIL credit score (700+ prime), employment stability, and DTI capacity.',
                                  accentColor: const Color(0xFFF59E0B),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  ),
);
}

  Widget _buildFormulaItem({
    required String badge,
    required String title,
    required String formula,
    required String description,
    required Color accentColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textDark),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            formula,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: Color(0xFF0F172A),
              letterSpacing: 0.2,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: const TextStyle(fontSize: 11, color: AppColors.textGrey, height: 1.35),
        ),
      ],
    );
  }
}

class _Seg extends StatelessWidget {
  final bool filled;
  const _Seg({required this.filled});
  @override
  Widget build(BuildContext context) => Container(
        height: 5,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : AppColors.primary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(3),
        ),
      );
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _ActionTile({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, sub, amount;
  const _ActivityRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.sub,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(sub, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
