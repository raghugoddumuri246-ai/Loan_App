import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../utils/user_state.dart';

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
  final user = UserProfileState();
  bool _isCustomBank = false;

  final _customHolderCtrl = TextEditingController();
  final _customAccCtrl = TextEditingController();
  final _customIfscCtrl = TextEditingController();
  final _customBankNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (user.bankName.isEmpty || user.accountNumber.isEmpty) {
      _isCustomBank = true;
      _customHolderCtrl.text = user.fullName;
    }
  }

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
    final hasSavedBank = user.bankName.isNotEmpty && user.accountNumber.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Disbursal Account', style: AppTextStyles.heading),
          const SizedBox(height: 6),
          const Text('The sanctioned loan amount will be credited directly to this verified account.', style: AppTextStyles.subheading),
          const SizedBox(height: 24),

          // Primary Default Bank Card (if profile has saved bank)
          if (hasSavedBank) ...[
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
                                  user.bankName,
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
                          Text('A/C: ${user.accountNumber} · IFSC: ${user.ifscCode}', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                          const SizedBox(height: 2),
                          Text('Holder: ${user.fullName}', style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                        ],
                      ),
                    ),
                    Radio<bool>(
                      value: false,
                      groupValue: _isCustomBank,
                      activeColor: AppColors.primary,
                      onChanged: (v) => setState(() => _isCustomBank = false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Enter Bank Details Section
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _isCustomBank || !hasSavedBank ? AppColors.primary : AppColors.border, width: _isCustomBank || !hasSavedBank ? 1.5 : 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasSavedBank)
                  Row(
                    children: [
                      const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      const Text('Add Different Bank Account', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                      const Spacer(),
                      Radio<bool>(
                        value: true,
                        groupValue: _isCustomBank,
                        activeColor: AppColors.primary,
                        onChanged: (v) => setState(() => _isCustomBank = true),
                      ),
                    ],
                  )
                else
                  const Text('Enter Bank Account Details', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textDark)),
                const SizedBox(height: 14),

                AppTextField(
                  label: 'Bank Name',
                  hint: 'e.g. State Bank of India / HDFC Bank',
                  controller: _customBankNameCtrl,
                  prefix: const Icon(Icons.account_balance_outlined, size: 18, color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Account Number',
                  hint: 'e.g. 987654321098',
                  controller: _customAccCtrl,
                  keyboardType: TextInputType.number,
                  prefix: const Icon(Icons.pin_outlined, size: 18, color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Bank IFSC Code',
                  hint: 'e.g. SBIN0001234',
                  controller: _customIfscCtrl,
                  prefix: const Icon(Icons.domain_outlined, size: 18, color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Account Holder Name',
                  hint: 'e.g. Aditi Sharma',
                  controller: _customHolderCtrl,
                  prefix: const Icon(Icons.person_outline_rounded, size: 18, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          AppButton(
            label: 'Confirm & Proceed to e-Mandate',
            onTap: () {
              if (_isCustomBank || !hasSavedBank) {
                final bName = _customBankNameCtrl.text.trim().isNotEmpty ? _customBankNameCtrl.text.trim() : 'State Bank of India';
                final bAcc = _customAccCtrl.text.trim().isNotEmpty ? _customAccCtrl.text.trim() : '987654321098';
                final bIfsc = _customIfscCtrl.text.trim().isNotEmpty ? _customIfscCtrl.text.trim() : 'SBIN0001234';
                final bHolder = _customHolderCtrl.text.trim().isNotEmpty ? _customHolderCtrl.text.trim() : (user.fullName.isNotEmpty ? user.fullName : 'Customer');

                user.updateProfile(newBankName: bName, newAccountNumber: bAcc, newIfscCode: bIfsc);
                widget.onBankConfirmed(bName, bAcc, bIfsc, bHolder);
              } else {
                widget.onBankConfirmed(user.bankName, user.accountNumber, user.ifscCode, user.fullName);
              }
            },
          ),
        ],
      ),
    );
  }
}
