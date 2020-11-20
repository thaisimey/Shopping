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
    _list[index].isSelect = !value;
    notifyListeners();
  }

  void removeItem({Item item}) {
    print('removed from cartItem: ${item.id} - ${item.name}');
    cartList.remove(item);
    notifyListeners();
  }

  void updateOulineFromCardView(Item item) {
    if(list.contains(item)) {
      list[list.indexWhere((element) => element.id == item.id)].isSelect = false;
    }
    notifyListeners();
  }
  void cartAmount(Item item) {
    if(list[list.indexWhere((element) => element.id == item.id)].id ==
    cartList[cartList.indexWhere((element) => element.id == item.id)].id) {}


  }

  void increaseItem(int index, int value) {
    _list[index].amount = value;
    notifyListeners();
  }

  void decreaseItem(int index, int value) {
    _list[index].amount = value;
    notifyListeners();
  }




  void getData() {
    try {
      viewState = ViewState.Loading;

      var data = [
        Item(1, "Wooden Manhattan", false, 1, 45,"https://img.pixelz.com/blog/white-background-photography/product-photo-lipstick-makeup-1000.jpg?w=1000"),
        Item(2, "Orange Wooden Car", false, 1,25,"https://img.pixelz.com/blog/white-background-photography/product-photo-lipstick-makeup-1000.jpg?w=1000"),
        Item(3, "Green Wooden Car", false, 1, 65,"https://img.pixelz.com/blog/white-background-photography/product-photo-lipstick-makeup-1000.jpg?w=1000"),
        Item(4, "Wooden Manhattan", false, 10, 5,"https://img.pixelz.com/blog/white-background-photography/product-photo-lipstick-makeup-1000.jpg?w=1000"),
        Item(5, "Wooden Manhattan", false, 1, 95,"https://img.pixelz.com/blog/white-background-photography/product-photo-lipstick-makeup-1000.jpg?w=1000"),
        Item(6, "Wooden Manhattan", false, 1, 75,"https://img.pixelz.com/blog/white-background-photography/product-photo-lipstick-makeup-1000.jpg?w=1000"),
      ];
      list.addAll(data);

      Future.delayed(Duration(milliseconds: 400),() {
        viewState = ViewState.Data;
      });

    } catch(e) {
      viewState = ViewState.Error;
    }
  }



}