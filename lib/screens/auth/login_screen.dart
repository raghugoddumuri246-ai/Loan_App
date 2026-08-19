import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import 'signup_screen.dart';
import 'phone_login_screen.dart';
import '../dashboard/customer_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _tabIndex = 0; // 0: Email, 1: Phone
  final _emailCtrl = TextEditingController(text: 'aditi@example.com');
  final _passCtrl = TextEditingController(text: 'password123');
  final _phoneCtrl = TextEditingController(text: '9876543210');
  bool _obscure = true;
  bool _loading = false;
  String? _emailErr, _passErr, _phoneErr;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  bool _validEmail(String v) => RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-z]{2,}$').hasMatch(v.trim());

  void _submitEmail() {
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
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        setState(() => _loading = false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CustomerDashboardScreen()),
        );
      });
    }
  }

  void _submitPhone() {
    final phone = _phoneCtrl.text.trim();
    if (phone.length != 10) {
      setState(() => _phoneErr = 'Enter a valid 10-digit mobile number');
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PhoneLoginScreen()),
    );
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
                // ── Brand Logo Header ──
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF044E38), Color(0xFF00C48C)],
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
                  child: _tabIndex == 0 ? _buildEmailForm() : _buildPhoneForm(),
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
                        MaterialPageRoute(builder: (_) => const SignupScreen()),
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

  Widget _buildPhoneForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'Registered Mobile Number',
          hint: '9876543210',
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          error: _phoneErr,
          onChanged: (_) => setState(() => _phoneErr = null),
          prefix: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.phone_outlined, size: 18, color: AppColors.primary),
                SizedBox(width: 6),
                Text('+91', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'We will send a 4-digit verification code to this mobile number.',
          style: TextStyle(fontSize: 12, color: AppColors.textGrey),
        ),
        const SizedBox(height: 22),
        AppButton(
          label: 'Send Verification OTP',
          onTap: _submitPhone,
        ),
      ],
    );
  }
}
