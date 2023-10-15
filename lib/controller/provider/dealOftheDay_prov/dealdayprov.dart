import 'package:amazon/controller/services/user_product_services/user_pdt_serv.dart';
import 'package:amazon/model/product_modl.dart';
import 'package:flutter/cupertino.dart';

class DealOfTheDayProv extends ChangeNotifier {
  List<ProductModel> deals = [];
  bool dealsfetched = false;

  fetchTodaysDeal() async {
    deals = [];
    deals = await UsersProductService.featchDealOfTheDay();
    dealsfetched = true;
    notifyListeners();
  }
}
