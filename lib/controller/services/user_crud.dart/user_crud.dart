import 'dart:developer';

import 'package:amazon/constants/common_func.dart';
import 'package:amazon/constants/const.dart';
import 'package:amazon/model/addressmodel.dart';
import 'package:amazon/model/user_model.dart';
import 'package:amazon/view/auth_screen/signinLogic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';

class UserDataCRUD {
  static addnewUser(
      {required UserModel userModel, required BuildContext context}) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.phoneNumber)
          .set(userModel.toMap())
          .whenComplete(() {
        log('Data Added');
        Commonfunc.showToast(context: context, message: 'User Added Succesful');

        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const SignInLogicc(),
                type: PageTransitionType.rightToLeft),
            (route) => false);
      });
    } catch (e) {
      log(e.toString());
      Commonfunc.showToast(context: context, message: e.toString());
    }
  }

  static Future<bool> checkUser() async {
    bool userPresent = false;
    try {
      await firestore
          .collection('users')
          .where('mobileNum', isEqualTo: auth.currentUser!.phoneNumber)
          .get()
          .then((value) =>
              value.size > 0 ? userPresent = true : userPresent = false);
    } catch (e) {
      log(e.toString());
    }
    log(userPresent.toString());
    return userPresent;
  }

  static Future adduserAddress({
    required AddressModel addmodel,
    required BuildContext context,
    required String docID,
  }) async {
    try {
      await firestore
          .collection('Address')
          .doc(auth.currentUser!.phoneNumber)
          .collection('address')
          .doc(docID)
          .set(addmodel.toMap())
          .whenComplete(() {
        log('Data Added');
        Commonfunc.showToast(context: context, message: 'User Added Succesful');

        Navigator.pop(context);
      });
    } catch (e) {
      log(e.toString());
      Commonfunc.showToast(context: context, message: e.toString());
    }
  }

  static Future<bool> checkUserAddress() async {
    bool addressPresent = false;
    try {
      await firestore
          .collection('Address')
          .doc(auth.currentUser!.phoneNumber)
          .collection('address')
          //.where('mobileNum', isEqualTo: auth.currentUser!.phoneNumber)
          .get()
          .then((value) =>
              value.size > 0 ? addressPresent = true : addressPresent = false);
    } catch (e) {
      log(e.toString());
    }
    log(addressPresent.toString());
    return addressPresent;
  }

  static Future<List<AddressModel>> getAllAddress() async {
    List<AddressModel> allAddress = [];
    AddressModel defaultAddress = AddressModel();
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Address')
          .doc(auth.currentUser!.phoneNumber)
          .collection('address')
          .get();

      snapshot.docs.forEach((element) {
        allAddress.add(AddressModel.fromMap(element.data()));
        AddressModel currentAddresss = AddressModel.fromMap(element.data());
        if (currentAddresss.isDefault == true) {
          defaultAddress = currentAddresss;
        }
      });
    } catch (e) {
      log('error Found');
      log(e.toString());
    }
    for (var data in allAddress) {
      log(data.toMap().toString());
    }
    return allAddress;
  }

  static Future getCurrentSelectedAddress() async {
    AddressModel defaultAddress = AddressModel();
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Address')
          .doc(auth.currentUser!.phoneNumber)
          .collection('address')
          .get();

      snapshot.docs.forEach((element) {
        AddressModel currentAddresss = AddressModel.fromMap(element.data());
        if (currentAddresss.isDefault == true) {
          defaultAddress = currentAddresss;
        }
      });
    } catch (e) {
      log('error Found');
      log(e.toString());
    }
    return defaultAddress;
  }

  static Future<bool> userIsSeller() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('users')
          .doc(auth.currentUser!.phoneNumber)
          .get();
      if (snapshot.exists) {
        UserModel userModel = UserModel.fromMap(snapshot.data()!);
        log('User Type is: ${userModel.userType!}');
        if (userModel.userType != 'user') {
          return true;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }
}
