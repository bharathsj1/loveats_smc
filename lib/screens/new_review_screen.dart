import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/screens/home_screen.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/custom_text_form_field.dart';
import 'package:potbelly/widgets/ratings_widget.dart';
import 'package:potbelly/widgets/search_card.dart';
import 'package:potbelly/widgets/search_input_field.dart';
import 'package:potbelly/widgets/spaces.dart';
import 'package:toast/toast.dart';

class NewReviewScreen extends StatefulWidget {
   var orderdata;
  NewReviewScreen({@required this.orderdata});

  @override
  _NewReviewScreenState createState() => _NewReviewScreenState();
}

class _NewReviewScreenState extends State<NewReviewScreen> {
  TextEditingController controller = TextEditingController();
  bool showSuffixIcon = false;
  bool hasRestaurantBeenAdded = false;
  bool isCardShowing = false;
  bool canPost = false;
    bool _imageSelected=false;
  File selectedfile;
  double starsrating=1.0;
    TextEditingController review = TextEditingController();


  TextStyle subTitleTextStyle = Styles.customNormalTextStyle(
    color: AppColors.grey,
    fontSize: Sizes.TEXT_SIZE_16,
  );

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

  uploadrating() async {
    int userId = await Service().getUserId_int();
    print(widget.orderdata['orderdata']);
    var data={
      'order_id':widget.orderdata['orderdata']['id'],
      'rating':newstarsrating.toString(),
      'comment':review.text,
      'rest_id':widget.orderdata['orderdata']['order_detail'][0]['rest_details']['id'],
      'image': await MultipartFile.fromFile(selectedfile.path,
            filename: selectedfile.path.split('/').last),
      'user_id':userId,
    };
    print(data);
     AppService().addnewreview(data).then((value) {
        print(value);
        if(value['success'] == true){
        Toast.show('Thanks for adding review', context, duration: 3);
        Navigator.pop(context,value['data']);
        }
        else{
        Toast.show('error', context, duration: 3);
        }
      });
      setState(() {});
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
      // File croppedFile = await ImageCropper.cropImage(
      //   sourcePath: image.path,
      //   aspectRatioPresets: Platform.isAndroid
      //       ? [
      //           CropAspectRatioPreset.square,
      //         ]
      //       : [
      //           CropAspectRatioPreset.square
      //         ],
      //   androidUiSettings: AndroidUiSettings(
      //     cropFrameColor: primaryColor,
      //     activeControlsWidgetColor: primaryColor,
      //       toolbarTitle: AppLocalizations.of(context).translate('Image Crop'),
      //       toolbarColor: primaryColor,
      //       toolbarWidgetColor: Colors.white,
      //       initAspectRatio: CropAspectRatioPreset.square,
      //       lockAspectRatio: true),
      //   iosUiSettings: IOSUiSettings(
      //     title: AppLocalizations.of(context).translate('Image Crop'),  
      //     aspectRatioLockEnabled: true,
      //   ));
    // if (croppedFile != null) {
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
            selectedfile = compressedFile;
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
    //  File croppedFile = await ImageCropper.cropImage(
    //     sourcePath: image.path,
    //     aspectRatioPresets: Platform.isAndroid
    //         ? [
    //             CropAspectRatioPreset.square
    //           ]
    //         : [
    //             CropAspectRatioPreset.square
    //           ],
    //     androidUiSettings: AndroidUiSettings(
    //       cropFrameColor: primaryColor,
    //       activeControlsWidgetColor: primaryColor,
    //         toolbarTitle: AppLocalizations.of(context).translate('Image Crop'),
    //         toolbarColor: primaryColor,
    //         toolbarWidgetColor: Colors.white,
    //         initAspectRatio: CropAspectRatioPreset.square,
    //         lockAspectRatio: true),
    //     iosUiSettings: IOSUiSettings(
    //       title: AppLocalizations.of(context).translate('Image Crop'), 
    //       aspectRatioLockEnabled: true,
                  
    //     ));
    // if (croppedFile != null) {
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

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(68.0),
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: Sizes.MARGIN_16,
              vertical: Sizes.MARGIN_16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  // onTap: () => AppRouter.navigator.pushNamedAndRemoveUntil(
                  //   AppRouter.rootScreen,
                  //   (Route<dynamic> route) => false,
                  //   arguments: CurrentScreen(
                  //     tab_no: HomeScreen.TAB_NO,
                  //     currentScreen: HomeScreen(),
                  //   ),
                  // ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(left: 4),
                      child: Text(
                        'Cancel',
                        style: textTheme.body1.copyWith(
                          color: Colors.black54,
                          fontSize: Sizes.TEXT_SIZE_16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "New Review",
                  style: Styles.customTitleTextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: Sizes.TEXT_SIZE_22,
                  ),
                ),
                InkWell(

                  onTap: selectedfile !=null && review.text.isNotEmpty
                      ?(){ 
                        FocusScope.of(context).unfocus();
                        uploadrating();
                      }
                      : null,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: Text(
                        'Post',
                        style: textTheme.body1.copyWith(
                          color: selectedfile !=null && review.text.isNotEmpty?
                              AppColors.secondaryElement
                              : Colors.black54,
                          fontSize: Sizes.TEXT_SIZE_16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: Sizes.MARGIN_16,
            vertical: Sizes.MARGIN_4,
          ),
          child: ListView(
            children: <Widget>[
              // isCardShowing ? SpaceH30() : Container(),
              //     isCardShowing
              //         ? FoodyBiteSearchCard(
              //             hasBeenAdded: hasRestaurantBeenAdded,
              //             onPressed: () {
              //               changeState(
              //                   hasRestaurantBeenAdded: true,
              //                   isCardShowing: true,
              //                   showSuffixIcon: true,
              //                   canPost: true);
              //             },
              //             onPressClose: () {
              //               changeState(
              //                 isCardShowing: false,
              //                 hasRestaurantBeenAdded: false,
              //                 showSuffixIcon: true,
              //               );
              //             },
              //           )
              //         : Container(),
              // SpaceH30(),
              Center(
                child: Container(
                    child: Text(
                  'Add review with photo and get free 10 coins in your wallet',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                )),
              ),
              SpaceH30(),
              RatingsBar(starsrating: starsrating,),
             
              SpaceH20(),
              InkWell(
                onTap: (){
                  _settingModalBottomSheet(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 60,
                  padding: EdgeInsets.symmetric(
                    horizontal: 0.0,
                  ),
                  height: _imageSelected? 200:100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 0.5,color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: _imageSelected? ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Image.file(selectedfile,filterQuality: FilterQuality.high,fit: BoxFit.cover,)): Icon(Icons.add_a_photo_outlined,color: Colors.black87,),
                ),
              ),
              SpaceH20(),
              _buildReview(context: context,review: review),
            ],
          ),
        ),
      ),
    );
  }

  void _onChange(String value) {
    if (value.length > 0) {
      changeState(showSuffixIcon: true, isCardShowing: true);
    } else {
      changeState(showSuffixIcon: false, isCardShowing: false);
    }
  }

  void changeState({
    bool showSuffixIcon = false,
    bool hasRestaurantBeenAdded = false,
    bool isCardShowing = false,
    bool canPost = false,
  }) {
    setState(() {
      this.showSuffixIcon = showSuffixIcon;
      this.hasRestaurantBeenAdded = hasRestaurantBeenAdded;
      this.isCardShowing = isCardShowing;
      this.canPost = canPost;
    });
  }

  Widget _buildReview({@required BuildContext context,@required review}) {
    var textTheme = Theme.of(context).textTheme;
    return Column(
      children: <Widget>[
        Text(
          "Review",
          style: Styles.customTitleTextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.TEXT_SIZE_20,
          ),
        ),
        SpaceH16(),
        CustomTextFormField(
          hasPrefixIcon: false,
          maxLines: 10,
          hintText: "Write your experience",
          hintTextStyle: subTitleTextStyle,
          borderWidth: 1.5,
          borderRadius: Sizes.RADIUS_12,
          borderStyle: BorderStyle.solid,
          focusedBorderColor: AppColors.black,
          textFormFieldStyle: textTheme.body1,
          contentPaddingHorizontal: Sizes.MARGIN_16,
          textEditingController: review,
          borderColor: Colors.grey,
        ),
      ],
    );
  }

  Widget suffixIcon() {
    return Container(
      child: Icon(
        Icons.close,
        color: AppColors.indigo,
      ),
    );
  }
}
