import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class BookmarkService with ChangeNotifier {

    getbookmarklist() async {
    List<dynamic> temp = [];
    List localbookmark=[];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var carts = prefs.getString("bookmarks");
    print(carts);
    if (carts == null) {
      print("Nothing");
      return localbookmark;
    } else {

      temp.add(JsonDecoder().convert(carts));

      for (var item in temp[0]) {
        localbookmark.add(item);
      }
      return localbookmark;
    }
  }

    
 Future  addbookmark(context, restaurant) async {
    // check array is empty
   var bookmarklist= await getbookmarklist();
    int index = bookmarklist.indexWhere((x) {
      return x['id'] == restaurant['id'];
    });
    if (index == -1) {
      bookmarklist.add(restaurant);
      // also save into sqflite
       SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('bookmarks', jsonEncode(bookmarklist));
    
      notifyListeners();
      Toast.show('restaurant added to bookmarks', context, duration: 3);
      return 'success';
    } else {
      // increase the qty
      bookmarklist.removeAt(index);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('bookmarks');
      await prefs.setString('bookmarks', jsonEncode(bookmarklist));
      notifyListeners();
      Toast.show('restaurant removed from bookmarks', context, duration: 3);
      return 'success';
    }
   
  }

 Future checkbookmark(restaurant) async {
    var bookmarklist= await getbookmarklist();
    int index = bookmarklist.indexWhere((x) {
      return x['id'] == restaurant['id'];
    });
    if (index == -1) {
      return false;
  }
  else{
    return true;
  }
  }
}