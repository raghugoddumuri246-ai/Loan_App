import 'package:flutter/material.dart';

/// Centralized Reactive State Manager for User Profile and KYC Data.
///
/// This singleton class maintains the complete profile information of the logged-in customer.
/// By extending [ChangeNotifier], any UI widget listening to this state (like Home, Profile,
/// Loan Flow, KYC) will automatically re-render whenever profile attributes are updated.
///
/// When connecting with a Node.js/REST backend in future phases, these methods can be hooked
/// directly to API calls (e.g. `POST /api/user/profile`, `PUT /api/user/kyc`).
class UserProfileState extends ChangeNotifier {
  // Singleton pattern initialization
  static final UserProfileState _instance = UserProfileState._internal();
  factory UserProfileState() => _instance;
  UserProfileState._internal();

  // -------------------------------------------------------------
  // Personal & Contact Information
  // -------------------------------------------------------------
  String fullName = 'Aditi Sharma';
  String email = 'aditi@example.com';
  String phone = '9876543210';
  String dob = '15/06/1995';
  String gender = 'Female';
  String address = 'Flat 402, Green Glen Layout, Bellandur';
  String cityPincode = 'Bangalore - 560103';

  // -------------------------------------------------------------
  // Employment & Financial Profile
  // -------------------------------------------------------------
  String employer = 'TechCorp Solutions Pvt Ltd';
  String designation = 'Senior Software Engineer';
  double monthlyIncome = 65000.0;
  int cibilScore = 742;
  double activeLoanAmount = 85000.0;
  double eligibleLoanAmount = 250000.0;

  // -------------------------------------------------------------
  // KYC & Statutory Government Identifiers (Unmasked)
  // -------------------------------------------------------------
  String idType = 'Aadhaar Card';
  String idNumber = '5482 9102 3847';
  String aadhaarNumber = '5482 9102 3847';
  String panNumber = 'ABCDE1234F';
  bool isKycVerified = true;
  bool isPhoneVerified = true;
  bool isEmailVerified = true;
  bool isAadhaarVerified = true;
  bool isPanVerified = true;

  // -------------------------------------------------------------
  // Disbursal Bank Account Details (Unmasked)
  // -------------------------------------------------------------
  String bankName = 'State Bank of India';
  String accountNumber = '987654321098';
  String ifscCode = 'SBIN0001234';
  String? livePhotoPath;

  /// Updates profile attributes dynamically and notifies all UI listeners across the app.
  ///
  /// Call this whenever the user submits the edit profile form, completes KYC,
  /// or modifies bank account details.
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
    String? newIdType,
    String? newIdNumber,
    String? newAadhaarNumber,
    String? newPanNumber,
    bool? newIsAadhaarVerified,
    bool? newIsPanVerified,
    String? newBankName,
    String? newAccountNumber,
    String? newIfscCode,
    String? newLivePhotoPath,
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
    if (newIdType != null) idType = newIdType;
    if (newIdNumber != null) idNumber = newIdNumber;
    if (newAadhaarNumber != null) aadhaarNumber = newAadhaarNumber;
    if (newPanNumber != null) panNumber = newPanNumber;
    if (newIsAadhaarVerified != null) isAadhaarVerified = newIsAadhaarVerified;
    if (newIsPanVerified != null) isPanVerified = newIsPanVerified;
    if (newBankName != null) bankName = newBankName;
    if (newAccountNumber != null) accountNumber = newAccountNumber;
    if (newIfscCode != null) ifscCode = newIfscCode;
    if (newLivePhotoPath != null) livePhotoPath = newLivePhotoPath;

    // Broadcast changes to all active screens
    notifyListeners();
  }
}
