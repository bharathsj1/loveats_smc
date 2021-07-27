import 'package:flutter/material.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/custom_app_bar.dart';
import 'package:potbelly/widgets/custom_text_form_field.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:potbelly/widgets/spaces.dart';
import 'package:toast/toast.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var userData;

  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    populateUserData();
    super.initState();
  }

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
            title: "Edit Profile",
            hasTrailing: false,
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: Sizes.MARGIN_20,
          ),
          child: Column(
            children: <Widget>[
              // Stack(
              //   children: <Widget>[
              //     Positioned(
              //       child: CircleAvatar(
              //         backgroundImage: AssetImage(ImagePath.andy),
              //         minRadius: 70.0,
              //         maxRadius: 70.0,
              //       ),
              //     ),
              //     Positioned(
              //       left: 90,
              //       top: 94,
              //       child: Image.asset(
              //         ImagePath.uploadIcon,
              //         fit: BoxFit.cover,
              //       ),
              //     ),
              //   ],
              // ),
              Spacer(),
              CustomTextFormField(
                hasPrefixIcon: true,
                prefixIconImagePath: ImagePath.personIcon,
                textFormFieldStyle: textFormFieldTextStyle,
                textEditingController: nameController,
                hintText: "John Williams",
                prefixIconColor: AppColors.secondaryElement,
                hintTextStyle: hintTextStyle,
                borderStyle: BorderStyle.solid,
                borderWidth: Sizes.WIDTH_1,
              ),
              SpaceH20(),
              // CustomTextFormField(
              //   hasPrefixIcon: true,
              //   prefixIcon: (Icons.mobile_friendly),
              //   textFormFieldStyle: textFormFieldTextStyle,
              //   hintText: "9203222222",
              //   hintTextStyle: hintTextStyle,
              //   borderStyle: BorderStyle.solid,
              //   borderWidth: Sizes.WIDTH_1,
              //   textEditingController: phoneNumberController,
              //   prefixIconColor: AppColors.secondaryElement,
              // ),

              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.secondaryElement),
                      ),
                    )
                  : PotbellyButton(
                      "Update",
                      buttonWidth: MediaQuery.of(context).size.width,
                      onTap: () => updateProfile(),
                    ),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  populateUserData() async {
    this.userData = await AppService().getCurrentUserData();
    nameController.text = userData['cust_first_name'];
    phoneNumberController.text = userData['cust_phone_number'];
    print(userData);
  }

  updateProfile() async {
    _isLoading = true;
    setState(() {});
    var data = {
      'cust_first_name': nameController.text,
    };
    bool isUpdated = await Service().updateProfile(data);
    if (isUpdated) {
      Toast.show('Profile Updated Successfully', context);
    } else {
      Toast.show('Something really bad happens', context);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
