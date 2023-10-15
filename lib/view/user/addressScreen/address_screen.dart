import 'package:amazon/constants/common_func.dart';
import 'package:amazon/constants/const.dart';
import 'package:amazon/controller/services/user_crud.dart/user_crud.dart';
import 'package:amazon/model/addressmodel.dart';
import 'package:amazon/view/user/addressScreen/widgets/address_screen_textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/colors.dart';

class AddressScrn extends StatefulWidget {
  const AddressScrn({super.key});

  @override
  State<AddressScrn> createState() => _AddressScrnState();
}

class _AddressScrnState extends State<AddressScrn> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController townController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(width, height * 0.08),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.01),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: addressBarGradientColor,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(
                    image: const AssetImage(
                        'assets/images/logo&splash/amazon_black_logo.png'),
                    height: height * 0.045,
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              width: width,
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.02),
              child: Column(
                children: [
                  AddressScreenTextField(
                      title: 'Enter Your Name',
                      hintText: 'Enter your Name',
                      textController: nameController),
                  Commonfunc.blankSpace(height * 0.02, 0),
                  AddressScreenTextField(
                      title: 'Enter Your Mobile Number',
                      hintText: 'Mobile Number',
                      textController: mobileController),
                  Commonfunc.blankSpace(height * 0.02, 0),
                  AddressScreenTextField(
                      title: 'Enter Your House No.',
                      hintText: 'House No',
                      textController: houseController),
                  Commonfunc.blankSpace(height * 0.02, 0),
                  AddressScreenTextField(
                      title: 'Enter Your Area',
                      hintText: 'Area Name',
                      textController: areaController),
                  Commonfunc.blankSpace(height * 0.02, 0),
                  AddressScreenTextField(
                      title: 'Enter Landmark',
                      hintText: 'Landmark',
                      textController: landmarkController),
                  Commonfunc.blankSpace(height * 0.02, 0),
                  AddressScreenTextField(
                      title: 'Enter Pincode',
                      hintText: 'Pincode',
                      textController: pincodeController),
                  Commonfunc.blankSpace(height * 0.02, 0),
                  AddressScreenTextField(
                      title: 'Enter Your Town Name',
                      hintText: 'Town Name',
                      textController: townController),
                  Commonfunc.blankSpace(height * 0.02, 0),
                  AddressScreenTextField(
                      title: 'Enter Your State Name',
                      hintText: 'State Name',
                      textController: stateController),
                  Commonfunc.blankSpace(height * 0.02, 0),
                  ElevatedButton(
                      onPressed: () {
                        Uuid uuid = Uuid();
                        String docID = uuid.v1();

                        AddressModel addModel = AddressModel(
                          name: nameController.text,
                          mobileNumber: mobileController.text.trim(),
                          authenticatedMobileNumber:
                              auth.currentUser!.phoneNumber,
                          houseNumber: houseController.text.trim(),
                          area: areaController.text.trim(),
                          landMark: landmarkController.text.trim(),
                          pincode: pincodeController.text.trim(),
                          town: townController.text.trim(),
                          state: stateController.text.trim(),
                          docID: docID,
                          isDefault: true,
                        );
                        UserDataCRUD.adduserAddress(
                            addmodel: addModel, context: context, docID: docID);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: amber,
                          minimumSize: Size(width, height * 0.06)),
                      child: Text(
                        'Add Address',
                        style: TextStyle(fontSize: 19, color: black),
                      )),
                  Commonfunc.blankSpace(height * 0.02, 0),
                ],
              ),
            ),
          )),
    );
  }
}
