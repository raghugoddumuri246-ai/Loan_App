import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'otp_screen.dart'; // EmailOtpScreen is here
import 'signup_screen.dart';
import 'phone_login_screen.dart';
import '../dashboard/customer_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const CustomerDashboardScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainGreen,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 40.0, bottom: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.white, size: 36),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Log in to manage your loan applications.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildLabel('Email'),
                        _buildFigmaInput(
                          controller: _emailController,
                          hint: 'Enter your email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),

                        _buildLabel('Password'),
                        _buildFigmaInput(
                          controller: _passwordController,
                          hint: '••••••••',
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                        ),
                        
                        const SizedBox(height: 16),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text('Forgot Password?', style: TextStyle(color: AppColors.mainGreen, fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                        
                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainGreen,
                              elevation: 4,
                              shadowColor: AppColors.mainGreen.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _submitForm,
                            child: const Text(
                              'Log in',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                        
                        Row(
                          children: [
                            Expanded(child: Divider(color: AppColors.borderGrey, thickness: 1)),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('OR', style: TextStyle(color: AppColors.textLight, fontSize: 14, fontWeight: FontWeight.bold)),
                            ),
                            Expanded(child: Divider(color: AppColors.borderGrey, thickness: 1)),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Phone Login
                        _buildOutlinedButton(
                          icon: Icons.phone_android,
                          label: 'Continue with Phone',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PhoneLoginScreen()),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Google Login
                        _buildOutlinedButton(
                          icon: Icons.g_mobiledata,
                          label: 'Continue with Google',
                          onPressed: () {},
                          iconSize: 32,
                        ),

                        const SizedBox(height: 40),

                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignupScreen()),
                              );
                            },
                            child: RichText(
                              text: const TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(color: AppColors.textLight, fontSize: 15, fontWeight: FontWeight.w500),
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(color: AppColors.mainGreen, fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(text, style: AppTextStyles.label),
    );
  }

  Widget _buildFigmaInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textLight.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: AppColors.textLight, size: 22),
        filled: true,
        fillColor: AppColors.lightGreenSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.mainGreen, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required field';
        
        if (keyboardType == TextInputType.emailAddress) {
          final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
          if (!emailRegex.hasMatch(value)) {
            return 'Enter a valid email address (e.g. name@gmail.com)';
          }
        }
        
        return null;
      },
    );
  }

  Widget _buildOutlinedButton({required IconData icon, required String label, required VoidCallback onPressed, double iconSize = 24}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.borderGrey, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          foregroundColor: AppColors.textDark,
        ),
        icon: Icon(icon, size: iconSize, color: AppColors.textDark),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        onPressed: onPressed,
      ),
    );
  }
}
