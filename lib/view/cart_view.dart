import 'dart:ffi';

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
              SizedBox(height: 60,),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(60),topRight: Radius.circular(60)),
                      ),

                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Text("Your Cart",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,),
                          SizedBox(height: 10,),
                          Text("3 items"),

                          Expanded(
                            child: Stack(
                              children: [
                                Selector<ShoppingViewModel, ViewState>(
                                  selector: (context, value) => value.viewState,
                                  builder: (__, value, ___) {
                                    if(value == ViewState.Data) {
                                      return  Consumer<ShoppingViewModel>(builder: (BuildContext context, value, Widget child) {
                                        return ListView.builder(
                                          itemCount: value.cartList.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Container(
                                                  height: 100,
                                                  width:  MediaQuery.of(context).size.width,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        height: 150,
                                                        width: 90,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(color: Colors.orange),
                                                            borderRadius: BorderRadius.circular(15),
                                                            image: DecorationImage(
                                                              image: NetworkImage(value.cartList[index].image),
                                                            )
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(value.cartList[index].name,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                                          Text("\$ ${value.cartList[index].price}"),
                                                        ],
                                                      ),

                                                      SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: FloatingActionButton(
                                                          heroTag: null,
                                                          child: Icon(Icons.add, color: Colors.black87),
                                                          backgroundColor: Colors.white,
                                                          onPressed: () {
                                                            int incre = value.cartList[index].amount++;
                                                            value.increaseItem(index, incre);

                                                          },
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(value.cartList[index].amount.toString()),
                                                      ),

                                                      SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: FloatingActionButton(
                                                          heroTag: null,
                                                          child: Icon(Icons.remove, color: Colors.black87),
                                                          backgroundColor: Colors.white,
                                                          onPressed: () {
                                                            Item temp = value.cartList[index];
                                                            int decrease = value.cartList[index].amount--;


                                                              if(value.cartList[index].amount < 1) {
                                                                value.removeItem(item: temp);
                                                                value.updateOulineFromCardView(temp);
                                                              } else {
                                                                value.decreaseItem(index,decrease);
                                                              }


                                                          },
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                )
                                            );
                                          },
                                        );
                                      });
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  },
                                ),

                                Selector<ShoppingViewModel, ViewState>(
                                  selector: (context, value) => value.viewState,
                                  builder: (__, value, ___) {
                                    if(value == ViewState.Loading) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  },
                                ),

                                Selector<ShoppingViewModel, ViewState>(
                                  selector: (context, value) => value.viewState,
                                  builder: (__, value, ___) {
                                    if(value == ViewState.Error) {
                                      return Center(
                                        child: Text("Error"),
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  },
                                ),

                                Selector<ShoppingViewModel, ViewState>(
                                  selector: (context, value) => value.viewState,
                                  builder: (__, value, ___) {
                                    if(value == ViewState.Empty) {
                                      return Center(
                                          child: Text('Empty data')
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  },
                                )
                              ],
                            ),
                          )

                        ],
                      ),
                    )

                  ],
                ),
              ),

            ],
          ),
        )
    );
  }
}
