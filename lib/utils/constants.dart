import 'package:flutter/material.dart';

// ─────────────────────────────────────────
// EZFINANZ Design System — Single Source of Truth
// ─────────────────────────────────────────

class AppColors {
  // Brand
  static const Color primary     = Color(0xFF00C48C); // Main green
  static const Color primaryDark = Color(0xFF009E72); // Pressed/dark green

  // Backgrounds
  static const Color background  = Color(0xFFFFFFFF); // Pure white screen bg
  static const Color surface     = Color(0xFFF5F7FA); // Cards / input fields
  static const Color greenBg     = Color(0xFF00C48C); // Green header bg

  // Text
  static const Color textDark    = Color(0xFF0D1B2A); // Primary text
  static const Color textGrey    = Color(0xFF7B8794); // Hint / subtitle
  static const Color textLight   = Color(0xFFB0BAC9); // Placeholder

  // Borders
  static const Color border      = Color(0xFFE2E8F0); // Input / card borders
  
  // Status
  static const Color error       = Color(0xFFE53E3E);
  static const Color success     = Color(0xFF00C48C);
  static const Color warning     = Color(0xFFF6A623);

  // Compatibility aliases (used throughout older screens)
  static const Color white             = Color(0xFFFFFFFF);
  static const Color textLight2        = Color(0xFF7B8794); // alias for textGrey
  static const Color borderGrey        = Color(0xFFE2E8F0); // alias for border
  static const Color mainGreen         = Color(0xFF00C48C);
  static const Color backgroundLight   = Color(0xFFF5F7FA);
  static const Color lightGreenSurface = Color(0xFFF5F7FA);
  static const Color darkAccent        = Color(0xFF0D1B2A);
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 26, fontWeight: FontWeight.w700,
    color: AppColors.textDark, letterSpacing: -0.3,
  );
  static const TextStyle subheading = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w400,
    color: AppColors.textGrey, height: 1.5,
  );
  static const TextStyle label = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );
  static const TextStyle bodyText = TextStyle(
    fontSize: 14, color: AppColors.textDark, height: 1.5,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12, color: AppColors.textGrey,
  );
}

// ── Shared Widgets ────────────────────────────────────────────────

/// Standard full-width primary button
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  const AppButton({Key? key, required this.label, this.onTap, this.loading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: loading ? null : onTap,
        child: loading
            ? const SizedBox(width: 22, height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
            : Text(label, style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
    );
  }
}

/// Standard text input field
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscure;
  final Widget? suffix;
  final Widget? prefix;
  final String? error;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final int? maxLength;

  const AppTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.obscure = false,
    this.suffix,
    this.prefix,
    this.error,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          onChanged: onChanged,
          maxLength: maxLength,
          style: const TextStyle(fontSize: 15, color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
            hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
            filled: true,
            fillColor: AppColors.surface,
            suffixIcon: suffix,
            prefixIcon: prefix,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: error != null ? AppColors.error : AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: error != null ? AppColors.error : AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 14, color: AppColors.error),
              const SizedBox(width: 4),
              Expanded(child: Text(error!, style: const TextStyle(fontSize: 12, color: AppColors.error))),
            ],
          ),
        ],
      ],
    );
  }
}

/// Green top section that all screens use
class GreenHeader extends StatelessWidget {
  final String? title;
  final Widget? child;
  final bool showBack;
  const GreenHeader({Key? key, this.title, this.child, this.showBack = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, showBack ? 8 : 24, 24, 28),
      child: child ?? (title != null
          ? Row(
              children: [
                if (showBack) ...[
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Text(title!, style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            )
          : const SizedBox()),
    );
  }
}

/// White body container with rounded top corners
class WhiteBody extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const WhiteBody({Key? key, required this.child, this.padding = const EdgeInsets.all(24)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        child: SingleChildScrollView(padding: padding, child: child),
      ),
    );
  }
}
