import 'package:amazon/constants/common_func.dart';
import 'package:amazon/controller/services/product_services/production_serv.dart';
import 'package:amazon/controller/services/user_product_services/user_pdt_serv.dart';
import 'package:amazon/model/product_modl.dart';
import 'package:amazon/model/user_prod_modl.dart';
import 'package:amazon/utils/colors.dart';
import 'package:amazon/view/user/home/home_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../constants/const.dart';

class ProdcutScrn extends StatefulWidget {
  ProdcutScrn({super.key, required this.productModel});
  ProductModel productModel;

  @override
  State<ProdcutScrn> createState() => _ProdcutScrnState();
}

class _ProdcutScrnState extends State<ProdcutScrn> {
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
    UserProductModel userProductModel = UserProductModel(
      imagesURL: widget.productModel.imagesURL,
      name: widget.productModel.name,
      category: widget.productModel.category,
      description: widget.productModel.description,
      brandName: widget.productModel.brandName,
      manufacturerName: widget.productModel.manufacturerName,
      countryOfOrigin: widget.productModel.countryOfOrigin,
      specifications: widget.productModel.specifications,
      price: widget.productModel.price,
      discountedPrice: widget.productModel.discountedPrice,
      productID: widget.productModel.productID,
      productSellerID: widget.productModel.productSellerID,
      inStock: widget.productModel.inStock,
      discountPercentage: widget.productModel.discountPercentage,
      productCount: 1,
      time: DateTime.now(),
    );
    await ProductServices.addSalesData(
      context: context,
      productModel: userProductModel,
      userID: auth.currentUser!.phoneNumber!,
    );
    await UsersProductService.addOrder(
        context: context, productModel: userProductModel);
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
      'name': widget.productModel.name,
      'description': (widget.productModel.description!.length < 255)
          ? widget.productModel.description!.length
          : widget.productModel.description!.substring(0, 250),
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
            child: HomeAppBar(
              height: height,
              width: width,
            ),
            preferredSize: Size(width, height * 0.1)),
        body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.02),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  carouselController: CarouselController(),
                  options: CarouselOptions(
                      height: height * 0.24,
                      autoPlay: true,
                      viewportFraction: 1),
                  items: widget.productModel.imagesURL!.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: width,
                          //margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                              color: white,
                              image: DecorationImage(
                                  image: NetworkImage(i), fit: BoxFit.contain)),
                        );
                      },
                    );
                  }).toList(),
                ),
                Commonfunc.blankSpace(height * 0.02, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Brand: ${widget.productModel.brandName}',
                      style: textTheme.labelMedium!
                          .copyWith(color: teal, fontSize: 14),
                    ),
                    Row(
                      children: [
                        Text(
                          '0.0',
                          style: textTheme.labelMedium!
                              .copyWith(color: teal, fontSize: 15),
                        ),
                        RatingBar(
                          initialRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: width * 0.04,
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
                              .copyWith(color: grey, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
                Commonfunc.blankSpace(0, width * 0.02),
                Text(
                  widget.productModel.name!,
                  style: textTheme.labelMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                Commonfunc.blankSpace(0, width * 0.02),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: '-${widget.productModel.discountPercentage}%',
                      style: textTheme.displaySmall!.copyWith(
                          color: red,
                          fontWeight: FontWeight.w500,
                          fontSize: 30)),
                  TextSpan(
                      text: '\t\t₹${widget.productModel.discountedPrice}%',
                      style: textTheme.displayLarge!.copyWith(
                          color: black,
                          fontWeight: FontWeight.w600,
                          fontSize: 27))
                ])),
                Text(
                  'M.R.P: ₹ ${widget.productModel.price}',
                  style: textTheme.labelMedium!.copyWith(
                      color: grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      decoration: TextDecoration.lineThrough),
                ),
                Commonfunc.blankSpace(0, width * 0.02),
                ElevatedButton(
                    onPressed: () async {
                      UserProductModel model = UserProductModel(
                        imagesURL: widget.productModel.imagesURL,
                        name: widget.productModel.name,
                        category: widget.productModel.category,
                        description: widget.productModel.description,
                        brandName: widget.productModel.brandName,
                        manufacturerName: widget.productModel.manufacturerName,
                        countryOfOrigin: widget.productModel.countryOfOrigin,
                        specifications: widget.productModel.specifications,
                        price: widget.productModel.price,
                        discountedPrice: widget.productModel.discountedPrice,
                        productID: widget.productModel.productID,
                        productSellerID: widget.productModel.productSellerID,
                        inStock: widget.productModel.inStock,
                        discountPercentage:
                            widget.productModel.discountPercentage,
                        productCount: 1,
                        time: DateTime.now(),
                      );
                      await UsersProductService.addProductToCart(
                          context: context, productModel: model);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: amber,
                        minimumSize: Size(width, height * 0.05),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: Text(
                      'Add to Cart',
                      style: textTheme.bodyMedium!.copyWith(color: black),
                    )),
                Commonfunc.blankSpace(0, width * 0.02),
                ElevatedButton(
                    onPressed: executePayment,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        minimumSize: Size(width, height * 0.05),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: Text(
                      'Buy Now',
                      style: textTheme.bodyMedium!.copyWith(color: black),
                    )),
                Commonfunc.blankSpace(0, width * 0.02),
                Commonfunc.divider(),
                Commonfunc.blankSpace(0, width * 0.02),
                Text(
                  "Features",
                  style: textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 19),
                ),
                Commonfunc.blankSpace(0, width * 0.02),
                Text(
                  widget.productModel.description!,
                  style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w400, fontSize: 17, color: grey),
                ),
                Commonfunc.blankSpace(height * 0.01, 0),
                Commonfunc.divider(),
                Commonfunc.blankSpace(height * 0.01, 0),
                Text(
                  "Specification",
                  style: textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 19),
                ),
                Commonfunc.blankSpace(height * 0.01, 0),
                Text(
                  widget.productModel.specifications!,
                  style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w400, fontSize: 17, color: grey),
                ),
                Commonfunc.blankSpace(height * 0.01, 0),
                Commonfunc.divider(),
                Commonfunc.blankSpace(height * 0.015, 0),
                Text(
                  "Product Image Gallery",
                  style: textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 19),
                ),
                Commonfunc.blankSpace(height * 0.02, 0),
                Text(
                  widget.productModel.description!,
                  style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w400, fontSize: 17, color: grey),
                ),
                Commonfunc.blankSpace(height * 0.01, 0),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const PageScrollPhysics(),
                    itemCount: widget.productModel.imagesURL!.length,
                    itemBuilder: (context, index) {
                      return Image(
                          image: NetworkImage(
                              widget.productModel.imagesURL![index]));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
