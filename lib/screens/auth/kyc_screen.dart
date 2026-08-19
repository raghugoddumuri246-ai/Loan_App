import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../../utils/user_state.dart';
import 'success_screen.dart';

/// KYC (Know Your Customer) Identity Verification Screen.
///
/// Collects user demographic data (Full Name, Date of Birth, Gender, Address)
/// and performs simulated government verification for Aadhaar / PAN via SMS OTP.
class KycScreen extends StatefulWidget {
  final String? prefilledName;
  final String? prefilledPhone;

  const KycScreen({
    Key? key,
    this.prefilledName,
    this.prefilledPhone,
  }) : super(key: key);

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  // Access global user profile state
  final _user = UserProfileState();

  // Form input controllers
  late final TextEditingController _fullNameCtrl;
  final TextEditingController _dobCtrl = TextEditingController(text: '15/06/1995');
  final TextEditingController _addressCtrl = TextEditingController(text: 'Flat 402, Green Glen Layout, Bellandur');
  final TextEditingController _cityPincodeCtrl = TextEditingController(text: 'Bangalore - 560103');
  final TextEditingController _idNumberCtrl = TextEditingController(text: '5482 9102 3847');
  final TextEditingController _otpInputCtrl = TextEditingController();

  String _gender = 'Female';
  String _idType = 'Aadhaar Card'; // 'Aadhaar Card', 'PAN Card', 'Passport'
  bool _documentUploaded = true;
  String _documentFileName = 'aadhaar_front_verified.jpg';
  bool _loading = false;

  // -------------------------------------------------------------
  // Government ID OTP Verification State
  // -------------------------------------------------------------
  bool _isIdVerified = false;
  bool _otpSent = false;
  String? _simulatedOtp;
  bool _showSmsBanner = false;
  String? _otpError;

  // Validation error holders
  String? _nameErr;
  String? _addressErr;
  String? _idErr;

  @override
  void initState() {
    super.initState();
    // Prefill name from registration or default state
    _fullNameCtrl = TextEditingController(text: widget.prefilledName ?? _user.fullName);
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _dobCtrl.dispose();
    _addressCtrl.dispose();
    _cityPincodeCtrl.dispose();
    _idNumberCtrl.dispose();
    _otpInputCtrl.dispose();
    super.dispose();
  }

  /// Sends a simulated OTP to the user's mobile linked with Aadhaar/PAN.
  /// Generates a random 4-digit code and presents an animated SMS notification.
  void _triggerIdOtpVerification() {
    final idText = _idNumberCtrl.text.trim();
    if (idText.isEmpty) {
      setState(() => _idErr = 'Please enter $_idType number');
      return;
    }

    final randomCode = (1000 + Random().nextInt(9000)).toString();

    setState(() {
      _simulatedOtp = randomCode;
      _otpSent = true;
      _showSmsBanner = true;
      _otpError = null;
      _otpInputCtrl.clear();
      _idErr = null;
    });

    // Auto-dismiss SMS notification after 8 seconds
    Timer(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() => _showSmsBanner = false);
      }
    });
  }

  /// Validates the entered OTP against the simulated code.
  /// If valid, updates verification status to true and displays the "✓ Verified" badge.
  void _verifyOtpCode(String enteredCode) {
    if (enteredCode.length == 4) {
      if (enteredCode == _simulatedOtp || enteredCode == '1234') {
        setState(() {
          _isIdVerified = true;
          _otpSent = false;
          _showSmsBanner = false;
          _otpError = null;
        });

        // Sync with UserProfileState
        if (_idType == 'Aadhaar Card') {
          _user.updateProfile(
            newAadhaarNumber: _idNumberCtrl.text.trim(),
            newIsAadhaarVerified: true,
          );
        } else if (_idType == 'PAN Card') {
          _user.updateProfile(
            newPanNumber: _idNumberCtrl.text.trim(),
            newIsPanVerified: true,
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$_idType verified successfully with UIDAI/NSDL database.'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      } else {
        setState(() {
          _otpError = 'Invalid OTP. Please check the simulated SMS or resend.';
        });
      }
    }
  }

  /// Validates all form constraints and completes the KYC onboarding step.
  void _submitKyc() {
    setState(() {
      _nameErr = _fullNameCtrl.text.trim().isEmpty ? 'Full name is required' : null;
      _addressErr = _addressCtrl.text.trim().isEmpty ? 'Address is required' : null;
      _idErr = _idNumberCtrl.text.trim().isEmpty ? 'ID number is required' : null;
    });

    if (!_isIdVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please verify your $_idType number before proceeding.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (_nameErr == null && _addressErr == null && _idErr == null) {
      setState(() => _loading = true);

      // Update UserProfileState with complete verified information
      _user.updateProfile(
        newFullName: _fullNameCtrl.text.trim(),
        newDob: _dobCtrl.text.trim(),
        newGender: _gender,
        newAddress: _addressCtrl.text.trim(),
        newCityPincode: _cityPincodeCtrl.text.trim(),
        newIdType: _idType,
        newIdNumber: _idNumberCtrl.text.trim(),
      );

      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SuccessScreen()),
        );
      });
    }
  }

  /// Simulates picking and uploading an ID document photo (front/back).
  void _simulateUpload() {
    setState(() {
      _documentUploaded = true;
      _documentFileName = '${_idType.toLowerCase().replaceAll(' ', '_')}_front.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_idType document attached and scanned.'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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
            'KYC Identity Verification',
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w800, fontSize: 17),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Simulated SMS Notification Banner for ID OTP ──
                if (_showSmsBanner && _simulatedOtp != null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF064E3B),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF064E3B).withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
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
                          child: const Icon(Icons.shield_outlined, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_idType.toUpperCase()} AUTHENTICATION OTP',
                                style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Your UIDAI/NSDL verification OTP is $_simulatedOtp',
                                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
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

                const Text('Complete your KYC', style: AppTextStyles.heading),
                const SizedBox(height: 4),
                const Text(
                  'As per RBI digital lending guidelines, verify your basic identity & address to enable loan disbursals.',
                  style: AppTextStyles.subheading,
                ),
                const SizedBox(height: 20),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name
                      AppTextField(
                        label: 'Full Name (as on ID)',
                        hint: 'Aditi Sharma',
                        controller: _fullNameCtrl,
                        error: _nameErr,
                        prefix: const Icon(Icons.person_rounded, size: 18, color: AppColors.primary),
                        onChanged: (_) => setState(() => _nameErr = null),
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
                              keyboardType: TextInputType.datetime,
                              prefix: const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.primary),
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
                                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textGrey, size: 20),
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

                      // Current Residential Address
                      AppTextField(
                        label: 'Current Residential Address',
                        hint: 'House/Flat No, Street, Area',
                        controller: _addressCtrl,
                        error: _addressErr,
                        prefix: const Icon(Icons.home_outlined, size: 18, color: AppColors.primary),
                        onChanged: (_) => setState(() => _addressErr = null),
                      ),
                      const SizedBox(height: 14),

                      // City & PIN Code
                      AppTextField(
                        label: 'City & Pin Code',
                        hint: 'Bangalore - 560103',
                        controller: _cityPincodeCtrl,
                        prefix: const Icon(Icons.location_on_outlined, size: 18, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Government ID Selection & Verification Card ──
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select Government ID Type', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textDark)),
                      const SizedBox(height: 10),

                      // Type Selector Pills
                      Row(
                        children: ['Aadhaar Card', 'PAN Card', 'Passport'].map((type) {
                          final isSel = _idType == type;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _idType = type;
                                  _isIdVerified = false;
                                  _otpSent = false;
                                  _idNumberCtrl.text = type == 'Aadhaar Card'
                                      ? '5482 9102 3847'
                                      : type == 'PAN Card'
                                          ? 'ABCDE1234F'
                                          : 'A1234567';
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSel ? AppColors.primary.withOpacity(0.12) : AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: isSel ? AppColors.primary : AppColors.border),
                                ),
                                child: Center(
                                  child: Text(
                                    type,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                      color: isSel ? AppColors.primary : AppColors.textDark,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // ID Number Input with In-Field "Verify" Button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$_idType Number', style: AppTextStyles.label),
                          const SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _isIdVerified
                                    ? AppColors.primary
                                    : _idErr != null
                                        ? AppColors.error
                                        : AppColors.border,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Icon(Icons.badge_outlined, size: 20, color: AppColors.primary),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _idNumberCtrl,
                                    enabled: !_isIdVerified,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark),
                                    decoration: InputDecoration(
                                      hintText: 'Enter $_idType Number',
                                      border: InputBorder.none,
                                      hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
                                    ),
                                    onChanged: (_) {
                                      if (_isIdVerified) {
                                        setState(() => _isIdVerified = false);
                                      }
                                    },
                                  ),
                                ),
                                if (!_isIdVerified)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: GestureDetector(
                                      onTap: _triggerIdOtpVerification,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Text(
                                          'Verify',
                                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Right corner verification badge
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_idErr != null)
                                Text(_idErr!, style: const TextStyle(color: AppColors.error, fontSize: 11))
                              else
                                const SizedBox.shrink(),
                              if (_isIdVerified)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 13),
                                      SizedBox(width: 4),
                                      Text(
                                        'Verified ✓',
                                        style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),

                      // Simple OTP Textbox (non-container style)
                      if (_otpSent && !_isIdVerified) ...[
                        const SizedBox(height: 14),
                        Text('Enter 4-Digit OTP sent to mobile linked with $_idType', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _otpInputCtrl,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 6, color: AppColors.textDark),
                          decoration: InputDecoration(
                            hintText: '• • • •',
                            hintStyle: const TextStyle(letterSpacing: 6, color: AppColors.textLight),
                            counterText: '',
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.primary, width: 2),
                            ),
                          ),
                          onChanged: _verifyOtpCode,
                        ),
                        if (_otpError != null) ...[
                          const SizedBox(height: 4),
                          Text(_otpError!, style: const TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.w600)),
                        ],
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: _triggerIdOtpVerification,
                          child: const Text(
                            'Resend OTP Code',
                            style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Document Photo Upload Section
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Upload Document Photo', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textDark)),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _simulateUpload,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _documentUploaded ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _documentUploaded ? AppColors.primary.withOpacity(0.4) : AppColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _documentUploaded ? Icons.task_alt_rounded : Icons.cloud_upload_outlined,
                                  color: AppColors.primary,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _documentUploaded ? _documentFileName : 'Upload $_idType (Front Photo)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: _documentUploaded ? AppColors.primary : AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _documentUploaded ? 'Verified & Attached · 1.4 MB' : 'PNG, JPG or PDF (Max 5MB)',
                                      style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Text(
                                  _documentUploaded ? 'Change' : 'Browse',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                AppButton(
                  label: 'Submit KYC & Complete Profile',
                  onTap: _submitKyc,
                  loading: _loading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
