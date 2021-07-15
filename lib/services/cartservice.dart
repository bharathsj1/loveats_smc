import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class CartProvider with ChangeNotifier {
  List cartitems = [];
  List uchatlist = [];
  double totalAmount = 0.0;

  void addToCart(context, product) async {
    // check array is empty
    await getcarts();
    List data = [];
    int index = cartitems.indexWhere((x) {
      print('indexwhere');
      print(x.toString());
      print(product['id']);
      return x['id'] == product['id'] &&
          x['restaurantId'] == product['restaurantId'];
    });
    if (index == -1) {
      double total = 0.0;
      cartitems.add(product);

      // also save into sqflite
      notifyListeners();
      cartitems.forEach((f) {
        total += (f['price']) * int.tryParse((f['qty']));
      });
      totalAmount = total;
      print('total');
      print(totalAmount);
      notifyListeners();
      Toast.show('Product Added in Cart', context, duration: 3);
    } else {
      // increase the qty
      cartitems[index]['qty'] =
          (int.parse(cartitems[index]['qty']) + int.parse(product['qty']))
              .toString();
      cartitems[index]['payableAmount'] =
          ((cartitems[index]['price']) *
                  double.parse(cartitems[index]['qty']))
              .toString();
      print('payable');
      print(cartitems[index]['payableAmount']);
      // also save into sqflite
      notifyListeners();
      double total = 0;
      cartitems.forEach((f) {
        total += (f['price']) * double.parse(f['qty']);
      });
      totalAmount = total;
      print('total');
      print(totalAmount);
      notifyListeners();
      Toast.show('Adding Quantity +' + product['qty'], context, duration: 3);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cartlist', jsonEncode(cartitems));
  }

  // Remove from cart
  Future<void> removeqtyCart(context,cart) async {
        await getcarts();
    int index = cartitems.indexWhere((x) => x['id'] == cart['id']);
    if (index == -1) {
      return;
    }
    int ntotalAmount = 1 * cart['price'];
    print(ntotalAmount);
    if (totalAmount > 0) {
      totalAmount = totalAmount - ntotalAmount;
      print(totalAmount);
    } else {
      totalAmount = 0;
      print('totalAmount');
      print(totalAmount);
    }
    print(totalAmount);
    if (int.parse(cartitems[index]['qty']) <= 1) {
      cartitems.removeAt(index);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('cartitems');
      await prefs.setString('cartlist', jsonEncode(cartitems));
       Toast.show('Item Removed', context, duration: 3);

    } else {
      cartitems[index]['qty'] =
          (int.parse(cartitems[index]['qty']) - 1).toString();
      double payable = 0.0;
      print('ntotalAmount');
      print(ntotalAmount);
      print('itempayyy');
      print(cartitems[index]['payableAmount']);
      payable = double.parse(cartitems[index]['payableAmount']) - ntotalAmount;
      print('payable');
      print(payable);
      cartitems[index]['payableAmount'] = payable.toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('cartitems');
      await prefs.setString('cartlist', jsonEncode(cartitems));
       Toast.show('Remove Quantity -1', context, duration: 3);
    }
    // also save into sqflite
    notifyListeners();
  }

  Future<void> removeToCart(cart) async {
    print(cart);
    await getcarts();
    print(cartitems);
    int index = cartitems.indexWhere((x) =>
        x['id'] == cart['id'] && x['restaurantId'] == cart['restaurantId']);
    if (index == -1) {
      return;
    } else {
      cartitems.removeAt(index);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('cartlist');
      await prefs.setString('cartlist', jsonEncode(cartitems));
    }

    // also save into sqflite
    notifyListeners();
  }

  Future<void> getcarts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cartlist = prefs.getString("cartlist");
    if (cartlist != null) {
      this.cartitems = JsonDecoder().convert(cartlist);
      print('cartitems');
      print(cartitems.length);
      double total = 0;
      cartitems.forEach((f) {
        total += (f['price']) * double.parse(f['qty']);
      });
      totalAmount = total;
      print('total');
      print(totalAmount);
      notifyListeners();
    } else {
      cartitems.clear();
      return cartitems;
    }
  }

  getcartslist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cartlist = prefs.getString("cartlist");
    if (cartlist != null) {
      var cartitems = JsonDecoder().convert(cartlist);

      print('cartitems');
      print(cartitems.length);
      return cartitems;
    } else {
      cartitems.clear();
      return cartitems;
    }
  }

  Future<void> clearcart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartlist');
    // this.guserdata=null;
    cartitems.clear();
    totalAmount = 0.0;
    notifyListeners();
  }
}
