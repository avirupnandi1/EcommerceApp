import 'package:amazon/constants/common_func.dart';
import 'package:amazon/constants/const.dart';
import 'package:amazon/controller/services/user_crud.dart/user_crud.dart';
import 'package:amazon/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../utils/colors.dart';

class UserDataInputScreen extends StatefulWidget {
  const UserDataInputScreen({super.key});

  @override
  State<UserDataInputScreen> createState() => _UserDataInputScreenState();
}

class _UserDataInputScreenState extends State<UserDataInputScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      phoneController.text = auth.currentUser!.phoneNumber ?? '';
    });
  }

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
        body: Container(
          //height: height,
          width: width,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter Your Name",
                style: TextStyle(fontSize: 18),
              ),
              Commonfunc.blankSpace(height * 0.01, 0),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter Your Name',
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
              Text(
                "Phone Number",
                style: TextStyle(fontSize: 18),
              ),
              Commonfunc.blankSpace(height * 0.01, 0),
              TextField(
                controller: phoneController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Enter your Phone Number',
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
              const Spacer(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: amber,
                      minimumSize: Size(width, height * 0.06)),
                  onPressed: () {
                    UserModel use = UserModel(
                      name: nameController.text.trim(),
                      mobileNum: phoneController.text.trim(),
                      userType: 'user',
                    );
                    UserDataCRUD.addnewUser(userModel: use, context: context);
                  },
                  child: Text(
                    'Proceed',
                    style: textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
