import 'package:amazon/controller/provider/address_prov.dart';
import 'package:amazon/controller/provider/auth_provider/auth_provider.dart';
import 'package:amazon/controller/provider/dealOftheDay_prov/dealdayprov.dart';
import 'package:amazon/controller/provider/productCategoryProv/product_category.dart';
import 'package:amazon/controller/provider/product_prov.dart';
import 'package:amazon/controller/provider/users_product_provider/users_product_prov.dart';
import 'package:amazon/view/auth_screen/signinLogic.dart';

//import 'package:amazon/view/user/profile/profilescreen.dart';
// import 'package:amazon/view/user/user_nav_bar/user_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Amazon());
}

class Amazon extends StatelessWidget {
  const Amazon({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<AddressProvider>(
          create: (_) => AddressProvider(),
        ),
        ChangeNotifierProvider<SellerProductProvider>(
          create: (_) => SellerProductProvider(),
        ),
        ChangeNotifierProvider<UsersProductProv>(
          create: (_) => UsersProductProv(),
        ),
        ChangeNotifierProvider<DealOfTheDayProv>(
          create: (_) => DealOfTheDayProv(),
        ),
        ChangeNotifierProvider<CategoryProd>(
          create: (_) => CategoryProd(),
        ),
      ],
      child: const MaterialApp(
        // home: const SignInLogicc(),
        home: const SignInLogicc(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
