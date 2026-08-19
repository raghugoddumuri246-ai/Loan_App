import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../../utils/loan_state.dart';

/// Comprehensive EMI Repayment History & Statement Screen.
///
/// Starts completely clean/empty for user's real account.
/// Allows selecting 'Demo Sample Loan (Preview)' from the dropdown to preview mock ledger data.
class EmiHistoryScreen extends StatefulWidget {
  const EmiHistoryScreen({Key? key}) : super(key: key);

  @override
  State<EmiHistoryScreen> createState() => _EmiHistoryScreenState();
}

class _EmiHistoryScreenState extends State<EmiHistoryScreen> {
  static const String _defaultPreviewLabel = 'Demo Sample Loan (Preview)';
  static const String _emptyAccountLabel = 'My Active Loans (0)';
  String _selectedLoan = _emptyAccountLabel;
  int _activeFilter = 0; // 0: All, 1: Paid, 2: Pending, 3: Charges

  // Mock transaction preview items (shown ONLY when Demo Sample Loan is explicitly chosen)
  static const List<_TransactionItem> _mockTxns = [
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

  List<String> _getAvailableLoans(List<AppliedLoanModel> userLoans) {
    final list = <String>[];
    if (userLoans.isEmpty) {
      list.add(_emptyAccountLabel);
    } else {
      for (final l in userLoans) {
        list.add('${l.title} - ${l.id}');
      }
    }
    list.add(_defaultPreviewLabel);
    return list;
  }

  List<_TransactionItem> _getFilteredTxns(bool isPreview, AppliedLoanModel? activeLoan) {
    if (isPreview) {
      switch (_activeFilter) {
        case 1:
          return _mockTxns.where((t) => t.type == 'Paid').toList();
        case 2:
          return _mockTxns.where((t) => t.type == 'Pending').toList();
        case 3:
          return _mockTxns.where((t) => t.type == 'Charges').toList();
        default:
          return _mockTxns;
      }
    }

    if (activeLoan == null) {
      return [];
    }

    // Real user loan transactions
    final realTxns = <_TransactionItem>[];
    if (activeLoan.status == 'Approved' || activeLoan.status == 'Disbursed') {
      realTxns.add(
        _TransactionItem(
          title: 'Upcoming EMI #1',
          date: 'Due on 14th Next Month',
          amount: activeLoan.emi,
          type: 'Pending',
          method: 'e-NACH Auto-Debit',
          txnId: 'TXN-PENDING',
          isSuccess: false,
          isPending: true,
        ),
      );
    }

    switch (_activeFilter) {
      case 1:
        return realTxns.where((t) => t.type == 'Paid').toList();
      case 2:
        return realTxns.where((t) => t.type == 'Pending').toList();
      case 3:
        return realTxns.where((t) => t.type == 'Charges').toList();
      default:
        return realTxns;
    }
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
        body: ListenableBuilder(
          listenable: LoanState(),
          builder: (context, _) {
            final userLoans = LoanState().appliedLoans;
            final availableLoans = _getAvailableLoans(userLoans);

            if (!availableLoans.contains(_selectedLoan)) {
              _selectedLoan = availableLoans.first;
            }

            final isPreview = _selectedLoan == _defaultPreviewLabel;
            final activeLoan = isPreview || _selectedLoan == _emptyAccountLabel
                ? null
                : userLoans.firstWhere(
                    (l) => '${l.title} - ${l.id}' == _selectedLoan,
                    orElse: () => userLoans.first,
                  );

            final txns = _getFilteredTxns(isPreview, activeLoan);

            return Column(
              children: [
                // ── Enhanced Header with Dropdown ──
                Padding(
                  padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 10, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Repayment Ledger',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Track your EMI payments & statements',
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
                            child: const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Floating Dropdown Loan Switcher
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedLoan,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                            style: const TextStyle(
                              color: AppColors.textDark,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                            items: availableLoans.map((loan) {
                              final isDef = loan == _defaultPreviewLabel;
                              return DropdownMenuItem(
                                value: loan,
                                child: Row(
                                  children: [
                                    Icon(
                                      isDef ? Icons.preview_rounded : Icons.account_balance_wallet_rounded,
                                      color: isDef ? const Color(0xFFD97706) : AppColors.primary,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        loan,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: isDef ? FontWeight.bold : FontWeight.w700,
                                          color: isDef ? const Color(0xFFD97706) : AppColors.textDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedLoan = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── White Scrollable Content Body ──
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                      children: [
                        // Loan Summary Overview Card
                        _buildOverviewCard(isPreview, activeLoan),
                        const SizedBox(height: 18),

                        // Upcoming EMI Payment Action Card (Only if preview or approved loan exists)
                        if (isPreview || (activeLoan != null && (activeLoan.status == 'Approved' || activeLoan.status == 'Disbursed'))) ...[
                          _buildUpcomingEmiCard(isPreview, activeLoan),
                          const SizedBox(height: 20),
                        ],

                        // Filter Chips
                        Row(
                          children: [
                            _buildFilterChip(0, 'All (${txns.length})'),
                            const SizedBox(width: 8),
                            _buildFilterChip(1, 'Paid'),
                            const SizedBox(width: 8),
                            _buildFilterChip(2, 'Pending'),
                            const SizedBox(width: 8),
                            _buildFilterChip(3, 'Charges'),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Transaction List
                        if (txns.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.inbox_outlined, size: 44, color: AppColors.textLight),
                                const SizedBox(height: 12),
                                Text(
                                  activeLoan != null && activeLoan.status.toLowerCase().contains('review')
                                      ? 'Application Under Review'
                                      : 'No Transactions Yet',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textDark),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  activeLoan != null && activeLoan.status.toLowerCase().contains('review')
                                      ? 'EMI repayment ledger will be generated once underwriting approves your loan application.'
                                      : 'Select "Demo Sample Loan (Preview)" in the dropdown above to view an interactive sample ledger.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: AppColors.textGrey, fontSize: 12, height: 1.4),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: AppColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: txns.length,
                              separatorBuilder: (_, __) => const Divider(color: AppColors.border, height: 1),
                              itemBuilder: (ctx, i) => _buildTxnRow(txns[i]),
                            ),
                          ),

                        const SizedBox(height: 20),

                        // Statement Download Banner
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.file_download_outlined, color: AppColors.primary, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('Download Statement', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textDark)),
                                    SizedBox(height: 2),
                                    Text('PDF statement of all payments & interest', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Exporting account statement PDF...'),
                                      backgroundColor: AppColors.primary,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text('Export', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOverviewCard(bool isPreview, AppliedLoanModel? activeLoan) {
    final loanAmount = isPreview ? '₹1,00,000' : (activeLoan?.amount ?? '₹0');
    final paidAmount = isPreview ? '₹42,000' : '₹0';
    final remainingAmount = isPreview ? '₹58,000' : (activeLoan?.amount ?? '₹0');
    final progress = isPreview ? 0.42 : 0.0;
    final statusText = isPreview
        ? 'Active · 12/24 EMIs'
        : activeLoan != null
            ? activeLoan.status
            : 'No Active Debt';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Sanctioned', style: TextStyle(fontSize: 11, color: AppColors.textGrey, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(loanAmount, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textDark)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_rounded, size: 12, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Linear Repayment Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.primary.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Paid: $paidAmount', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
              Text('Outstanding: $remainingAmount', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textGrey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEmiCard(bool isPreview, AppliedLoanModel? activeLoan) {
    final emiAmount = isPreview ? '₹3,500' : (activeLoan?.emi ?? '₹0');
    final dueDate = isPreview ? '14 Oct 2024' : '14th Next Month';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.12),
            AppColors.primary.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.event_available_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Next Scheduled EMI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textGrey)),
                const SizedBox(height: 2),
                Text('$emiAmount due $dueDate', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textDark)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Processing 1-click EMI payment for $emiAmount...'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Pay Now', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSel = _activeFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSel ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSel ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSel ? Colors.white : AppColors.textDark,
            fontSize: 12,
            fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTxnRow(_TransactionItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: item.isSuccess
                  ? AppColors.primary.withOpacity(0.12)
                  : item.isPending
                      ? const Color(0xFFF59E0B).withOpacity(0.12)
                      : Colors.red.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.isSuccess
                  ? Icons.check_rounded
                  : item.isPending
                      ? Icons.hourglass_top_rounded
                      : Icons.priority_high_rounded,
              color: item.isSuccess
                  ? AppColors.primary
                  : item.isPending
                      ? const Color(0xFFF59E0B)
                      : Colors.red,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textDark)),
                const SizedBox(height: 2),
                Text('${item.date} · ${item.method}', style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.amount,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: item.isSuccess
                      ? AppColors.textDark
                      : item.isPending
                          ? const Color(0xFFD97706)
                          : Colors.red,
                ),
              ),
              const SizedBox(height: 2),
              Text(item.txnId, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
            ],
          ),
        ],
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
    this.isSuccess = true,
    this.isPending = false,
  });
}
