import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/item.dart';
import 'package:shopping/view/cart_view.dart';
import 'package:shopping/view_model/shopping_view_model.dart';

import '../../view_state.dart';

const activeColor = Color(0xFF1D1E33);
const deactiveColor = Color(0xAFB47B);

class HomeView extends StatefulWidget {
  @override
  _HomeWiewState createState() => _HomeWiewState();
}

class _HomeWiewState extends State<HomeView> with AutomaticKeepAliveClientMixin{

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Color outlineColor = deactiveColor;

  void updateOutlineColor(bool outline) {
    if(outline) {
      outlineColor = activeColor;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ShoppingViewModel>(context, listen: false).getData();
    });

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }


  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


        body: SafeArea(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 20),
                  child: Text("Christmas",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                ),
              ),
              Container(
                child: Expanded(
                  child: Stack(
                    children: [
                      Selector<ConnectivityResult, bool>(
                          selector: (context, connectivity) => connectivity != ConnectivityResult.none,
                          builder: (_, value, ___) {
                            print("connectivity $value");
                            if(value == false) {
                              return Flushbar(
                                message: "no internet",
                                icon: Icon(
                                  Icons.info_outline,
                                  size: 28.0,
                                  color: Colors.blue[300],
                                ),
                                duration: Duration(seconds: 3),
                                leftBarIndicatorColor: Colors.blue[300],
                              )..show(context);
                            } else {
                              return SizedBox.shrink();
                            }
                          }
                      ),
                      Consumer<ShoppingViewModel>(builder: (BuildContext context, value, Widget child) {
                        return Center(
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1/1.3),
                            itemCount: value.cartList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return  GestureDetector(
                                onLongPress: () {
                                  // print("print log ${value.list[index].id}");
                                  value.updateOutline(index: index, value: value.cartList[index].isSelect);
                                  // updateOutlineColor(value.cartList[index].isSelect);
                                  if(value.cartList[index].isSelect) {
                                    value.increaseItem(index, value.cartList[index].amount);
                                  }

                                  // if(value.list[index].isSelect) {
                                  //   value.cartList.add(value.list[index]);
                                  // } else {
                                  //   value.cartList.remove(value.list[index]);
                                  // }

                                  // setState(() {
                                  //   value[index].isSelect = !value[index].isSelect;
                                  //   updateOutlineColor(value[index].isSelect);
                                  //
                                  // });
                                },
                                child: Container(
                                  key: ObjectKey(value.list[index].name),
                                  margin: EdgeInsets.all(2),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 30,
                                        right: 0,
                                        left: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: value.list[index].isSelect ? outlineColor : deactiveColor),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 150,
                                                height: 150,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.deepOrangeAccent),
                                                    borderRadius: BorderRadius.circular(40),
                                                    image: DecorationImage(image: NetworkImage(value.list[index].image)

                                                    )
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(value.list[index].name,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: Text("\$${(value.list[index].price).toString()}",style: TextStyle(fontSize: 15),),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                  (value.cartList[index].amount >= 1) ? Positioned(
                                    top: 22,
                                    right: 8,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(color: Colors.greenAccent),
                                      ),
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(value.cartList[index].amount.toString(), style: TextStyle(fontSize: 17),)),
                                    ),
                                  ) : SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),

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
                      ),

                      Positioned(
                        bottom: 70,
                        right: 30,
                        child: Stack(
                          children: [
                            FloatingActionButton(
                              backgroundColor: Theme.of(context).primaryColor,
                              heroTag: null,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CartView()));
                              },
                              tooltip: 'multiplication',
                              child: Icon(Icons.shopping_cart,color: Colors.white,),
                            ),
                            (Provider.of<ShoppingViewModel>(context,listen: true).count() > 0) ? Padding(
                              padding: const EdgeInsets.only(left: 40),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.red

                                ),
                                child: Selector<ShoppingViewModel, int>(
                                  selector: (context,viewModel) => viewModel.count(),
                                  builder: (__, value, ___) {
                                    return Align(
                                      alignment: Alignment.center,
                                        child: Text(value.toString()));

                                  },

                                ),
                              ),
                            ) : SizedBox.shrink(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 70,
              )
            ],

          ),
        )
    );
  }
  //
  // int checkPrice(List<Item> mainList, Item cateItem) {
  //   return mainList[mainList.indexWhere((element) => element.id == cateItem.id)].amount;;
  // }



  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
