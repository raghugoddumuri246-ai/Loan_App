import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({Key? key}) : super(key: key);

  @override
  _LoansScreenState createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  String _selectedLoanType = 'All Loans';
  final List<String> _loanTypes = ['All Loans', 'Personal Loans', 'Home Loans', 'Auto Loans'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Text('Explore Loans', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.white)),
        ),
        
        // White Body
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF2FBF6),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown Filter
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.white, 
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderGrey)
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedLoanType,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF00D09C)),
                        items: _loanTypes.map((type) => DropdownMenuItem(
                          value: type, 
                          child: Text(type, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark))
                        )).toList(),
                        onChanged: (value) => setState(() => _selectedLoanType = value!),
                      ),
                    ),
                  ),
                ),
                
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    children: [
                      if (_selectedLoanType == 'All Loans' || _selectedLoanType == 'Personal Loans')
                        _buildLoanCard(context, 'Personal Loan', 'Up to ₹50,000', '10.5%', '60 Months', Icons.person),
                      if (_selectedLoanType == 'All Loans' || _selectedLoanType == 'Home Loans')
                        _buildLoanCard(context, 'Home Loan', 'Up to ₹500,000', '7.5%', '30 Years', Icons.home),
                      if (_selectedLoanType == 'All Loans' || _selectedLoanType == 'Auto Loans')
                        _buildLoanCard(context, 'Auto Loan', 'Up to ₹30,000', '8.0%', '84 Months', Icons.directions_car),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoanCard(BuildContext context, String title, String amount, String rate, String tenure, IconData icon) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => _buildBottomSheet(title, amount, rate, tenure, icon),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00D09C), Color(0xFF00B386)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: const Color(0xFF00D09C).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(icon, size: 150, color: Colors.white.withOpacity(0.1)),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                        child: Icon(icon, color: Colors.white, size: 28),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: const Text('Apply Now', style: TextStyle(color: Color(0xFF00D09C), fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Amount', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(width: 32),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Interest', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(rate, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet(String title, String amount, String rate, String tenure, IconData icon) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        child: ListView(
          controller: controller,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(color: AppColors.borderGrey, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF00D09C).withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: const Color(0xFF00D09C), size: 32),
                ),
                const SizedBox(width: 16),
                Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textDark)),
              ],
            ),
            const SizedBox(height: 32),
            
            // New Descriptive Paragraph
            const Text('About This Loan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 12),
            Text(
              'This $title provides you with quick access to funds tailored to your financial needs. Enjoy flexible repayment tenures and competitive interest rates, ensuring a smooth borrowing experience.',
              style: const TextStyle(fontSize: 14, color: AppColors.textLight, height: 1.6),
            ),
            const SizedBox(height: 32),
            
            const Text('Loan Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 16),
            _buildDetailRow('Maximum Amount', amount),
            const Divider(height: 32),
            _buildDetailRow('Interest Rate', 'Starting at $rate APR'),
            const Divider(height: 32),
            _buildDetailRow('Maximum Tenure', tenure),
            const Divider(height: 32),
            _buildDetailRow('Processing Fee', '1.5% of loan amount + GST'),
            
            const SizedBox(height: 32),
            const Text('Eligibility & Rules', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 16),
            _buildBulletPoint('Age must be between 21 and 58 years.'),
            _buildBulletPoint('Minimum monthly income of ₹2,500.'),
            _buildBulletPoint('Minimum CIBIL Score of 700.'),
            _buildBulletPoint('Pre-closure allowed after 6 EMIs (3% charge).'),
            
            const SizedBox(height: 32),
            const Text('Required Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 16),
            _buildBulletPoint('Identity Proof (Aadhaar/Passport).'),
            _buildBulletPoint('Address Proof.'),
            _buildBulletPoint('Last 3 months bank statements.'),
            
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D09C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {},
                child: const Text('Apply Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Updated to fix RenderFlex Overflow by using Expanded
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16, color: AppColors.textLight))),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Icon(Icons.circle, size: 8, color: Color(0xFF00D09C)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: AppColors.textDark, height: 1.5))),
        ],
      ),
    );
  }
}
