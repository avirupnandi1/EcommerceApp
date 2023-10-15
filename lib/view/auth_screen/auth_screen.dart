import 'package:amazon/constants/common_func.dart';
import 'package:amazon/utils/colors.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

import '../../controller/services/auth_services/auth_serv.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool inLogin = true;
  String currCountryCode = '+91';
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          centerTitle: true,
          title: Image(
            image: AssetImage('assets/images/logo&splash/amazon_logo.png'),
            height: height * 0.05,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: height,
              width: width,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.03,
                vertical: height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome",
                      style: textTheme.displaySmall!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 27)),
                  Commonfunc.blankSpace(height * 0.02, 0),
                  //signin(width, height, textTheme),
                  //signinn(width, height, textTheme, context),
                  //createAccount(width, height, textTheme, context),

                  Builder(builder: (context) {
                    if (inLogin) {
                      return signinn(width, height, textTheme, context);
                    }

                    return createAccount(width, height, textTheme, context);
                  }),
                  Commonfunc.blankSpace(height * 0.05, 0),
                  bottomAuthscreen(),
                ],
              ),
            ),
          ),
        ));
  }

  Container signinn(
      double width, double height, TextTheme textTheme, BuildContext context) {
    return Container(
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.02,
          vertical: height * 0.01,
        ),
        color: white,
        child: Column(
          children: [
            signin(width, height, textTheme),
            Row(children: [
              Container(
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: width * 0.02),
                    child: InkWell(
                      onTap: (() {
                        setState(() {
                          inLogin = true;
                        });
                      }),
                      child: Container(
                        height: height * 0.03,
                        width: height * 0.025,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: grey),
                          color: white,
                        ),
                        child: Icon(
                          Icons.circle,
                          size: height * 0.018,
                          color: !inLogin ? transparent : secondaryColor,
                        ),
                      ),
                    ),
                  ),
                  Commonfunc.blankSpace(0, width * 0.03),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Sign in.',
                          style: textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        TextSpan(
                            text: '  Already User?',
                            style: textTheme.bodyLarge!.copyWith(
                              fontSize: 18,
                            )),
                      ],
                    ),
                  ),
                ]),
              ),
            ]),
            Commonfunc.blankSpace(height * 0.01, width * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (() {
                    showCountryPicker(
                        context: context,
                        onSelect: (val) {
                          setState(() {
                            currCountryCode = '+${val.phoneCode}';
                          });
                        });
                  }),
                  child: Container(
                    height: height * 0.054,
                    width: width * 0.16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: grey),
                      color: greyShade2,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      currCountryCode,
                      style: textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 11),
                  child: SizedBox(
                    height: height * 0.06,
                    width: width * 0.68,
                    child: TextFormField(
                      controller: mobilecontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Mobile Number",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: grey)),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Commonfunc.blankSpace(height * 0.0, 0),
            CommonAuthButton(
              title: 'Continue',
              onPressed: () {
                AuthServices.recOTP(
                    context: context,
                    mobileNo:
                        '$currCountryCode${mobilecontroller.text.trim()}');
              },
              btnwidth: 0.88,
            ),
            Commonfunc.blankSpace(height * 0.02, 0),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: "By Continuing you agree to Amazon\'s",
                  style: textTheme.bodySmall!.copyWith(fontSize: 15)),
              TextSpan(
                  text: " Conditions of use",
                  style: textTheme.labelMedium!
                      .copyWith(color: blue, fontSize: 15)),
              TextSpan(
                  text: " and ",
                  style: textTheme.bodySmall!.copyWith(fontSize: 15)),
              TextSpan(
                  text: "Privacy Notice",
                  style: textTheme.labelMedium!
                      .copyWith(color: blue, fontSize: 15)),
            ]))
          ],
        ));
  }

  Container createAccount(
      double width, double height, TextTheme textTheme, BuildContext context) {
    return Container(
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.02,
          vertical: height * 0.01,
        ),
        color: white,
        child: Column(
          children: [
            Row(children: [
              Container(
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 0, horizontal: width * 0.02),
                    child: InkWell(
                      onTap: (() {
                        setState(() {
                          inLogin = true;
                        });
                      }),
                      child: Container(
                        height: height * 0.03,
                        width: height * 0.025,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: grey),
                          color: white,
                        ),
                        child: Icon(
                          Icons.circle,
                          size: height * 0.018,
                          color: !inLogin ? transparent : secondaryColor,
                        ),
                      ),
                    ),
                  ),
                  Commonfunc.blankSpace(0, width * 0.03),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Create Account.',
                          style: textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        TextSpan(
                            text: ' New to Amazon?',
                            style: textTheme.bodyLarge!.copyWith(
                              fontSize: 18,
                            )),
                      ],
                    ),
                  ),
                ]),
              ),
            ]),
            Commonfunc.blankSpace(height * 0.01, width * 0.03),
            SizedBox(
              child: TextField(
                controller: namecontroller,
                decoration: InputDecoration(
                  hintText: 'First and Last Name',
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (() {
                    showCountryPicker(
                        context: context,
                        onSelect: (val) {
                          setState(() {
                            currCountryCode = '+${val.phoneCode}';
                          });
                        });
                  }),
                  child: Container(
                    height: height * 0.054,
                    width: width * 0.16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: grey),
                      color: greyShade2,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      currCountryCode,
                      style: textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 11),
                  child: SizedBox(
                    height: height * 0.06,
                    width: width * 0.68,
                    child: TextFormField(
                      controller: mobilecontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Mobile Number",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: grey)),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Commonfunc.blankSpace(height * 0.02, 0),
            Text(
              "By enrolling a mobile phone number, you consent to receive automated security notifications via text message from Amazon.\nMessage & data rates may apply.",
              style: TextStyle(fontSize: 15),
            ),
            Commonfunc.blankSpace(height * 0.02, 0),
            CommonAuthButton(
              title: 'Continue',
              onPressed: () {
                AuthServices.recOTP(
                    context: context,
                    mobileNo:
                        '$currCountryCode${mobilecontroller.text.trim()}');
              },
              btnwidth: 0.88,
            ),
            Commonfunc.blankSpace(height * 0.02, 0),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: "By Continuing you agree to Amazon\'s",
                  style: textTheme.bodySmall!.copyWith(fontSize: 15)),
              TextSpan(
                  text: " Conditions of use",
                  style: textTheme.labelMedium!
                      .copyWith(color: blue, fontSize: 15)),
              TextSpan(
                text: " and ",
                style: textTheme.bodySmall!.copyWith(fontSize: 15),
              ),
              TextSpan(
                  text: "Privacy Notice",
                  style: textTheme.labelMedium!
                      .copyWith(color: blue, fontSize: 15)),
            ])),
            Container(
              height: height * 0.06,
              width: width,
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: greyShade3)),
                  color: greyShade1),
              child: Row(children: [
                Container(
                  child: Row(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 0, horizontal: width * 0.02),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            inLogin = true;
                          });
                        },
                        child: Container(
                          height: height * 0.03,
                          width: height * 0.03,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: grey),
                            color: white,
                          ),
                          child: Icon(
                            Icons.circle,
                            size: height * 0.015,
                            color: !inLogin ? transparent : secondaryColor,
                          ),
                        ),
                      ),
                    ),
                    Commonfunc.blankSpace(0, width * 0.02),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Sign in',
                            style: textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 19),
                          ),
                          TextSpan(
                              text: ' Already a Customer?',
                              style: textTheme.bodyLarge!.copyWith(
                                fontSize: 18,
                              )),
                        ],
                      ),
                    ),
                  ]),
                ),
              ]),
            )
          ],
        ));
  }

  Container signin(double width, double height, TextTheme textTheme) {
    return Container(
      width: width,
      decoration: BoxDecoration(border: Border.all(color: greyShade3)),
      child: Column(children: [
        Container(
          height: height * 0.06,
          color: greyShade1,
          child: Row(children: [
            Container(
              child: Row(children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 0, horizontal: width * 0.03),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        inLogin = false;
                      });
                    },
                    child: Container(
                      height: height * 0.03,
                      width: height * 0.03,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: grey),
                        color: white,
                      ),
                      child: Icon(
                        Icons.circle,
                        size: height * 0.015,
                        color: !inLogin ? secondaryColor : transparent,
                      ),
                    ),
                  ),
                ),
                Commonfunc.blankSpace(0, width * 0.02),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Create Account.',
                        style: textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 19),
                      ),
                      TextSpan(
                          text: '  New to Amazon?',
                          style: textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                          )),
                    ],
                  ),
                ),
              ]),
            ),
          ]),
        )
      ]),
    );
  }
}

// ignore: must_be_immutable
class CommonAuthButton extends StatelessWidget {
  CommonAuthButton(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.btnwidth});
  String title;
  VoidCallback onPressed;
  double btnwidth;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final textTheme = Theme.of(context).textTheme;
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(width * btnwidth, height * 0.06),
          backgroundColor: amber,
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(fontSize: 21, color: black),
        ));
  }
}

class bottomAuthscreen extends StatelessWidget {
  const bottomAuthscreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          height: 2,
          width: width,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [white, greyShade3, white])),
        ),
        Commonfunc.blankSpace(height * 0.02, width),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Condition of Use",
              style: textTheme.bodyMedium!.copyWith(color: blue, fontSize: 17),
            ),
            Text(
              "Privacy Notice",
              style: textTheme.bodyMedium!.copyWith(color: blue, fontSize: 17),
            ),
            Text(
              "Help",
              style: textTheme.bodyMedium!.copyWith(color: blue, fontSize: 17),
            )
          ],
        ),
        Commonfunc.blankSpace(height * 0.01, 0),
        Text(
          '© 1996-2023, Amazon.com, Inc. or its affiliates',
          style: textTheme.labelMedium!.copyWith(color: grey, fontSize: 14.5),
        )
      ],
    );
  }
}
