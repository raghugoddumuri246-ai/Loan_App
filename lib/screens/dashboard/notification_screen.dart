import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../loans/loan_status_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _activeFilter = 0; // 0: All, 1: Loans, 2: Payments, 3: Reminders

  final List<_NotifItem> _notifications = [
    _NotifItem(
      title: 'EMI Due in 2 Days',
      body: 'Your monthly EMI of ₹3,500 for Personal Loan is scheduled for auto-debit on 14 Aug.',
      time: 'Just now',
      category: 'Reminders',
      icon: Icons.schedule_rounded,
      color: const Color(0xFFD97706),
      isUnread: true,
      actionLabel: 'Pay Early',
    ),
    _NotifItem(
      title: 'Loan Pre-Approved 🎉',
      body: 'Congratulations! You are pre-approved for an Instant Cash Loan up to ₹5,00,000 at 10.5% p.a.',
      time: '2 hours ago',
      category: 'Loans',
      icon: Icons.verified_rounded,
      color: AppColors.primary,
      isUnread: true,
      actionLabel: 'View Offer',
    ),
    _NotifItem(
      title: 'EMI Payment Successful',
      body: 'Payment of ₹3,500 received via e-NACH Auto-Debit. Ref #TXN-98321045.',
      time: 'Yesterday, 10:30 AM',
      category: 'Payments',
      icon: Icons.check_circle_rounded,
      color: AppColors.primary,
      isUnread: false,
      actionLabel: 'View Receipt',
    ),
    _NotifItem(
      title: 'KYC Document Verified',
      body: 'Your Aadhaar Card and address verification have been successfully validated by our verification team.',
      time: '12 Aug, 04:15 PM',
      category: 'Loans',
      icon: Icons.shield_rounded,
      color: const Color(0xFF0D9488),
      isUnread: false,
    ),
    _NotifItem(
      title: 'Loan Disbursed to Bank',
      body: '₹85,000 has been credited to your State Bank of India account ending in ****1234.',
      time: '02 Aug, 02:00 PM',
      category: 'Payments',
      icon: Icons.account_balance_rounded,
      color: const Color(0xFF047857),
      isUnread: false,
      actionLabel: 'Check Balance',
    ),
  ];

  List<_NotifItem> get _filtered {
    if (_activeFilter == 1) return _notifications.where((n) => n.category == 'Loans').toList();
    if (_activeFilter == 2) return _notifications.where((n) => n.category == 'Payments').toList();
    if (_activeFilter == 3) return _notifications.where((n) => n.category == 'Reminders').toList();
    return _notifications;
  }

  void _markAllRead() {
    setState(() {
      for (var n in _notifications) {
        n.isUnread = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read.'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => n.isUnread).length;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textDark),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Notifications',
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w800, fontSize: 17),
          ),
          centerTitle: true,
          actions: [
            if (unreadCount > 0)
              TextButton(
                onPressed: _markAllRead,
                child: const Text(
                  'Mark all read',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            // Filter Pills
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: Row(
                children: ['All', 'Loans', 'Payments', 'Reminders'].asMap().entries.map((e) {
                  final isSel = _activeFilter == e.key;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _activeFilter = e.key),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isSel ? AppColors.primary : AppColors.border),
                          boxShadow: isSel
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            e.value,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isSel ? Colors.white : AppColors.textDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Notifications List
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.notifications_off_outlined, size: 48, color: AppColors.textGrey),
                          SizedBox(height: 12),
                          Text('No notifications found', style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 32),
                      itemCount: _filtered.length,
                      itemBuilder: (context, i) {
                        final notif = _filtered[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: notif.isUnread ? AppColors.primary.withOpacity(0.04) : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: notif.isUnread ? AppColors.primary.withOpacity(0.25) : AppColors.border,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: notif.color.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(notif.icon, color: notif.color, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            notif.title,
                                            style: TextStyle(
                                              fontWeight: notif.isUnread ? FontWeight.w800 : FontWeight.w700,
                                              fontSize: 14,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                        ),
                                        if (notif.isUnread)
                                          Container(
                                            width: 7,
                                            height: 7,
                                            decoration: const BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      notif.body,
                                      style: const TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.4),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          notif.time,
                                          style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                                        ),
                                        if (notif.actionLabel != null)
                                          GestureDetector(
                                            onTap: () {
                                              setState(() => notif.isUnread = false);
                                              if (notif.actionLabel == 'View Offer') {
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                notif.actionLabel!,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotifItem {
  final String title;
  final String body;
  final String time;
  final String category;
  final IconData icon;
  final Color color;
  bool isUnread;
  final String? actionLabel;

  _NotifItem({
    required this.title,
    required this.body,
    required this.time,
    required this.category,
    required this.icon,
    required this.color,
    required this.isUnread,
    this.actionLabel,
  });
}
