import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../../utils/user_state.dart';
import '../../services/api_service.dart';
import 'signup_screen.dart';
import '../dashboard/customer_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _tabIndex = 0; // 0: Email, 1: Phone
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _emailErr, _passErr, _phoneErr;

  // Phone OTP State
  bool _otpSent = false;
  String? _generatedOtp;
  bool _showSmsBanner = false;
  int _timerSeconds = 30;
  Timer? _countdownTimer;

  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());
  String? _otpError;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _phoneCtrl.dispose();
    _countdownTimer?.cancel();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  bool _validEmail(String v) => RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-z]{2,}$').hasMatch(v.trim());

  Future<void> _submitEmail() async {
    setState(() {
      _emailErr = _emailCtrl.text.trim().isEmpty
          ? 'Email is required'
          : !_validEmail(_emailCtrl.text)
              ? 'Enter a valid email address'
              : null;
      _passErr = _passCtrl.text.isEmpty
          ? 'Password is required'
          : _passCtrl.text.length < 6
              ? 'Minimum 6 characters'
              : null;
    });

    if (_emailErr == null && _passErr == null) {
      setState(() => _loading = true);
      
      final res = await ApiService().login(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      if (!mounted) return;
      setState(() => _loading = false);

      if (res['success'] == true) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CustomerDashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'] ?? 'Login failed. Please check credentials.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  Future<void> _sendPhoneOtp() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.length != 10) {
      setState(() => _phoneErr = 'Please enter a valid 10-digit mobile number');
      return;
    }

    setState(() {
      _phoneErr = null;
      _loading = true;
    });

    final res = await ApiService().sendOtp(
      identifier: phone,
      purpose: 'login_otp',
    );

    final otp = res['simulatedOtp'] ?? (1000 + Random().nextInt(9000)).toString();
    
    setState(() {
      _loading = false;
      _generatedOtp = otp;
      _otpSent = true;
      _showSmsBanner = true;
      _timerSeconds = 30;
      _otpError = null;
      for (var c in _otpControllers) {
        c.clear();
      }
    });

    _startTimer();

    // Auto-hide SMS banner after 8 seconds
    Timer(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() => _showSmsBanner = false);
      }
    });
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        t.cancel();
      }
    });
  }

  Future<void> _verifyPhoneOtp() async {
    final entered = _otpControllers.map((c) => c.text).join();
    if (entered.length < 4) {
      setState(() => _otpError = 'Please enter the complete 4-digit OTP');
      return;
    }

    setState(() {
      _loading = true;
      _otpError = null;
    });

    final res = await ApiService().loginWithPhone(
      phone: _phoneCtrl.text.trim(),
      otp: entered,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Phone verified successfully! Logging in...'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CustomerDashboardScreen()),
      );
    } else {
      setState(() => _otpError = res['message'] ?? 'Invalid OTP');
    }
  }

  void _googleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Signing in with Google Account (aditi@example.com)...'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CustomerDashboardScreen()),
      );
    });
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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Simulated SMS Notification Banner ──
                if (_showSmsBanner && _generatedOtp != null)
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
                          child: const Icon(Icons.sms_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'SIMULATED SMS NOTIFICATION',
                                style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Your EZFINANZ login OTP is $_generatedOtp',
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

                // ── Brand Logo Header ──
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00C48C), Color(0xFF009688)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'EZFINANZ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textDark,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'INSTANT DIGITAL LENDING',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Greeting Title
                const Text(
                  'Welcome Back 👋',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Log in to access your loan applications, active EMIs and pre-approved offers.',
                  style: AppTextStyles.subheading,
                ),
                const SizedBox(height: 24),

                // ── Seamless Custom Segmented Toggle ──
                Container(
                  height: 48,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _tabIndex = 0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: _tabIndex == 0 ? AppColors.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _tabIndex == 0
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.25),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    size: 15,
                                    color: _tabIndex == 0 ? Colors.white : AppColors.textGrey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Email & Password',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: _tabIndex == 0 ? Colors.white : AppColors.textGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _tabIndex = 1),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: _tabIndex == 1 ? AppColors.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _tabIndex == 1
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.25),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.phone_android_rounded,
                                    size: 15,
                                    color: _tabIndex == 1 ? Colors.white : AppColors.textGrey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Phone (OTP)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: _tabIndex == 1 ? Colors.white : AppColors.textGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // ── Form Input Card ──
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: _tabIndex == 0 ? _buildEmailForm() : _buildPhoneOtpForm(),
                ),
                const SizedBox(height: 24),

                // Social OAuth Divider
                Row(
                  children: const [
                    Expanded(child: Divider(color: AppColors.border)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'OR CONTINUE WITH',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textGrey,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.border)),
                  ],
                ),
                const SizedBox(height: 18),

                // Google OAuth Button
                GestureDetector(
                  onTap: _googleLogin,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'G',
                              style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF4285F4), fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Continue with Google Account',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Sign Up Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ", style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SignUpScreen()),
                      ),
                      child: const Text(
                        'Apply / Sign Up',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'Email Address',
          hint: 'aditi@example.com',
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          error: _emailErr,
          prefix: const Icon(Icons.email_outlined, size: 18, color: AppColors.primary),
          onChanged: (_) => setState(() => _emailErr = null),
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'Account Password',
          hint: '••••••••',
          controller: _passCtrl,
          obscure: _obscure,
          error: _passErr,
          prefix: const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.primary),
          suffix: IconButton(
            icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: AppColors.textGrey),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
          onChanged: (_) => setState(() => _passErr = null),
        ),
        const SizedBox(height: 22),
        AppButton(
          label: 'Sign In to Dashboard',
          onTap: _submitEmail,
          loading: _loading,
        ),
      ],
    );
  }

  Widget _buildPhoneOtpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_otpSent) ...[
          AppTextField(
            label: 'Mobile Number',
            hint: '9876543210',
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            error: _phoneErr,
            onChanged: (_) => setState(() => _phoneErr = null),
            prefix: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Text(
                '+91',
                style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'We will send a 4-digit verification code to this mobile number.',
            style: TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.4),
          ),
          const SizedBox(height: 20),
          AppButton(
            label: 'Send Verification OTP',
            onTap: _sendPhoneOtp,
            loading: _loading,
          ),
        ] else ...[
          // Active Phone Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone_iphone_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mobile Number', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                      const SizedBox(height: 2),
                      Text(
                        '+91 ${_phoneCtrl.text.trim()}',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textDark),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _otpSent = false),
                  child: const Text(
                    'Change',
                    style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('Enter 4-Digit Verification Code', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 12),

          // 4-Box OTP Input Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (i) {
              return SizedBox(
                width: 58,
                height: 58,
                child: TextField(
                  controller: _otpControllers[i],
                  focusNode: _otpFocusNodes[i],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textDark),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                  onChanged: (v) {
                    if (v.isNotEmpty && i < 3) {
                      _otpFocusNodes[i + 1].requestFocus();
                    } else if (v.isEmpty && i > 0) {
                      _otpFocusNodes[i - 1].requestFocus();
                    }
                    if (_otpControllers.every((c) => c.text.isNotEmpty)) {
                      _verifyPhoneOtp();
                    }
                  },
                ),
              );
            }),
          ),

          if (_otpError != null) ...[
            const SizedBox(height: 8),
            Text(_otpError!, style: const TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w600)),
          ],

          const SizedBox(height: 14),

          // Countdown Timer & Resend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _timerSeconds > 0 ? 'Resend code in 00:${_timerSeconds.toString().padLeft(2, '0')}' : 'Didn\'t receive code?',
                style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
              if (_timerSeconds == 0)
                GestureDetector(
                  onTap: _sendPhoneOtp,
                  child: const Text(
                    'Resend OTP',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),
          AppButton(
            label: 'Verify & Sign In',
            onTap: _verifyPhoneOtp,
            loading: _loading,
          ),
        ],
      ],
    );
  }
}
