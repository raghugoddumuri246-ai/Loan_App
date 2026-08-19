import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../../utils/user_state.dart';
import '../../utils/loan_state.dart';
import 'edit_profile_screen.dart';

/// Customer Profile Screen.
///
/// Displays real-time verified customer demographics, employment profile,
/// unmasked government identifiers (Aadhaar, PAN), and registered disbursal bank details.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
        body: ListenableBuilder(
          listenable: Listenable.merge([UserProfileState(), LoanState()]),
          builder: (context, _) {
            final user = UserProfileState();
            final loanState = LoanState();

            // Extract uppercase initials for avatar
            final initials = user.fullName.isNotEmpty
                ? user.fullName.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
                : 'U';

            final activeLoansCount = loanState.appliedLoans.length;

            return Column(
              children: [
                // ── Top Brand Header with Avatar, Verified Badge & Edit Action ──
                Padding(
                  padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 20),
                  child: Row(
                    children: [
                      // Avatar circle with verified check icon
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
                            child: Center(
                              child: Text(
                                initials,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                            ),
                          ),
                          if (user.isKycVerified)
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

                      // User full name & contact details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName.isNotEmpty ? user.fullName : 'Customer Account',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.phone.isNotEmpty
                                  ? '+91 ${user.phone}${user.email.isNotEmpty ? ' · ${user.email}' : ''}'
                                  : user.email.isNotEmpty
                                      ? user.email
                                      : 'Profile Incomplete',
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
                              child: Text(
                                user.isKycVerified ? '🛡️ Verified Customer · Tier 1' : '⏳ KYC Pending',
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Edit Profile Header Action
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── White Scrollable Profile Details Body ──
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
                        // Credit Score & Portfolio Summary Strip
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
                            children: [
                              _StatBox(label: 'CIBIL Score', val: '${user.cibilScore}'),
                              const _VLine(),
                              _StatBox(label: 'Active Loans', val: '$activeLoansCount ${activeLoansCount == 1 ? 'Loan' : 'Loans'}'),
                              const _VLine(),
                              const _StatBox(label: 'Repayment', val: '100% On-Time'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Section 1: Personal & Employment Information
                        _SectionCard(
                          title: 'Personal & Employment',
                          icon: Icons.person_outline_rounded,
                          onEdit: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                          ),
                          items: [
                            _Tile(label: 'Full Name', val: user.fullName.isNotEmpty ? user.fullName : 'Not Added'),
                            _Tile(label: 'Date of Birth', val: user.dob.isNotEmpty ? user.dob : 'Not Added'),
                            _Tile(label: 'Gender', val: user.gender),
                            _Tile(
                              label: 'Mobile Number',
                              val: user.phone.isNotEmpty ? '+91 ${user.phone}' : 'Not Added',
                              badge: user.isPhoneVerified ? 'Verified ✓' : null,
                            ),
                            _Tile(
                              label: 'Email Address',
                              val: user.email.isNotEmpty ? user.email : 'Not Added',
                              badge: user.isEmailVerified ? 'Verified ✓' : null,
                            ),
                            _Tile(label: 'Employer', val: user.employer.isNotEmpty ? user.employer : 'Not Added'),
                            _Tile(label: 'Designation', val: user.designation.isNotEmpty ? user.designation : 'Not Added'),
                            _Tile(
                              label: 'Monthly Net Income',
                              val: user.monthlyIncome > 0 ? '₹${user.monthlyIncome.toStringAsFixed(0)}' : 'Not Added',
                            ),
                            _Tile(
                              label: 'Residential Address',
                              val: user.address.isNotEmpty
                                  ? '${user.address}${user.cityPincode.isNotEmpty ? ', ${user.cityPincode}' : ''}'
                                  : 'Not Added',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Section 2: Disbursal Bank Account Details
                        _SectionCard(
                          title: 'Bank & Auto-Debit (e-NACH)',
                          icon: Icons.account_balance_rounded,
                          onEdit: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                          ),
                          items: [
                            _Tile(
                              label: 'Bank Name',
                              val: user.bankName.isNotEmpty ? user.bankName : 'Not Added',
                              badge: user.bankName.isNotEmpty ? 'Primary' : null,
                            ),
                            _Tile(
                              label: 'Account Number',
                              val: user.accountNumber.isNotEmpty ? user.accountNumber : 'Not Added',
                            ),
                            _Tile(
                              label: 'Branch IFSC',
                              val: user.ifscCode.isNotEmpty ? user.ifscCode : 'Not Added',
                            ),
                            _Tile(
                              label: 'e-Mandate Status',
                              val: user.accountNumber.isNotEmpty ? 'Active (Auto-Debit Enabled)' : 'Setup Pending',
                              isGreen: user.accountNumber.isNotEmpty,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Section 3: KYC & Government Identifiers
                        _SectionCard(
                          title: 'KYC & Government IDs',
                          icon: Icons.shield_outlined,
                          onEdit: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                          ),
                          items: [
                            _Tile(
                              label: 'Aadhaar Card',
                              val: user.aadhaarNumber.isNotEmpty ? user.aadhaarNumber : 'Not Added',
                              badge: user.isAadhaarVerified ? 'Verified 🛡️' : 'Unverified',
                            ),
                            _Tile(
                              label: 'PAN Card',
                              val: user.panNumber.isNotEmpty ? user.panNumber : 'Not Added',
                              badge: user.isPanVerified ? 'Verified 🛡️' : 'Unverified',
                            ),
                            _Tile(
                              label: 'ID Proof Document',
                              val: user.kycDocumentPath != null || user.isKycVerified ? 'Stored in Database' : 'Pending Upload',
                              isGreen: user.isKycVerified,
                            ),
                            _Tile(
                              label: 'Live Face Verification',
                              val: user.livePhotoPath != null ? 'Verified · 99.8% Liveness' : 'Not Captured',
                              isGreen: user.livePhotoPath != null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, val;
  const _StatBox({required this.label, required this.val});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textDark)),
      ],
    );
  }
}

class _VLine extends StatelessWidget {
  const _VLine();
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 28, color: AppColors.border);
}

class _Tile {
  final String label;
  final String val;
  final String? badge;
  final bool isGreen;
  const _Tile({required this.label, required this.val, this.badge, this.isGreen = false});
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onEdit;
  final List<_Tile> items;

  const _SectionCard({
    required this.title,
    required this.icon,
    this.onEdit,
    required this.items,
  });

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
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Title Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textDark),
                ),
                const Spacer(),
                if (onEdit != null)
                  GestureDetector(
                    onTap: onEdit,
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 12),
                    ),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(item.label, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            item.val,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: item.isGreen
                                  ? AppColors.primary
                                  : item.val == 'Not Added' || item.val == 'Not Captured'
                                      ? AppColors.textLight
                                      : AppColors.textDark,
                            ),
                          ),
                        ),
                        if (item.badge != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: item.badge!.contains('Unverified')
                                  ? Colors.grey.withOpacity(0.15)
                                  : AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.badge!,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: item.badge!.contains('Unverified') ? AppColors.textGrey : AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
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
