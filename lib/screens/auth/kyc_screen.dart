import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../profile/add_bank_account_screen.dart';

class KycScreen extends StatelessWidget {
  const KycScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Complete KYC', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Clean Fintech Card wrapping the entire form
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03), // Signature soft shadow
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Personal Details', style: AppTextStyles.heading),
                    const SizedBox(height: 24),
                    
                    _buildLabel('Full Name (As per ID)'),
                    _buildTextField('Enter your full name', Icons.person_outline),
                    
                    const SizedBox(height: 16),
                    _buildLabel('Date of Birth'),
                    _buildTextField('DD/MM/YYYY', Icons.calendar_today_outlined),
                    
                    const SizedBox(height: 16),
                    _buildLabel('Current Address'),
                    _buildTextField('Enter full address', Icons.home_outlined, maxLines: 3),
                    
                    const SizedBox(height: 16),
                    _buildLabel('ID Type'),
                    _buildDropdown(['PAN Card', 'Aadhaar Card', 'Passport']),
                    
                    const SizedBox(height: 16),
                    _buildLabel('ID Number'),
                    _buildTextField('Enter ID Number', Icons.badge_outlined),
                    
                    const SizedBox(height: 24),
                    // Dashed-style Upload Box Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderGrey, style: BorderStyle.solid),
                      ),
                      child: Column(
                        children: const [
                          Icon(Icons.cloud_upload_outlined, color: AppColors.mainGreen, size: 40),
                          SizedBox(height: 8),
                          Text('Upload ID Photo', style: TextStyle(color: AppColors.mainGreen, fontWeight: FontWeight.w600)),
                          Text('PNG, JPG up to 5MB', style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddBankAccountScreen()),
                    );
                  },
                  child: const Text(
                    'Save & Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable simple label widget
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(text, style: AppTextStyles.label),
    );
  }

  // Reusable simple text field mimicking minimalist design (grey fill, no harsh borders)
  Widget _buildTextField(String hint, IconData icon, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textLight.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: AppColors.textLight),
        filled: true,
        fillColor: AppColors.lightGreenSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.mainGreen, width: 1.5),
        ),
      ),
    );
  }

  // Simple dropdown for ID types
  Widget _buildDropdown(List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightGreenSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text('Select ID Type', style: TextStyle(color: AppColors.textLight.withOpacity(0.5))),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: AppColors.textDark)),
            );
          }).toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }
}
