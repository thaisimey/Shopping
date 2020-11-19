import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/view_model/shopping_view_model.dart';

import '../../view_state.dart';

class ShoppingCartView extends StatefulWidget {
  @override
  _ShoppingCartViewState createState() => _ShoppingCartViewState();
}

class _ShoppingCartViewState extends State<ShoppingCartView> {
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
                  padding: const EdgeInsets.only(top: 20, bottom: 40),
                  child: Text("Wooden Toys", style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),),
                ),
              ),

              Expanded(
                child: Stack(
                  children: [

                    Selector<ShoppingViewModel, ViewState>(
                      selector: (context, value) => value.viewState,
                      builder: (__, value, ___) {
                        if (value == ViewState.Data) {
                          return Consumer<ShoppingViewModel>(
                              builder: (BuildContext context, value,
                                  Widget child) {
                                return GridView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: value.list.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 0.0,
                                        mainAxisSpacing: 4.0),
                                    itemBuilder: (BuildContext context,
                                        int position) {
                                      return Column(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Container(
                                                height: 250,
                                                width: 250,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .deepOrangeAccent),
                                                    borderRadius: BorderRadius
                                                        .circular(20)
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                    8.0),
                                                child: Text(
                                                  value.list[position].name,
                                                  style: TextStyle(fontSize: 15,
                                                      fontWeight: FontWeight
                                                          .bold),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  "\$${(value.list[position]
                                                      .price).toString()}",
                                                  style: TextStyle(
                                                      fontSize: 15),),
                                              )
                                            ],
                                          )
                                        ],
                                      );
                                    }
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
                        if (value == ViewState.Loading) {
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
                        if (value == ViewState.Error) {
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
                        if (value == ViewState.Empty) {
                          return Center(
                              child: Text('Empty data')
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),

                  ],
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
}
