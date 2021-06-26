import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/models/UserModel.dart';
import 'package:potbelly/screens/login_screen.dart';
import 'package:potbelly/screens/root_screen.dart';
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

  const RegisterScreen({Key key, this.email}) : super(key: key);
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
                        ImagePath.uploadIcon,
                        fit: BoxFit.none,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
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
          ),
          SpaceH16(),
          CustomTextFormField(
            hasPrefixIcon: true,
            textEditingController: emailController,
            prefixIconImagePath: ImagePath.emailIcon,
            hintText: StringConst.HINT_TEXT_EMAIL,
          ),
          SpaceH16(),
          CustomTextFormField(
            hasPrefixIcon: true,
            textEditingController: passwordController,
            prefixIconImagePath: ImagePath.passwordIcon,
            hintText: StringConst.HINT_TEXT_PASSWORD,
            obscured: true,
          ),
          SpaceH16(),
          CustomTextFormField(
            hasPrefixIcon: true,
            textEditingController: phoneNoController,
            prefixIconImagePath: ImagePath.callIcon,
            hintText: StringConst.HINT_TEXT_PHONE_NO,
          ),
        ],
      ),
    );
  }

  void validateFormAndCreateUser(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = await _auth.currentUser();
    print('In validate Form');
    String message;
    if (_formKey.currentState.validate()) {
      String url = await Service().uploadImageToServer(_profilePicture);

      UserModel userModel = UserModel(
          currentUser != null ? currentUser.uid : '',
          nameController.text,
          emailController.text,
          passwordController.text,
          phoneNoController.text,
          url ?? '');

      if (widget.email != null) {
        message = await Service().setDataInUserCollection(userModel);
      } else {
        message = await Service().registerWithEmail(userModel, _profilePicture);
      }
      if (message.contains('successfully'))
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => RootScreen()));
      else {
        showSnackBar(context, message);
      }
    }
  }
}
