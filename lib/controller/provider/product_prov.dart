import 'dart:io';

import 'package:amazon/controller/services/product_services/production_serv.dart';
import 'package:amazon/model/product_modl.dart';
import 'package:flutter/material.dart';

class SellerProductProvider extends ChangeNotifier {
  List<File> productImages = [];
  List<String> productImagesURL = [];
  List<ProductModel> products = [];
  bool sellerProductsFetched = false;

  fetchProductImagesFromGallery({required BuildContext context}) async {
    productImages = await ProductServices.getImages(context: context);
    notifyListeners();
  }

  updateProductImagesURL({required List<String> imageURLs}) async {
    productImagesURL = imageURLs;
    notifyListeners();
  }

  fecthSellerProducts() async {
    products = await ProductServices.getSellersProducts();
    sellerProductsFetched = true;
    notifyListeners();
  }

  emptyProductImagesList() {
    productImages = [];
    notifyListeners();
  }

  uploadProductImgToFirebase({required BuildContext context}) async {
    productImagesURL = await ProductServices.uploadImageToFirebaseStorage(
        images: productImages, context: context);
    notifyListeners();
  }
}
