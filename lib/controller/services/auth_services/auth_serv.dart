import 'dart:developer';

import 'package:amazon/controller/provider/auth_provider/auth_provider.dart';
import 'package:amazon/view/auth_screen/otp.dart';
import 'package:amazon/view/auth_screen/signinLogic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class AuthServices {
  static bool CheckAuthentication() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      return true;
    }
    return false;
  }

  static recOTP(
      {required BuildContext context, required String mobileNo}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: mobileNo,
          verificationCompleted: (PhoneAuthCredential credential) {
            log(credential.toString());
          },
          verificationFailed: (FirebaseAuthException exception) {
            log(exception.toString());
          },
          codeSent: (String verificationID, int? resendToken) {
            context
                .read<AuthProvider>()
                .updateVerificationID(verID: verificationID);
            Navigator.push(
              context,
              PageTransition(
                child: OTPScreen(mobilenumber: mobileNo),
                type: PageTransitionType.rightToLeft,
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } catch (e) {
      log(e.toString());
    }
  }

  static verifyOTP({required BuildContext context, required String otp}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: context.read<AuthProvider>().verificationID,
          smsCode: otp);
      await auth.signInWithCredential(credential);

      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          PageTransition(
              child: const SignInLogicc(),
              type: PageTransitionType.rightToLeft));
    } catch (e) {
      log(e.toString());
    }
  }
}
