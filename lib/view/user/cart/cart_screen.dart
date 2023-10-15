import 'package:amazon/controller/services/user_product_services/user_pdt_serv.dart';
import 'package:amazon/model/user_prod_modl.dart';
import 'package:amazon/utils/colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../constants/common_func.dart';
import '../../../constants/const.dart';
import '../../../controller/services/product_services/production_serv.dart';
import '../home/home_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final razorpay = Razorpay();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    List<UserProductModel> cartItem = await UsersProductService.fetchCart();
    DateTime currentTime = DateTime.now();
    for (var product in cartItem) {
      UserProductModel model = UserProductModel(
        imagesURL: product.imagesURL,
        name: product.name,
        category: product.category,
        description: product.description,
        brandName: product.brandName,
        manufacturerName: product.manufacturerName,
        countryOfOrigin: product.countryOfOrigin,
        specifications: product.specifications,
        price: product.price,
        discountedPrice: product.discountedPrice,
        productID: product.productID,
        productSellerID: product.productSellerID,
        inStock: product.inStock,
        discountPercentage: product.discountPercentage,
        productCount: 1,
        time: currentTime,
      );

      await ProductServices.addSalesData(
        context: context,
        productModel: product,
        userID: auth.currentUser!.phoneNumber!,
      );
      await UsersProductService.addOrder(
          context: context, productModel: product);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Commonfunc.showErrorToast(
      context: context,
      message: 'Opps! Product Purchase Failed',
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  executePayment() {
    var options = {
      'key': keyID,
      // 'amount': widget.productModel.discountedPrice! * 100,
      'amount': 1 * 100, // Amount is rs 1,
      // here amount * 100 because razorpay counts amount in paisa
      //i.e 100 paisa = 1 Rupee
      // 'image' : '<YOUR BUISNESS EMAIL>'
      'name': 'Multiple Order',
      'description': "multiple",
      'prefill': {
        'contact': auth.currentUser!.phoneNumber, //<USERS CONTACT NO.>
        'email': 'test@razorpay.com' // <USERS EMAIL NO.>
      }
    };

    razorpay.open(options);
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
          child: HomeAppBar(width: width, height: height),
        ),
        body: SingleChildScrollView(
          child: Container(
              height: height,
              width: width,
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder(
                    stream: UsersProductService.fetchCartProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            "Oops! you don't have any product in cart",
                            style: textTheme.displayMedium,
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        List<UserProductModel> cartProduct = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: "Subtotal ",
                                  style: textTheme.bodyLarge!
                                      .copyWith(fontSize: 25)),
                              TextSpan(
                                text:
                                    '₹${cartProduct.fold(0.0, (previousValue, product) => previousValue + (product.productCount! * product.discountedPrice!)).toStringAsFixed(0)}',
                                style: textTheme.displaySmall!.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 34),
                              ),
                            ])),
                            Commonfunc.blankSpace(height * 0.01, 0),
                            SizedBox(
                              height: height * 0.06,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: teal,
                                  ),
                                  Commonfunc.blankSpace(0, width * 0.01),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        RichText(
                                            textAlign: TextAlign.justify,
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                      "Your Order is eligible for FREE Delivery, ",
                                                  style: textTheme.bodySmall!
                                                      .copyWith(
                                                    color: teal,
                                                    fontSize: 16,
                                                  )),
                                              TextSpan(
                                                  text:
                                                      "Select this option at checkout.",
                                                  style: textTheme.bodySmall!
                                                      .copyWith(
                                                    fontSize: 16,
                                                  )),
                                            ])),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ElevatedButton(
                                onPressed: executePayment,
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor: amber,
                                    minimumSize: Size(width, height * 0.06)),
                                child: Text(
                                  "Proceed to Buy",
                                  style: TextStyle(fontSize: 19, color: black),
                                )),
                            Commonfunc.blankSpace(height * 0.02, 0),
                            Commonfunc.divider(),
                            Commonfunc.blankSpace(height * 0.02, 0),
                            ListView.builder(
                                itemCount: cartProduct.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  UserProductModel currenProduct =
                                      cartProduct[index];
                                  return Container(
                                    height: height * 0.27,
                                    width: width,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.02,
                                        vertical: height * 0.01),
                                    margin: EdgeInsets.symmetric(
                                      vertical: height * 0.01,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: greyShade1),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image(
                                                image: NetworkImage(
                                                    currenProduct
                                                        .imagesURL![0]),
                                                fit: BoxFit.fitHeight,
                                              ),
                                              Commonfunc.blankSpace(
                                                  height * 0.01, 0),
                                              Container(
                                                height: height * 0.06,
                                                width: width,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: greyShade3)),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 2,
                                                        child: InkWell(
                                                          onTap: () async {
                                                            if (currenProduct
                                                                    .productCount ==
                                                                1) {
                                                              await UsersProductService
                                                                  .removeProductfromCart(
                                                                      productId:
                                                                          currenProduct
                                                                              .productID!,
                                                                      context:
                                                                          context);
                                                            }

                                                            // ignore: use_build_context_synchronously
                                                            await UsersProductService.updateCountCartProduct(
                                                                productId:
                                                                    currenProduct
                                                                        .productID!,
                                                                newCount:
                                                                    currenProduct
                                                                            .productCount! -
                                                                        1,
                                                                context:
                                                                    context);
                                                          },
                                                          child: Container(
                                                              height: double
                                                                  .infinity,
                                                              width: double
                                                                  .infinity,
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      right: BorderSide(
                                                                          color:
                                                                              greyShade3))),
                                                              child: Icon(Icons
                                                                  .remove)),
                                                        )),
                                                    Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                            color: white,
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(currenProduct
                                                                .productCount!
                                                                .toString()))),
                                                    Expanded(
                                                        flex: 2,
                                                        child: InkWell(
                                                          onTap: () async {
                                                            await UsersProductService.updateCountCartProduct(
                                                                productId:
                                                                    currenProduct
                                                                        .productID!,
                                                                newCount:
                                                                    currenProduct
                                                                            .productCount! +
                                                                        1,
                                                                context:
                                                                    context);
                                                          },
                                                          child: Container(
                                                              height: double
                                                                  .infinity,
                                                              width: double
                                                                  .infinity,
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      right: BorderSide(
                                                                          color:
                                                                              greyShade3))),
                                                              child: Icon(
                                                                  Icons.add)),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Commonfunc.blankSpace(0, width * 0.03),
                                        Expanded(
                                            flex: 7,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  currenProduct.name!,
                                                  maxLines: 3,
                                                  style:
                                                      TextStyle(fontSize: 23),
                                                ),
                                                Commonfunc.blankSpace(
                                                    height * 0.01, 0),
                                                Text(
                                                  ' ₹ ${currenProduct.discountedPrice!.toStringAsFixed(0)}'
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "MRP: ",
                                                  style: TextStyle(color: grey),
                                                ),
                                                Text(
                                                  "  ${currenProduct.price!.toStringAsFixed(0)}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: teal,
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                ),
                                                Commonfunc.blankSpace(
                                                    height * 0.005, 0),
                                                Text(
                                                  currenProduct
                                                              .discountedPrice! >
                                                          499
                                                      ? 'Eligible for Free Shipping'
                                                      : 'Extra Delivery Charges Applied ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: grey,
                                                  ),
                                                ),
                                                Commonfunc.blankSpace(
                                                    height * 0.008, 0),
                                                Text(
                                                  "In stock",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: teal),
                                                ),
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          await UsersProductService
                                                              .removeProductfromCart(
                                                                  productId:
                                                                      currenProduct
                                                                          .productID!,
                                                                  context:
                                                                      context);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    white,
                                                                side: BorderSide(
                                                                    color:
                                                                        greyShade3)),
                                                        child: Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color: black,
                                                              fontSize: 15),
                                                        )),
                                                    Spacer(),
                                                    ElevatedButton(
                                                        onPressed: () async {},
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    white,
                                                                side: BorderSide(
                                                                    color:
                                                                        greyShade3)),
                                                        child: Text(
                                                          'Save for Later',
                                                          style: TextStyle(
                                                              color: black,
                                                              fontSize: 15),
                                                        )),
                                                  ],
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  );
                                })
                          ],
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text('Oops! Error Found');
                      } else {
                        return const Text('Oops! No product Added to Cart');
                      }
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
