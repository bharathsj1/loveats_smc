import 'package:flutter/material.dart';
import 'package:potbelly/models/subscription_model.dart';

import 'appServices.dart';

class ServiceProvider with ChangeNotifier  {
  bool usermealsub=false; //have to change to false
  bool freemealweek=false;
  bool userinradius=false;
  bool userloactionenable=false;
  var userlocaladdress;
  
  getsubdata() async {
    var res= await AppService().checksubweek();
   if(res['success']== true){
    usermealsub= res['already_subscribed'];
    freemealweek= res['free_meal_taken'];
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
      'within_KM':40 
    };
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


}