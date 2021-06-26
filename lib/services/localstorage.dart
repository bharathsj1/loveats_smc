import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Localstorage {
  Future getlocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var local = prefs.getBool('data');
    print(local);
    return local;
  }

 Future setlocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var local = prefs.setBool('data', true);
    print(local);
    return local;
  }

 Future setuser(user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setString('user', user.toString());
    return 'success';
  }

 Future getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data= prefs.getString('user');
    print(data);
    // if(data !=null){
    // data= jsonDecode(data);
    // }
    return data;
  }

 Future loggout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data= prefs.remove('user');
    return 'success';
  }
}
