import 'dart:math';

import 'package:bottom_personalized_dot_bar/bottom_personalized_dot_bar.dart';
import 'package:flutter/material.dart';
import 'package:shopping/view/navigation_view/home_view.dart';
import 'package:shopping/view/navigation_view/shopping_cart_view.dart';


class ListItemsView extends StatefulWidget {
  @override
  _ListItemsViewState createState() => _ListItemsViewState();
}

class _ListItemsViewState extends State<ListItemsView> {

  String _itemSelected = 'item-1';
  bool _enableAnimation = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            switchOutCurve: Interval(0.0, 0.0),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final revealAnimation = Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.ease));
              return AnimatedBuilder(
                builder: (BuildContext context, Widget _) {
                  return _buildAnimation(
                      context, _itemSelected, child, revealAnimation.value);
                },
                animation: animation,
              );
            },
            child: _buildPage(_itemSelected),
          ),
          BottomPersonalizedDotBar(
              navigatorBackground: Colors.deepOrangeAccent,
              width: MediaQuery.of(context).size.width,
              keyItemSelected: _itemSelected,
              doneText: 'Done',
              settingTitleText: 'Your Menu',
              settingSubTitleText: 'Drag and drop',
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 10.0, spreadRadius: 1.0)
              ],
              iconSettingColor: const Color(0xFFFFD201),
              buttonDoneColor: const Color(0xFFFFD500),
              settingSubTitleColor: const Color(0xFFFECE02),
              hiddenItems: <BottomPersonalizedDotBarItem>[],
              items: <BottomPersonalizedDotBarItem>[
                BottomPersonalizedDotBarItem('item-1',
                    icon: Icons.home,
                    name: 'Flutter',
                    onTap: (itemSelected) => _changePage(itemSelected)),
                BottomPersonalizedDotBarItem('item-2',
                    icon: Icons.search,
                    name: 'Favoriton',
                    onTap: (itemSelected) => _changePage(itemSelected)),
                BottomPersonalizedDotBarItem('item-3',
                    icon: Icons.favorite_border,
                    name: 'Favorito',
                    onTap: (itemSelected) => _changePage(itemSelected)),
                BottomPersonalizedDotBarItem('item-4',
                    icon: Icons.face,
                    name: 'Perfil',
                    onTap: (itemSelected) => _changePage(itemSelected)),
              ]),
        ],
      ),
    );
}

  void _changePage(String itemSelected) {
    if (_itemSelected != itemSelected && _enableAnimation) {
      _enableAnimation = false;
      setState(() => _itemSelected = itemSelected);
      Future.delayed(
          const Duration(milliseconds: 700), () => _enableAnimation = true);
    }
  }

  Widget _buildAnimation(BuildContext context, String itemSelected,
      Widget child, double valueAnimation) {
    switch (itemSelected) {
      case 'item-1':
        return Transform.translate(
            offset: Offset(
                .0,
                -(valueAnimation - 1).abs() *
                    MediaQuery.of(context).size.width),
            child: child);
      case 'item-2':
        return PageReveal(revealPercent: valueAnimation, child: child);
      case 'item-3':
        return Opacity(opacity: valueAnimation, child: child);
      case 'item-4':
        return Transform.translate(
            offset: Offset(
                -(valueAnimation - 1).abs() * MediaQuery.of(context).size.width,
                .0),
            child: child);

      default:
        return Transform.translate(
            offset: Offset(
                .0,
                -(valueAnimation - 1).abs() *
                    MediaQuery.of(context).size.width),
            child: child);
    }
  }

  Widget _buildPage(String itemSelected) {
    switch (itemSelected) {
      case 'item-1':
        return HomeView();
      case 'item-2':
        return ShoppingCartView();
      case 'item-3':
        return HomeView();
      case 'item-4':
        return HomeView();

    }
  }
}

class PageReveal extends StatelessWidget {
  final double revealPercent;
  final Widget child;

  const PageReveal({Key key, this.revealPercent, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipper: CircleRevealClipper(revealPercent),
      child: child,
    );
  }
}

class CircleRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;

  CircleRevealClipper(this.revealPercent);

  @override
  Rect getClip(Size size) {
    final epicenter = Offset(size.width / 2, size.height * 0.5);
    double theta = atan(epicenter.dy / epicenter.dx);
    final distanceToCorner = epicenter.dy / sin(theta);

    final radius = distanceToCorner * revealPercent;

    final diameter = 2 * radius;

    return Rect.fromLTWH(
        epicenter.dx - radius, epicenter.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

