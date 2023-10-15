import 'package:amazon/controller/services/user_product_services/user_pdt_serv.dart';
import 'package:amazon/model/product_modl.dart';
import 'package:flutter/material.dart';

class UsersProductProv extends ChangeNotifier {
  List<ProductModel> searchedProduct = [];
  bool productsfetched = false;
  emptySearchProductList() {
    searchedProduct = [];
    bool productsfetched = false;
    notifyListeners();
  }

  getsearchedProducts({required String productName}) async {
    searchedProduct = await UsersProductService.getProducts(productName);
    productsfetched = true;
    notifyListeners();
  }
}
