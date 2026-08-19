import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class LoanItemModel {
  final String title;
  final String amount;
  final String rate;
  final String tenure;
  final IconData icon;
  final Color accentColor;
  final String description;
  final String? badge;
  final bool isPopular;

  const LoanItemModel({
    required this.title,
    required this.amount,
    required this.rate,
    required this.tenure,
    required this.icon,
    required this.accentColor,
    required this.description,
    this.badge,
    this.isPopular = false,
  });
}

class LoanCardWidget extends StatefulWidget {
  final LoanItemModel loan;
  final VoidCallback onTap;

  const LoanCardWidget({
    Key? key,
    required this.loan,
    required this.onTap,
  }) : super(key: key);

  @override
  State<LoanCardWidget> createState() => _LoanCardWidgetState();
}

class _LoanCardWidgetState extends State<LoanCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loan = widget.loan;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: (_) => _animController.forward(),
        onTapUp: (_) {
          _animController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _animController.reverse(),
        child: Container(
          decoration: BoxDecoration(
            color: loan.isPopular ? const Color(0xFFF0FDF4) : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: loan.isPopular
                  ? AppColors.primary.withOpacity(0.4)
                  : AppColors.border,
              width: loan.isPopular ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: loan.isPopular
                    ? AppColors.primary.withOpacity(0.12)
                    : Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Popular Badge on Top Right
              if (loan.badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: loan.isPopular ? AppColors.primary : const Color(0xFF0D9488),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(21),
                        bottomLeft: Radius.circular(14),
                      ),
                    ),
                    child: Text(
                      loan.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon Circle with soft ambient tint
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: loan.accentColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: loan.accentColor.withOpacity(0.2)),
                      ),
                      child: Icon(loan.icon, color: loan.accentColor, size: 22),
                    ),

                    const SizedBox(height: 8),

                    // Title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loan.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          loan.amount,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: loan.accentColor,
                          ),
                        ),
                      ],
                    ),

                    // Rate and Action Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          loan.rate,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textGrey,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: loan.accentColor.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 13,
                            color: loan.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
