import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../auth/privacy_notice_screen.dart';

class AddBankAccountScreen extends StatefulWidget {
  const AddBankAccountScreen({Key? key}) : super(key: key);

  @override
  _AddBankAccountScreenState createState() => _AddBankAccountScreenState();
}

class _AddBankAccountScreenState extends State<AddBankAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PrivacyNoticeScreen()),
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
                    child: Text('Add Bank Account', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.white, letterSpacing: -0.5)),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Where should we send your loan amount?', style: TextStyle(fontSize: 16, color: AppColors.white.withOpacity(0.8), fontWeight: FontWeight.w400)),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Account Holder Name'),
                        _buildFigmaInput(
                          controller: _holderNameController,
                          hint: 'As per bank records',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 20),

                        _buildLabel('Bank Name'),
                        _buildFigmaInput(
                          controller: _bankNameController,
                          hint: 'e.g., State Bank of India',
                          icon: Icons.account_balance_outlined,
                        ),
                        const SizedBox(height: 20),

                        _buildLabel('Account Number'),
                        _buildFigmaInput(
                          controller: _accountNumberController,
                          hint: 'Enter account number',
                          icon: Icons.numbers,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        
                        _buildLabel('IFSC Code'),
                        _buildFigmaInput(
                          controller: _ifscController,
                          hint: 'Enter 11-digit IFSC code',
                          icon: Icons.code,
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
                            onPressed: _submitForm,
                            child: const Text('Save & Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textLight.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: AppColors.textLight, size: 22),
        filled: true,
        fillColor: AppColors.lightGreenSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.mainGreen, width: 2.0)),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
    );
  }
}
