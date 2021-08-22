import 'package:flutter/material.dart';

import 'appServices.dart';

class ServiceProvider with ChangeNotifier  {
  bool usermealsub=true; //have to change to false
  bool freemealweek=false;
  
  getsubdata() async {
    var res= await AppService().checksubweek();
   if(res['success']== true){
    usermealsub= res['already_subscribed'];
    freemealweek= res['free_meal_taken'];
   }
    print(res);
    notifyListeners();
  }
}