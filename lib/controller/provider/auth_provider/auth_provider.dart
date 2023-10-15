import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String phoneNumber = '';
  String verificationID = '';
  String otp = '';

  updatePhone({required String num}) {
    phoneNumber = num;
    notifyListeners();
  }

  updateVerificationID({required String verID}) {
    verificationID = verID;
    notifyListeners();
  }
}
