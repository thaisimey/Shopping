import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopping/view/list_item_view.dart';
import 'package:shopping/view_model/shopping_view_model.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: ShoppingViewModel()),
    StreamProvider.value(value: Connectivity().onConnectivityChanged),
  ],
  child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping',
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Concert One',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeMode.system,
      home: ListItemsView(),
    );
  }


}
