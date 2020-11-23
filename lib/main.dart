import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/view/list_item_view.dart';
import 'package:shopping/view_model/shopping_view_model.dart';

void main() {
  runApp(MultiProvider(providers: [
ChangeNotifierProvider.value(value: ShoppingViewModel())
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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Concert One',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListItemsView(),
    );
  }
}
