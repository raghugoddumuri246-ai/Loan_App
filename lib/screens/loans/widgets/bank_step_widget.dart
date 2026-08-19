import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class BankStepWidget extends StatefulWidget {
  final Function(String bankName, String accountNumber, String ifsc, String holderName) onBankConfirmed;

  const BankStepWidget({
    Key? key,
    required this.onBankConfirmed,
  }) : super(key: key);

  @override
  State<BankStepWidget> createState() => _BankStepWidgetState();
}

class _BankStepWidgetState extends State<BankStepWidget> {
  final String _bankHolderName = 'Aditi Sharma';
  final String _accountNumber = '987654321098';
  final String _ifscCode = 'SBIN0001234';
  final String _bankName = 'State Bank of India';
  bool _isCustomBank = false;

  final _customHolderCtrl = TextEditingController();
  final _customAccCtrl = TextEditingController();
  final _customIfscCtrl = TextEditingController();
  final _customBankNameCtrl = TextEditingController();

  @override
  void dispose() {
    _customHolderCtrl.dispose();
    _customAccCtrl.dispose();
    _customIfscCtrl.dispose();
    _customBankNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Disbursal Account', style: AppTextStyles.heading),
          const SizedBox(height: 6),
          const Text('The sanctioned loan amount will be credited directly to this verified account.', style: AppTextStyles.subheading),
          const SizedBox(height: 24),

          // Primary Default Bank Card
          GestureDetector(
            onTap: () => setState(() => _isCustomBank = false),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: !_isCustomBank ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: !_isCustomBank ? AppColors.primary : AppColors.border, width: !_isCustomBank ? 1.8 : 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                _bankName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                              child: const Text('Primary', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('A/C: $_accountNumber · IFSC: $_ifscCode', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                        const SizedBox(height: 2),
                        Text('Holder: $_bankHolderName', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                  Icon(
                    !_isCustomBank ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                    color: !_isCustomBank ? AppColors.primary : AppColors.textGrey,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Add / Change Bank Option
          GestureDetector(
            onTap: () => setState(() => _isCustomBank = true),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _isCustomBank ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _isCustomBank ? AppColors.primary : AppColors.border, width: _isCustomBank ? 1.8 : 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: AppColors.border.withOpacity(0.5), shape: BoxShape.circle),
                    child: const Icon(Icons.add_card_rounded, color: AppColors.textDark, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Add Different Bank Account', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                        SizedBox(height: 2),
                        Text('Provide account number & branch IFSC', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                  Icon(
                    _isCustomBank ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                    color: _isCustomBank ? AppColors.primary : AppColors.textGrey,
                  ),
                ],
              ),
            ),
          ),

          if (_isCustomBank) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter Bank Account Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
                  const SizedBox(height: 14),
                  AppTextField(label: 'Account Holder Name', hint: 'Aditi Sharma', controller: _customHolderCtrl),
                  const SizedBox(height: 12),
                  AppTextField(label: 'Account Number', hint: '112233445566', controller: _customAccCtrl, keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  AppTextField(label: 'IFSC Code', hint: 'HDFC0001234', controller: _customIfscCtrl),
                  const SizedBox(height: 12),
                  AppTextField(label: 'Bank Name', hint: 'HDFC Bank Ltd', controller: _customBankNameCtrl),
                ],
              ),
            ),
          ],

          const SizedBox(height: 28),
          AppButton(
            label: 'Proceed to Declaration',
            onTap: () {
              if (_isCustomBank) {
                if (_customAccCtrl.text.isEmpty || _customIfscCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid account number & IFSC code.')),
                  );
                  return;
                }
                widget.onBankConfirmed(
                  _customBankNameCtrl.text.isNotEmpty ? _customBankNameCtrl.text : 'HDFC Bank',
                  _customAccCtrl.text,
                  _customIfscCtrl.text,
                  _customHolderCtrl.text.isNotEmpty ? _customHolderCtrl.text : _bankHolderName,
                );
              } else {
                widget.onBankConfirmed(_bankName, _accountNumber, _ifscCode, _bankHolderName);
              }
            },
          ),
        ],
      ),
    );
  }
}
