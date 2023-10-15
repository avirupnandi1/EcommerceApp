import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Amazon"),
      ),
      body: Image(
        image: AssetImage('assets/images/amaz1.jpg'),
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
