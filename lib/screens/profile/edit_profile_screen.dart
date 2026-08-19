import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../../utils/user_state.dart';

/// Edit Customer Profile Screen.
///
/// Enables users to edit demographic, contact, employment, and banking details.
/// For critical credentials (Aadhaar, PAN, Phone, Email), it provides simulated
/// OTP re-verification via a fixed floating top banner and a dedicated verification modal.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Reference to singleton global state
  final _user = UserProfileState();

  // Controllers for personal & contact info
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _dobCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _cityPincodeCtrl;

  // Controllers for employment & financial info
  late final TextEditingController _employerCtrl;
  late final TextEditingController _designationCtrl;
  late final TextEditingController _incomeCtrl;

  // Controllers for KYC & Bank details
  late final TextEditingController _aadhaarCtrl;
  late final TextEditingController _panCtrl;
  late final TextEditingController _bankNameCtrl;
  late final TextEditingController _accNumCtrl;
  late final TextEditingController _ifscCtrl;

  late String _gender;
  bool _loading = false;

  // Verification state tracking
  String? _verifyingField; // 'phone', 'email', 'aadhaar', 'pan'
  String? _simulatedOtp;
  bool _showSmsBanner = false;

  bool _isPhoneVerified = true;
  bool _isEmailVerified = true;
  bool _isAadhaarVerified = true;
  bool _isPanVerified = true;

  // Validation error holders
  String? _nameErr, _emailErr, _phoneErr;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: _user.fullName);
    _emailCtrl = TextEditingController(text: _user.email);
    _phoneCtrl = TextEditingController(text: _user.phone);
    _dobCtrl = TextEditingController(text: _user.dob);
    _addressCtrl = TextEditingController(text: _user.address);
    _cityPincodeCtrl = TextEditingController(text: _user.cityPincode);

    _employerCtrl = TextEditingController(text: _user.employer);
    _designationCtrl = TextEditingController(text: _user.designation);
    _incomeCtrl = TextEditingController(text: _user.monthlyIncome.toStringAsFixed(0));

    _aadhaarCtrl = TextEditingController(text: _user.aadhaarNumber);
    _panCtrl = TextEditingController(text: _user.panNumber);
    _bankNameCtrl = TextEditingController(text: _user.bankName);
    _accNumCtrl = TextEditingController(text: _user.accountNumber);
    _ifscCtrl = TextEditingController(text: _user.ifscCode);

    _gender = _user.gender;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _dobCtrl.dispose();
    _addressCtrl.dispose();
    _cityPincodeCtrl.dispose();
    _employerCtrl.dispose();
    _designationCtrl.dispose();
    _incomeCtrl.dispose();
    _aadhaarCtrl.dispose();
    _panCtrl.dispose();
    _bankNameCtrl.dispose();
    _accNumCtrl.dispose();
    _ifscCtrl.dispose();
    super.dispose();
  }

  bool _validEmail(String v) => RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-z]{2,}$').hasMatch(v.trim());

  /// Triggers simulated OTP generation and floating notification, then opens a verification modal.
  void _startVerificationFor(String fieldName, String title) {
    final code = (1000 + Random().nextInt(9000)).toString();

    setState(() {
      _verifyingField = fieldName;
      _simulatedOtp = code;
      _showSmsBanner = true;
    });

    // Show dedicated OTP verification bottom sheet modal
    _showOtpBottomSheet(fieldName, title, code);

    Timer(const Duration(seconds: 12), () {
      if (mounted) {
        setState(() => _showSmsBanner = false);
      }
    });
  }

  /// Opens a dedicated, focused Bottom Sheet for entering the 4-digit OTP.
  void _showOtpBottomSheet(String fieldName, String title, String expectedOtp) {
    final modalOtpCtrl = TextEditingController();
    String? localError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.shield_outlined, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Verify $title', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textDark)),
                            const SizedBox(height: 2),
                            const Text('Enter 4-digit code sent to your registered mobile', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Simple, clean OTP textfield
                  TextField(
                    controller: modalOtpCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    autofocus: true,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, letterSpacing: 8, color: AppColors.textDark),
                    decoration: InputDecoration(
                      hintText: '• • • •',
                      hintStyle: const TextStyle(letterSpacing: 8, color: AppColors.textLight),
                      counterText: '',
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    onChanged: (val) {
                      if (val.length == 4) {
                        if (val == expectedOtp || val == '1234') {
                          Navigator.pop(ctx);
                          setState(() {
                            if (fieldName == 'phone') _isPhoneVerified = true;
                            if (fieldName == 'email') _isEmailVerified = true;
                            if (fieldName == 'aadhaar') _isAadhaarVerified = true;
                            if (fieldName == 'pan') _isPanVerified = true;
                            _showSmsBanner = false;
                          });

                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text('$title verified successfully! ✓'),
                              backgroundColor: AppColors.primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        } else {
                          setModalState(() {
                            localError = 'Invalid code. Please check the floating SMS banner at the top.';
                          });
                        }
                      }
                    },
                  ),

                  if (localError != null) ...[
                    const SizedBox(height: 8),
                    Text(localError!, style: const TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],

                  const SizedBox(height: 20),
                  AppButton(
                    label: 'Confirm & Verify',
                    onTap: () {
                      final val = modalOtpCtrl.text.trim();
                      if (val == expectedOtp || val == '1234') {
                        Navigator.pop(ctx);
                        setState(() {
                          if (fieldName == 'phone') _isPhoneVerified = true;
                          if (fieldName == 'email') _isEmailVerified = true;
                          if (fieldName == 'aadhaar') _isAadhaarVerified = true;
                          if (fieldName == 'pan') _isPanVerified = true;
                          _showSmsBanner = false;
                        });

                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                            content: Text('$title verified successfully! ✓'),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      } else {
                        setModalState(() {
                          localError = 'Invalid code. Enter the 4-digit code shown in the floating banner.';
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Validates all input fields, updates the global UserProfileState, and pops back.
  void _saveProfile() {
    setState(() {
      _nameErr = _nameCtrl.text.trim().isEmpty ? 'Full name is required' : null;
      _emailErr = _emailCtrl.text.trim().isEmpty
          ? 'Email is required'
          : !_validEmail(_emailCtrl.text)
              ? 'Enter a valid email'
              : null;
      _phoneErr = _phoneCtrl.text.trim().length != 10 ? 'Enter valid 10-digit phone' : null;
    });

    if (!_isPhoneVerified || !_isEmailVerified || !_isAadhaarVerified || !_isPanVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please verify any modified credentials before saving.'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (_nameErr == null && _emailErr == null && _phoneErr == null) {
      setState(() => _loading = true);

      _user.updateProfile(
        newFullName: _nameCtrl.text.trim(),
        newEmail: _emailCtrl.text.trim(),
        newPhone: _phoneCtrl.text.trim(),
        newDob: _dobCtrl.text.trim(),
        newGender: _gender,
        newAddress: _addressCtrl.text.trim(),
        newCityPincode: _cityPincodeCtrl.text.trim(),
        newEmployer: _employerCtrl.text.trim(),
        newDesignation: _designationCtrl.text.trim(),
        newMonthlyIncome: double.tryParse(_incomeCtrl.text.replaceAll(',', '')) ?? _user.monthlyIncome,
        newAadhaarNumber: _aadhaarCtrl.text.trim(),
        newPanNumber: _panCtrl.text.trim(),
        newIsAadhaarVerified: _isAadhaarVerified,
        newIsPanVerified: _isPanVerified,
        newBankName: _bankNameCtrl.text.trim(),
        newAccountNumber: _accNumCtrl.text.trim(),
        newIfscCode: _ifscCtrl.text.trim(),
      );

      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile details updated successfully.'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textDark),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Edit Profile',
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w800, fontSize: 17),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: _loading ? null : _saveProfile,
              child: const Text(
                'Save',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 14),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              // ── Main Scrollable Form Body ──
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Personal Information
                    _buildSectionHeader('Personal Information', Icons.person_outline_rounded),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          AppTextField(
                            label: 'Full Name',
                            hint: 'Aditi Sharma',
                            controller: _nameCtrl,
                            error: _nameErr,
                            prefix: const Icon(Icons.person_rounded, size: 18, color: AppColors.primary),
                            onChanged: (_) => setState(() => _nameErr = null),
                          ),
                          const SizedBox(height: 14),

                          // Email with In-Field Verification
                          _buildVerifiableField(
                            label: 'Email Address',
                            controller: _emailCtrl,
                            icon: Icons.email_outlined,
                            isVerified: _isEmailVerified,
                            onVerify: () => _startVerificationFor('email', 'Email Address'),
                            onChanged: (v) {
                              if (_isEmailVerified && v != _user.email) {
                                setState(() => _isEmailVerified = false);
                              }
                            },
                          ),
                          const SizedBox(height: 14),

                          // Mobile with In-Field Verification
                          _buildVerifiableField(
                            label: 'Mobile Number',
                            controller: _phoneCtrl,
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            isVerified: _isPhoneVerified,
                            onVerify: () => _startVerificationFor('phone', 'Mobile Number'),
                            onChanged: (v) {
                              if (_isPhoneVerified && v != _user.phone) {
                                setState(() => _isPhoneVerified = false);
                              }
                            },
                          ),
                          const SizedBox(height: 14),

                          // Date of Birth & Gender
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: AppTextField(
                                  label: 'Date of Birth',
                                  hint: 'DD/MM/YYYY',
                                  controller: _dobCtrl,
                                  prefix: const Icon(Icons.cake_outlined, size: 18, color: AppColors.primary),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Gender', style: AppTextStyles.label),
                                    const SizedBox(height: 6),
                                    Container(
                                      height: 48,
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _gender,
                                          isExpanded: true,
                                          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark, fontSize: 13),
                                          dropdownColor: Colors.white,
                                          items: ['Female', 'Male', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                                          onChanged: (v) => setState(() => _gender = v!),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          AppTextField(
                            label: 'Residential Address',
                            hint: 'Street, Apartment, Area',
                            controller: _addressCtrl,
                            prefix: const Icon(Icons.home_outlined, size: 18, color: AppColors.primary),
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            label: 'City & PIN Code',
                            hint: 'Bangalore - 560103',
                            controller: _cityPincodeCtrl,
                            prefix: const Icon(Icons.location_on_outlined, size: 18, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Section 2: KYC Government Identifiers (Unmasked & Verifiable)
                    _buildSectionHeader('KYC Government Identifiers (Unmasked)', Icons.shield_outlined),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          // Aadhaar Number with Verification
                          _buildVerifiableField(
                            label: 'Aadhaar Number',
                            controller: _aadhaarCtrl,
                            icon: Icons.badge_outlined,
                            isVerified: _isAadhaarVerified,
                            onVerify: () => _startVerificationFor('aadhaar', 'Aadhaar Number'),
                            onChanged: (v) {
                              if (_isAadhaarVerified && v != _user.aadhaarNumber) {
                                setState(() => _isAadhaarVerified = false);
                              }
                            },
                          ),
                          const SizedBox(height: 14),

                          // PAN Number with Verification
                          _buildVerifiableField(
                            label: 'PAN Card Number',
                            controller: _panCtrl,
                            icon: Icons.credit_card_outlined,
                            isVerified: _isPanVerified,
                            onVerify: () => _startVerificationFor('pan', 'PAN Card'),
                            onChanged: (v) {
                              if (_isPanVerified && v != _user.panNumber) {
                                setState(() => _isPanVerified = false);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Section 3: Employment & Income
                    _buildSectionHeader('Employment & Financial Details', Icons.work_outline_rounded),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          AppTextField(
                            label: 'Company / Employer Name',
                            hint: 'TechCorp Solutions Pvt Ltd',
                            controller: _employerCtrl,
                            prefix: const Icon(Icons.business_rounded, size: 18, color: AppColors.primary),
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            label: 'Current Designation',
                            hint: 'Senior Software Engineer',
                            controller: _designationCtrl,
                            prefix: const Icon(Icons.badge_outlined, size: 18, color: AppColors.primary),
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            label: 'Monthly Net Take-Home Salary (₹)',
                            hint: '65000',
                            controller: _incomeCtrl,
                            keyboardType: TextInputType.number,
                            prefix: const Icon(Icons.currency_rupee_rounded, size: 18, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Section 4: Disbursal Bank Account
                    _buildSectionHeader('Bank Account for Disbursal (Unmasked)', Icons.account_balance_rounded),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          AppTextField(
                            label: 'Bank Name',
                            hint: 'State Bank of India',
                            controller: _bankNameCtrl,
                            prefix: const Icon(Icons.account_balance_outlined, size: 18, color: AppColors.primary),
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            label: 'Bank Account Number',
                            hint: '987654321098',
                            controller: _accNumCtrl,
                            prefix: const Icon(Icons.credit_card_outlined, size: 18, color: AppColors.primary),
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            label: 'Branch IFSC Code',
                            hint: 'SBIN0001234',
                            controller: _ifscCtrl,
                            prefix: const Icon(Icons.code_rounded, size: 18, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Save Button
                    AppButton(
                      label: 'Save & Update Profile',
                      onTap: _saveProfile,
                      loading: _loading,
                    ),
                  ],
                ),
              ),

              // ── FLOATING SMS NOTIFICATION PINNED AT TOP ──
              if (_showSmsBanner && _simulatedOtp != null)
                Positioned(
                  top: 10,
                  left: 16,
                  right: 16,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF064E3B),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.sms_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_verifyingField?.toUpperCase()} VERIFICATION OTP',
                                style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Your verification code is $_simulatedOtp',
                                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 18),
                          onPressed: () => setState(() => _showSmsBanner = false),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a section header with icon and text.
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textDark),
        ),
      ],
    );
  }

  /// Builds an input field with integrated in-line verification button and status checkmark.
  Widget _buildVerifiableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isVerified,
    required VoidCallback onVerify,
    required void Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isVerified ? AppColors.primary : AppColors.border),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(icon, size: 20, color: AppColors.primary),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark),
                  decoration: InputDecoration(
                    hintText: 'Enter $label',
                    border: InputBorder.none,
                    hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
                  ),
                  onChanged: onChanged,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: isVerified
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 13),
                            SizedBox(width: 4),
                            Text('Verified ✓', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: onVerify,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Verify', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
