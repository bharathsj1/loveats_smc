import 'dart:math';

import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potbelly/screens/bookmarks_screen.dart';
import 'package:potbelly/screens/cart_screen.dart';
import 'package:potbelly/screens/home_screen.dart';
import 'package:potbelly/screens/notification_screen.dart';
import 'package:potbelly/screens/profile_screen.dart';
import 'navbar.dart';

class BubbleTabBarDemo extends StatefulWidget {
  @override
  _BubbleTabBarDemoState createState() => _BubbleTabBarDemoState();
}

class _BubbleTabBarDemoState extends State<BubbleTabBarDemo> {
  List<NavBarItemData> _navBarItems;
  int _selectedNavIndex = 0;

  List<Widget> _viewsByIndex;

  @override
  void initState() {
    //Declare some buttons for our tab bar
    _navBarItems = [
      NavBarItemData("Home", OMIcons.home, 100, Colors.black),
      NavBarItemData("Bookmarks", OMIcons.bookmarks, 140, Colors.black),
      NavBarItemData("Cart", OMIcons.shoppingCart, 90, Colors.black),
      NavBarItemData("Notification", OMIcons.notificationsActive, 140, Colors.black),
      NavBarItemData("Profile", OMIcons.person, 105, Colors.black),
    ];

    //Create the views which will be mapped to the indices for our nav btns
    _viewsByIndex = <Widget>[
      HomeScreen(),
      BookmarksScreen(),
      CartScreen(),
      NotificationsScreen(),
      ProfileScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var accentColor = _navBarItems[_selectedNavIndex].selectedColor;

    //Create custom navBar, pass in a list of buttons, and listen for tap event
    var navBar = NavBar(
      items: _navBarItems,
      itemTapped: _handleNavBtnTapped,
      currentIndex: _selectedNavIndex,
    );
    //Display the correct child view for the current index
    var contentView = _viewsByIndex[min(_selectedNavIndex, _viewsByIndex.length - 1)];
    //Wrap our custom navbar + contentView with the app Scaffold
    return Scaffold(
      backgroundColor: Color(0xffE6E6E6),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          //Wrap the current page in an AnimatedSwitcher for an easy cross-fade effect
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 350),
            //Pass the current accent color down as a theme, so our overscroll indicator matches the btn color
            child: contentView,
          ),
        ),
      ),
      bottomNavigationBar: navBar, //Pass our custom navBar into the scaffold
    );
  }

  void _handleNavBtnTapped(int index) {
    //Save the new index and trigger a rebuild
    setState(() {
      //This will be passed into the NavBar and change it's selected state, also controls the active content page
      _selectedNavIndex = index;
    });
  }
}
