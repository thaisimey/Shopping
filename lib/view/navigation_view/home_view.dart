import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/model/item.dart';
import 'package:shopping/view_model/shopping_view_model.dart';

import '../../view_state.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeWiewState createState() => _HomeWiewState();
}

class _HomeWiewState extends State<HomeView> with AutomaticKeepAliveClientMixin{

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
        body: SafeArea(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 30),
                  child: Text("Wooden Toys",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                ),
              ),
              Container(
                child: Expanded(
                  child: Stack(
                    children: [
                      Selector<ShoppingViewModel, List<Item>>(
                        selector: (context, value) => value.list,
                        builder: (__, value, ___) {
                          return GridView.builder(
                            scrollDirection: Axis.vertical,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1/1.6),
                            itemCount: value.length,
                            itemBuilder: (BuildContext context, int index) {
                              return  GestureDetector(
                                onLongPress: () {

                                },
                                child: Container(
                                  margin: EdgeInsets.all(2),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 30,
                                        right: 0,
                                        left: 0,
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 150,
                                                height: 150,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.deepOrangeAccent),
                                                    borderRadius: BorderRadius.circular(40),
                                                    image: DecorationImage(image: NetworkImage(value[index].image)

                                                    )
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(value[index].name,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: Text("\$${(value[index].price).toString()}",style: TextStyle(fontSize: 15),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(value[index].name,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 20,
                                        right: 10,
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(50),
                                            border: Border.all(color: Colors.greenAccent),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
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
                      ),

                      Positioned(
                        bottom: 70,
                        right: 30,
                        child: FloatingActionButton(
                          backgroundColor: Colors.black,
                          heroTag: null,
                          onPressed: () {
                          },
                          tooltip: 'multiplication',
                          child: Icon(Icons.shopping_cart,color: Colors.white,),
                        ),

                      ),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
