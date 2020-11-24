
import 'package:flutter/cupertino.dart';
import 'package:shopping/model/item.dart';
import 'package:shopping/view_state.dart';

class ShoppingViewModel extends ChangeNotifier {

  ViewState _viewState = ViewState.Empty;
  ViewState get viewState => _viewState;

  List<Item> _list = List();

  List<Item> _cartList = List();

  List<Item> get cartList => _cartList;
  set cartList(List<Item> value) {
    _cartList = value;
    notifyListeners();
  }

  set viewState(ViewState value) {
    _viewState = value;
    notifyListeners();
  }

  List<Item> get list => _list;
  set list(List<Item> value) {
    _list = value;
    notifyListeners();
  }

  void updateOutline({int index, bool value}) {
    _cartList[index].isSelect = !value;
    if(_cartList[index].isSelect == false) {
      _cartList[index].amount = 0;
    }
    notifyListeners();
  }

  void remove({int index, bool value}) {
    _cartList[index].isSelect = false;
    count();
    notifyListeners();
  }


  // void removeItem({Item item}) {
  //   print('removed from cartItem: ${item.id} - ${item.name}');
  //   cartList.remove(item);
  //   notifyListeners();
  // }

  // void updateOutlineFromCardView(Item item) {
  //   if(cartList.contains(item)) {
  //     cartList[cartList.indexWhere((element) => element.id == item.id)].isSelect = false;
  //   }
  //   notifyListeners();
  // }

  // void cartAmount(Item item) {
  //   if(list[list.indexWhere((element) => element.id == item.id)].id ==
  //   cartList[cartList.indexWhere((element) => element.id == item.id)].id) {}
  //
  //
  // }

  void increaseItem(int index, int value) {
    _cartList[index].amount++;
    // cartList[index].amount = value;
    notifyListeners();
  }

  void decreaseItem(int index, int value) {
    _cartList[index].amount--;
    notifyListeners();
  }

  int count() {
    List<Item> temp = cartList.where((element) => element.isSelect == true).toList();
    // print("count : ${temp.length}");
    return temp.length;

  }

  double total() {
    double eachtotal = 0;
    double total = 0;
    List<Item> temp = cartList.where((element) => element.isSelect == true).toList();
    temp.forEach((element) {
      eachtotal = element.amount * element.price;
      total += eachtotal;
    });


    return total;

  }


  void getData() {
    try {
      viewState = ViewState.Loading;

      var data = [
        Item(1, "Wooden Manhattan", false, 0, 45,"https://icon2.cleanpng.com/20200228/uzt/transparent-medical-mask-surgical-mask-5e9563047301d4.5824216415868485164711.jpg"),
        Item(2, "Orange Wooden Car", false, 0,25,"https://icon2.cleanpng.com/20171221/oqw/cute-santa-claus-with-gift-png-clipart-5a3b6a42512226.7928266815138432663323.jpg"),
        Item(3, "Green Wooden Car", false, 0, 65,"https://icon2.cleanpng.com/20171221/ivq/haunted-castle-clipart-5a3bee14ec08a6.6541982115138770129668.jpg"),
        Item(4, "Wooden Manhattan", false, 0, 5,"https://icon.holidaypng.com/20191015/ir/snowman-christmas-ornament-christmas-for-christmas-5da59c5744be74.70030528.png"),
        Item(5, "Wooden Manhattan", false, 0, 95,"https://icon2.cleanpng.com/20180220/soe/kisspng-santa-claus-cartoon-royalty-free-illustration-santa-claus-5a8c0300397574.9550410615191252482354.jpg"),
        Item(6, "Wooden ", false, 0, 75,"https://icon2.cleanpng.com/20171221/fae/halloween-black-cauldron-png-clipart-image-5a3c14fc82a390.8388266715138869725351.jpg"),
      ];
      list.addAll(data);
      cartList = list;

      Future.delayed(Duration(milliseconds: 400),() {
        viewState = ViewState.Data;
      });

    } catch(e) {
      viewState = ViewState.Error;
    }
  }



}