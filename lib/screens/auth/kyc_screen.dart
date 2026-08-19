import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import 'success_screen.dart';

class KycScreen extends StatefulWidget {
  final String? prefilledName;
  final String? prefilledPhone;

  const KycScreen({
    Key? key,
    this.prefilledName,
    this.prefilledPhone,
  }) : super(key: key);

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  late final TextEditingController _fullNameCtrl;
  final TextEditingController _dobCtrl = TextEditingController(text: '15/06/1995');
  final TextEditingController _addressCtrl = TextEditingController(text: 'Flat 402, Green Glen Layout, Bellandur');
  final TextEditingController _cityPincodeCtrl = TextEditingController(text: 'Bangalore - 560103');
  final TextEditingController _idNumberCtrl = TextEditingController(text: '5482 9102 3847');

  String _gender = 'Female';
  String _idType = 'Aadhaar Card';
  bool _documentUploaded = true;
  String _documentFileName = 'aadhaar_front_verified.jpg';
  bool _loading = false;

  String? _nameErr;
  String? _addressErr;
  String? _idErr;

  @override
  void initState() {
    super.initState();
    _fullNameCtrl = TextEditingController(text: widget.prefilledName ?? 'Aditi Sharma');
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _dobCtrl.dispose();
    _addressCtrl.dispose();
    _cityPincodeCtrl.dispose();
    _idNumberCtrl.dispose();
    super.dispose();
  }

  void _submitKyc() {
    setState(() {
      _nameErr = _fullNameCtrl.text.trim().isEmpty ? 'Full name is required' : null;
      _addressErr = _addressCtrl.text.trim().isEmpty ? 'Address is required' : null;
      _idErr = _idNumberCtrl.text.trim().isEmpty ? 'ID number is required' : null;
    });

    if (_nameErr == null && _addressErr == null && _idErr == null) {
      setState(() => _loading = true);
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SuccessScreen()),
        );
      });
    }
  }

  void _simulateUpload() {
    setState(() {
      _documentUploaded = true;
      _documentFileName = '${_idType.toLowerCase().replaceAll(' ', '_')}_front.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_idType document uploaded & verified.'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            'KYC Identity Verification',
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w800, fontSize: 17),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Complete your KYC', style: AppTextStyles.heading),
                const SizedBox(height: 6),
                const Text(
                  'As per RBI lending guidelines, verify your basic identity & address to unlock full loan access.',
                  style: AppTextStyles.subheading,
                ),
                const SizedBox(height: 24),

                // Full Name
                AppTextField(
                  label: 'Full Name (as on ID)',
                  hint: 'Aditi Sharma',
                  controller: _fullNameCtrl,
                  error: _nameErr,
                  onChanged: (_) => setState(() => _nameErr = null),
                ),
                const SizedBox(height: 16),

                // Date of Birth & Gender Row
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: AppTextField(
                        label: 'Date of Birth',
                        hint: 'DD/MM/YYYY',
                        controller: _dobCtrl,
                        keyboardType: TextInputType.datetime,
                        suffix: const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textGrey),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Gender', style: AppTextStyles.label),
                          const SizedBox(height: 6),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _gender,
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textGrey, size: 20),
                                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark, fontSize: 13),
                                dropdownColor: Colors.white,
                                items: ['Female', 'Male', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                                onChanged: (v) => setState(() => _gender = v!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Current Address
                AppTextField(
                  label: 'Current Residential Address',
                  hint: 'House/Flat No, Street, Landmark',
                  controller: _addressCtrl,
                  error: _addressErr,
                  onChanged: (_) => setState(() => _addressErr = null),
                ),
                const SizedBox(height: 16),

                // City & Pin Code
                AppTextField(
                  label: 'City & Pin Code',
                  hint: 'Bangalore - 560103',
                  controller: _cityPincodeCtrl,
                ),
                const SizedBox(height: 20),

                // ID Document Type Selector
                const Text('Government ID Type', style: AppTextStyles.label),
                const SizedBox(height: 8),
                Row(
                  children: ['Aadhaar Card', 'PAN Card', 'Passport'].map((type) {
                    final isSel = _idType == type;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _idType = type),
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSel ? AppColors.primary.withOpacity(0.12) : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSel ? AppColors.primary : AppColors.border),
                          ),
                          child: Center(
                            child: Text(
                              type,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                color: isSel ? AppColors.primary : AppColors.textDark,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // ID Number
                AppTextField(
                  label: '$_idType Number',
                  hint: _idType == 'Aadhaar Card'
                      ? '5482 9102 3847'
                      : _idType == 'PAN Card'
                          ? 'ABCDE1234F'
                          : 'A1234567',
                  controller: _idNumberCtrl,
                  error: _idErr,
                  onChanged: (_) => setState(() => _idErr = null),
                ),
                const SizedBox(height: 20),

                // Document Photo Upload Section
                const Text('Upload Document Photo', style: AppTextStyles.label),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _simulateUpload,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _documentUploaded ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _documentUploaded ? AppColors.primary.withOpacity(0.4) : AppColors.border,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _documentUploaded ? Icons.task_alt_rounded : Icons.cloud_upload_outlined,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _documentUploaded ? _documentFileName : 'Upload $_idType (Front Photo)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: _documentUploaded ? AppColors.primary : AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _documentUploaded ? 'Verified & Attached · 1.4 MB' : 'PNG, JPG or PDF (Max 5MB)',
                                style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            _documentUploaded ? 'Change' : 'Browse',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                AppButton(
                  label: 'Submit KYC & Complete Profile',
                  onTap: _submitKyc,
                  loading: _loading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
