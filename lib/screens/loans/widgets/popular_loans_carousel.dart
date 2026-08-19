import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../apply_loan_flow_screen.dart';

class PopularLoanItem {
  final String title;
  final String amount;
  final String rate;
  final String tenure;
  final String badge;
  final List<Color> gradientColors;
  final IconData icon;
  final String tagLine;

  const PopularLoanItem({
    required this.title,
    required this.amount,
    required this.rate,
    required this.tenure,
    required this.badge,
    required this.gradientColors,
    required this.icon,
    required this.tagLine,
  });
}

class PopularLoansCarousel extends StatefulWidget {
  final Function(String title, String amount, String rate)? onApply;

  const PopularLoansCarousel({Key? key, this.onApply}) : super(key: key);

  @override
  State<PopularLoansCarousel> createState() => _PopularLoansCarouselState();
}

class _PopularLoansCarouselState extends State<PopularLoansCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.88);
  int _currentPage = 0;

  // Harmonious theme-matched vibrant green gradients based directly on AppColors.primary (0xFF00C48C)
  static const List<PopularLoanItem> _popularLoans = [
    PopularLoanItem(
      title: 'Instant Personal Loan',
      amount: 'Up to ₹5,00,000',
      rate: '10.5% p.a.',
      tenure: 'Flexible 12-60 mo',
      badge: '🔥 MOST POPULAR',
      gradientColors: [Color(0xFF00C48C), Color(0xFF009F72)],
      icon: Icons.flash_on_rounded,
      tagLine: 'Zero collateral · Disbursed in 30 mins',
    ),
    PopularLoanItem(
      title: 'Dream Home Loan',
      amount: 'Up to ₹50,00,000',
      rate: '7.5% p.a.',
      tenure: 'Tenure up to 30 yrs',
      badge: '⭐ LOWEST RATE',
      gradientColors: [Color(0xFF00BFA5), Color(0xFF009688)],
      icon: Icons.home_rounded,
      tagLine: 'Minimal processing fee · Instant sanction',
    ),
    PopularLoanItem(
      title: 'Emergency Medical Loan',
      amount: 'Up to ₹10,00,000',
      rate: '11.0% p.a.',
      tenure: 'Fast 6-48 mo',
      badge: '⚡ 2-HR DISBURSAL',
      gradientColors: [Color(0xFF10B981), Color(0xFF059669)],
      icon: Icons.medical_services_rounded,
      tagLine: 'Hospital bills & treatments covered',
    ),
    PopularLoanItem(
      title: 'Vehicle Express Loan',
      amount: 'Up to ₹30,00,000',
      rate: '8.0% p.a.',
      tenure: 'Up to 7 yrs',
      badge: '🚗 100% ON-ROAD',
      gradientColors: [Color(0xFF00C48C), Color(0xFF00897B)],
      icon: Icons.directions_car_filled_rounded,
      tagLine: 'Pre-approved car & bike financing',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.local_fire_department_rounded, color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Featured & Best Offers',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              Row(
                children: List.generate(_popularLoans.length, (i) {
                  final isCurrent = _currentPage == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(left: 4),
                    width: isCurrent ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isCurrent ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 175,
          child: PageView.builder(
            controller: _controller,
            itemCount: _popularLoans.length,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemBuilder: (context, index) {
              final loan = _popularLoans[index];
              return _buildPopularCard(loan);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularCard(PopularLoanItem loan) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: loan.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: loan.gradientColors.first.withOpacity(0.32),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ambient watermark icon
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              loan.icon,
              size: 130,
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top row: Theme Badge and Rate Pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Text(
                        loan.badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        loan.rate,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),

                // Middle: Title and Tagline
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loan.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      loan.tagLine,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Bottom row: Amount & Action Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Max Eligible',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          loan.amount,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        if (widget.onApply != null) {
                          widget.onApply!(loan.title, loan.amount, loan.rate);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ApplyLoanFlowScreen(
                                loanTitle: loan.title,
                                maxAmount: loan.amount,
                                defaultRate: loan.rate,
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Apply Now',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
