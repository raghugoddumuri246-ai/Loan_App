import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import 'notification_screen.dart';

class HomeDashboardView extends StatefulWidget {
  const HomeDashboardView({Key? key}) : super(key: key);

  @override
  _HomeDashboardViewState createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends State<HomeDashboardView> {
  int _selectedTab = 0; // 0: Active, 1: Pending, 2: Closed

  @override
  Widget build(BuildContext context) {
    const Color themeGreen = Color(0xFF00D09C);
    const Color paleGreen = Color(0xFFF2FBF6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hi, Welcome Back', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.white)),
                  Text('Good Morning', style: TextStyle(fontSize: 14, color: AppColors.white.withOpacity(0.9))),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.notifications_none, color: AppColors.textDark),
                ),
              ),
            ],
          ),
        ),
        
        // Balance Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.account_balance_wallet_outlined, color: AppColors.white, size: 16),
                        SizedBox(width: 4),
                        Text('Approved Limit', style: TextStyle(color: AppColors.white, fontSize: 14)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text('₹20,000', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.white)),
                  ],
                ),
              ),
              Container(height: 40, width: 1, color: AppColors.white.withOpacity(0.5)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.event_busy_outlined, color: AppColors.white, size: 16),
                        SizedBox(width: 4),
                        Text('Next EMI', style: TextStyle(color: AppColors.white, fontSize: 14)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text('₹450.00', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Progress Bar
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
          child: Container(
            height: 24,
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Container(
                  width: 120, // 40% width
                  decoration: BoxDecoration(color: AppColors.textDark, borderRadius: BorderRadius.circular(12)),
                  child: const Center(child: Text('40% Repaid', style: TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('Outstanding: ₹12,000', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 12.0, bottom: 24.0),
          child: Row(
            children: [
              const Icon(Icons.check_circle, size: 16, color: AppColors.white),
              const SizedBox(width: 8),
              Text('Your repayment track record looks excellent.', style: TextStyle(color: AppColors.white, fontSize: 13)),
            ],
          ),
        ),
        
        // Bottom White Area
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: paleGreen,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                children: [
                  // Green Middle Card (CIBIL Score)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: themeGreen, borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        // Circle Progress for Credit Score
                        Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 80, width: 80,
                                  child: CircularProgressIndicator(
                                    value: 0.85,
                                    color: AppColors.white,
                                    backgroundColor: AppColors.white.withOpacity(0.2),
                                    strokeWidth: 5,
                                  ),
                                ),
                                const Text('784', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.white)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text('CIBIL\nScore', textAlign: TextAlign.center, style: TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Container(height: 80, width: 1, color: AppColors.white.withOpacity(0.5)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.inventory_outlined, size: 20, color: AppColors.white),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Active Loans', style: TextStyle(fontSize: 11, color: AppColors.white)),
                                      Text('1 Personal Loan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Divider(color: AppColors.white.withOpacity(0.5)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month_outlined, size: 20, color: AppColors.white),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('Due Date', style: TextStyle(fontSize: 11, color: AppColors.white)),
                                      Text('Oct 15, 2026', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Tabs
                  Container(
                    height: 50,
                    decoration: BoxDecoration(color: themeGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      children: [
                        _buildTab(0, 'Active', themeGreen),
                        _buildTab(1, 'Pending', themeGreen),
                        _buildTab(2, 'Closed', themeGreen),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Loans List (Replacing EMI History)
                  if (_selectedTab == 0) ...[
                    _buildHomeLoanCard('Personal Loan', '₹15,000.00', 'APP-10293', 'Active', Icons.person),
                    const SizedBox(height: 16),
                  ] else if (_selectedTab == 1) ...[
                    _buildHomeLoanCard('Auto Loan', '₹350,000.00', 'APP-11452', 'Pending', Icons.directions_car),
                    const SizedBox(height: 16),
                  ] else ...[
                    _buildHomeLoanCard('Home Loan', '₹2,500,000.00', 'APP-09921', 'Closed', Icons.home),
                    const SizedBox(height: 16),
                  ],

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 32),

                  // About Company Section
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('About Us', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'We are committed to providing accessible and transparent financial solutions. Our mission is to empower individuals by offering competitive rates, flexible repayment options, and exceptional customer service.',
                    style: TextStyle(fontSize: 14, color: AppColors.textLight, height: 1.5),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Trusted Clients / Partners
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Trusted Partners', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildPartnerBadge('State Bank'),
                        _buildPartnerBadge('HDFC Bank'),
                        _buildPartnerBadge('ICICI'),
                        _buildPartnerBadge('Axis Bank'),
                        _buildPartnerBadge('Kotak'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Testimonials
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('What Our Clients Say', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildTestimonialCard('Sarah Jenkins', 'The loan process was incredibly fast and transparent. I received the funds exactly when I needed them most.'),
                        _buildTestimonialCard('Michael Chen', 'Excellent customer service. The flexible repayment terms helped me manage my business cash flow perfectly.'),
                        _buildTestimonialCard('Priya Patel', 'I loved the easy documentation process and the quick approval. Highly recommend their services!'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(int index, String title, Color themeGreen) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? themeGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.textDark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeLoanCard(String title, String amount, String id, String status, IconData icon) {
    Color statusColor = status == 'Active' ? const Color(0xFF00D09C) : (status == 'Pending' ? Colors.orange : AppColors.textLight);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF00D09C).withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFF00D09C)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text('ID: $id', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
              const SizedBox(height: 4),
              Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerBadge(String name) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Center(
        child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 14)),
      ),
    );
  }

  Widget _buildTestimonialCard(String name, String review) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.star, color: Colors.amber, size: 16),
              Icon(Icons.star, color: Colors.amber, size: 16),
              Icon(Icons.star, color: Colors.amber, size: 16),
              Icon(Icons.star, color: Colors.amber, size: 16),
              Icon(Icons.star, color: Colors.amber, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text('"$review"', style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontStyle: FontStyle.italic)),
          ),
          const SizedBox(height: 8),
          Text('- $name', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textLight)),
        ],
      ),
    );
  }
}
