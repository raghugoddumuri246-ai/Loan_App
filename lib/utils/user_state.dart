import 'package:flutter/material.dart';

/// Centralized Reactive State Manager for User Profile and KYC Data.
///
/// This singleton class maintains the complete profile information of the logged-in customer.
/// By extending [ChangeNotifier], any UI widget listening to this state (like Home, Profile,
/// Loan Flow, KYC) will automatically re-render whenever profile attributes are updated.
class UserProfileState extends ChangeNotifier {
  // Singleton pattern initialization
  static final UserProfileState _instance = UserProfileState._internal();
  factory UserProfileState() => _instance;
  UserProfileState._internal();

  // -------------------------------------------------------------
  // Personal & Contact Information (Real-time, starts empty until entered)
  // -------------------------------------------------------------
  String fullName = '';
  String email = '';
  String phone = '';
  String dob = '';
  String gender = 'Female';
  String address = '';
  String cityPincode = '';

  // -------------------------------------------------------------
  // Employment & Financial Profile
  // -------------------------------------------------------------
  String employer = '';
  String designation = '';
  double monthlyIncome = 0.0;
  int cibilScore = 742;
  double activeLoanAmount = 0.0;
  double eligibleLoanAmount = 500000.0;

  // -------------------------------------------------------------
  // KYC & Statutory Government Identifiers
  // -------------------------------------------------------------
  String idType = 'Aadhaar Card';
  String idNumber = '';
  String aadhaarNumber = '';
  String panNumber = '';
  bool isKycVerified = false;
  bool isPhoneVerified = false;
  bool isEmailVerified = false;
  bool isAadhaarVerified = false;
  bool isPanVerified = false;
  String? kycDocumentPath;
  String? livePhotoPath;

  // -------------------------------------------------------------
  // Disbursal Bank Account Details
  // -------------------------------------------------------------
  String bankName = '';
  String accountNumber = '';
  String ifscCode = '';

  /// Updates profile attributes dynamically and notifies all UI listeners across the app.
  void updateProfile({
    String? newFullName,
    String? newEmail,
    String? newPhone,
    String? newDob,
    String? newGender,
    String? newAddress,
    String? newCityPincode,
    String? newEmployer,
    String? newDesignation,
    double? newMonthlyIncome,
    int? newCibilScore,
    double? newActiveLoanAmount,
    double? newEligibleLoanAmount,
    String? newIdType,
    String? newIdNumber,
    String? newAadhaarNumber,
    String? newPanNumber,
    bool? newIsKycVerified,
    bool? newIsPhoneVerified,
    bool? newIsEmailVerified,
    bool? newIsAadhaarVerified,
    bool? newIsPanVerified,
    String? newKycDocumentPath,
    String? newLivePhotoPath,
    String? newBankName,
    String? newAccountNumber,
    String? newIfscCode,
  }) {
    if (newFullName != null) fullName = newFullName;
    if (newEmail != null) email = newEmail;
    if (newPhone != null) phone = newPhone;
    if (newDob != null) dob = newDob;
    if (newGender != null) gender = newGender;
    if (newAddress != null) address = newAddress;
    if (newCityPincode != null) cityPincode = newCityPincode;
    if (newEmployer != null) employer = newEmployer;
    if (newDesignation != null) designation = newDesignation;
    if (newMonthlyIncome != null) monthlyIncome = newMonthlyIncome;
    if (newCibilScore != null) cibilScore = newCibilScore;
    if (newActiveLoanAmount != null) activeLoanAmount = newActiveLoanAmount;
    if (newEligibleLoanAmount != null) eligibleLoanAmount = newEligibleLoanAmount;
    if (newIdType != null) idType = newIdType;
    if (newIdNumber != null) idNumber = newIdNumber;
    if (newAadhaarNumber != null) aadhaarNumber = newAadhaarNumber;
    if (newPanNumber != null) panNumber = newPanNumber;
    if (newIsKycVerified != null) isKycVerified = newIsKycVerified;
    if (newIsPhoneVerified != null) isPhoneVerified = newIsPhoneVerified;
    if (newIsEmailVerified != null) isEmailVerified = newIsEmailVerified;
    if (newIsAadhaarVerified != null) isAadhaarVerified = newIsAadhaarVerified;
    if (newIsPanVerified != null) isPanVerified = newIsPanVerified;
    if (newKycDocumentPath != null) kycDocumentPath = newKycDocumentPath;
    if (newLivePhotoPath != null) livePhotoPath = newLivePhotoPath;
    if (newBankName != null) bankName = newBankName;
    if (newAccountNumber != null) accountNumber = newAccountNumber;
    if (newIfscCode != null) ifscCode = newIfscCode;

    notifyListeners();
  }
}
