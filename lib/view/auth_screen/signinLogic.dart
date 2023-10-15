import 'dart:developer';

import 'package:amazon/controller/services/auth_services/auth_serv.dart';
import 'package:amazon/controller/services/user_crud.dart/user_crud.dart';
import 'package:amazon/view/auth_screen/auth_screen.dart';
import 'package:amazon/view/seller/seller_persistant_nav.dart';
import 'package:amazon/view/user/userDataScreen/userDataInputScreen.dart';
import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:page_transition/page_transition.dart';

import '../../Home/home.dart';
import '../user/user_nav_bar/user_nav.dart';

class SignInLogicc extends StatefulWidget {
  const SignInLogicc({super.key});

  @override
  State<SignInLogicc> createState() => _SignInLogiccState();
}

class _SignInLogiccState extends State<SignInLogicc> {
  checkUser() async {
    bool userAlreadyThere = await UserDataCRUD.checkUser();
    log(userAlreadyThere.toString());
    if (userAlreadyThere == true) {
      bool userIsSeller = await UserDataCRUD.userIsSeller();
      log('start');
      log(userIsSeller.toString());
      if (userIsSeller == true) {
        Navigator.push(
          context,
          PageTransition(
            child: const SellerBottomNavBar(),
            type: PageTransitionType.rightToLeft,
          ),
        );
      } else {
        Navigator.push(
          context,
          PageTransition(
            child: const UserBottomNavBar(),
            type: PageTransitionType.rightToLeft,
          ),
        );
      }
    } else {
      Navigator.push(
        context,
        PageTransition(
          child: const UserDataInputScreen(),
          type: PageTransitionType.rightToLeft,
        ),
      );
    }
  }

  checkAuthentication() {
    bool userIsAuthenticated = AuthServices.CheckAuthentication();
    userIsAuthenticated
        ? checkUser()
        : Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const AuthScreen(),
                type: PageTransitionType.rightToLeft),
            (route) => false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuthentication();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Image(
        image: AssetImage('assets/images/logo&splash/amazon_splash_screen.png'),
        fit: BoxFit.fill,
      ),
    );
  }
}
