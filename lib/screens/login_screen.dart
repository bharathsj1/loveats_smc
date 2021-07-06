import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:potbelly/models/user.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/screens/register_screen.dart';
import 'package:potbelly/screens/root_screen.dart';
import 'package:potbelly/screens/root_screen2.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/custom_text_form_field.dart';
import 'package:potbelly/widgets/dark_overlay.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:potbelly/widgets/snackbar.dart';
import 'package:potbelly/widgets/spaces.dart';

import 'package:video_player/video_player.dart';
import 'dart:io' show Platform;

// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

void main() => runApp(BackgroundVideo());

class BackgroundVideo extends StatefulWidget {
  @override
  _BackgroundVideoState createState() => _BackgroundVideoState();
}

class _BackgroundVideoState extends State<BackgroundVideo>
    with TickerProviderStateMixin {
  VideoPlayerController _controller;
  final _formKey = GlobalKey<FormState>();
  bool isLogin = false;
  double opa = 0.0;
  bool isSignIn = false;
  int bottom = 20;
  Service _service;

  AnimationController animation;
  Animation<double> _fadeInFadeOut;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Pointing the video controller to our local asset.
    _controller = VideoPlayerController.asset("assets/loveats2.mp4")
      ..initialize().then((_) {
        _controller.setVolume(0.0);
        // Once the video has been loaded we play the video and set looping to true.
        _controller.play();
        _controller.setLooping(true);

        // Ensure the first frame is shown after the video is initialized.
        setState(() {});

        animation = AnimationController(
          vsync: this,
          duration: Duration(seconds: 5),
        );
        _fadeInFadeOut = Tween<double>(begin: 0.2, end: 1).animate(animation);

        animation.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            animation.reverse();
          } else if (status == AnimationStatus.dismissed) {
            animation.forward();
          }
        });
        animation.forward();
      });
  }

  @override
  Widget build(BuildContext context) {
    var heightOfScreen = MediaQuery.of(context).size.height;
    var widthOfScreen = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Container(
          child: Stack(
            children: [
              SizedBox(
                child: FittedBox(
                  child: SizedBox(
                    child: VideoPlayer(_controller),
                    height: heightOfScreen,
                    width: widthOfScreen,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              DarkOverLay(),
              Positioned(
                left: 0,
                top: 100,
                right: 0,
                bottom: 36,
                child: ListView(
                  children: [
                    _buildHeader(),
                    SizedBox(height: Sizes.HEIGHT_130),
                    isLogin
                        ? _buildForm(
                            emailController, passwordController, _formKey)
                        : Container(),
                    SpaceH36(),
                    isLogin
                        ? _buildFooter(context, emailController,
                            passwordController, _formKey)
                        : Container()
                  ],
                ),
              ),
              !isSignIn && !isLogin
                  ?  Positioned(
                      bottom: 90,
                      left: 20,
                      right: 20,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: PotbellyButton(
                          // StringConst.SUBSCRIPTION,
                          'Create Account',
                          buttonHeight: 50,
                           buttonTextStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: AppColors.secondaryElement),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegisterScreen()

                                // style: TextStyle(
                                //     fontSize: 18.0, color: Colors.white),
                                ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              !isSignIn && !isLogin
                  ? Positioned(
                      bottom: 30,
                      left: 20,
                      right: 20,
                      child: InkWell(
                        onTap: () => _signIn(),
                        child: Container(
                           margin: EdgeInsets.symmetric(horizontal: 30),
                          child: PotbellyButton('Sign in',
                          buttonHeight: 50,
                          buttonTextStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),

                           onTap: () => _signIn()

                              // style: TextStyle(
                              //     fontSize: 18.0, color: Colors.white),

                              ),
                        ),
                      ),
                    )
                  : Container(),
              SpaceH36(),
              isSignIn
                  ? Positioned(
                      left: 20,
                      right: 20,
                      bottom: bottom.toDouble(),
                      child: FadeTransition(
                        opacity: _fadeInFadeOut,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SignInButton(
                              Buttons.Email,
                              // mini: true,
                              onPressed: () => _showLoginForm(),
                            ),
                            SignInButton(
                              Buttons.Google,
                              // mini: true,
                              onPressed: () => _signInWithGoogle(context),
                            ),
                            SizedBox(width: 14),
                            Platform.isIOS
                                ? SignInButton(
                                    Buttons.Apple,
                                    // mini: true,
                                    onPressed: () => _signInWithApple(context),
                                  )
                                : Container(),
                            Platform.isIOS ? SizedBox(width: 10) : Container(),
                            SignInButton(
                              Buttons.Facebook,
                              // mini: true,
                              onPressed: () {},
                            ),
                            SizedBox(height: Sizes.HEIGHT_20),
                            InkWell(
                                onTap: () => _signIn(),
                                child: Text('Back',
                                     style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white)))
                          ],
                        ),
                      ),
                    )
                  : Container(),
              // _buildFooter(
              //     context, emailController, passwordController, _formKey)
            ],
          ),
        ),
      ),
    );
  }

  _showLoginForm() {
    setState(() {
      isSignIn = !isSignIn;
      isLogin = !isLogin;
    });
  }

  _signIn() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }

  // TODO 8: Override the dipose() method to cleanup the video controller.
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
_signInWithEmail(BuildContext context, TextEditingController emailCont,
    TextEditingController passwordCont, key) async {
  if (key.currentState.validate()) {
    var response = await Service()
        .signInWithEmail(context, emailCont.text, passwordCont.text);
    if (response['message'].contains('success')) {
      print(response['user']);
      
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => response['user'].data.custAccountType =='2'? RootScreen():RootScreen2()), (route) => false);
    } else
      showSnackBar(context, response['message']);
  }
}


@override
Widget _buildHeader() {
  return Align(
    alignment: Alignment.topCenter,
    child: Container(
      margin: EdgeInsets.only(top: Sizes.MARGIN_30),
      child: Text(
        StringConst.FOODY_BITE,
        textAlign: TextAlign.center,
        style: Styles.titleTextStyleWithSecondaryTextColor,
      ),
    ),
  );
}

emailValidation(String value) {
  if (value.isEmpty)
    return 'Email is required';
  else if (!value.contains('@')) return 'Invalid Email';
}

passwordValidation(String value) {
  if (value.isEmpty)
    return 'Password is required';
  else if (value.length < 8) return 'Password is wrong';
}

Widget _buildForm(
    TextEditingController email, TextEditingController password, _key) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: Sizes.MARGIN_48),
    child: Column(
      children: [
        Form(
          key: _key,
          child: Column(
            children: [
              CustomTextFormField(
                hasPrefixIcon: true,
                prefixIconImagePath: ImagePath.emailIcon,
                hintText: StringConst.HINT_TEXT_EMAIL,
                textEditingController: email,
                function: emailValidation,
              ),
              SpaceH16(),
              CustomTextFormField(
                hasPrefixIcon: true,
                prefixIconImagePath: ImagePath.passwordIcon,
                hintText: StringConst.HINT_TEXT_PASSWORD,
                obscured: true,
                textEditingController: password,
                function: passwordValidation,
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => AppRouter.navigator
                      .pushNamed(AppRouter.forgotPasswordScreen),
                  child: Container(
                    margin: EdgeInsets.only(top: Sizes.MARGIN_16),
                    child: Text(
                      StringConst.FORGOT_PASSWORD_QUESTION,
                      textAlign: TextAlign.right,
                      style: Styles.customNormalTextStyle(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

_signInWithGoogle(BuildContext context) async {
  String message = await Service().signInWithGoogle();
  print(message);

  if (message.contains('successfully')){

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => RootScreen()), (route) => false);
  }
  
  else if (message.contains('register screen')) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    var currUser = await _auth.currentUser();
    print(currUser.uid);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterScreen(
            email: currUser.email,
            uid: currUser.uid,
            type: 1,
          ),
        ),
        (route) => false);
  } else
    showSnackBar(context, message);
}

_signInWithApple(BuildContext context) async {
  String message = await Service().signInWithApple();
  print(message);

  if (message.contains('successfully'))
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => RootScreen()), (route) => false);
  else if (message.contains('register screen')) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    var currUser = await _auth.currentUser();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterScreen(
            email: currUser.email,
             uid: currUser.uid,
             type: 2,
          ),
        ),
        (route) => false);
  } else
    showSnackBar(context, message);
}

Widget _buildFooter(BuildContext context, TextEditingController email,
    TextEditingController pass, key) {
  return Column(
    children: [
      PotbellyButton(
        StringConst.LOGIN,
        onTap: () => _signInWithEmail(context, email, pass, key),
      ),
      SizedBox(height: Sizes.HEIGHT_20),
      InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => RegisterScreen())),
        child: Text(
          StringConst.CREATE_NEW_ACCOUNT,
          style: Styles.normalTextStyle,
        ),
      )
    ],
  );
}
