import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:potbelly/Flip_nav_bar/demo.dart';
import 'package:potbelly/grovey_startScreens/demo.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/screens/home_screen.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/vendor_screens.dart/Home_screen.dart';
import 'package:potbelly/vendor_screens.dart/open_direction.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';

class New_Splash extends StatefulWidget {
  @override
  _New_SplashState createState() => _New_SplashState();
}

class _New_SplashState extends State<New_Splash> with TickerProviderStateMixin {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  VideoPlayerController _controller;

  AnimationController animationcontroll;
  @override
  void initState() {
    // TODO: implement initState
    // initialize();
    animationcontroll = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    super.initState();
  }

  @override
  dispose() {
    // if (_controller != null) {
    //   _controller.dispose();
    // }
    animationcontroll.dispose();
    super.dispose();
  }

  initialize() {
    // print(videourl);
    if (_controller != null) {
      _controller.dispose();
    }
    _controller = VideoPlayerController.asset('assets/splashvid.mp4')
      ..addListener(() {
        if (_controller.value.position == _controller.value.duration) {
          print('video Ended');
          navigatetonext(context);
        }
      })
      ..initialize().then((_) {
        _controller.play();
        // _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Lottie.asset(
          // 'assets/food.json',
          'assets/splash.json',
          // 'assets/food2.json',
          // 'assets/food3.json',
          width: MediaQuery.of(context).size.width,
          frameRate: FrameRate.max,
          fit: BoxFit.fill,
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
        )
        // child: SizedBox(
        //   child: FittedBox(
        //     child: SizedBox(
        //       child: VideoPlayer(_controller),
        //       height: MediaQuery.of(context).size.height,
        //       width: MediaQuery.of(context).size.width,
        //     ),
        //     fit: BoxFit.fill,
        //   ),
        // ),
      ),
    );
  }

  navigatetonext(context) async {
    final user = firebaseAuth.currentUser;
    final shared = await Service().loggedUser();
    final driving = await Service().checkdriving();
    Future.delayed(Duration(milliseconds: 1000), () async {
      if (shared == '3' && driving == true) {
        var location = await _determinePosition(context);
        print(location);
        if (location == null) {
          _onAlertButtonsPressed(context, '');
        } else {
          SharedPreferences pref = await SharedPreferences.getInstance();
          var orderdata = pref.get('drivingorder');
          var order = jsonDecode(orderdata);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => Open_direction(desdirection: {
                        'lat': double.parse(
                            order['user_address']['user_latitude']),
                        'long': double.parse(
                            order['user_address']['user_longitude']),
                        'clat': location.latitude,
                        'clong': location.longitude,
                        'data': order,
                        'driving': true
                      })),
              (route) => false);
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
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => shared != null
                    ?
                    shared == '2'?
                    //  BubbleTabBarDemo(type: shared,)
                    HomeScreen(): Vendor_Home_screen()
                    :
                    //  BackgroundVideo()
                    GooeyEdgeDemo()),
            (route) => false);
      }
    });
  }

  _onAlertButtonsPressed(context, detail) {
    return Alert(
      context: context,
      type: AlertType.error,
      closeIcon: Container(
        height: 20,
      ),
      onWillPopActive: false,
      useRootNavigator: false,
      closeFunction: null,
      title: "Are you still driving?",
      desc: detail,
      buttons: [
        DialogButton(
          child: Text(
            "Cancel driving",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            var orderdata = pref.get('drivingorder');
            var order = jsonDecode(orderdata);
            final shared = await Service().loggedUser();
            var data = {'order_id': order['id'], 'status': 'ready'};
            AppService().setorderstatus(data).then((value) {
              pref.remove('driving');
              pref.remove('drivingorder');
              print(value);
              if (value['message'].contains('Successfully')) {}
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => shared != null
                        ? BubbleTabBarDemo(
                            type: shared,
                          )
                        : GooeyEdgeDemo()),
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
    if (shared == '3' && driving == true) {
      var location = await _determinePosition(context);
      print(location);
      if (location != null) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        var orderdata = await pref.get('drivingorder');
        var order = jsonDecode(orderdata);
        Navigator.pushNamed(context, AppRouter.Opendirection, arguments: {
          'lat': double.parse(order['user_address']['user_latitude']),
          'long': double.parse(order['user_address']['user_longitude']),
          'clat': location.latitude,
          'clong': location.longitude,
          'data': order,
          'driving': true
        });
      } else {
        _onAlertButtonsPressed(context, '');
      }
    }
  }
}
