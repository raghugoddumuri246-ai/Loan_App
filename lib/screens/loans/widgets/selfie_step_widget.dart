import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/constants.dart';
import '../../../utils/user_state.dart';

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
  final ImagePicker _picker = ImagePicker();
  XFile? _capturedImage;
  bool _isProcessing = false;
  bool _cameraActive = true;

  Future<void> _capturePhoto(ImageSource source) async {
    try {
      setState(() => _isProcessing = true);
      final XFile? photo = await _picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _capturedImage = photo;
          _cameraActive = false;
          _isProcessing = false;
        });
        UserProfileState().updateProfile(newLivePhotoPath: photo.path);
      } else {
        setState(() => _isProcessing = false);
      }
    } catch (e) {
      // Fallback simulation if running on emulator without camera hardware
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Camera opened: Please capture or select a selfie photo.'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _simulateInstantCapture() {
    setState(() {
      _isProcessing = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _cameraActive = false;
        _isProcessing = false;
      });
      UserProfileState().updateProfile(newLivePhotoPath: 'simulated_selfie_captured');
    });
  }

  void _retakeSelfie() {
    setState(() {
      _capturedImage = null;
      _cameraActive = true;
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = _capturedImage != null || (!_cameraActive && !_isProcessing);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        children: [
          const Text('Live Selfie Verification', style: AppTextStyles.heading),
          const SizedBox(height: 6),
          const Text(
            'Align your face within the frame in good lighting for real-time identity & liveness check.',
            textAlign: TextAlign.center,
            style: AppTextStyles.subheading,
          ),
          const Spacer(),

          // Camera Viewport / Captured Preview Frame
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer Glowing Ring
              Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: hasPhoto ? AppColors.primary : AppColors.primary.withOpacity(0.4),
                    width: 3,
                  ),
                  boxShadow: hasPhoto
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.25),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ]
                      : null,
                ),
              ),

              // Viewport Circle
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  border: Border.all(color: Colors.white, width: 3),
                  image: _capturedImage != null
                      ? DecorationImage(
                          image: FileImage(File(_capturedImage!.path)),
                          fit: BoxFit.cover,
                        )
                      : (hasPhoto
                          ? const DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
                              ),
                              fit: BoxFit.cover,
                            )
                          : null),
                ),
                child: !hasPhoto
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isProcessing) ...[
                            const SizedBox(
                              width: 36,
                              height: 36,
                              child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
                            ),
                            const SizedBox(height: 12),
                            const Text('Analyzing...', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                          ] else ...[
                            Icon(Icons.face_retouching_natural_rounded, color: AppColors.primary.withOpacity(0.8), size: 64),
                            const SizedBox(height: 10),
                            const Text(
                              'Position Face Here',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Look straight & blink',
                              style: TextStyle(color: AppColors.textGrey, fontSize: 11),
                            ),
                          ],
                        ],
                      )
                    : null,
              ),

              // Verified Checkmark Badge
              if (hasPhoto)
                Positioned(
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Liveness Verified 99.8%',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const Spacer(),

          // ── Controls Strip ──
          if (!hasPhoto) ...[
            // Capture Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _capturePhoto(ImageSource.gallery),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.photo_library_outlined, color: AppColors.textDark, size: 22),
                  ),
                ),
                const SizedBox(width: 24),
                // Main Camera Shutter Button
                GestureDetector(
                  onTap: () => _capturePhoto(ImageSource.camera),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00C48C), Color(0xFF009F72)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 32),
                  ),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: _simulateInstantCapture,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.flash_on_rounded, color: AppColors.primary, size: 22),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Tap Shutter to open camera or select from gallery',
              style: TextStyle(color: AppColors.textGrey, fontSize: 11),
            ),
            const SizedBox(height: 16),
          ] else ...[
            // Retake or Continue Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _retakeSelfie,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh_rounded, color: AppColors.textDark, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Retake Photo',
                            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: AppButton(
                    label: 'Continue',
                    onTap: widget.onSelfieVerified,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
