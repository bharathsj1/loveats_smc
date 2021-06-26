import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/AuthenticationService.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/custom_text_form_field.dart';
import 'package:potbelly/widgets/dark_overlay.dart';
import 'package:potbelly/widgets/loaders.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:potbelly/widgets/spaces.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:potbelly/models/Article.dart';
import 'package:video_player/video_player.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

void main() => runApp(BackgroundVideo());

class BackgroundVideo extends StatefulWidget {
  @override
  _BackgroundVideoState createState() => _BackgroundVideoState();
}

class _BackgroundVideoState extends State<BackgroundVideo> {
  // TODO 4: Create a VideoPlayerController object.
  bool validator = false;
  bool loader = false;
  VideoPlayerController _controller;
  var service = AuthenticationService();
  final _key = GlobalKey<FormState>();
  final AuthenticationService _auth = AuthenticationService();
  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // TODO 5: Override the initState() method and setup your VideoPlayerController
  @override
  void initState() {
    super.initState();
    // Pointing the video controller to our local asset.
    _controller = VideoPlayerController.asset("assets/loveats.mp4")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized.
        setState(() {});
      });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     theme: ThemeData(
  //       // Adjusted theme colors to match logo.
  //       primaryColor: Color(0xffb55e28),
  //       accentColor: Color(0xffffd544),
  //     ),
  //     home: SafeArea(
  //       child: Scaffold(
  //         // TODO 6: Create a Stack Widget
  //         body: Stack(
  //           children: <Widget>[
  //             // TODO 7: Add a SizedBox to contain our video.
  //             SizedBox.expand(
  //               child: FittedBox(
  //                 // If your background video doesn't look right, try changing the BoxFit property.
  //                 // BoxFit.fill created the look I was going for.
  //                 fit: BoxFit.cover,
  //                 child: SizedBox(
  //                   width: _controller.value.size?.width ?? 0,
  //                   height: _controller.value.size?.height ?? 0,
  //                   child: VideoPlayer(_controller),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
            children: <Widget>[
              SizedBox(
                height: heightOfScreen,
                width: widthOfScreen,
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
                bottom: 10,
                child: ListView(
                  children: <Widget>[
                    _buildHeader(),
                    SizedBox(height: Sizes.HEIGHT_200),
                    _buildForm(),
                    SpaceH36(),
                    _buildFooter()
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

  Widget _buildForm() {
    return Form(
      key: _key,
      autovalidate: validator,
      onChanged: () {
        setState(() {
          if (validator == true) {
            _key.currentState.validate();
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: Sizes.MARGIN_48),
        child: Column(
          children: <Widget>[
            CustomTextFormField(
              controller: _emailContoller,
              validator: 'validateEmail',
              hasPrefixIcon: true,
              prefixIconImagePath: ImagePath.emailIcon,
              hintText: StringConst.HINT_TEXT_EMAIL,
            ),
            SpaceH16(),
            CustomTextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value.isEmpty || value.length < 6) {
                  return value.length < 6
                      ? "password must be at least 6 characters"
                      : "Password can't be empty";
                } else
                  return null;
              },
              hasPrefixIcon: true,
              prefixIconImagePath: ImagePath.passwordIcon,
              hintText: StringConst.HINT_TEXT_PASSWORD,
              obscured: true,
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
    );
  }

  Widget _buildFooter() {
    return Column(
      children: <Widget>[
        loader
            ? Smallloader()
            : PotbellyButton(
                StringConst.LOGIN,
                onTap: () {
                  FocusScope.of(context).unfocus();

                  if (_key.currentState.validate()) {
                    //    setState(() {
                    //   this.loader = true;
                    // });
                    this
                        .service
                        .loginUser(context, _emailContoller.text,
                            _passwordController.text)
                        .then((value) {
                      setState(() {
                        this.loader = false;
                      });
                    });
                  } else {
                    print('error');
                    this.validator = true;
                    setState(() {});
                  }
                },
              ),
        SizedBox(height: Sizes.HEIGHT_60),
        InkWell(
          onTap: () => AppRouter.navigator.pushNamed(AppRouter.registerScreen),
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
}

@override
Widget _buildHeader() {
  return Align(
    alignment: Alignment.topCenter,
    child: Container(
      margin: EdgeInsets.only(top: Sizes.MARGIN_60),
      child: Text(
        StringConst.FOODY_BITE,
        textAlign: TextAlign.center,
        style: Styles.titleTextStyleWithSecondaryTextColor,
      ),
    ),
  );
}
