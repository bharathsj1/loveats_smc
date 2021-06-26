import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/AuthenticationService.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/custom_text_form_field.dart';
import 'package:potbelly/widgets/dark_overlay.dart';
import 'package:potbelly/widgets/loaders.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:potbelly/widgets/spaces.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailContoller = TextEditingController();
  bool loader = false;
  bool validator = false;
  final _key = GlobalKey<FormState>();
  var service = AuthenticationService();

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
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0.0,
                child: Image.asset(
                  ImagePath.boiledEggs,
                  fit: BoxFit.cover,
                  height: heightOfScreen,
                  width: widthOfScreen,
                ),
              ),
              DarkOverLay(),
              Positioned(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Sizes.MARGIN_24),
                  child: ListView(
                    children: [
                      SpaceH16(),
                      _buildAppBar(),
                      Container(
                        margin: EdgeInsets.only(top: Sizes.MARGIN_60),
                        child: Text(
                          StringConst.RESET_PASSWORD_DESCRIPTION,
                          textAlign: TextAlign.center,
                          style: Styles.customMediumTextStyle(),
                        ),
                      ),
                      SizedBox(height: Sizes.HEIGHT_60),
                      Form(
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
                          margin: const EdgeInsets.symmetric(
                              horizontal: Sizes.MARGIN_16),
                          child: CustomTextFormField(
                            controller: _emailContoller,
                            validator: 'validateEmail',
                            hasPrefixIcon: true,
                            prefixIconImagePath: ImagePath.emailIcon,
                            hintText: StringConst.HINT_TEXT_EMAIL,
                          ),
                        ),
                      ),
                      SizedBox(height: Sizes.HEIGHT_180),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: Sizes.MARGIN_16,
                        ),
                        child: loader
                            ? Smallloader()
                            : PotbellyButton(StringConst.SEND,
                                buttonWidth: widthOfScreen, onTap: () {
                                if (_key.currentState.validate()) {
                                setState(() {
                                  loader = true;
                                });
                                  service.resetpassword(
                                      context, _emailContoller.text);
                                } else {
                                  print('error');
                                  this.validator = true;
                                  setState(() {});
                                }
                              }),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        InkWell(
          onTap: () => AppRouter.navigator.pop(),
          child: Padding(
            padding: const EdgeInsets.only(
              left: Sizes.MARGIN_12,
              right: Sizes.MARGIN_12,
              top: Sizes.MARGIN_4,
              bottom: Sizes.MARGIN_4,
            ),
            child: Image.asset(
              ImagePath.arrowBackIcon,
              fit: BoxFit.none,
            ),
          ),
        ),
        Spacer(),
        Text(
          StringConst.FORGOT_PASSWORD,
          style: Styles.customMediumTextStyle(),
        ),
        Spacer(),
      ],
    );
  }
}
