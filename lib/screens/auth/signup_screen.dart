import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import 'success_screen.dart';
import 'kyc_screen.dart';

/// Signup flow: fill form → verify email OTP → verify phone OTP → KYC → success
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Step: 0=form, 1=email OTP, 2=phone OTP
  int _step = 0;

  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _cpassCtrl = TextEditingController();

  bool _obscureP = true, _obscureC = true, _loading = false;
  String? _nameErr, _emailErr, _phoneErr, _passErr, _cpassErr;

  int get _strength {
    final p = _passCtrl.text;
    if (p.isEmpty) return 0;
    int s = 0;
    if (p.length >= 8) s++;
    if (RegExp(r'[A-Z]').hasMatch(p)) s++;
    if (RegExp(r'[0-9]').hasMatch(p)) s++;
    if (RegExp(r'[!@#\$&*~]').hasMatch(p)) s++;
    return s;
  }

  Color get _sc {
    switch (_strength) { case 1: return Colors.red; case 2: return Colors.orange;
      case 3: return Colors.amber; case 4: return AppColors.primary; default: return AppColors.border; }
  }

  String get _sl {
    switch (_strength) { case 1: return 'Weak'; case 2: return 'Fair';
      case 3: return 'Good'; case 4: return 'Strong'; default: return ''; }
  }

  bool _validEmail(String v) =>
      RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-z]{2,}$').hasMatch(v.trim());

  void _submitForm() {
    setState(() {
      _nameErr  = _nameCtrl.text.trim().isEmpty ? 'Full name required' : null;
      _emailErr = _emailCtrl.text.trim().isEmpty ? 'Email required'
          : !_validEmail(_emailCtrl.text) ? 'Enter a valid email' : null;
      _phoneErr = _phoneCtrl.text.trim().length < 10 ? 'Enter 10-digit number' : null;
      _passErr  = _passCtrl.text.length < 8 ? 'Minimum 8 characters' : null;
      _cpassErr = _cpassCtrl.text != _passCtrl.text ? 'Passwords don\'t match' : null;
    });
    if ([_nameErr, _emailErr, _phoneErr, _passErr, _cpassErr].every((e) => e == null)) {
      setState(() { _loading = true; });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() { _loading = false; _step = 1; }); // go to email OTP
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _passCtrl.dispose(); _cpassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => _step == 0 ? Navigator.pop(context) : setState(() => _step--),
        ),
        title: Text(_step == 0 ? 'Create Account'
            : _step == 1 ? 'Verify Email' : 'Verify Phone'),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _step == 0
            ? _buildForm()
            : _OtpStep(
                key: ValueKey(_step),
                title: _step == 1 ? 'Check your email' : 'Check your phone',
                subtitle: _step == 1
                    ? 'Sent to ${_emailCtrl.text.trim()}'
                    : 'Sent to +91 ${_phoneCtrl.text.trim()}',
                isEmail: _step == 1,
                onVerified: () {
                  if (_step == 1) {
                    setState(() => _step = 2); // move to phone OTP
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => KycScreen(
                          prefilledName: _nameCtrl.text.trim(),
                          prefilledPhone: _phoneCtrl.text.trim(),
                        ),
                      ),
                    );
                  }
                },
              ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      key: const ValueKey(0),
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step indicator
          _StepDots(current: 0, total: 3),
          const SizedBox(height: 24),
          const Text('Let\'s get started', style: AppTextStyles.heading),
          const SizedBox(height: 6),
          const Text('Fill in your details to create an account.',
              style: AppTextStyles.subheading),
          const SizedBox(height: 28),

          AppTextField(label: 'Full Name', hint: 'Aditi Sharma',
              controller: _nameCtrl, error: _nameErr,
              onChanged: (_) => setState(() => _nameErr = null)),
          const SizedBox(height: 18),
          AppTextField(label: 'Email Address', hint: 'you@example.com',
              controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
              error: _emailErr, onChanged: (_) => setState(() => _emailErr = null)),
          const SizedBox(height: 18),
          AppTextField(
            label: 'Mobile Number', hint: '9876543210',
            controller: _phoneCtrl, keyboardType: TextInputType.phone,
            maxLength: 10, error: _phoneErr,
            onChanged: (_) => setState(() => _phoneErr = null),
            prefix: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Text('+91', style: TextStyle(fontWeight: FontWeight.w600,
                  color: AppColors.textDark, fontSize: 14)),
            ),
          ),
          const SizedBox(height: 18),
          AppTextField(
            label: 'Password', hint: 'Min. 8 characters',
            controller: _passCtrl, obscure: _obscureP, error: _passErr,
            onChanged: (_) => setState(() => _passErr = null),
            suffix: IconButton(
              icon: Icon(_obscureP ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20, color: AppColors.textGrey),
              onPressed: () => setState(() => _obscureP = !_obscureP),
            ),
          ),
          if (_passCtrl.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(children: List.generate(4, (i) => Expanded(child: Container(
              margin: const EdgeInsets.only(right: 4), height: 4,
              decoration: BoxDecoration(
                color: i < _strength ? _sc : AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            )))),
            const SizedBox(height: 4),
            Align(alignment: Alignment.centerRight,
                child: Text(_sl, style: TextStyle(fontSize: 11, color: _sc, fontWeight: FontWeight.w600))),
          ],
          const SizedBox(height: 18),
          AppTextField(
            label: 'Confirm Password', hint: 'Re-enter password',
            controller: _cpassCtrl, obscure: _obscureC, error: _cpassErr,
            onChanged: (_) => setState(() => _cpassErr = null),
            suffix: IconButton(
              icon: Icon(_obscureC ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20, color: AppColors.textGrey),
              onPressed: () => setState(() => _obscureC = !_obscureC),
            ),
          ),
          const SizedBox(height: 32),
          AppButton(label: 'Continue', onTap: _submitForm, loading: _loading),
        ],
      ),
    );
  }
}

// ── OTP verification step (reused for email and phone) ────────────
class _OtpStep extends StatefulWidget {
  final String title, subtitle;
  final bool isEmail;
  final VoidCallback onVerified;
  const _OtpStep({Key? key, required this.title, required this.subtitle,
      required this.isEmail, required this.onVerified}) : super(key: key);
  @override
  State<_OtpStep> createState() => _OtpStepState();
}

class _OtpStepState extends State<_OtpStep> with SingleTickerProviderStateMixin {
  late final String _otp = List.generate(6, (_) => Random().nextInt(10)).join();
  bool _showBanner = true;
  int _bannerSecs = 30, _resendSecs = 60;
  Timer? _bannerT, _resendT;
  bool _loading = false, _hasErr = false;

  final _ctrls = List.generate(6, (_) => TextEditingController());
  final _nodes = List.generate(6, (_) => FocusNode());
  late AnimationController _shake;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shake = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnim = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn)).animate(_shake)
      ..addStatusListener((s) { if (s == AnimationStatus.completed) _shake.reverse(); });
    _startBanner(); _startResend();
  }

  void _startBanner() {
    _bannerT?.cancel();
    setState(() { _bannerSecs = 30; _showBanner = true; });
    _bannerT = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() { if (_bannerSecs > 1) _bannerSecs--; else { _showBanner = false; t.cancel(); } });
    });
  }

  void _startResend() {
    _resendT?.cancel();
    setState(() => _resendSecs = 60);
    _resendT = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() { if (_resendSecs > 0) _resendSecs--; else t.cancel(); });
    });
  }

  void _onDigit(int i, String v) {
    if (v.length == 1 && i < 5) _nodes[i + 1].requestFocus();
    else if (v.isEmpty && i > 0) _nodes[i - 1].requestFocus();
    if (_ctrls.map((c) => c.text).join().length == 6) _verify();
  }

  void _verify() {
    final entered = _ctrls.map((c) => c.text).join();
    if (entered == _otp) {
      setState(() => _loading = true);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        widget.onVerified();
      });
    } else {
      setState(() => _hasErr = true);
      _shake.forward(from: 0);
      for (final c in _ctrls) c.clear();
      _nodes[0].requestFocus();
    }
  }

  @override
  void dispose() {
    _bannerT?.cancel(); _resendT?.cancel(); _shake.dispose();
    for (final c in _ctrls) c.dispose();
    for (final n in _nodes) n.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepDots(current: widget.isEmail ? 1 : 2, total: 3),
          const SizedBox(height: 24),

          if (_showBanner)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(widget.isEmail ? Icons.email_outlined : Icons.sms_outlined,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                        children: [
                          const TextSpan(text: 'OTP: '),
                          TextSpan(text: _otp,
                              style: const TextStyle(fontWeight: FontWeight.w800,
                                  letterSpacing: 4, color: AppColors.primary, fontSize: 15)),
                          TextSpan(text: '  (${_bannerSecs}s)',
                              style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _showBanner = false),
                    child: const Icon(Icons.close, size: 16, color: AppColors.textGrey),
                  ),
                ],
              ),
            ),

          Text(widget.title, style: AppTextStyles.heading),
          const SizedBox(height: 6),
          Text(widget.subtitle,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 14)),
          const SizedBox(height: 36),

          AnimatedBuilder(
            animation: _shakeAnim,
            builder: (_, child) => Transform.translate(
              offset: Offset(_shakeAnim.value * sin(_shake.value * pi * 6), 0),
              child: child,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) => _OtpBox2(
                controller: _ctrls[i], focusNode: _nodes[i],
                hasError: _hasErr, onChanged: (v) => _onDigit(i, v),
              )),
            ),
          ),
          if (_hasErr) ...[
            const SizedBox(height: 10),
            const Text('Incorrect OTP. Please try again.',
                style: TextStyle(color: AppColors.error, fontSize: 13)),
          ],
          const SizedBox(height: 32),
          AppButton(
              label: widget.isEmail ? 'Verify Email' : 'Verify Phone & Create Account',
              onTap: _verify, loading: _loading),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: _resendSecs == 0 ? () { _startBanner(); _startResend();
                for (final c in _ctrls) c.clear(); setState(() => _hasErr = false); } : null,
              child: RichText(
                text: TextSpan(style: const TextStyle(fontSize: 14), children: [
                  const TextSpan(text: "Didn't receive? ",
                      style: TextStyle(color: AppColors.textGrey)),
                  TextSpan(
                    text: _resendSecs > 0 ? 'Resend in ${_resendSecs}s' : 'Resend',
                    style: TextStyle(
                        color: _resendSecs > 0 ? AppColors.textGrey : AppColors.primary,
                        fontWeight: FontWeight.w600),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpBox2 extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;
  const _OtpBox2({required this.controller, required this.focusNode,
      required this.hasError, required this.onChanged});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 46, height: 56,
        child: TextField(
          controller: controller, focusNode: focusNode,
          textAlign: TextAlign.center, keyboardType: TextInputType.number,
          maxLength: 1, onChanged: onChanged,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
              color: AppColors.textDark),
          decoration: InputDecoration(
            counterText: '', filled: true, fillColor: AppColors.surface,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: hasError ? AppColors.error : AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2)),
          ),
        ),
      );
}

// ── Step dots indicator ──────────────────────────────────────────
class _StepDots extends StatelessWidget {
  final int current, total;
  const _StepDots({required this.current, required this.total});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 6),
        width: i == current ? 24 : 8, height: 8,
        decoration: BoxDecoration(
          color: i == current ? AppColors.primary
              : i < current ? AppColors.primary.withOpacity(0.4) : AppColors.border,
          borderRadius: BorderRadius.circular(4),
        ),
      )),
    );
  }
}
