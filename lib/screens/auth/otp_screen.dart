import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import 'success_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({Key? key, required this.phone}) : super(key: key);
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  // ── OTP generation ────────────────────────────────────────────
  late final String _generatedOtp;
  bool _showOtpBanner = true;
  int _bannerCountdown = 30; // seconds before auto-hide
  Timer? _bannerTimer;

  // ── 6-box OTP input ──────────────────────────────────────────
  final List<TextEditingController> _ctrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());
  bool _hasError = false;
  String? _errorMsg;

  // ── Resend cooldown ──────────────────────────────────────────
  int _resendCooldown = 60;
  Timer? _resendTimer;
  bool _loading = false;

  // ── Shake animation ──────────────────────────────────────────
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _generatedOtp = _randomOtp();
    _startBannerTimer();
    _startResendTimer();

    _shakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnim = Tween<double>(begin: 0, end: 12).chain(
        CurveTween(curve: Curves.elasticIn)).animate(_shakeCtrl)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) _shakeCtrl.reverse();
      });
  }

  String _randomOtp() {
    final r = Random();
    return List.generate(6, (_) => r.nextInt(10)).join();
  }

  void _startBannerTimer() {
    _bannerTimer?.cancel();
    setState(() { _bannerCountdown = 30; _showOtpBanner = true; });
    _bannerTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        if (_bannerCountdown > 1) {
          _bannerCountdown--;
        } else {
          _showOtpBanner = false;
          t.cancel();
        }
      });
    });
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _resendCooldown = 60);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        if (_resendCooldown > 0) _resendCooldown--;
        else t.cancel();
      });
    });
  }

  void _onDigitChanged(int idx, String val) {
    if (val.length == 1 && idx < 5) {
      _nodes[idx + 1].requestFocus();
    } else if (val.isEmpty && idx > 0) {
      _nodes[idx - 1].requestFocus();
    }
    // Auto-submit when all 6 filled
    final entered = _ctrls.map((c) => c.text).join();
    if (entered.length == 6) _verify();
  }

  void _verify() {
    final entered = _ctrls.map((c) => c.text).join();
    if (entered == _generatedOtp) {
      setState(() => _loading = true);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const SuccessScreen()));
      });
    } else {
      setState(() { _hasError = true; _errorMsg = 'Incorrect OTP. Please try again.'; });
      _shakeCtrl.forward(from: 0);
      // Clear boxes
      for (final c in _ctrls) c.clear();
      _nodes[0].requestFocus();
    }
  }

  void _resend() {
    if (_resendCooldown > 0) return;
    for (final c in _ctrls) c.clear();
    setState(() { _hasError = false; _errorMsg = null; });
    _startBannerTimer();
    _startResendTimer();
    _nodes[0].requestFocus();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _resendTimer?.cancel();
    _shakeCtrl.dispose();
    for (final c in _ctrls) c.dispose();
    for (final n in _nodes) n.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Verify OTP'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── OTP Banner ──────────────────────────────────
              if (_showOtpBanner)
                AnimatedSlide(
                  offset: _showOtpBanner ? Offset.zero : const Offset(0, -1),
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                              children: [
                                const TextSpan(text: 'Your OTP: '),
                                TextSpan(
                                  text: _generatedOtp,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 4,
                                      color: AppColors.primary,
                                      fontSize: 16),
                                ),
                                TextSpan(
                                  text: '  (hides in ${_bannerCountdown}s)',
                                  style: const TextStyle(
                                      color: AppColors.textGrey, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _showOtpBanner = false),
                          child: const Icon(Icons.close,
                              color: AppColors.textGrey, size: 18),
                        ),
                      ],
                    ),
                  ),
                ),

              Text('Enter OTP', style: AppTextStyles.heading),
              const SizedBox(height: 8),
              Text(
                'Sent to +91 ${widget.phone}',
                style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),

              const SizedBox(height: 40),

              // ── 6-box OTP input with shake ──────────────────
              AnimatedBuilder(
                animation: _shakeAnim,
                builder: (_, child) => Transform.translate(
                  offset: Offset(_shakeAnim.value * sin(_shakeCtrl.value * pi * 6), 0),
                  child: child,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (i) => _OtpBox(
                    controller: _ctrls[i],
                    focusNode: _nodes[i],
                    hasError: _hasError,
                    onChanged: (v) => _onDigitChanged(i, v),
                  )),
                ),
              ),

              if (_hasError && _errorMsg != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.info_outline, size: 14, color: AppColors.error),
                    const SizedBox(width: 6),
                    Text(_errorMsg!,
                        style: const TextStyle(
                            color: AppColors.error, fontSize: 13)),
                  ],
                ),
              ],

              const SizedBox(height: 36),
              AppButton(label: 'Verify', onTap: _verify, loading: _loading),

              const SizedBox(height: 28),
              Center(
                child: GestureDetector(
                  onTap: _resend,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14),
                      children: [
                        const TextSpan(
                            text: "Didn't receive OTP? ",
                            style: TextStyle(color: AppColors.textGrey)),
                        TextSpan(
                          text: _resendCooldown > 0
                              ? 'Resend in ${_resendCooldown}s'
                              : 'Resend OTP',
                          style: TextStyle(
                            color: _resendCooldown > 0
                                ? AppColors.textGrey
                                : AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Individual OTP box ──────────────────────────────────────────
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;
  const _OtpBox({
    required this.controller, required this.focusNode,
    required this.hasError, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46, height: 56,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: onChanged,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.w700,
            color: AppColors.textDark),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: hasError ? AppColors.error : AppColors.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        ),
      ),
    );
  }
}
