import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pc = PageController();
  int _page = 0;

  static const _slides = [
    _Slide(
      icon: Icons.monetization_on_outlined,
      title: 'Instant Loan Approval',
      subtitle: 'Get personal loans approved in minutes.\nNo paperwork, no hassle.',
      color: Color(0xFF00C48C),
    ),
    _Slide(
      icon: Icons.security_outlined,
      title: '100% Secure & Private',
      subtitle: 'Your data is encrypted end-to-end.\nWe never share your information.',
      color: Color(0xFF3D8EF0),
    ),
    _Slide(
      icon: Icons.trending_down_outlined,
      title: 'Low Interest Rates',
      subtitle: 'Competitive rates starting at 10.5% p.a.\nFlexible repayment options.',
      color: Color(0xFF9B59B6),
    ),
  ];

  void _next() {
    if (_page < _slides.length - 1) {
      _pc.nextPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 24, 0),
                child: TextButton(
                  onPressed: _goToLogin,
                  child: const Text('Skip',
                      style: TextStyle(
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w500,
                          fontSize: 14)),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pc,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => _OnboardingPage(slide: _slides[i]),
              ),
            ),

            // Dots + button
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
              child: Column(
                children: [
                  // Dot indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _page == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _page == i ? AppColors.primary : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: _page == _slides.length - 1 ? 'Get Started' : 'Next',
                    onTap: _next,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Slide data ────────────────────────────────────────────────────
class _Slide {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _Slide({required this.icon, required this.title, required this.subtitle, required this.color});
}

class _OnboardingPage extends StatelessWidget {
  final _Slide slide;
  const _OnboardingPage({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration placeholder
          Container(
            width: 180, height: 180,
            decoration: BoxDecoration(
              color: slide.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(slide.icon, size: 80, color: slide.color),
          ),
          const SizedBox(height: 48),
          Text(slide.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w700,
                  color: AppColors.textDark, height: 1.2)),
          const SizedBox(height: 16),
          Text(slide.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15, color: AppColors.textGrey, height: 1.6)),
        ],
      ),
    );
  }
}
