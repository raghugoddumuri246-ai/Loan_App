import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../dashboard/customer_dashboard_screen.dart';

/// Phone login: enter phone → OTP verify → Dashboard
class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({Key? key}) : super(key: key);
  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneCtrl = TextEditingController();
  String? _phoneErr;
  bool _sent = false;

  void _sendOtp() {
    setState(() {
      _phoneErr = _phoneCtrl.text.trim().length < 10
          ? 'Enter a valid 10-digit number' : null;
    });
    if (_phoneErr == null) {
      setState(() => _sent = true);
    }
  }

  @override
  void dispose() { _phoneCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Phone Sign In'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: _sent
            ? _PhoneOtpEntry(phone: _phoneCtrl.text.trim())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter your phone', style: AppTextStyles.heading),
                  const SizedBox(height: 8),
                  const Text('We\'ll send an OTP to verify',
                      style: AppTextStyles.subheading),
                  const SizedBox(height: 36),
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
                      child: Text('+91',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppButton(label: 'Send OTP', onTap: _sendOtp),
                ],
              ),
      ),
    );
  }
}

class _PhoneOtpEntry extends StatefulWidget {
  final String phone;
  const _PhoneOtpEntry({required this.phone});
  @override
  State<_PhoneOtpEntry> createState() => _PhoneOtpEntryState();
}

class _PhoneOtpEntryState extends State<_PhoneOtpEntry>
    with SingleTickerProviderStateMixin {
  late final String _otp = List.generate(6, (_) => Random().nextInt(10)).join();
  bool _showBanner = true;
  int _bannerSecs = 30;
  int _resendSecs = 60;
  Timer? _bannerT, _resendT;
  bool _loading = false;
  bool _hasErr = false;

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
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const CustomerDashboardScreen()),
            (r) => false);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                const Icon(Icons.sms_outlined, color: AppColors.primary, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                      children: [
                        const TextSpan(text: 'OTP: '),
                        TextSpan(text: _otp,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, letterSpacing: 4,
                                color: AppColors.primary, fontSize: 15)),
                        TextSpan(text: '  (${_bannerSecs}s)',
                            style: const TextStyle(
                                color: AppColors.textGrey, fontSize: 11)),
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

        const Text('Verify OTP', style: AppTextStyles.heading),
        const SizedBox(height: 6),
        Text('Sent to +91 ${widget.phone}',
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
            children: List.generate(6, (i) => _OtpBox(
              controller: _ctrls[i], focusNode: _nodes[i],
              hasError: _hasErr, onChanged: (v) => _onDigit(i, v),
            )),
          ),
        ),

        if (_hasErr) ...[
          const SizedBox(height: 10),
          const Text('Incorrect OTP. Try again.',
              style: TextStyle(color: AppColors.error, fontSize: 13)),
        ],

        const SizedBox(height: 32),
        AppButton(label: 'Verify & Sign In', onTap: _verify, loading: _loading),
        const SizedBox(height: 20),
        Center(
          child: GestureDetector(
            onTap: _resendSecs == 0 ? () { _startBanner(); _startResend(); for (final c in _ctrls) c.clear(); setState(() => _hasErr = false); } : null,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14),
                children: [
                  const TextSpan(text: "Didn't receive? ",
                      style: TextStyle(color: AppColors.textGrey)),
                  TextSpan(
                    text: _resendSecs > 0 ? 'Resend in ${_resendSecs}s' : 'Resend OTP',
                    style: TextStyle(
                        color: _resendSecs > 0 ? AppColors.textGrey : AppColors.primary,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;
  const _OtpBox({required this.controller, required this.focusNode,
      required this.hasError, required this.onChanged});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 46, height: 56,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          onChanged: onChanged,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
              color: AppColors.textDark),
          decoration: InputDecoration(
            counterText: '',
            filled: true, fillColor: AppColors.surface,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: hasError ? AppColors.error : AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2)),
          ),
        ),
      );
}
