import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:potbelly/screens/register_screen.dart';
import 'package:potbelly/screens/root_screen.dart';
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

class _BackgroundVideoState extends State<BackgroundVideo> {
  VideoPlayerController _controller;
  final _formKey = GlobalKey<FormState>();

  Service _service;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Pointing the video controller to our local asset.
    _controller = VideoPlayerController.asset("assets/loveats.mp4")
      ..initialize().then((_) {
        _controller.setVolume(0.0);
        // Once the video has been loaded we play the video and set looping to true.
        _controller.play();
        _controller.setLooping(true);

        // Ensure the first frame is shown after the video is initialized.
        setState(() {});
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
                  // If your background video doesn't look right, try changing the BoxFit property.
                  // BoxFit.fill created the look I was going for.

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
                top: 0,
                right: 0,
                bottom: 36,
                child: ListView(
                  children: <Widget>[
                    _buildHeader(),
                    SizedBox(height: Sizes.HEIGHT_130),
                    _buildForm(emailController, passwordController, _formKey),
                    SpaceH36(),
                    _buildFooter(
                        context, emailController, passwordController, _formKey)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
    String message = await Service()
        .signInWithEmail(context, emailCont.text, passwordCont.text);
    if (message.contains('successfully')) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => RootScreen()), (route) => false);
    } else
      showSnackBar(context, message);
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
              ),
              SpaceH16(),
              CustomTextFormField(
                hasPrefixIcon: true,
                prefixIconImagePath: ImagePath.passwordIcon,
                hintText: StringConst.HINT_TEXT_PASSWORD,
                obscured: true,
                textEditingController: password,
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  // onTap: () =>
                  //     AppRouter.navigator.pushNamed(AppRouter.forgotPasswordScreen),
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
          ),
        ),
        (route) => false);
  } else
    showSnackBar(context, message);
}

_signInWithApple(BuildContext context) async {
  FirebaseUser _user = await Service().signInWithApple();
  if (_user != null) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => RootScreen()), (route) => false);
  }
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
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => _signInWithGoogle(context),
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/images/google_icon.png'),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 14),
          Platform.isIOS
              ? SignInButton(
                  Buttons.Apple,
                  mini: true,
                  onPressed: () => _signInWithApple(context),
                )
              : Container(),
          Platform.isIOS ? SizedBox(width: 10) : Container(),
          SignInButton(
            Buttons.Facebook,
            mini: true,
            onPressed: () {},
          ),
        ],
      ),
      SizedBox(height: Sizes.HEIGHT_20),
      InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RegisterScreen(),
          ),
        ),
        child: Container(
          width: Sizes.WIDTH_150,
          height: Sizes.HEIGHT_24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                StringConst.CREATE_NEW_ACCOUNT,
                textAlign: TextAlign.center,
                style: Styles.customNormalTextStyle(),
              ),
              Spacer(),
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: 1),
                decoration: Decorations.horizontalBarDecoration,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
