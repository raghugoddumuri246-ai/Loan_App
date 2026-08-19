import 'dart:async';
import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class SelfieStepWidget extends StatefulWidget {
  final VoidCallback onSelfieVerified;

  const SelfieStepWidget({
    Key? key,
    required this.onSelfieVerified,
  }) : super(key: key);

  @override
  State<SelfieStepWidget> createState() => _SelfieStepWidgetState();
}

class _SelfieStepWidgetState extends State<SelfieStepWidget> {
  bool _isScanning = false;
  bool _selfieCaptured = false;
  int _selfieCountdown = 2;
  Timer? _countdownTimer;

  void _startSelfieCapture() {
    setState(() {
      _isScanning = true;
      _selfieCountdown = 2;
    });

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_selfieCountdown > 1) {
          _selfieCountdown--;
        } else {
          _isScanning = false;
          _selfieCaptured = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        children: [
          const Text('Live Selfie Verification', style: AppTextStyles.heading),
          const SizedBox(height: 6),
          const Text(
            'Position your face inside the circle frame and hold steady.',
            textAlign: TextAlign.center,
            style: AppTextStyles.subheading,
          ),
          const Spacer(),

          // Camera Viewport Simulator Frame
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulsing ring
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selfieCaptured
                        ? AppColors.primary
                        : _isScanning
                            ? AppColors.primary
                            : AppColors.border,
                    width: 3,
                  ),
                ),
              ),
              // Inner Viewport Circle
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  image: _selfieCaptured
                      ? const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80'),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: !_selfieCaptured
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isScanning ? Icons.face_retouching_natural_rounded : Icons.face_rounded,
                            size: 72,
                            color: _isScanning ? AppColors.primary : AppColors.textGrey,
                          ),
                          if (_isScanning) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Capturing in $_selfieCountdown s...',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13),
                            ),
                          ]
                        ],
                      )
                    : null,
              ),
              if (_selfieCaptured)
                Positioned(
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_rounded, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text('Liveness Verified 99.8%', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const Spacer(),

          if (!_selfieCaptured)
            AppButton(
              label: _isScanning ? 'Hold Steady...' : 'Capture Live Photo',
              onTap: _isScanning ? null : _startSelfieCapture,
            )
          else ...[
            AppButton(
              label: 'Verify & Review Details',
              onTap: widget.onSelfieVerified,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => setState(() => _selfieCaptured = false),
              child: const Text('Recapture Photo', style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w600)),
            ),
          ],
        ],
      ),
    );
  }
}
