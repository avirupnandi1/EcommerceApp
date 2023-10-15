import 'package:amazon/constants/common_func.dart';
import 'package:amazon/controller/services/user_product_services/user_pdt_serv.dart';
import 'package:amazon/model/product_modl.dart';
import 'package:amazon/model/user_prod_modl.dart';
import 'package:amazon/view/user/productScreen/product_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:page_transition/page_transition.dart';

import '../../../utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                children: [
                  Image(
                    image: const AssetImage(
                        'assets/images/logo&splash/amazon_black_logo.png'),
                    height: height * 0.045,
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_none,
                        color: black,
                        size: height * 0.035,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                        color: black,
                        size: height * 0.035,
                      )),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              width: width,
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              child: Column(
                children: [
                  UserGreetings(width: width, textTheme: textTheme),
                  Commonfunc.blankSpace(height * 0.01, 0),
                  YouGridBtn(width: width, textTheme: textTheme),
                  Commonfunc.blankSpace(height * 0.027, 0),
                  Orders(width: width, height: height, textTheme: textTheme),
                  Commonfunc.blankSpace(height * 0.015, 0),
                  Commonfunc.divider(),
                  keepshoppingfor(
                      width: width, height: height, textTheme: textTheme),
                  keepshoppingGrid(textTheme: textTheme),
                  Commonfunc.blankSpace(height * 0.02, 0),
                  Commonfunc.divider(),
                  BuyAgain(width: width, height: height, textTheme: textTheme),
                ],
              ),
            ),
          )),
    );
  }
}

class keepshoppingGrid extends StatelessWidget {
  const keepshoppingGrid({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return StreamBuilder(
        stream: UsersProductService.fetchKeepShoppingForProducts(),
        builder: (context, snapshot) {
          if (snapshot.data!.isEmpty) {
            return Container(
              height: height * 0.15,
              width: width,
              alignment: Alignment.center,
              child: Text(
                'Start Browsing for Products',
                style: textTheme.bodyMedium,
              ),
            );
          }

          if (snapshot.hasData) {
            List<ProductModel> products = snapshot.data!;
            return GridView.builder(
                padding: EdgeInsets.all(13),
                itemCount: (products.length > 6) ? 6 : products.length,
                shrinkWrap: true,
                physics: PageScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.84),
                itemBuilder: ((context, index) {
                  ProductModel currentProd = products[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: ProdcutScrn(productModel: currentProd),
                              type: PageTransitionType.rightToLeft));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: greyShade3,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Image(
                              image: NetworkImage(currentProd.imagesURL![0]),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Commonfunc.blankSpace(height * 0.005, 0),
                        Text(
                          currentProd.name!,
                          maxLines: 2,
                          style: textTheme.labelLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  );
                }));
          }
          if (snapshot.hasError) {
            return Container(
              height: height * 0.15,
              width: width,
              alignment: Alignment.center,
              child: Text(
                'Oops! There was an error!',
                style: textTheme.bodyMedium,
              ),
            );
          } else {
            return Container(
              height: height * 0.15,
              width: width,
              alignment: Alignment.center,
              child: Text(
                'Oops! No product found',
                style: textTheme.bodyMedium,
              ),
            );
          }
        });
  }
}

class buyAgainGrid extends StatelessWidget {
  const buyAgainGrid({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: 5,
        shrinkWrap: true,
        physics: PageScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.84),
        itemBuilder: ((context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: greyShade3,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Text(
                "Product",
                style:
                    textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
              )
            ],
          );
        }));
  }
}

class keepshoppingfor extends StatelessWidget {
  const keepshoppingfor({
    super.key,
    required this.width,
    required this.height,
    required this.textTheme,
  });

  final double width;
  final double height;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.04, vertical: height * 0.01),
      child: Row(
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: "  Keep shopping for",
                style: textTheme.bodyLarge!
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
          ])),
          Spacer(),
          TextButton(
            onPressed: () {},
            child: Text(
              "Browsing History",
              style: textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold, color: blue),
            ),
          )
        ],
      ),
    );
  }
}

class Orders extends StatelessWidget {
  const Orders({
    super.key,
    required this.width,
    required this.height,
    required this.textTheme,
  });

  final double width;
  final double height;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserProductModel>>(
        stream: UsersProductService.fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Container(
                height: height * 0.2,
                width: width,
                alignment: Alignment.center,
                child: Text(
                  "Oops! You didn't Order anything yet",
                  style: TextStyle(fontSize: 17),
                ),
              );
            } else {
              List<UserProductModel> orders = snapshot.data!;
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04, vertical: height * 0.01),
                child: Column(
                  children: [
                    Row(
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "  Your Orders",
                              style: textTheme.bodyLarge!.copyWith(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ])),
                        Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "See All",
                            style: textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold, color: blue),
                          ),
                        )
                      ],
                    ),
                    Commonfunc.blankSpace(height * 0.01, 0),
                    SizedBox(
                        height: height * 0.17,
                        child: ListView.builder(
                            itemCount: orders.length,
                            shrinkWrap: true,
                            physics: const PageScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              UserProductModel currentProduct = orders[index];
                              return InkWell(
                                onTap: () {
                                  ProductModel currmodel = ProductModel(
                                      imagesURL: currentProduct.imagesURL,
                                      name: currentProduct.name,
                                      category: currentProduct.category,
                                      description: currentProduct.description,
                                      brandName: currentProduct.brandName,
                                      manufacturerName:
                                          currentProduct.manufacturerName,
                                      countryOfOrigin:
                                          currentProduct.countryOfOrigin,
                                      specifications:
                                          currentProduct.specifications,
                                      price: currentProduct.price,
                                      discountedPrice:
                                          currentProduct.discountedPrice,
                                      productID: currentProduct.productID,
                                      productSellerID:
                                          currentProduct.productSellerID,
                                      inStock: currentProduct.inStock,
                                      uploadedAt: currentProduct.time,
                                      discountPercentage:
                                          currentProduct.discountPercentage);
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: ProdcutScrn(
                                              productModel: currmodel),
                                          type:
                                              PageTransitionType.rightToLeft));
                                },
                                child: Container(
                                  width: width * 0.4,
                                  height: height * 0.14,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.02),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: greyShade3,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Stack(
                                    children: [
                                      Image(
                                        image: NetworkImage(
                                            currentProduct.imagesURL![0]),
                                        fit: BoxFit.contain,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: white),
                                            child: Text(currentProduct
                                                .productCount!
                                                .toStringAsFixed(0))),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }))
                  ],
                ),
              );
            }
          }
          if (snapshot.hasError) {
            return Container(
              height: height * 0.2,
              width: width,
              alignment: Alignment.center,
              child: Text(
                "Oops! There is Error",
                style: TextStyle(fontSize: 17),
              ),
            );
          } else {
            return Container(
              height: height * 0.2,
              width: width,
              alignment: Alignment.center,
              child: Text(
                "Oops! No order found",
                style: TextStyle(fontSize: 17),
              ),
            );
          }
        });
  }
}

class BuyAgain extends StatelessWidget {
  const BuyAgain({
    super.key,
    required this.width,
    required this.height,
    required this.textTheme,
  });

  final double width;
  final double height;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.04, vertical: height * 0.01),
      child: Column(
        children: [
          Row(
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "  Buy Again",
                    style: textTheme.bodyLarge!
                        .copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
              ])),
              Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  "See All",
                  style: textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold, color: blue),
                ),
              )
            ],
          ),
          Commonfunc.blankSpace(height * 0.01, 0),
          SizedBox(
              height: height * 0.12,
              child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: const PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      width: height * 0.12,
                      height: height * 0.12,
                      margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: greyShade3,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                    );
                  }))
        ],
      ),
    );
  }
}

class UserGreetings extends StatelessWidget {
  const UserGreetings({
    super.key,
    required this.width,
    required this.textTheme,
  });

  final double width;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Row(
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: "   Hello,",
                style: textTheme.bodyLarge!.copyWith(fontSize: 20)),
            TextSpan(
                text: " Avirup",
                style: textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 20))
          ])),
          const Spacer(),
          Icon(
            Icons.person,
            size: 44,
          ),
        ],
      ),
    );
  }
}

class YouGridBtn extends StatelessWidget {
  const YouGridBtn({
    super.key,
    required this.width,
    required this.textTheme,
  });

  final double width;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: 4,
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3.4),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: greyShade2,
                border: Border.all(color: grey),
                borderRadius: BorderRadius.circular(40)),
            child: Builder(builder: (context) {
              if (index == 0) {
                return Text("Your Orders",
                    style: textTheme.bodyMedium!.copyWith(fontSize: 17));
              }
              if (index == 1) {
                return Text("Buy Again",
                    style: textTheme.bodyMedium!.copyWith(fontSize: 17));
              }
              if (index == 2) {
                return Text("Your Account",
                    style: textTheme.bodyMedium!.copyWith(fontSize: 17));
              }
              if (index == 3) {
                return Text("Your Order",
                    style: textTheme.bodyMedium!.copyWith(fontSize: 17));
              }
              return Text("k");
            }),
          );
        });
  }
}
