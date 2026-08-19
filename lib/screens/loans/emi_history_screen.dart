import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';

class EmiHistoryScreen extends StatefulWidget {
  const EmiHistoryScreen({Key? key}) : super(key: key);

  @override
  State<EmiHistoryScreen> createState() => _EmiHistoryScreenState();
}

class _EmiHistoryScreenState extends State<EmiHistoryScreen> {
  String _selectedLoan = 'Personal Loan - #EZ-7654';
  int _activeFilter = 0; // 0: All, 1: Paid, 2: Pending, 3: Charges

  final List<String> _loans = [
    'Personal Loan - #EZ-7654',
    'Auto Loan - #EZ-7821',
    'Home Loan - #EZ-7412',
    'Medical Loan - #EZ-7001',
  ];

  static const List<_TransactionItem> _allTxns = [
    _TransactionItem(
      title: 'Monthly EMI #12',
      date: '15 Sep 2024 · 10:30 AM',
      amount: '-₹3,500',
      type: 'Paid',
      method: 'e-NACH Auto-Debit',
      txnId: 'TXN-98321045',
      isSuccess: true,
    ),
    _TransactionItem(
      title: 'Upcoming EMI #13',
      date: 'Due on 14 Oct 2024',
      amount: '₹3,500',
      type: 'Pending',
      method: 'Scheduled Auto-Debit',
      txnId: 'TXN-PENDING',
      isSuccess: false,
      isPending: true,
    ),
    _TransactionItem(
      title: 'Monthly EMI #11',
      date: '15 Aug 2024 · 09:15 AM',
      amount: '-₹3,500',
      type: 'Paid',
      method: 'UPI (GPay)',
      txnId: 'TXN-87439201',
      isSuccess: true,
    ),
    _TransactionItem(
      title: 'Monthly EMI #10',
      date: '15 Jul 2024 · 11:45 AM',
      amount: '-₹3,500',
      type: 'Paid',
      method: 'NetBanking (SBI)',
      txnId: 'TXN-76531980',
      isSuccess: true,
    ),
    _TransactionItem(
      title: 'Late Payment Fee',
      date: '18 Jun 2024 · 02:20 PM',
      amount: '-₹200',
      type: 'Charges',
      method: 'Penalty Charge',
      txnId: 'CHG-430912',
      isSuccess: false,
    ),
    _TransactionItem(
      title: 'Monthly EMI #9',
      date: '15 Jun 2024 · 06:10 PM',
      amount: '-₹3,500',
      type: 'Paid',
      method: 'UPI (PhonePe)',
      txnId: 'TXN-65421987',
      isSuccess: true,
    ),
    _TransactionItem(
      title: 'Monthly EMI #8',
      date: '15 May 2024 · 08:30 AM',
      amount: '-₹3,500',
      type: 'Paid',
      method: 'e-NACH Auto-Debit',
      txnId: 'TXN-54310986',
      isSuccess: true,
    ),
  ];

  List<_TransactionItem> get _filteredTxns {
    switch (_activeFilter) {
      case 1:
        return _allTxns.where((t) => t.type == 'Paid').toList();
      case 2:
        return _allTxns.where((t) => t.type == 'Pending').toList();
      case 3:
        return _allTxns.where((t) => t.type == 'Charges').toList();
      default:
        return _allTxns;
    }
  }

  void _showReceiptSheet(BuildContext ctx, _TransactionItem txn) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: (txn.isSuccess ? AppColors.primary : AppColors.warning).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                txn.isSuccess ? Icons.receipt_long_rounded : Icons.pending_actions_rounded,
                color: txn.isSuccess ? AppColors.primary : AppColors.warning,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            Text(txn.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textDark)),
            const SizedBox(height: 4),
            Text(txn.amount, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textDark)),
            const SizedBox(height: 20),
            const Divider(color: AppColors.border),
            const SizedBox(height: 12),
            _buildReceiptRow('Transaction Ref', txn.txnId),
            _buildReceiptRow('Date & Time', txn.date),
            _buildReceiptRow('Payment Mode', txn.method),
            _buildReceiptRow('Status', txn.type),
            const SizedBox(height: 24),
            AppButton(
              label: 'Download Tax Receipt (PDF)',
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Receipt downloaded to device.'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
          Text(val, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark, fontSize: 13)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Green Header
            Padding(
              padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 12, 24, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Repayment & History',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Track EMIs, schedules & payment receipts',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.file_download_outlined, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),

            // White Body
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          children: [
                            // Interactive Loan Selector Dropdown
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedLoan,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                    fontSize: 14,
                                  ),
                                  dropdownColor: Colors.white,
                                  items: _loans.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                                  onChanged: (v) => setState(() => _selectedLoan = v!),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Creative Repayment Progress & Gauge Card
                            Container(
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: AppColors.primary.withOpacity(0.18)),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.08),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // Progress Gauge Circle
                                      SizedBox(
                                        width: 104,
                                        height: 104,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SizedBox(
                                              width: 104,
                                              height: 104,
                                              child: CircularProgressIndicator(
                                                value: 1,
                                                strokeWidth: 8,
                                                color: AppColors.primary.withOpacity(0.12),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 104,
                                              height: 104,
                                              child: CircularProgressIndicator(
                                                value: 0.5,
                                                strokeWidth: 8,
                                                color: AppColors.primary,
                                                strokeCap: StrokeCap.round,
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: const [
                                                Text(
                                                  '12/24',
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w800,
                                                    color: AppColors.textDark,
                                                  ),
                                                ),
                                                Text(
                                                  '50% Repaid',
                                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 20),

                                      // Summary column
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary.withOpacity(0.12),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.celebration_rounded, color: AppColors.primary, size: 14),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    'Halfway Milestone!',
                                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text('Outstanding Balance', style: TextStyle(color: AppColors.textGrey, fontSize: 11)),
                                            const Text('₹42,000', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                                            const SizedBox(height: 4),
                                            const Text('Next Due: 14 Aug · ₹3,500', style: TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 18),
                                  const Divider(color: AppColors.border),
                                  const SizedBox(height: 12),

                                  // 3 Stats Metrics Footer
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: const [
                                      _MetricCell(label: 'Total Principal', val: '₹84,000'),
                                      _Divider(),
                                      _MetricCell(label: 'Paid Amount', val: '₹42,000'),
                                      _Divider(),
                                      _MetricCell(label: 'Interest Saved', val: '₹4,820'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Pay Early & Foreclosure Banner
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF064E3B), Color(0xFF047857)],
                                ),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF064E3B).withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.18),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.savings_outlined, color: Colors.white, size: 22),
                                  ),
                                  const SizedBox(width: 14),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Pre-Pay & Save Extra', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                        SizedBox(height: 2),
                                        Text('Foreclose early with 0% penalty fee', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Text('Pay Early', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 12)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Transaction Filter Chips
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Payment Records',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark),
                                ),
                                Text(
                                  '${_filteredTxns.length} entries',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Filter Pills
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: ['All', 'Paid', 'Pending', 'Charges'].asMap().entries.map((e) {
                                  final isSel = _activeFilter == e.key;
                                  return GestureDetector(
                                    onTap: () => setState(() => _activeFilter = e.key),
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSel ? AppColors.primary : Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: isSel ? AppColors.primary : AppColors.border),
                                      ),
                                      child: Text(
                                        e.value,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: isSel ? Colors.white : AppColors.textDark,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],
                        ),
                      ),
                    ),

                    // Transactions List
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final txn = _filteredTxns[i];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: _TransactionCard(
                              txn: txn,
                              onTap: () => _showReceiptSheet(context, txn),
                            ),
                          );
                        },
                        childCount: _filteredTxns.length,
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  final String label, val;
  const _MetricCell({required this.label, required this.val});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
        const SizedBox(height: 3),
        Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textDark)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 26, color: AppColors.border);
}

class _TransactionCard extends StatelessWidget {
  final _TransactionItem txn;
  final VoidCallback onTap;

  const _TransactionCard({required this.txn, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusColor = txn.isPending
        ? AppColors.warning
        : txn.isSuccess
            ? AppColors.primary
            : AppColors.error;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                txn.isPending
                    ? Icons.schedule_rounded
                    : txn.isSuccess
                        ? Icons.check_circle_rounded
                        : Icons.info_outline_rounded,
                color: statusColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txn.title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 3),
                  Text('${txn.method} · ${txn.date}', style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  txn.amount,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: txn.isPending
                        ? AppColors.warning
                        : txn.isSuccess
                            ? AppColors.textDark
                            : AppColors.error,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    txn.type,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionItem {
  final String title;
  final String date;
  final String amount;
  final String type;
  final String method;
  final String txnId;
  final bool isSuccess;
  final bool isPending;

  const _TransactionItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.type,
    required this.method,
    required this.txnId,
    required this.isSuccess,
    this.isPending = false,
  });
}
