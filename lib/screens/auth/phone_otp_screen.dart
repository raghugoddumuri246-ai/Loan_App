import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'kyc_screen.dart';
import '../dashboard/customer_dashboard_screen.dart';

class PhoneOtpScreen extends StatefulWidget {
  final bool isLogin;
  const PhoneOtpScreen({Key? key, this.isLogin = false}) : super(key: key);
  @override
  _PhoneOtpScreenState createState() => _PhoneOtpScreenState();
}

class _PhoneOtpScreenState extends State<PhoneOtpScreen> {
  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() => _secondsRemaining = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
              padding: const EdgeInsets.only(left: 16.0, right: 24.0, top: 10.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Verify Phone', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.white, letterSpacing: -0.5)),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Enter the 4-digit code sent to your phone number via SMS.', style: TextStyle(fontSize: 16, color: AppColors.white.withOpacity(0.8), fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) => _buildOtpBox()),
                      ),
                      const SizedBox(height: 16),
                      
                      // Timer and Resend Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (_secondsRemaining > 0)
                            Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 16, color: AppColors.textLight),
                                const SizedBox(width: 4),
                                Text(
                                  '00:${_secondsRemaining.toString().padLeft(2, '0')}', 
                                  style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: _secondsRemaining == 0 ? _startTimer : null,
                            child: Text(
                              'Resend Code',
                              style: TextStyle(
                                color: _secondsRemaining == 0 ? AppColors.mainGreen : AppColors.textLight.withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () {
                            if (widget.isLogin) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const CustomerDashboardScreen()),
                                (route) => false,
                              );
                            } else {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const KycScreen()),
                                (route) => false,
                              );
                            }
                          },
                          child: const Text('Verify Phone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
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
    );
  }
  
  Widget _buildOtpBox() {
    return Container(
      height: 64,
      width: 64,
      decoration: BoxDecoration(
        color: AppColors.lightGreenSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: TextField(
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
          decoration: const InputDecoration(counterText: "", border: InputBorder.none),
          onChanged: (value) {
            if (value.isNotEmpty) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).previousFocus();
            }
          },
        ),
      ),
    );
  }
}
