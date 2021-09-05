import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofilters/widgets/photo_filter.dart';
import 'package:potbelly/services/ServiceProvider.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/custom_app_bar.dart';
import 'package:potbelly/widgets/custom_text_form_field.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:potbelly/widgets/spaces.dart';
import 'package:provider/provider.dart';
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

   bool _imageSelected = false;
  // File _image;
    File selectedfile;

  @override
  void initState() {
    populateUserData();
    super.initState();
  }

  
     _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Container(
            height: 190,
            decoration: BoxDecoration(
              color: AppColors.white,
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
                            Icons.image_outlined,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      title: new Text('Gallery'),
                      onTap: () {
                        Navigator.pop(context);
                        opengallery(context);
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
                          Icons.camera_alt_outlined,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    title: new Text('Camera'),
                    onTap: () {
                      Navigator.pop(context);
                      opencamera(context);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

    
  Future opencamera(BuildContext context) async {
    final image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );
    if (image != null) {
     final f = File(image.path);            
         int sizeInBytes = f.lengthSync();
         print('sizeInBytes1');
         print(sizeInBytes);
         final fff = File(image.path);            
         int sizeInBytesss = fff.lengthSync();
         print('sizeInBytes2');
         print(sizeInBytesss);
         File compressedFile = await FlutterNativeImage.compressImage(image.path,
          quality:sizeInBytes >=800000 ?60: sizeInBytes >=2000000?50:80, percentage: sizeInBytes >=800000 ?60: sizeInBytes >=2000000?50:80);
         final ff = File(compressedFile.path);            
         int sizeInBytess = ff.lengthSync();
         print('sizeInBytes3');
         print(sizeInBytess);
          setState(() {
            selectedfile= compressedFile;
            _imageSelected = true;
          });
       
          // doUploadImage(base64Encode(compressedFile.readAsBytesSync()));
    // }
    }
  }

  Future opengallery(BuildContext context) async {
    final image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (image != null) {
         final f = File(image.path);            
         int sizeInBytes = f.lengthSync();
         print('sizeInBytes1');
         print(sizeInBytes);
   
         final fff = File(image.path);            
         int sizeInBytesss = fff.lengthSync();
         print('sizeInBytes2');
         print(sizeInBytesss);
         File compressedFile = await FlutterNativeImage.compressImage(image.path,
          quality:sizeInBytes >=800000 ?60: sizeInBytes >=2000000?50:80, percentage: sizeInBytes >=800000 ?60: sizeInBytes >=2000000?50:80);
         final ff = File(compressedFile.path);            
         int sizeInBytess = ff.lengthSync();
         print('sizeInBytes3');
         print(sizeInBytess);
          setState(() {
            selectedfile= compressedFile;
            _imageSelected = true;
          });
          // doUploadImage(base64Encode(compressedFile.readAsBytesSync()));
    // }
    }
  }


  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var hintTextStyle =
        textTheme.subtitle.copyWith(color: AppColors.grey);
    var textFormFieldTextStyle =
        textTheme.subtitle.copyWith(color: Colors.black54);

        
   return Consumer<ServiceProvider>(builder: (context, service, child) {
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                SizedBox(height: 50,),
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
                 Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            Container(
              height: 180,
              width: 180,
              decoration: new BoxDecoration(
                border: Border.all(width: 2, color: AppColors.secondaryElement),
                borderRadius: new BorderRadius.all(Radius.circular(100)),
                shape: BoxShape.rectangle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: (service.userData['profile_picture'] !=null && service.userData['profile_picture'].isNotEmpty ) && _imageSelected == false?
                 Material(
                  elevation: 10,
                  shadowColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(StringConst.BASE_imageURL+ service.userData['profile_picture']),
                    backgroundColor: Colors.grey.shade300,
                    minRadius: Sizes.RADIUS_18,
                    maxRadius: Sizes.RADIUS_18,
                  ),
                ):
                 _imageSelected == false
                    ?  Material(
                  elevation: 10,
                  shadowColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/andy.png'),
                    backgroundColor: Colors.grey,
                    minRadius: Sizes.RADIUS_18,
                    maxRadius: Sizes.RADIUS_18,
                  ),
                )
                    :
                    //  Image.file(
                    //     selectedfile,
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 200,
                    //     fit: BoxFit.cover,
                    //   ),
                     Material(
                  elevation: 10,
                  shadowColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: CircleAvatar(
                    backgroundImage: FileImage(selectedfile),
                    backgroundColor: Colors.grey,
                    minRadius: Sizes.RADIUS_18,
                    maxRadius: Sizes.RADIUS_18,
                  ),
                )
              ),
            ),
            Positioned(
              bottom: 0,
              right: 20,
              child: InkWell(
                onTap: () {
                  _settingModalBottomSheet(context);
                },
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.secondaryElement.withOpacity(0.6), width: 2),
                      color: _imageSelected? AppColors.white: Colors.white),
                  child:  _imageSelected? Padding(
                    padding: const EdgeInsets.all(3),
                    child: Image.asset('assets/images/logo.png',),
                  ):
                   Icon(
                    FeatherIcons.camera,
                    size: 18,
                    color:  _imageSelected? Colors.white: AppColors.secondaryElement,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    ),
                // Spacer(),
                SizedBox(height: 30,),
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
      ),
    );
   });
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
    try{

    var data = {
      'cust_first_name': nameController.text,
    };
    bool isUpdated = await Service().updateProfile(data,context);
    // if (isUpdated) {
    //   // Toast.show('Profile Updated Successfully', context,duration:2);
    // } else {
    //   Toast.show('Error! Something went wrong', context,duration:2);
    // }

    if(_imageSelected){
      var data2={
      'profile_picture': await MultipartFile.fromFile(selectedfile.path,
            filename: selectedfile.path.split('/').last),
    };
     bool isUpdated2 = await Service().updateProfilepic(data2,context);
     if (isUpdated2 && isUpdated) {
      Toast.show('Profile Updated Successfully', context,duration:2);
    } else {
      Toast.show('Error! Something went wrong', context,duration:2);
    }
    }

    setState(() {
      _isLoading = false;
    });
    }
    catch(error){
      Toast.show('Error! Something went wrong', context,duration:2);
    }
  }
}
