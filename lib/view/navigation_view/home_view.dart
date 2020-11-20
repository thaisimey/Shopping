import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                      Consumer<ShoppingViewModel>(builder: (BuildContext context, value, Widget child) {
                        return GridView.builder(
                          scrollDirection: Axis.vertical,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1/1.6),
                          itemCount: value.list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return  GestureDetector(
                              onLongPress: () {
                                print("print log ${value.list[index].id}");
                                value.updateOutline(index: index,value: value.list[index].isSelect);
                                updateOutlineColor(value.list[index].isSelect);
                                if(value.list[index].isSelect) {
                                  value.cartList.add(value.list[index]);
                                } else {
                                  value.cartList.remove(value.list[index]);
                                }

                                // setState(() {
                                //   value[index].isSelect = !value[index].isSelect;
                                //   updateOutlineColor(value[index].isSelect);
                                //
                                // });
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
                                    Selector<ShoppingViewModel, List<Item>>(
                                      selector: (context, value) => value.cartList,
                                      builder: (__, value, ___) {
                                       return Builder(
                                         builder: (BuildContext context) {
                                           if(value.length <= 0) {
                                             return SizedBox.shrink();
                                           } else {
                                             return Positioned(
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
                                                     child: Text(value[index].amount.toString(),style: TextStyle(fontSize: 17),)),
                                               ),
                                             );
                                           }
                                         } ,);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
                        child: FloatingActionButton(
                          backgroundColor: Colors.black,
                          heroTag: null,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CartView()));
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
