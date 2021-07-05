import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/screens/root_screen2.dart';
import 'package:potbelly/services/service.dart';

import 'package:potbelly/screens/home_screen.dart';
import 'package:potbelly/screens/login_screen.dart';
import 'package:potbelly/screens/root_screen.dart';
import 'package:potbelly/values/values.dart';
import 'dart:math' as math;

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

  void textControllerListener() async {
    if (_textController.status == AnimationStatus.completed) {
      final user = await firebaseAuth.currentUser();
      final shared = await Service().loggedUser();
      Future.delayed(Duration(milliseconds: 1000), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    shared != null ? shared == '2'? RootScreen():  RootScreen2() : BackgroundVideo()),
            (route) => false);
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
