import 'package:amazon/constants/common_func.dart';
import 'package:amazon/controller/provider/product_prov.dart';
import 'package:amazon/model/product_modl.dart';
import 'package:amazon/utils/colors.dart';
import 'package:amazon/view/seller/add_product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SellerProductProvider>().fecthSellerProducts();
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
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: AddPdtscreen(),
                        type: PageTransitionType.rightToLeft));
              },
              backgroundColor: amber,
              child: Icon(
                Icons.add,
                color: black,
              )),
          body: Container(
            width: width,
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.03, vertical: height * 0.02),
            child: Column(
              children: [
                Consumer<SellerProductProvider>(
                    // ignore: avoid_types_as_parameter_names
                    builder: (context, SellerProductProvider, child) {
                  if (SellerProductProvider.sellerProductsFetched == false)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  else if (SellerProductProvider.products.isEmpty) {
                    return Center(
                      child: Text('No products found'),
                    );
                  }
                  return ListView.builder(
                      itemCount: SellerProductProvider.products.length,
                      shrinkWrap: true,
                      physics: const PageScrollPhysics(),
                      itemBuilder: ((context, index) {
                        ProductModel currModel =
                            SellerProductProvider.products[index];
                        return Container(
                          height: height * 0.3,
                          width: width,
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.01),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: grey)),
                          child: Column(
                            children: [
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: height * 0.2,
                                  autoPlay: false,
                                  viewportFraction: 1,
                                ),
                                items: currModel.imagesURL!.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: white,
                                          image: DecorationImage(
                                            image: NetworkImage(i),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          currModel.name!,
                                          style: textTheme.bodyMedium!.copyWith(
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          currModel.description!,
                                          // textAlign: TextAlign.justify,
                                          maxLines: 2,
                                          style: textTheme.bodySmall!.copyWith(
                                              overflow: TextOverflow.ellipsis,
                                              color: grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Commonfunc.blankSpace(
                                    0,
                                    width * 0.02,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          '₹ ${currModel.discountedPrice.toString()}',
                                          style: textTheme.bodyMedium,
                                        ),
                                        Text(
                                          '₹ ${currModel.price.toString()}',
                                          style: textTheme.labelMedium!
                                              .copyWith(
                                                  color: grey,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                        ),
                                        Text(
                                          currModel.inStock!
                                              ? 'in Stock'
                                              : 'Out of Stock',
                                          style: textTheme.bodySmall!.copyWith(
                                              color: currModel.inStock!
                                                  ? teal
                                                  : red),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      }));
                })
              ],
            ),
          )),
    );
  }
}
