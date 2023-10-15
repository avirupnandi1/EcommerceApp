import 'package:amazon/constants/common_func.dart';
import 'package:amazon/controller/services/auth_services/auth_serv.dart';
import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:amazon/utils/colors.dart';

import 'auth_screen.dart';

// ignore: must_be_immutable
class OTPScreen extends StatefulWidget {
  OTPScreen({super.key, required this.mobilenumber});
  String mobilenumber;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpcontrol = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        title: Image(
          image: AssetImage('assets/images/amazon_logo.png'),
          height: height * 0.05,
        ),
      ),
      body: SafeArea(
          child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Authentication required",
              style: textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 26, color: black),
            ),
            Commonfunc.blankSpace(height * 0.01, 0),
            Text(
              '${widget.mobilenumber} Change',
              style: textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Commonfunc.blankSpace(height * 0.02, 0),
            Text(
              'We have sent a One Time Password(OTP) to the mobile number above.Please enter it to complete verification',
              style: textTheme.bodyMedium!.copyWith(fontSize: 17),
            ),
            Commonfunc.blankSpace(height * 0.02, 0),
            TextField(
              controller: otpcontrol,
              decoration: InputDecoration(
                hintText: 'Enter OTP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: secondaryColor,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: grey,
                  ),
                ),
              ),
            ),
            Commonfunc.blankSpace(height * 0.02, 0),
            CommonAuthButton(
              title: "Continue",
              onPressed: () {
                AuthServices.verifyOTP(
                    context: context, otp: otpcontrol.text.trim());
              },
              btnwidth: 0.95,
            ),
            Commonfunc.blankSpace(height * 0.008, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: (() {}),
                    child: Text(
                      "Resend OTP",
                      style: textTheme.bodyMedium!
                          .copyWith(color: blue, fontSize: 16),
                    )),
              ],
            ),
            Commonfunc.blankSpace(height * 0.02, 0),
            const bottomAuthscreen(),
          ],
        ),
      )),
    );
  }
}
