import 'dart:developer';

import 'package:amazon/constants/common_func.dart';
import 'package:amazon/constants/const.dart';
import 'package:amazon/controller/provider/address_prov.dart';
import 'package:amazon/controller/provider/productCategoryProv/product_category.dart';
import 'package:amazon/controller/services/user_crud.dart/user_crud.dart';
import 'package:amazon/model/addressmodel.dart';
import 'package:amazon/model/product_modl.dart';
import 'package:amazon/utils/colors.dart';
import 'package:amazon/view/user/addressScreen/address_screen.dart';
import 'package:amazon/controller/provider/dealOftheDay_prov/dealdayprov.dart';
import 'package:amazon/view/user/productScreen/product_screen.dart';
import 'package:amazon/view/user/product_category_scrn/prooduct_ctgry.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../SearchedproductScreen/searched_product_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CarouselController todaysDealsCarouselController = CarouselController();

  checkUserAddress() async {
    bool userAddressPresent = await UserDataCRUD.checkUserAddress();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (userAddressPresent == false) {
      showModalBottomSheet(
          backgroundColor: transparent,
          context: context,
          builder: (context) {
            return Container(
              height: height * 0.4,
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.04, horizontal: width * 0.03),
              width: width,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Address',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: height * 0.15,
                    child: ListView.builder(
                        itemCount: 1,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: ((context, index) {
                          return InkWell(
                            onTap: () {
                              if (index == 0) {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: const AddressScrn(),
                                        type: PageTransitionType.rightToLeft));
                              }
                            },
                            child: Container(
                              width: width * 0.35,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03,
                                  vertical: height * 0.01),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: greyShade3)),
                              child: Builder(builder: (context) {
                                if (index == 0) {
                                  return Text(
                                    'Add Address',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: greyShade3),
                                  );
                                } else
                                  return Text(
                                    'Add Address',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: greyShade3),
                                  );
                              }),
                            ),
                          );
                        })),
                  ),
                ],
              ),
            );
          });
    }
  }

  hdphoneDeals(int index) {
    switch (index) {
      case 0:
        return 'Bose';
      case 1:
        return 'boAt';
      case 2:
        return 'Sony';
      case 3:
        return 'OnePlus';
    }
  }

  clothingDeals(int index) {
    switch (index) {
      case 0:
        return 'Kurtas, sarees & more';
      case 1:
        return 'Tops, dresses & more';
      case 2:
        return 'T-Shirt, jeans & more';
      case 3:
        return 'View all';
    }
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserAddress();
      context.read<AddressProvider>().getCurrSelectedAddres();
      context.read<DealOfTheDayProv>().fetchTodaysDeal();
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
          child: HomeAppBar(width: width, height: height),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HomeAddressBar(height: height, width: width),
              Commonfunc.divider(),
              HomeCategoriesList(
                  height: height, width: width, textTheme: textTheme),
              Commonfunc.blankSpace(height * 0.014, 0),
              Commonfunc.divider(),
              HomeBanner(height: height, width: width),
              TodaysDealHomeWidget(
                  width: width,
                  height: height,
                  textTheme: textTheme,
                  todaysDealsCarouselController: todaysDealsCarouselController),
              Commonfunc.divider(),
              otherOfferGridWidget(
                  title: "Latest Launched Head Phones",
                  TextBtnName: "Explore More",
                  PdtPicNamesList: headphonesDeals,
                  offerfor: 'headphones'),
              Commonfunc.divider(),
              Container(
                height: height * 0.4,
                width: width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/offersNsponcered/insurance.png"),
                        fit: BoxFit.fill)),
              ),
              Commonfunc.divider(),
              otherOfferGridWidget(
                  title: "Minimum 70% off | Top Offers on Clothing ",
                  TextBtnName: "See All Deals",
                  PdtPicNamesList: clothingDealsList,
                  offerfor: 'clothing'),
              Commonfunc.divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Commonfunc.blankSpace(height * 0.01, 0),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03,
                    ),
                    child: Text(
                      'Watch Sixer only on miniTV',
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                  Commonfunc.blankSpace(height * 0.009, 0),
                  Container(
                    color: black,
                    height: height * 0.45,
                    width: width,
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03, vertical: height * 0.01),
                    child: Image(
                      image: AssetImage(
                          "assets/images/offersNsponcered/sixer.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Container otherOfferGridWidget(
      {required String title,
      required String TextBtnName,
      required List<String> PdtPicNamesList,
      required String offerfor}) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Container(
        width: width,
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: black,
                fontSize: 24,
              ),
            ),
            Commonfunc.blankSpace(height * 0.01, 0),
            GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                shrinkWrap: true,
                itemCount: 4,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/offersNsponcered/${PdtPicNamesList[index]}'),
                                  fit: BoxFit.contain)),
                        ),
                      ),
                      Text(
                        offerfor == "headphones"
                            ? hdphoneDeals(index)
                            : clothingDeals(index),
                        style: textTheme.bodyMedium!.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      )
                    ],
                  );
                }),
            TextButton(
                onPressed: () {},
                child: Text(
                  TextBtnName,
                  style: textTheme.bodySmall!.copyWith(
                      color: Colors.blue[700],
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                )),
          ],
        ));
  }
}

class TodaysDealHomeWidget extends StatelessWidget {
  const TodaysDealHomeWidget({
    super.key,
    required this.width,
    required this.height,
    required this.textTheme,
    required this.todaysDealsCarouselController,
  });

  final double width;
  final double height;
  final TextTheme textTheme;
  final CarouselController todaysDealsCarouselController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: width,
        child: Consumer<DealOfTheDayProv>(
            builder: (context, DealOfTheDayProv, child) {
          if (DealOfTheDayProv.dealsfetched == false) {
            return Container(
              height: height * 0.2,
              width: width,
              alignment: Alignment.center,
              child: Text(
                'Loading Latest Deals',
                style: textTheme.bodyMedium,
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '50-70% off | Latest deals!!',
                  //'${DealOfTheDayProv.deals[1].discountPercentage}%-${DealOfTheDayProv.deals[0].discountPercentage}% off | Latest deals.',
                  style: textTheme.displaySmall!
                      .copyWith(fontWeight: FontWeight.w600, color: black),
                ),
                Commonfunc.blankSpace(height * 0.01, 0),
                CarouselSlider(
                  carouselController: todaysDealsCarouselController,
                  options: CarouselOptions(
                    height: height * 0.2,
                    autoPlay: true,
                    viewportFraction: 1,
                  ),
                  items: DealOfTheDayProv.deals.map((i) {
                    ProductModel currProduct = i;
                    return Builder(
                      builder: (BuildContext context) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: ProdcutScrn(productModel: currProduct),
                                type: PageTransitionType.rightToLeft,
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: white,
                              image: DecorationImage(
                                image: NetworkImage(currProduct.imagesURL![0]),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Commonfunc.blankSpace(
                  height * 0.01,
                  0,
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          color: red),
                      child: Text(
                        'Upto 62% Off',
                        style: textTheme.labelMedium!.copyWith(color: white),
                      ),
                    ),
                    Commonfunc.blankSpace(0, width * 0.03),
                    Text(
                      'Deal of the Day',
                      style: textTheme.labelMedium!.copyWith(
                        color: red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Commonfunc.blankSpace(height * 0.01, 0),
                GridView.builder(
                    itemCount: DealOfTheDayProv.deals.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 20),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      ProductModel currentModel = DealOfTheDayProv.deals[index];
                      return InkWell(
                        onTap: () {
                          log(index.toString());
                          todaysDealsCarouselController.animateToPage(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: greyShade3,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(currentModel.imagesURL![0]),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    }),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See all Deals',
                    style: textTheme.bodySmall!.copyWith(
                      color: blue,
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}

class HomeBanner extends StatelessWidget {
  const HomeBanner({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          height: height * 0.24, autoPlay: true, viewportFraction: 1),
      items: carouselPictures.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: width,
              //margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                  color: Colors.amber,
                  image: DecorationImage(
                      image:
                          AssetImage('assets/images/carousel_slideshow/${i}'),
                      fit: BoxFit.cover)),
            );
          },
        );
      }).toList(),
    );
  }
}

class HomeCategoriesList extends StatelessWidget {
  const HomeCategoriesList({
    Key? key,
    required this.height,
    required this.width,
    required this.textTheme,
  }) : super(key: key);

  final double height;
  final double width;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.09,
      child: ListView.builder(
          itemCount: categories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: ((context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: productcategoryScreen(
                            productcategory: categories[index]),
                        type: PageTransitionType.rightToLeft));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.01),
                child: Column(
                  children: [
                    Image(
                      image: AssetImage(
                          'assets/images/categories/${categories[index]}.png'),
                      height: height * 0.07,
                    ),
                    Text(
                      categories[index],
                      style: textTheme.labelMedium,
                    )
                  ],
                ),
              ),
            );
          })),
    );
  }
}

class HomeAddressBar extends StatelessWidget {
  const HomeAddressBar({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.06,
      width: width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: addressBarGradientColor,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      )),
      child:
          Consumer<AddressProvider>(builder: (context, addressProvider, child) {
        if (addressProvider.fetchedCurrentSelectedAddress &&
            addressProvider.addressPresent) {
          AddressModel selectedAddress = addressProvider.currentSelectedAddress;
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Commonfunc.blankSpace(0, width * 0.02),
              Icon(
                Icons.location_pin,
                color: black,
              ),
              Commonfunc.blankSpace(0, width * 0.02),
              Text(
                  'Deliver to ${selectedAddress.name} - ${selectedAddress.town}, ${selectedAddress.state}')
            ],
          );
        } else
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.location_pin,
                color: black,
              ),
              Commonfunc.blankSpace(0, width * 0.02),
              Text('Deliver to user - City, State')
            ],
          );
      }),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: const searchedproductScreen(),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            },
            child: Container(
              width: width * 0.81,
              height: height * 0.06,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  5,
                ),
                border: Border.all(
                  color: grey,
                ),
                color: white,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: black,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.03,
                    ),
                    child: Text(
                      'Search Amazon.in',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: grey),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.camera_alt_sharp,
                    color: grey,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.mic,
                color: black,
              ))
        ],
      ),
    );
  }
}
