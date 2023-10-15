import 'dart:io';
import 'package:amazon/constants/common_func.dart';
import 'package:amazon/controller/provider/product_prov.dart';
import 'package:amazon/controller/services/product_services/production_serv.dart';
import 'package:amazon/model/product_modl.dart';
import 'package:amazon/view/seller/product_details_common.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../constants/const.dart';

import '../../utils/colors.dart';

class AddPdtscreen extends StatefulWidget {
  const AddPdtscreen({super.key});

  @override
  State<AddPdtscreen> createState() => _AddPdtscreenState();
}

class _AddPdtscreenState extends State<AddPdtscreen> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController manufacturerNameController = TextEditingController();
  TextEditingController countryOfOriginController = TextEditingController();
  TextEditingController productSpecificationsController =
      TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController discountedProductPriceController =
      TextEditingController();
  TextEditingController categorycontroller = TextEditingController();
  String dropDownValue = 'Select Category';
  bool addProductBtnPressed = false;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SellerProductProvider>().emptyProductImagesList();
      setState(() {
        addProductBtnPressed = false;
      });
    });
  }

  onPressed() async {
    if (context.read<SellerProductProvider>().productImages.isNotEmpty) {
      setState(() {
        addProductBtnPressed = true;
      });
      await ProductServices.uploadImageToFirebaseStorage(
          images: context.read<SellerProductProvider>().productImages,
          context: context);
      List<String> imagesURLs =
          context.read<SellerProductProvider>().productImagesURL;
      Uuid uuid = const Uuid();
      String sellerID = auth.currentUser!.phoneNumber!;
      String productID = '$sellerID${uuid.v1()}';
      double discountAmount = double.parse(productPriceController.text.trim()) -
          double.parse(discountedProductPriceController.text.trim());
      double discountPercentage =
          (discountAmount / double.parse(productPriceController.text.trim())) *
              100;
      ProductModel model = ProductModel(
        imagesURL: imagesURLs,
        name: productNameController.text.trim(),
        category: dropDownValue,
        description: productDescriptionController.text.trim(),
        brandName: brandNameController.text.trim(),
        manufacturerName: manufacturerNameController.text.trim(),
        countryOfOrigin: countryOfOriginController.text.trim(),
        specifications: productSpecificationsController.text.trim(),
        price: double.parse(productPriceController.text.trim()),
        discountedPrice:
            double.parse(discountedProductPriceController.text.trim()),
        productID: productID,
        productSellerID: sellerID,
        inStock: true,
        uploadedAt: DateTime.now(),
        discountPercentage: int.parse(
          discountPercentage.toStringAsFixed(
            0,
          ),
        ),
      );

      await ProductServices.addProduct(context: context, productModel: model);
      Commonfunc.showSuccessToast(
          context: context, message: 'Product Added Successful');
    }
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage(
                      'assets/images/logo&splash/amazon_black_logo.png'),
                  height: height * 0.045,
                ),
                //const Spacer(),
                Text(
                  "Add Product",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                )
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
                Consumer<SellerProductProvider>(
                    builder: (context, SellerProductProvider, child) {
                  return Builder(builder: (context) {
                    if (SellerProductProvider.productImages.isEmpty) {
                      return InkWell(
                        onTap: () {
                          SellerProductProvider.fetchProductImagesFromGallery(
                              context: context);
                        },
                        child: Container(
                          height: height * 0.23,
                          width: width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: greyShade3)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add,
                                  size: height * 0.1, color: greyShade3),
                              Text(
                                "Add Product",
                                style: textTheme.bodyMedium!
                                    .copyWith(color: greyShade3),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      List<File> images = SellerProductProvider.productImages;
                      return Container(
                        height: height * 0.24,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: greyShade3),
                        ),
                        child: CarouselSlider(
                          options: CarouselOptions(
                              height: height * 0.24,
                              autoPlay: true,
                              viewportFraction: 1),
                          items: images.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: width,
                                  //margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                          image: FileImage(File(i.path)),
                                          fit: BoxFit.contain)),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      );
                    }
                  });
                }),
                Commonfunc.blankSpace(height * 0.02, 0),
                addProductCommonTextField(
                    textController: productNameController,
                    title: "Product Name",
                    hintText: "name"),
                addProductCommonTextField(
                  title: 'Categories',
                  hintText: 'category',
                  textController: categorycontroller,
                ),
                Commonfunc.blankSpace(height * 0.015, 0),
                addProductCommonTextField(
                  title: 'Description',
                  hintText: 'description',
                  textController: productDescriptionController,
                ),
                Commonfunc.blankSpace(height * 0.015, 0),
                addProductCommonTextField(
                  title: 'Manufacturer Name',
                  hintText: 'name',
                  textController: manufacturerNameController,
                ),
                Commonfunc.blankSpace(height * 0.015, 0),
                addProductCommonTextField(
                  title: 'Brand Name',
                  hintText: 'name',
                  textController: brandNameController,
                ),
                Commonfunc.blankSpace(height * 0.015, 0),
                addProductCommonTextField(
                  title: 'Country of Origin',
                  hintText: 'country name',
                  textController: countryOfOriginController,
                ),
                Commonfunc.blankSpace(height * 0.015, 0),
                addProductCommonTextField(
                  title: 'Product Specification',
                  hintText: 'specification',
                  textController: productSpecificationsController,
                ),
                Commonfunc.blankSpace(height * 0.015, 0),
                addProductCommonTextField(
                  title: 'Product Price',
                  hintText: 'price',
                  textController: productPriceController,
                ),
                Commonfunc.blankSpace(height * 0.015, 0),
                addProductCommonTextField(
                  title: 'Discounted Product Price',
                  hintText: 'Discounted price',
                  textController: discountedProductPriceController,
                ),
                Commonfunc.blankSpace(height * 0.02, 0),
                ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: amber,
                      minimumSize: Size(
                        width,
                        height * 0.06,
                      ),
                    ),
                    child: addProductBtnPressed
                        ? CircularProgressIndicator(
                            color: white,
                          )
                        : Text(
                            'Add Product',
                            style: textTheme.bodyMedium,
                          )),
                Commonfunc.blankSpace(height * 0.03, 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
