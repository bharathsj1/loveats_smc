import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/screens/root_screen2.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/service.dart';

import 'package:potbelly/screens/home_screen.dart';
import 'package:potbelly/screens/login_screen.dart';
import 'package:potbelly/screens/root_screen.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/vendor_screens.dart/open_direction.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import 'package:toast/toast.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _imageController;
  AnimationController _textController;
  Animation<double> _imageAnimation;
  Animation<double> _textAnimation;
  bool hasImageAnimationStarted = false;
  bool hasTextAnimationStarted = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _imageAnimation =
        Tween<double>(begin: 1, end: 1.5).animate(_imageController);
    _textAnimation = Tween<double>(begin: 3, end: 0.5).animate(_textController);
    _imageController.addListener(imageControllerListener);
    _textController.addListener(textControllerListener);
    run();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void imageControllerListener() {
    if (_imageController.status == AnimationStatus.completed) {
      Future.delayed(Duration(milliseconds: 1000), () {
        setState(() {
          hasTextAnimationStarted = true;
        });
        _textController.forward().orCancel;
      });
    }
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
                    shared != null ? shared == '2'? RootScreen():  RootScreen2() : BackgroundVideo()),
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
            retry();
          },
          color: AppColors.secondaryElement,
        )
      ],
    ).show();
  }


  
  Future<Position> _determinePosition() async {
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

  retry() async {
    final shared = await Service().loggedUser();
      final driving = await Service().checkdriving();
     if(shared == '3' && driving == true){
           var location = await _determinePosition();
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


  void textControllerListener() async {
    if (_textController.status == AnimationStatus.completed) {
      final user =  firebaseAuth.currentUser;
      final shared = await Service().loggedUser();
      final driving = await Service().checkdriving();
      Future.delayed(Duration(milliseconds: 1000), () async {
        if(shared == '3' && driving == true){
           var location = await _determinePosition();
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
                    shared != null ? shared == '2'? RootScreen():  RootScreen2() : BackgroundVideo()),
            (route) => false);
        }
      });
    }
  }

  void run() {
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        hasImageAnimationStarted = true;
      });
      _imageController.forward().orCancel;
    });
  }

  @override
  dispose() {
    _imageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AnimatedBuilder(
            animation: _imageController,
            child: Image.asset(
              ImagePath.splashImage,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            builder: (context, child) => RotationTransition(
              turns: hasImageAnimationStarted
                  ? Tween(begin: 0.0, end: 0.025).animate(_imageController)
                  : Tween(begin: 180.0, end: 0.02).animate(_imageController),
              child: Transform.scale(
                scale: 1 * _imageAnimation.value,
                child: child,
              ),
            ),
          ),
          hasTextAnimationStarted
              ? Center(
                  child: AnimatedBuilder(
                    animation: _textController,
                    child: Text(
                      'Loveats',
                      style: Styles.customTitleTextStyle(
                        color: AppColors.primaryText,
                      ),
                    ),
                    builder: (context, child) => Transform.scale(
                      scale: 2 * _textAnimation.value,
                      alignment: Alignment.center,
                      child: child,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
