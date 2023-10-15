import 'package:amazon/controller/services/user_crud.dart/user_crud.dart';
import 'package:amazon/model/addressmodel.dart';
import 'package:flutter/cupertino.dart';

class AddressProvider extends ChangeNotifier {
  List<AddressModel> allAddressModel = [];
  AddressModel currentSelectedAddress = AddressModel();
  bool fetchedAllAddress = false;
  bool fetchedCurrentSelectedAddress = false;
  bool addressPresent = false;

  getAllAddress() async {
    allAddressModel = await UserDataCRUD.getAllAddress();
    fetchedAllAddress = true;
    notifyListeners();
  }

  getCurrSelectedAddres() async {
    currentSelectedAddress = await UserDataCRUD.getCurrentSelectedAddress();
    addressPresent = await UserDataCRUD.checkUserAddress();
    fetchedCurrentSelectedAddress = true;
    notifyListeners();
  }
}
