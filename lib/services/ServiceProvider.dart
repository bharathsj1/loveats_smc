import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:potbelly/models/subscription_model.dart';
import 'package:potbelly/services/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'appServices.dart';

class ServiceProvider with ChangeNotifier  {
  bool usermealsub=false; //have to change to false
  bool freemealweek=false;
  bool userinradius=false;
  bool userloactionenable=false;
  var userlocaladdress;
  int cartitemlength=0;
  SharedPreferences prefs;
  var userData={};
  List orderslist = [];
  bool loader = true;
  bool reloader = true;

  
  getsubdata(context) async {
    var res= await AppService().checksubweek();
   if(res['success']== true){
    usermealsub= res['already_subscribed'];
    freemealweek= res['free_meal_taken'];
   }
   else{
       Toast.show('Comment is empty', context, duration: 3);
   }
    print(res);
    notifyListeners();
  }

  getuserradius(lat,lng) async {
    userloactionenable=true;
    var data= {
      'rest_id':1,
      'lat':lat,
      'lng': lng,
      'within_km':6420
    };
    print(data);
    var res= await AppService().checkradius(data);
   if(res['success']== true){
     
   }
    print(res);
  }
    notifyListeners();


    checklocation() async {
    var res= await AppService().localaddress();
    if(res !=null && res['location']){
      userlocaladdress=res['address'];
      userloactionenable=res['location'];
      print(userlocaladdress);
      getuserradius(res['coords']['latitude'],res['coords']['longitude']);
    }
    else{
      userloactionenable=false;
      userlocaladdress=null;
    }
    notifyListeners();
  }



 getcartslist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cartlist = prefs.getString("cartlist");
    if (cartlist != null) {
      var cartitems = JsonDecoder().convert(cartlist);
      print('cartitems');
      print(cartitems.length);
      cartitemlength= cartitems.length;
    } else {
      cartitemlength=0;
    }
    notifyListeners();
  }

     getUserDetail() async {
    prefs = await Service().initializdPrefs();
    userData = await AppService().getCurrentUserData2();
    print('userData');
    print(userData);
    notifyListeners();
  }


    getorders() async {
    // notifyListeners();
    String accounttype = await AppService().gettype();
    var orders = await AppService().getOrdersRestaurent();
    print(orders);
    orderslist = orders['data'];
    if(accounttype =='4'){
    orderslist= orderslist.reversed.toList();
    }
    loader = false;
    reloader = false;
    notifyListeners();
  }

  resetorder(){
    loader=true;
    reloader=true;
    orderslist.clear();
    notifyListeners();
  }

}