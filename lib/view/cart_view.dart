import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/model/item.dart';
import 'package:shopping/view_model/shopping_view_model.dart';

import '../view_state.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ShoppingViewModel>(context, listen: false).getData();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.orangeAccent,
      child: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Your Cart",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Selector<ShoppingViewModel, int>(
                        selector: (context,viewModel) => viewModel.count(),
                        builder: (__, value, ___) {
                          return Align(
                              alignment: Alignment.center,
                              child: Text("${value.toString()} Items"));

                        },

                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Consumer<ShoppingViewModel>(builder:
                                (BuildContext context, value, Widget child) {
                              return Center(
                                child: ListView.builder(
                                  itemCount: value.cartList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return value.cartList[index].isSelect
                                        ? Padding(
                                          padding: const EdgeInsets.only(bottom: 10,left: 3,right: 3),
                                          child: Container(
                                            height: 100,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Expanded(
                                              child: Row(

                                                children: [
                                                  Container(
                                                    height: 150,
                                                    width: 90,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.orange),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                15),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              value
                                                                  .cartList[index]
                                                                  .image),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5),
                                                    child: Container(
                                                      width: 160,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              value
                                                                  .cartList[index].name,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                            ),
                                                          ),
                                                          SizedBox(height: 10,),
                                                          Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                                "\$ ${value.cartList[index].price}"),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),


                                                  SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: FloatingActionButton(
                                                      heroTag: null,
                                                      child: Icon(Icons.remove,
                                                          color: Colors.black87),
                                                      backgroundColor:
                                                          Colors.white,
                                                      onPressed: () {
                                                        if (value.cartList[index]
                                                                .amount <=
                                                            1) {
                                                          value.updateOutline(
                                                              index: index,
                                                              value: value
                                                                  .cartList[index]
                                                                  .isSelect);
                                                          value.remove(
                                                              index: index,
                                                              value: value
                                                                  .cartList[index]
                                                                  .isSelect);
                                                        } else {
                                                          value.decreaseItem(
                                                              index,
                                                              value
                                                                  .cartList[index]
                                                                  .amount);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.all(8.0),
                                                    child: Text(value
                                                        .cartList[index].amount
                                                        .toString()),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: FloatingActionButton(
                                                      heroTag: null,
                                                      child: Icon(Icons.add,
                                                          color: Colors.black87),
                                                      backgroundColor:
                                                      Colors.white,
                                                      onPressed: () {
                                                        value.increaseItem(
                                                            index,
                                                            value.cartList[index]
                                                                .amount);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        : SizedBox.shrink();
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text("Total :"),
                                Selector<ShoppingViewModel, double>(
                                  selector: (context,viewModel) => viewModel.total(),
                                  builder: (__, value, ___) {
                                    return Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Text("${value.toString()} \$",style: TextStyle(fontWeight: FontWeight.bold)),
                                        ));
                                  },

                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              width: 190,
                              child: RaisedButton(
                                color: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)
                                ),
                                child: Text("Checkout"),
                                  onPressed: () {}),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20,)
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
