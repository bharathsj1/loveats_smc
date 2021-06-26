import 'dart:io';

import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/AuthenticationService.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/custom_text_form_field.dart';
import 'package:potbelly/widgets/dark_overlay.dart';
import 'package:potbelly/widgets/imagepicker.dart';
import 'package:potbelly/widgets/loaders.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:potbelly/widgets/spaces.dart';
import 'package:toast/toast.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _key = GlobalKey<FormState>();
  bool validator = false;
  bool loader = false;
  bool _checkedValue = false;
  File profile;
  var service = AuthenticationService();
  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

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
          decoration: Decorations.regularDecoration,
          child: Stack(
            children: [
              Positioned(
                top: 0.0,
                child: Image.asset(
                  ImagePath.boiledEggs,
                  height: heightOfScreen,
                  width: widthOfScreen,
                  fit: BoxFit.cover,
                ),
              ),
              DarkOverLay(),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 40,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: Sizes.MARGIN_40),
                  child: ListView(
                    children: [
                      SpaceH36(),
                      _buildProfileSelector(),
                      SpaceH16(),
                      _buildForm(),
                      SpaceH40(),
                      loader
                          ? Smallloader()
                          : PotbellyButton(StringConst.REGISTER, onTap: () {
                              //  AppRouter.navigator
                              //   .pushNamed(AppRouter.setLocationScreen)
                              if (_key.currentState.validate()) {
                                setState(() {
                                  loader = true;
                                });
                                this
                                    .service
                                    .createuser(
                                        context,
                                        _emailContoller.text,
                                        _nameController.text,
                                        _passwordController.text,
                                        _checkedValue,
                                        profile)
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
                            }),
                      SpaceH40(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            StringConst.HAVE_AN_ACCOUNT_QUESTION,
                            textAlign: TextAlign.right,
                            style: Styles.customNormalTextStyle(),
                          ),
                          SpaceW16(),
                          InkWell(
                            onTap: () => AppRouter.navigator
                                .pushReplacementNamed(AppRouter.loginScreen),
                            child: Text(
                              StringConst.LOGIN,
                              textAlign: TextAlign.left,
                              style: Styles.customNormalTextStyle(
                                color: AppColors.secondaryElement,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildProfileSelector() {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.only(top: 28),
        decoration: BoxDecoration(
          color: AppColors.fillColor,
          border: Border.all(
            width: 1,
            color: Color.fromARGB(125, 0, 0, 0),
          ),
          boxShadow: [
            Shadows.secondaryShadow,
          ],
          borderRadius: BorderRadius.all(Radius.circular(76)),
        ),
        child: Stack(
          children: <Widget>[
            this.profile == null
                ? Center(
                    child: Image.asset(
                      ImagePath.personIconMedium,
                      fit: BoxFit.none,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.file(
                      profile,
                      fit: BoxFit.cover,
                      height: 150,
                      width: 150,
                    )),
            InkWell(
              onTap: () {
                settingModalBottomSheet(context);
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  ImagePath.uploadIcon,
                  fit: BoxFit.none,
                ),
              ),
            )
          ],
        ),
      ),
    );
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
      child: Column(
        children: <Widget>[
          CustomTextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return "Name can't be empty";
              } else
                return null;
            },
            hasPrefixIcon: true,
            controller: _nameController,
            prefixIconImagePath: ImagePath.personIcon,
            hintText: StringConst.HINT_TEXT_NAME,
          ),
          SpaceH16(),
          CustomTextFormField(
            validator: 'validateEmail',
            controller: _emailContoller,
            hasPrefixIcon: true,
            prefixIconImagePath: ImagePath.emailIcon,
            hintText: StringConst.HINT_TEXT_EMAIL,
          ),
          SpaceH16(),
          CustomTextFormField(
            validator: (value) {
              if (value.isEmpty || value.length < 6) {
                return value.length < 6
                    ? "password must be at least 6 characters"
                    : "Password can't be empty";
              } else
                return null;
            },
            controller: _passwordController,
            hasPrefixIcon: true,
            prefixIconImagePath: ImagePath.passwordIcon,
            hintText: StringConst.HINT_TEXT_PASSWORD,
            obscured: true,
          ),
          SpaceH16(),
          CustomTextFormField(
            validator: (value) {
              if (value != _passwordController.text) {
                return "Password confirmation doesn't match Password";
              } else
                return null;
            },
            controller: _confirmpasswordController,
            hasPrefixIcon: true,
            prefixIconImagePath: ImagePath.passwordIcon,
            hintText: StringConst.HINT_TEXT_CONFIRM_PASSWORD,
            obscured: true,
          ),
          CheckboxListTile(
            title: Text(
              "Verify Email",
              style: TextStyle(color: Colors.white),
            ),
            value: _checkedValue,
            checkColor: AppColors.secondaryElement,
            onChanged: (newValue) {
              setState(() {
                _checkedValue = newValue;
              });
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          )
        ],
      ),
    );
  }

  Future settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Wrap(
              children: <Widget>[
                Center(
                    child: Text(
                  'Choose Source',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                )),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: new ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [
                                  0.5,
                                  0.5
                                ],
                                colors: [
                                  Colors.purple[500],
                                  Colors.purple[400]
                                ])),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: new Icon(
                            Icons.image,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      title: new Text('Gallery'),
                      onTap: () {
                        Navigator.pop(context);
                        Imagepicker().opengallery(context).then((value) {
                          print(value);
                          setState(() {
                            this.profile = File(value.path);
                          });
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: new ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.5, 0.5],
                              colors: [Colors.pink[500], Colors.pink[400]])),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: new Icon(
                          Icons.camera,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    title: new Text('Camera'),
                    onTap: () {
                      Navigator.pop(context);
                      Imagepicker().opencamera(context).then((value) {
                        print(value);
                        setState(() {
                          this.profile = File(value.path);
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
