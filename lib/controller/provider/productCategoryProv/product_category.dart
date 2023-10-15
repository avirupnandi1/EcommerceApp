import 'package:amazon/constants/const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../model/product_modl.dart';
import '../../services/user_product_services/user_pdt_serv.dart';

class CategoryProd extends ChangeNotifier {
  List<ProductModel> products = [];
  bool productsfetched = false;

  fetchProducts({required String category}) async {
    products = [];
    products = await UsersProductService.fetchProductBasedOnCategory(
        category: category);
    productsfetched = true;
    notifyListeners();
  }
}
