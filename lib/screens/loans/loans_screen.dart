import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import 'widgets/loan_card_widget.dart';
import 'widgets/popular_loans_carousel.dart';
import 'widgets/loan_detail_bottom_sheet.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({Key? key}) : super(key: key);

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  String _selectedCategory = 'All Categories';

  final List<String> _categories = [
    'All Categories',
    'Personal Loan',
    'Home Loan',
    'Auto Loan',
    'Education Loan',
    'Medical Loan',
    'Business Loan',
  ];

  static const List<LoanItemModel> _loans = [
    LoanItemModel(
      title: 'Personal Loan',
      amount: '₹5,00,000',
      rate: '10.5% p.a.',
      tenure: '60 mo',
      icon: Icons.person_rounded,
      accentColor: Color(0xFF00C48C),
      description: 'Quick collateral-free loan for personal, medical, or lifestyle needs.',
      badge: 'TOP PICK',
      isPopular: true,
    ),
    LoanItemModel(
      title: 'Home Loan',
      amount: '₹50,00,000',
      rate: '7.5% p.a.',
      tenure: '30 yr',
      icon: Icons.home_rounded,
      accentColor: Color(0xFF059669),
      description: 'Purchase or construct your dream home with lowest interest rates in the market.',
      badge: '7.5% LOWEST',
      isPopular: true,
    ),
    LoanItemModel(
      title: 'Auto Loan',
      amount: '₹30,00,000',
      rate: '8.0% p.a.',
      tenure: '84 mo',
      icon: Icons.directions_car_filled_rounded,
      accentColor: Color(0xFF0D9488),
      description: 'Instant approval for new and certified pre-owned four-wheelers & two-wheelers.',
    ),
    LoanItemModel(
      title: 'Education Loan',
      amount: '₹20,00,000',
      rate: '9.0% p.a.',
      tenure: '10 yr',
      icon: Icons.school_rounded,
      accentColor: Color(0xFF10B981),
      description: 'Study abroad or premier domestic universities with low interest moratorium.',
    ),
    LoanItemModel(
      title: 'Medical Loan',
      amount: '₹10,00,000',
      rate: '11.0% p.a.',
      tenure: '48 mo',
      icon: Icons.medical_services_rounded,
      accentColor: Color(0xFF047857),
      description: 'Emergency hospital bills & critical treatment credit disbursed in 2 hours.',
      badge: '2-HR DISBURSAL',
    ),
    LoanItemModel(
      title: 'Business Loan',
      amount: '₹25,00,000',
      rate: '12.0% p.a.',
      tenure: '60 mo',
      icon: Icons.business_center_rounded,
      accentColor: Color(0xFF15803D),
      description: 'Expand inventory, working capital, or infrastructure with zero collateral.',
    ),
  ];

  List<LoanItemModel> get _filtered {
    if (_selectedCategory == 'All Categories') return _loans;
    return _loans.where((l) => l.title == _selectedCategory).toList();
  }

  void _showDetail(BuildContext ctx, LoanItemModel loan) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => LoanDetailBottomSheet(loan: loan),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Clean Header with Dropdown Filter ──
            Padding(
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Explore Loans',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Curated financing for every need',
                            style: TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Premium Dropdown Selector
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 24),
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        dropdownColor: Colors.white,
                        items: _categories.map((cat) {
                          return DropdownMenuItem<String>(
                            value: cat,
                            child: Row(
                              children: [
                                Icon(
                                  cat == 'All Categories'
                                      ? Icons.apps_rounded
                                      : Icons.account_balance_wallet_outlined,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 10),
                                Text(cat),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedCategory = val);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── White Scrollable Body ──
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Featured Best Offers Carousel
                      if (_selectedCategory == 'All Categories') ...[
                        const PopularLoansCarousel(),
                        const SizedBox(height: 24),
                      ],

                      // Grid Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedCategory == 'All Categories' ? 'Available Plans' : '$_selectedCategory Plans',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_filtered.length} Options',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 2-Column Responsive Card Grid
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.86,
                          ),
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) => LoanCardWidget(
                            loan: _filtered[i],
                            onTap: () => _showDetail(context, _filtered[i]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
