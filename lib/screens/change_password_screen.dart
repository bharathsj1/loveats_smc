import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/circularIndicator.dart';
import 'package:potbelly/widgets/custom_app_bar.dart';
import 'package:potbelly/widgets/custom_text_form_field.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:potbelly/widgets/spaces.dart';
import 'package:toast/toast.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final currentPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();
  bool _isLoading = false;
  String message;
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var hintTextStyle =
        textTheme.subtitle.copyWith(color: AppColors.accentText);
    var textFormFieldTextStyle =
        textTheme.subtitle.copyWith(color: AppColors.accentText);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: CustomAppBar(
            title: "Change Password",
            hasTrailing: false,
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: Sizes.MARGIN_20, vertical: Sizes.MARGIN_20),
          child: Column(
            children: <Widget>[
              message != null
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10.0),
                     
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15.0)
                      ),
                      child: Text(
                        message,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const SizedBox(),
              Spacer(),
              CustomTextFormField(
                hasPrefixIcon: true,
                prefixIconImagePath: ImagePath.passwordIcon,
                textFormFieldStyle: textFormFieldTextStyle,
                hintText: "Current Password",
                prefixIconColor: AppColors.indigo,
                textEditingController: currentPassController,
                hintTextStyle: hintTextStyle,
                borderStyle: BorderStyle.solid,
                borderWidth: Sizes.WIDTH_1,
                obscured: true,
              ),
              SpaceH20(),
              CustomTextFormField(
                hasPrefixIcon: true,
                prefixIconImagePath: ImagePath.passwordIcon,
                textFormFieldStyle: textFormFieldTextStyle,
                hintText: "New Password",
                hintTextStyle: hintTextStyle,
                borderStyle: BorderStyle.solid,
                textEditingController: newPassController,
                borderWidth: Sizes.WIDTH_1,
                obscured: true,
                prefixIconColor: AppColors.indigo,
              ),
              SpaceH20(),
              CustomTextFormField(
                hasPrefixIcon: true,
                prefixIconImagePath: ImagePath.passwordIcon,
                textFormFieldStyle: textFormFieldTextStyle,
                hintText: "Confirm Password",
                hintTextStyle: hintTextStyle,
                borderStyle: BorderStyle.solid,
                textEditingController: confirmPassController,
                borderWidth: Sizes.WIDTH_1,
                obscured: true,
                prefixIconColor: AppColors.indigo,
              ),
              Spacer(flex: 1),
              _isLoading
                  ? CircularIndicator()
                  : PotbellyButton(
                      "Update",
                      buttonWidth: MediaQuery.of(context).size.width,
                      onTap: () => changePassword(),
                      // onTap: () => AppRouter.navigator.pushNamedAndRemoveUntil(
                      //   AppRouter.loginScreen,
                      //   (Route<dynamic> route) => false,
                      // ),
                    ),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  changePassword() async {
    if (currentPassController.text.isEmpty ||
        newPassController.text.isEmpty ||
        confirmPassController.text.isEmpty) {
      message = 'All Fields are required';
      setState(() {});
    } else {
      _isLoading = true;
      message = null;
      setState(() {});
      Map<String, dynamic> data = {
        'old_password': currentPassController.text,
        'new_password': newPassController.text,
        'confirm_password': confirmPassController.text
      };
      var response = await Service().changePassword(data);
      if (response['success'] == true) {
        currentPassController.text = null;
        newPassController.text = null;
        confirmPassController.text = null;
        Toast.show(response['message'], context);
      } else {
        message = response['message'];
      }
      _isLoading = false;
      setState(() {});
    }
  }
}
