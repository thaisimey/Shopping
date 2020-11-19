import 'package:flutter/cupertino.dart';
import 'package:shopping/model/item.dart';
import 'package:shopping/view_state.dart';

class ShoppingViewModel extends ChangeNotifier {

  ViewState _viewState = ViewState.Empty;

  ViewState get viewState => _viewState;

  set viewState(ViewState value) {
    _viewState = value;
    notifyListeners();
  }

  List<Item> _list = List();

  List<Item> get list => _list;

  set list(List<Item> value) {
    _list = value;
    notifyListeners();
  }

  void getData() {
    try {
      viewState = ViewState.Loading;

      var data = [
        Item(1, "Wooden Manhattan", true, 2, 45,"https://img.pixelz.com/blog/white-background-photography/product-photo-lipstick-makeup-1000.jpg?w=1000"),
        Item(2, "Orange Wooden Car", true, 2,25,"https://img.pixelz.com/blog/white-background-photography/product-photo-lipstick-makeup-1000.jpg?w=1000"),
        Item(3, "Green Wooden Car", true, 2, 65,"https://img.pixelz.com/blog/white-background-photography/product-photo-lipstick-makeup-1000.jpg?w=1000"),
        Item(4, "Wooden Manhattan", true, 2, 5,"https://img.pixelz.com/blog/white-background-photography/product-photo-lipstick-makeup-1000.jpg?w=1000"),
        Item(5, "Wooden Manhattan", true, 2, 95,"https://img.pixelz.com/blog/white-background-photography/product-photo-lipstick-makeup-1000.jpg?w=1000"),
        Item(6, "Wooden Manhattan", true, 2, 75,"https://img.pixelz.com/blog/white-background-photography/product-photo-lipstick-makeup-1000.jpg?w=1000"),
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