import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/models/UserModel.dart';
import 'package:potbelly/screens/login_screen.dart';
import 'package:potbelly/screens/root_screen.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/custom_text_form_field.dart';
import 'package:potbelly/widgets/dark_overlay.dart';
import 'package:potbelly/widgets/image_pick.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:potbelly/widgets/snackbar.dart';
import 'package:potbelly/widgets/spaces.dart';

class RegisterScreen extends StatefulWidget {
  final String email;
  final String uid;
  final int type;

  const RegisterScreen({Key key, this.email, this.uid, this.type})
      : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final phoneNoController = TextEditingController();

  File _profilePicture;

  double heightOfScreen;
  double widthOfScreen;

  Service _service = Service();

  @override
  void initState() {
    if (widget.email != null) {
      emailController.text = widget.email;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    heightOfScreen = MediaQuery.of(context).size.height;
    widthOfScreen = MediaQuery.of(context).size.width;
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
                      PotbellyButton(
                        StringConst.REGISTER,
                        
                        onTap: () => validateFormAndCreateUser(context),
                      ),
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
                            onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => BackgroundVideo())),
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

  getImage() async {
    PickImage pickImage = PickImage();
    File picture = await pickImage.imgFromGallery();
    if (picture != null) {
      setState(() {
        _profilePicture = picture;
      });
    }
  }

  Widget _buildProfileSelector() {
    return InkWell(
      onTap: () => getImage(),
      child: Center(
        child: _profilePicture != null
            ? CircleAvatar(
                backgroundImage: FileImage(_profilePicture),
                radius: widthOfScreen * 0.14,
                backgroundColor: Colors.grey[400].withOpacity(
                  0.4,
                ),
              )
            : Container(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50.0),
                    Center(
                      child: Image.asset(
                        ImagePath.personIconMedium,
                        fit: BoxFit.none,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        ImagePath.uploadIcon2,
                        fit: BoxFit.none,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  passwordValidator(String value) {
    if (value.isEmpty) {
      return 'Passowrd field is required';
    } else if (value.length <= 7) {
      return 'Password field must be greater then 8';
    }
  }

  emailValidator(String value) {
    if (value.isEmpty) {
      return 'Email field is required';
    } else if (!value.contains('@')) {
      return 'Email is invalid';
    }
  }

  nameValidator(String value) {
    if (value.isEmpty)
      return 'Name field is required';
    else if (value.length < 3) return 'Please enter valid name';
  }

  phoneValidator(String value) {
    if (value.isEmpty)
      return 'Phone number is required';
    else if (value.length < 10) return 'Invalid PHone Number';
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextFormField(
            hasPrefixIcon: true,
            textEditingController: nameController,
            prefixIconImagePath: ImagePath.personIcon,
            hintText: StringConst.HINT_TEXT_NAME,
            function: nameValidator,
          ),
          SpaceH16(),
          CustomTextFormField(
            hasPrefixIcon: true,
            textEditingController: emailController,
            prefixIconImagePath: ImagePath.emailIcon,
            hintText: StringConst.HINT_TEXT_EMAIL,
            function: emailValidator,
          ),
          SpaceH16(),
          CustomTextFormField(
            hasPrefixIcon: true,
            textEditingController: passwordController,
            prefixIconImagePath: ImagePath.passwordIcon,
            hintText: StringConst.HINT_TEXT_PASSWORD,
            function: passwordValidator,
            obscured: true,
          ),
          SpaceH16(),
          CustomTextFormField(
            hasPrefixIcon: true,
            textEditingController: phoneNoController,
            prefixIconImagePath: ImagePath.callIcon,
            hintText: StringConst.HINT_TEXT_PHONE_NO,
            function: phoneValidator,
          ),
        ],
      ),
    );
  }

  void validateFormAndCreateUser(BuildContext context) async {
    print('In Validating form section');

    if (_formKey.currentState.validate()) {
      UserModel userModel = UserModel(
          '',
          nameController.text,
          emailController.text,
          passwordController.text,
          phoneNoController.text,
          '');

      String uid = widget.uid;
      print(uid);
      var message = await _service.registerUserWithEmail(
          userModel, _profilePicture, uid, widget.type ?? 0);
      print(message);
      if (message == 'success') {
    // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
        var udid;
       DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      udid = androidInfo.id;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      udid = iosInfo.identifierForVendor;
    }
    //  _firebaseMessaging.getToken().then((tokeen) {
    //   var data={
    //     'device_id':udid,
    //     'firebase_token':tokeen
    //   };
      // AppService().savedeicetoken(data).then((value){
        // print(value);
    //   Navigator.pushAndRemoveUntil(context,
    //      MaterialPageRoute(builder: (_) =>  RootScreen()), (route) => false);
    //   });
    //  });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => RootScreen()));
      } else {
        showSnackBar(context, message);
      }
    } else {
      print('Not Validate');
    }

    // FirebaseAuth _auth = FirebaseAuth.instance;
    // var currentUser = await _auth.currentUser();
    // print('In validate Form');
    // String message;
    // if (_formKey.currentState.validate()) {
    //   UserModel userModel = UserModel(
    //       currentUser != null ? currentUser.uid : '',
    //       nameController.text,
    //       emailController.text,
    //       passwordController.text,
    //       phoneNoController.text,
    //       '');

    //   if (widget.email != null) {
    //     message = await Service().setDataInUserCollection(userModel);
    //   } else {
    //     message = await Service().registerWithEmail(userModel, _profilePicture);
    //   }
    //   if (message.contains('successfully'))
    //     Navigator.push(
    //         context, MaterialPageRoute(builder: (_) => RootScreen()));
    //   else {
    //     showSnackBar(context, message);
    //   }
    // }
  }
}
