import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class CartProvider with ChangeNotifier {
  List cartitems = [];
  List packitems = [];
  List uchatlist = [];
  double totalAmount = 0.0;
  double packtotalAmount = 0.0;
  int cartitemlength=0;

   void updatecartaddon(context, product ,newaddon,oldaddon) async {
     await getcarts();
      int index = cartitems.indexWhere((x) {
      print('indexwhere');
      print(x.toString());
      print(product['id']);
      return x['id'] == product['id'] &&
          x['restaurantId'] == product['restaurantId'];
    });
   var extraadd = cartitems.where((x) =>x['addon'].toString() == oldaddon.toString() ).toList();
   print(index);

    //  if (extraadd.length==0) {
    //   // double total = 0.0;
    //   // cartitems.add(product);
    //   cartitems[index]['addon']=newaddon;
    //   // also save into sqflite
    //   notifyListeners();
    //   Toast.show('Item customized', context, duration: 3);
    // } else {
      // // increase the qty
      // cartitems[index]['qty'] =
      //     (int.parse(cartitems[index]['qty']) + int.parse(product['qty']))
      //         .toString();
      // cartitems[index]['payableAmount'] =
      //     ((cartitems[index]['price']) * double.parse(cartitems[index]['qty']))
      //         .toString();
      // print('payable');
      // print(cartitems[index]['payableAmount']);
      // // also save into sqflite
      // notifyListeners();
      // double total = 0;
      // cartitems.forEach((f) {
      //   total += (f['price']) * double.parse(f['qty']);
      // });
      // totalAmount = total;
      // print('total');
      // print(totalAmount);
      // notifyListeners();
      // Toast.show('Adding Quantity +' + product['qty'], context, duration: 3);
    // }
     
          // double total = 0.0;
      // cartitems.add(product);
      cartitems[index]['addon']=newaddon;
      // also save into sqflite
      notifyListeners();
      Toast.show('Item customized', context, duration: 3);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cartlist', jsonEncode(cartitems));
   }

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
    var extraadd = cartitems.where((x) =>x['addon'].toString() == product['addon'].toString() ).toList();
    print(index);
    // print(cartitems[index]['topping']);
    // print(product['topping']);
    // print(cartitems[index]['topping'].toString() == product['topping'].toString());

    if (index == -1 || extraadd.length==0) {
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
          ((cartitems[index]['price']) * double.parse(cartitems[index]['qty']))
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
  Future<void> removeqtyCart(context, cart) async {
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
  // Remove from pack cart
  Future<void> removeqtypackCart(context, pack) async {
    await getpackagecarts();
    int index = packitems.indexWhere((x) => x['id'] == pack['id']);
    if (index == -1) {
      return;
    }
    int ntotalAmount = 1 * pack['price'];
    print(ntotalAmount);
    if (packtotalAmount > 0) {
      packtotalAmount = totalAmount - ntotalAmount;
      print(packtotalAmount);
    } else {
      packtotalAmount = 0;
      print('packtotalAmount');
      print(packtotalAmount);
    }
    print(packtotalAmount);
    if (int.parse(packitems[index]['qty']) <= 1) {
      packitems.removeAt(index);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('packitems');
      await prefs.setString('packlist', jsonEncode(packitems));
      Toast.show('Item Removed', context, duration: 3);
    } else {
      packitems[index]['qty'] =
          (int.parse(packitems[index]['qty']) - 1).toString();
      double payable = 0.0;
      print('ntotalAmount');
      print(ntotalAmount);
      print('itempayyy');
      print(packitems[index]['payableAmount']);
      payable = double.parse(packitems[index]['payableAmount']) - ntotalAmount;
      print('payable');
      print(payable);
      packitems[index]['payableAmount'] = payable.toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('packitems');
      await prefs.setString('packlist', jsonEncode(packitems));
      Toast.show('Remove Quantity -1', context, duration: 3);
    }
    // also save into sqflite
    notifyListeners();
  }

  void packageaddToCart(context, package) async {
    // check array is empty
    await getpackagecarts();
    List data = [];
    int index = packitems.indexWhere((x) {
      print('indexwhere');
      print(x.toString());
      print(package['id']);
      return x['id'] == package['id'] ;
    });
    // print(cartitems[index]['topping']);
    // print(package['topping']);
    // print(cartitems[index]['topping'].toString() == package['topping'].toString());

    if (index == -1 ) {
      double total = 0.0;
      packitems.add(package);

      // also save into sqflite
      notifyListeners();
      // packitems.forEach((f) {
      //   total += (f['price']) * int.tryParse((f['qty']));
      // });
      // totalAmount = total;
      // print('total');
      // print(totalAmount);
      notifyListeners();
      Toast.show('Package Added in Cart', context, duration: 3);
    } else {
      // increase the qty
      packitems[index]['qty'] =
          (int.parse(packitems[index]['qty']) + int.parse(package['qty']))
              .toString();
      packitems[index]['payableAmount'] =
          ((packitems[index]['price']) * double.parse(packitems[index]['qty']))
              .toString();
      print('payable');
      print(packitems[index]['payableAmount']);
      // also save into sqflite
      notifyListeners();
      // double total = 0;
      // packitems.forEach((f) {
      //   total += (f['price']) * double.parse(f['qty']);
      // });
      // totalAmount = total;
      // print('total');
      // print(totalAmount);
      notifyListeners();
      Toast.show('Adding Quantity +' + package['qty'], context, duration: 3);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('packlist', jsonEncode(packitems));
  }


  Future<void> removeToCart(cart) async {
    print(cart);
    await getcarts();
    print(cartitems);
    int index = cartitems.indexWhere((x) =>
        x['id'] == cart['id'] && x['restaurantId'] == cart['restaurantId'] && x['addon'].toString() == cart['addon'].toString());
        
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
  
  Future<void> removeTopackCart(pack) async {
    print(pack);
    await getpackagecarts();
    print(packitems);
    int index = packitems.indexWhere((x) =>
        x['id'] == pack['id'] );
    if (index == -1) {
      return;
    } else {
      packitems.removeAt(index);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('packlist');
      await prefs.setString('packlist', jsonEncode(packitems));
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
      print(cartitems);
      print(cartitems.length);
      cartitemlength= cartitems.length;
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
      cartitemlength= 0;
    notifyListeners();
      return cartitems;
    }
  }

  Future<void> getpackagecarts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var packlist = prefs.getString("packlist");
    if (packlist != null) {
      this.packitems = JsonDecoder().convert(packlist);
      print('packitems');
      print(packitems);
      print(packitems.length);
      double total = 0;
      packitems.forEach((f) {
        total += (f['price']) * double.parse(f['qty']);
      });
      packtotalAmount = total;
      print('total');
      print(packtotalAmount);
      notifyListeners();
    } else {
      packitems.clear();
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
     cartitemlength= cartitems.length;
    notifyListeners();
      return cartitems;
    } else {
      cartitems.clear();
         cartitemlength= 0;
    notifyListeners();
      return cartitems;
    }
  }
  getcartspacklist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var packlist = prefs.getString("packlist");
    if (packlist != null) {
      var packitems = JsonDecoder().convert(packlist);

      print('packitems');
      print(packitems.length);
      return packitems;
    } else {
      packitems.clear();
      return packitems;
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
  Future<void> clearpackcart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('packlist');
    // this.guserdata=null;
    packitems.clear();
    // totalAmount = 0.0;
    notifyListeners();
  }
}
