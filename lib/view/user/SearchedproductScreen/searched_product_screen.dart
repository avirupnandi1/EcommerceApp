import 'dart:developer';

import 'package:amazon/constants/common_func.dart';
import 'package:amazon/controller/provider/users_product_provider/users_product_prov.dart';
import 'package:amazon/controller/services/user_product_services/user_pdt_serv.dart';
import 'package:amazon/model/product_modl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';

import 'package:provider/provider.dart';

import '../../../model/user_prod_modl.dart';
import '../../../utils/colors.dart';
import '../productScreen/product_screen.dart';

class searchedproductScreen extends StatefulWidget {
  const searchedproductScreen({super.key});

  @override
  State<searchedproductScreen> createState() => _searchedproductScreenState();
}

class _searchedproductScreenState extends State<searchedproductScreen> {
  TextEditingController searchcontrol = TextEditingController();
  getDay(int dayNum) {
    switch (dayNum % 7) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      case 6:
        return 'Sunday';
      default:
        'Sunday';
    }
  }

  getMonth(int deliveryDate) {
    if (DateTime.now().month == 2) {
      if (deliveryDate > 28) {
        return 'March';
      } else {
        return 'Febuary';
      }
    }
    if (DateTime.now().month == 4 ||
        DateTime.now().month == 6 ||
        DateTime.now().month == 8 ||
        DateTime.now().month == 10 ||
        DateTime.now().month == 12) {
      if ((deliveryDate > 30) && (DateTime.now().month == 12)) {
        return 'January';
      }
      if (deliveryDate > 30) {
        int month = DateTime.now().month + 1;
        switch (month) {
          case 1:
            return 'January';

          case 2:
            return 'February';

          case 3:
            return 'March';

          case 4:
            return 'April';

          case 5:
            return 'May';

          case 6:
            return 'June';

          case 7:
            return 'July';

          case 8:
            return 'August';

          case 9:
            return 'September';

          case 10:
            return 'October';

          case 11:
            return 'November';
          case 12:
            return 'December';
        }
      } else {
        int month = DateTime.now().month;
        switch (month) {
          case 1:
            return 'January';

          case 2:
            return 'February';

          case 3:
            return 'March';

          case 4:
            return 'April';

          case 5:
            return 'May';

          case 6:
            return 'June';

          case 7:
            return 'July';

          case 8:
            return 'August';

          case 9:
            return 'September';

          case 10:
            return 'October';

          case 11:
            return 'November';
          case 12:
            return 'December';
        }
      }
    }
    log(DateTime.now().month.toString());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersProductProv>().emptySearchProductList();
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
              child: Container(
                // margin: EdgeInsets.symmetric(),
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.01, vertical: height * 0.0085),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: appBarGradientColor,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back)),
                    SizedBox(
                      width: width * 0.66,
                      child: TextField(
                        controller: searchcontrol,
                        onSubmitted: (product_Name) {
                          context
                              .read<UsersProductProv>()
                              .getsearchedProducts(productName: product_Name);
                        },
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            fillColor: white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5))),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.mic,
                          color: black,
                        ))
                  ],
                ),
              ),
              preferredSize: Size(width, height * 0.1)),
          body: Consumer<UsersProductProv>(
            builder: (context, UsersProductProv, child) {
              if (UsersProductProv.productsfetched == false) {
                // return Center(
                //  child: CircularProgressIndicator(
                //   color: amber,
                // ),
                //);
                return SizedBox();
              } else {
                if (UsersProductProv.searchedProduct.isEmpty) {
                  return const Center(
                    child: Text('Oops product not found 🫤'),
                  );
                } else {
                  return ListView.builder(
                      itemCount: UsersProductProv.searchedProduct.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        ProductModel currproduct =
                            UsersProductProv.searchedProduct[index];
                        return InkWell(
                          onTap: () async {
                            await UsersProductService.addRecentlySeenProduct(
                                context: context, productModel: currproduct);
                            Navigator.push(
                                context,
                                PageTransition(
                                    child:
                                        ProdcutScrn(productModel: currproduct),
                                    type: PageTransitionType.rightToLeft));
                          },
                          child: Container(
                            height: height * 0.4,
                            width: width,
                            margin: EdgeInsets.symmetric(
                                horizontal: width * 0.03,
                                vertical: height * 0.007),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      color: greyShade1,
                                      child: Image.network(
                                        currproduct.imagesURL![0],
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )),
                                Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.02,
                                          vertical: height * 0.01),
                                      child: Column(
                                        children: [
                                          Text(
                                            currproduct.name ?? '',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: textTheme.bodySmall!
                                                .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 22),
                                          ),
                                          Commonfunc.blankSpace(
                                              height * 0.01, 0),
                                          Row(
                                            children: [
                                              Text(
                                                '0.0',
                                                style: textTheme.labelMedium!
                                                    .copyWith(
                                                        color: teal,
                                                        fontSize: 15),
                                              ),
                                              RatingBar(
                                                initialRating: 0,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: width * 0.06,
                                                ignoreGestures: true,
                                                ratingWidget: RatingWidget(
                                                  full: Icon(
                                                    Icons.star,
                                                    color: amber,
                                                  ),
                                                  half: Icon(
                                                    Icons.star_half,
                                                    color: amber,
                                                  ),
                                                  empty: Icon(
                                                    Icons.star_outline_sharp,
                                                    color: amber,
                                                  ),
                                                ),
                                                itemPadding: EdgeInsets.zero,
                                                onRatingUpdate: (rating) {},
                                              ),
                                              Text(
                                                '(0)',
                                                style: textTheme.labelMedium!
                                                    .copyWith(
                                                        color: grey,
                                                        fontSize: 15),
                                              ),
                                            ],
                                          ),
                                          Commonfunc.blankSpace(
                                              0, width * 0.02),
                                          RichText(
                                            maxLines: 2,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '₹ ',
                                                  style: textTheme.bodyMedium,
                                                ),
                                                TextSpan(
                                                  text: currproduct
                                                      .discountedPrice!
                                                      .toStringAsFixed(0),
                                                  style: textTheme.bodyLarge!
                                                      .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '\tMRP: ',
                                                  style: textTheme.labelMedium!
                                                      .copyWith(color: grey),
                                                ),
                                                TextSpan(
                                                  text:
                                                      //'₹${currproduct.price!.toStringAsFixed(0)}',
                                                      "yy",
                                                  style: textTheme.labelMedium!
                                                      .copyWith(
                                                    color: grey,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      // '\t(${currproduct.discountPercentage!.toStringAsFixed(0)}% Off)',
                                                      "uu",
                                                  style: textTheme.labelMedium!
                                                      .copyWith(
                                                    color: grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Commonfunc.blankSpace(
                                            height * 0.01,
                                            0,
                                          ),
                                          Text(
                                            'Save extra with No Cost EMI',
                                            style:
                                                textTheme.labelMedium!.copyWith(
                                              color: grey,
                                            ),
                                          ),
                                          Commonfunc.blankSpace(
                                            height * 0.01,
                                            0,
                                          ),
                                          RichText(
                                            maxLines: 2,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Get it by ',
                                                  style: textTheme.labelMedium!
                                                      .copyWith(
                                                    color: grey,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: getDay(
                                                      DateTime.now().weekday +
                                                          3),
                                                  style: textTheme.labelMedium!
                                                      .copyWith(
                                                          color: black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                                TextSpan(
                                                  text:
                                                      ', ${DateTime.now().day + 3} ',
                                                  style: textTheme.labelMedium!
                                                      .copyWith(
                                                          color: black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                                TextSpan(
                                                  text: getMonth(
                                                      DateTime.now().month),
                                                  style: textTheme.labelMedium!
                                                      .copyWith(
                                                          color: black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Commonfunc.blankSpace(
                                            height * 0.01,
                                            0,
                                          ),
                                          Text(
                                            currproduct.discountedPrice! > 500
                                                ? 'FREE Delivery by Amazon'
                                                : 'Extra delivery charges Applied',
                                            style:
                                                textTheme.labelMedium!.copyWith(
                                              color: grey,
                                            ),
                                          ),
                                          Commonfunc.blankSpace(
                                            height * 0.01,
                                            0,
                                          ),
                                          ElevatedButton(
                                              onPressed: () async {
                                                UserProductModel model =
                                                    UserProductModel(
                                                  imagesURL:
                                                      currproduct.imagesURL,
                                                  name: currproduct.name,
                                                  category:
                                                      currproduct.category,
                                                  description:
                                                      currproduct.description,
                                                  brandName:
                                                      currproduct.brandName,
                                                  manufacturerName: currproduct
                                                      .manufacturerName,
                                                  countryOfOrigin: currproduct
                                                      .countryOfOrigin,
                                                  specifications: currproduct
                                                      .specifications,
                                                  price: currproduct.price,
                                                  discountedPrice: currproduct
                                                      .discountedPrice,
                                                  productID:
                                                      currproduct.productID,
                                                  productSellerID: currproduct
                                                      .productSellerID,
                                                  inStock: currproduct.inStock,
                                                  discountPercentage:
                                                      currproduct
                                                          .discountPercentage,
                                                  productCount: 1,
                                                  time: DateTime.now(),
                                                );
                                                await UsersProductService
                                                    .addProductToCart(
                                                        context: context,
                                                        productModel: model);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: amber,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              child: Text(
                                                "Add to Cart",
                                                style: textTheme.bodyMedium,
                                              ))
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        );
                      });
                }
              }
            },
          )),
    );
  }
}
