import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out?', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Are you sure you want to log out of your EZFINANZ account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (r) => false,
              );
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
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
          children: [
            // ── Top Green Header with Avatar & Verification Badge ──
            Padding(
              padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 12, 24, 20),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            'AS',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified_rounded, color: AppColors.primary, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Aditi Sharma',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '+91 98765 43210 · aditi@example.com',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '🛡️ Verified Customer · Tier 1',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  children: [
                    // Highlights Stats Strip
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          _StatBox(label: 'CIBIL Score', val: '742'),
                          _VLine(),
                          _StatBox(label: 'Active Loans', val: '1 Loan'),
                          _VLine(),
                          _StatBox(label: 'Repayment', val: '100% On-Time'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 1: Personal Info
                    _SectionCard(
                      title: 'Personal & Employment',
                      icon: Icons.person_outline_rounded,
                      items: const [
                        _Tile(label: 'Full Name', val: 'Aditi Sharma'),
                        _Tile(label: 'Date of Birth', val: '15 Jun 1995 (29 yrs)'),
                        _Tile(label: 'Employer', val: 'TechCorp Solutions Pvt Ltd'),
                        _Tile(label: 'Designation', val: 'Senior Software Engineer'),
                        _Tile(label: 'Address', val: 'Bangalore, Karnataka - 560103'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Section 2: Bank & Disbursal
                    _SectionCard(
                      title: 'Bank & Auto-Debit (e-NACH)',
                      icon: Icons.account_balance_rounded,
                      items: const [
                        _Tile(label: 'Bank Name', val: 'State Bank of India', badge: 'Primary'),
                        _Tile(label: 'Account Number', val: '•••• •••• 1234'),
                        _Tile(label: 'IFSC Code', val: 'SBIN0001234'),
                        _Tile(label: 'e-Mandate Status', val: 'Active (Auto-Debit Enabled)', isGreen: true),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Section 3: KYC & Identity
                    _SectionCard(
                      title: 'KYC & Government IDs',
                      icon: Icons.shield_outlined,
                      items: const [
                        _Tile(label: 'Aadhaar Card', val: '•••• •••• 5678', badge: 'Verified 🛡️'),
                        _Tile(label: 'PAN Card', val: 'ABCDE1234F', badge: 'Verified 🛡️'),
                        _Tile(label: 'Live Photo Check', val: 'Passed (99.8% Match)', isGreen: true),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Section 4: Help & Support
                    _SectionCard(
                      title: 'Help & Customer Support',
                      icon: Icons.headset_mic_outlined,
                      items: const [
                        _Tile(label: '24/7 Priority Support', val: 'support@ezfinanz.com'),
                        _Tile(label: 'Toll-Free Helpline', val: '1800-123-4567'),
                        _Tile(label: 'FAQ & Loan Guides', val: 'View Articles'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Logout Button
                    GestureDetector(
                      onTap: () => _confirmLogout(context),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.error.withOpacity(0.2)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Log Out of Account',
                              style: TextStyle(
                                color: AppColors.error,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, val;
  const _StatBox({required this.label, required this.val});
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
          const SizedBox(height: 2),
          Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textDark)),
        ],
      );
}

class _VLine extends StatelessWidget {
  const _VLine();
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 24, color: AppColors.border);
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_Tile> items;

  const _SectionCard({required this.title, required this.icon, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textDark),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          ...List.generate(items.length, (i) {
            final item = items[i];
            final isLast = i == items.length - 1;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.label, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                  Row(
                    children: [
                      Text(
                        item.val,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: item.isGreen ? AppColors.primary : AppColors.textDark,
                        ),
                      ),
                      if (item.badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.badge!,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary),
                          ),
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _Tile {
  final String label, val;
  final String? badge;
  final bool isGreen;
  const _Tile({required this.label, required this.val, this.badge, this.isGreen = false});
}
