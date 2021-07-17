import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:potbelly/Flip_nav_bar/demo.dart';
import 'package:potbelly/grovey_startScreens/demo.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/vendor_screens.dart/open_direction.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class New_Splash extends HookWidget {
   FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final animationcontroll = useAnimationController();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Lottie.asset(
          'assets/food.json',
          // 'assets/food2.json',
          // 'assets/food3.json',
          controller: animationcontroll,
          onLoaded: (value) {
            animationcontroll.addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                navigatetonext(context);
              }
            });
            animationcontroll
              ..duration = value.duration
              ..forward();
          },
        ),
      ),
    );
  }

  navigatetonext(context) async {
    // final shared = await Service().loggedUser();
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //         builder: (_) => shared != null
    //             ? BubbleTabBarDemo(
    //                 type: shared,
    //               )
    //             :
    //             //  BackgroundVideo()
    //             GooeyEdgeDemo()),
    //     (route) => false);
      final user =  firebaseAuth.currentUser;
      final shared = await Service().loggedUser();
      final driving = await Service().checkdriving();
      Future.delayed(Duration(milliseconds: 1000), () async {
        if(shared == '3' && driving == true){
           var location = await _determinePosition(context);
                print(location);
                if(location == null){
                 _onAlertButtonsPressed(context, '');
                }
                else{
                   SharedPreferences pref = await SharedPreferences.getInstance();
                  var orderdata=await  pref.get('drivingorder');
                  var order= jsonDecode(orderdata);
                  Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
                builder: (_) => Open_direction(desdirection:  {
                        'lat': double.parse(
                            order['user_address']['user_latitude']),
                        'long': double.parse(
                            order['user_address']['user_longitude']),
                        'clat': location.latitude,
                        'clong': location.longitude,
                        'data': order,
                        'driving': true
                      })), (route) => false);
                    // Navigator.pushNamed(context, AppRouter.Opendirection,
                    //   arguments: {
                    //     'lat': double.parse(
                    //         order['user_address']['user_latitude']),
                    //     'long': double.parse(
                    //         order['user_address']['user_longitude']),
                    //     'clat': location.latitude,
                    //     'clong': location.longitude,
                    //     'data': order,
                    //     'driving': true
                    //   });
                }
        }
        else{
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    shared != null ?  BubbleTabBarDemo(type: shared,) :
                    //  BackgroundVideo()
                    GooeyEdgeDemo()
                     ),
            (route) => false);
        }
      });
    }
  
    _onAlertButtonsPressed(context, detail) {
    //  StatefulBuilder(
    //       builder: (BuildContext context, StateSetter setState) {
    return Alert(

      context: context,
      type: AlertType.error,
       closeIcon: Container(height: 20,),
       onWillPopActive: false,
       useRootNavigator: false,
      closeFunction: null,
      title: "Are you still driving?",
      desc: detail,
      buttons: [
        DialogButton(
          child: Text(
            "Cancle driving",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
             var orderdata=await  pref.get('drivingorder');
                  var order= jsonDecode(orderdata);
                    final shared = await Service().loggedUser();
                    var data = {'order_id': order['id'], 'status': 'ready'};
                    AppService().setorderstatus(data).then((value) {
                      pref.remove('driving');
                    pref.remove('drivingorder');
                    print(value);
                    if (value['message'].contains('Successfully')) {
                     } });
                     Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    shared != null ? BubbleTabBarDemo(type: shared,):
                    //  BackgroundVideo()
                    GooeyEdgeDemo()
                     ),
            (route) => false);
          },
          color: Colors.grey,
        ),
        DialogButton(
          child: Text(
            "Retry",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () async {
           Navigator.of(context).pop();
            retry(context);
          },
          color: AppColors.secondaryElement,
        )
      ],
    ).show();
  }

  Future<Position> _determinePosition(context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Toast.show(
          'Location services are disabled. Turn on your location', context,
          duration: 4);
      // return Future.error('Location services are disabled.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Toast.show(
            'Location permissions are denied. Turn on your location', context,
            duration: 4);
        // return Future.error('Location permissions are denied');
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Toast.show(
          'Location permissions are permanently denied, we cannot request permissions. Turn on your location',
          context,
          duration: 4);
      // return Future.error(
      //   'Location permissions are permanently denied, we cannot request permissions.');
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }

  retry(context) async {
    final shared = await Service().loggedUser();
      final driving = await Service().checkdriving();
     if(shared == '3' && driving == true){
           var location = await _determinePosition(context);
           print(location);
             if (location != null) {
                SharedPreferences pref = await SharedPreferences.getInstance();
                  var orderdata=await  pref.get('drivingorder');
                  var order= jsonDecode(orderdata);
                    Navigator.pushNamed(context, AppRouter.Opendirection,
                      arguments: {
                        'lat': double.parse(
                            order['user_address']['user_latitude']),
                        'long': double.parse(
                            order['user_address']['user_longitude']),
                        'clat': location.latitude,
                        'clong': location.longitude,
                        'data': order,
                        'driving': true
                      });
             }
             else{
             _onAlertButtonsPressed(context, '');
             }
        }
  }


}