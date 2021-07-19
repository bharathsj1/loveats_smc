import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:potbelly/models/UserModel.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/screens/settings_screen.dart';
import 'package:potbelly/services/bookmarkservice.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/foody_bite_card.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:potbelly/widgets/spaces.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  static const int TAB_NO = 3;

  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel userModel;
  bool _isLoading = true;
  SharedPreferences prefs;
   List bookmarks = [];
  bool loader = true;


  getbookmark() async {
    bookmarks = await BookmarkService().getbookmarklist();
    print(bookmarks);
    loader = false;
    setState(() {});
  }

  @override
  void initState() {
    getUserDetail();
    getbookmark();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: Sizes.ELEVATION_0,
          centerTitle: true,
          title: Text(
            'Profile',
            style: Styles.customTitleTextStyle(
              color: AppColors.headingText,
              fontWeight: FontWeight.w600,
              fontSize: Sizes.TEXT_SIZE_22,
            ),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: EdgeInsets.only(top: Sizes.MARGIN_8),
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: [
                        prefs.getString('photo') != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                  StringConst.LOCAL_URL +
                                      prefs.getString('photo'),
                                ),
                                backgroundColor: Colors.transparent,
                                minRadius: Sizes.RADIUS_60,
                                maxRadius: Sizes.RADIUS_60,
                              )
                            : CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/andy.png'),
                                backgroundColor: Colors.transparent,
                                minRadius: Sizes.RADIUS_40,
                                maxRadius: Sizes.RADIUS_40,
                              ),
                        SpaceH8(),
                        Text(prefs.getString('name') ?? 'Not Available',
                            style: Styles.foodyBiteTitleTextStyle),
                        SpaceH8(),
                        Text(prefs.getString('email') ?? 'Not Available',
                            style: Styles.foodyBiteSubtitleTextStyle),
                      ],
                    ),
                    SpaceH24(),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          detail(number: "250", text: "Reviews"),
                          VerticalDivider(
                            width: Sizes.WIDTH_40,
                            thickness: 1.0,
                          ),
                          detail(number: "100k", text: "Followers"),
                          VerticalDivider(
                            width: Sizes.WIDTH_40,
                            thickness: 1.0,
                          ),
                          detail(number: "30", text: "Following"),
                          SpaceH24(),
                        ],
                      ),
                    ),
                    SpaceH24(),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     PotbellyButton(
                    //       'Edit Profile',
                    //       // onTap: () => AppRouter.navigator
                    //       //     .pushNamed(AppRouter.editProfileScreen),
                    //       buttonWidth: MediaQuery.of(context).size.width / 3,
                    //       buttonHeight: Sizes.HEIGHT_50,
                    //     ),
                    //     SpaceW16(),
                    //     PotbellyButton(
                    //       'Settings',
                    //       onTap: () => Navigator.pushNamed(
                    //           context, AppRouter.settingsScreen),
                    //       buttonWidth: MediaQuery.of(context).size.width / 3,
                    //       buttonHeight: Sizes.HEIGHT_50,
                    //       decoration: BoxDecoration(
                    //         color: AppColors.primaryColor,
                    //         border: Border.all(color: AppColors.indigo),
                    //         borderRadius: BorderRadius.all(
                    //           Radius.circular(Sizes.RADIUS_8),
                    //         ),
                    //       ),
                    //       buttonTextStyle: Styles.customNormalTextStyle(
                    //         color: AppColors.accentText,
                    //         fontSize: Sizes.TEXT_SIZE_16,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Divider(
                      height: Sizes.HEIGHT_20,
                      thickness: 3.0,
                      color: Colors.grey[200],
                    ),
                    // Column(
                    //   children: <Widget>[
                    //     FoodyBiteCard(
                    //       imagePath: ImagePath.dinnerIsServed,
                    //       status: StringConst.STATUS_OPEN,
                    //       cardTitle: "Gramercy Tavern",
                    //       category: StringConst.ITALIAN,
                    //       distance: "12 km",
                    //       address: "394 Broome St, New York, NY 10013, USA",
                    //       isThereStatus: false,
                    //       onTap: () {},
                    //     ),
                    //     SpaceH16(),
                    //     FoodyBiteCard(
                    //       imagePath: ImagePath.breakfastInBed,
                    //       status: StringConst.STATUS_OPEN,
                    //       cardTitle: "Happy Bones",
                    //       category: StringConst.ITALIAN,
                    //       distance: "12 km",
                    //       address: "394 Broome St, New York, NY 10013, USA",
                    //       isThereStatus: false,
                    //       onTap: () {},
                    //     ),
                    //   ],
                    // ),
                    
                    Center(
                      child: Container(
                        // color: AppColors.green,
                          child: DefaultTabController(
                              length: 2,
                              child: Column(children: [
                                TabBar(
                                  // isScrollable: true,
                                  onTap: (index) {
                                    print('indeeeeeeeeeeeeeeex');
                                    print(index);
                                  },
                                  physics: BouncingScrollPhysics(),
                                  indicatorColor: AppColors.black,
                                  labelColor: AppColors.black,
                                  unselectedLabelColor: AppColors.grey,
                                  
                                  // isScrollable: true,
                                  indicator: UnderlineTabIndicator(
                                      borderSide: BorderSide(
                                          width: 1.2, color: AppColors.black),
                                      insets:
                                          EdgeInsets.symmetric(horizontal: 30.0)),
                                  // labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                  tabs: [
                                    Tab(
                                      text: "My Favourite",
                                    ),
                                    Tab(
                                      text: "Settings",
                                    ),
                                  ],
                                ),
                                SingleChildScrollView(
                                  child: Container(
                                      height: MediaQuery.of(context).size.height *
                                          0.55,
                                      color: Colors.transparent,
                                      child: TabBarView(children: [
                                        loader
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
              ),
            )
          : bookmarks.length == 0
              ? Center(
                  child: Container(
                      child: Text('No Bookmarks'),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(
                      left: Sizes.MARGIN_16,
                      right: Sizes.MARGIN_16,
                      top: Sizes.MARGIN_16,
                  ),
                  child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: bookmarks.length,
                      separatorBuilder: (context, index) {
                        return SpaceH8();
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          child: FoodyBiteCard(
                            onTap: () => Navigator.pushNamed(context,
                              AppRouter.restaurantDetailsScreen,
                              arguments: RestaurantDetails(
                                  imagePath: bookmarks[index]['rest_image'],
                                  restaurantName: bookmarks[index]['name'],
                                  restaurantAddress: bookmarks[index]['address'] +
                                      ' ' +
                                      bookmarks[index]['city'] +
                                      ' ' +
                                      bookmarks[index]['country'],
                                  rating: bookmarks[index]['rest_ratings'],
                                  category: bookmarks[index]['type'],
                                  distance: bookmarks[index]['distance'],
                                  data: bookmarks[index]),
                            ),
                            bookmark: true,
                            imagePath: bookmarks[index]['rest_image'],
                            status:
                                bookmarks[index]['rest_isOpen'] == 1 ? "OPEN" : "CLOSE",
                            cardTitle:
                                bookmarks[index]['name'] ?? 'Rose, Farrington',
                            rating:
                                bookmarks[index]['rest_rating'] ?? '4.2',
                            category: bookmarks[index]['rest_type'] ?? 'Not Available',
                            distance:
                                bookmarks[index]['distance'] ?? 'Not Available',
                            address: bookmarks[index]['rest_address'] ??
                                'Not Available' +
                                    ' ' +
                                    bookmarks[index]['rest_city'] +
                                    ' ' +
                                    bookmarks[index]['rest_country'],
                          ),
                        );
                      },
                  ),
                ),
                                         Column(
        children: <Widget>[
          SizedBox(height: 10,),
          _buildAccountSettings(context: context),
          _buildOtherSettings(context: context),
        ],
      ),
                                      ])),
                                )
                              ]))),
                    )
                  ],
                ),
              ));
  }

    Widget _buildAccountSettings({@required BuildContext context}) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      child: Column(
        children: <Widget>[
          // Container(
          //   color: AppColors.secondaryColor,
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: Sizes.MARGIN_16,
          //     vertical: Sizes.MARGIN_16,
          //   ),
          //   child: Row(
          //     children: <Widget>[
          //       Text(
          //         "Account",
          //         style: textTheme.title.copyWith(
          //           fontSize: Sizes.TEXT_SIZE_16,
          //           color: AppColors.indigoShade1,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          ListView(
            shrinkWrap: true,
            children: ListTile.divideTiles(
              context: context,
              tiles: <Widget>[
                // SettingsListTile(
                //   title: "Change Password",
                //   // onTap: () => AppRouter.navigator
                //   //     .pushNamed(AppRouter.changePasswordScreen),
                // ),
                SettingsListTile(
                  title: "Change Language",
                  titleColor: AppColors.black,
                  onTap: () => Navigator.pushNamed(context, AppRouter.changeLanguageScreen)
                      // .pushNamed(AppRouter.changeLanguageScreen),
                ),
                SettingsListTile(
                  title: "Order List",
                  titleColor: AppColors.black,
                  onTap: () => Navigator
                      .pushNamed(context,AppRouter.order_list),
                ),
                SettingsListTile(
                  title: "Payment",
                  titleColor: AppColors.black,
                  // onTap: () => AppRouter.navigator
                  //     .pushNamed(AppRouter.changeLanguageScreen),
                )
              ],
            ).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildOtherSettings({@required BuildContext context}) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: AppColors.secondaryColor,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.MARGIN_16,
              vertical: Sizes.MARGIN_16,
            ),
            child: Row(
              children: <Widget>[
                Text(
                  "OTHERS",
                  style: textTheme.title.copyWith(
                    fontSize: Sizes.TEXT_SIZE_16,
                    color: AppColors.indigoShade1,
                  ),
                ),
              ],
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: ListTile.divideTiles(
              context: context,
              tiles: <Widget>[
                // SettingsListTile(
                //   title: "Privacy Policy",
                //   onTap: () {},
                // ),
                SettingsListTile(
                  title: "Terms & Conditions",
                  titleColor: AppColors.black,
                  onTap: () {},
                ),
                
                SettingsListTile(
                  title: "Logout",
                  titleColor: AppColors.secondaryElement,
                  hasTrailing: false,
                  onTap: () => _logoutDialog(context),
                ),
              ],
            ).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _logoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return _buildAlertDialog(context);
      },
    );
  }

 _logoutFunction(BuildContext context) async {
    await Service().logout(context);
  }

  Widget _buildAlertDialog(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(Sizes.RADIUS_32),
        ),
      ),
      child: AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(
          Sizes.PADDING_0,
          Sizes.PADDING_36,
          Sizes.PADDING_0,
          Sizes.PADDING_0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.RADIUS_20),
        ),
        elevation: Sizes.ELEVATION_4,
        content: Container(
          height: Sizes.HEIGHT_150,
          width: Sizes.WIDTH_300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SingleChildScrollView(
                child: Center(
                  child: Text(
                    'Are you sure you want to Logout ?',
                    style: textTheme.title.copyWith(
                      fontSize: Sizes.TEXT_SIZE_20,
                    ),
                  ),
                ),
              ),
              Spacer(flex: 1),
              Row(
                children: <Widget>[
                  AlertDialogButton(
                    buttonText: "No",
                    width: Sizes.WIDTH_150,
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: AppColors.greyShade1,
                      ),
                      right: BorderSide(
                        width: 1,
                        color: AppColors.greyShade1,
                      ),
                    ),
                    textStyle:
                        textTheme.button.copyWith(color: AppColors.accentText),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  AlertDialogButton(
                    buttonText: "Yes",
                    width: Sizes.WIDTH_150,
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: AppColors.greyShade1,
                      ),
                    ),
                    textStyle: textTheme.button
                        .copyWith(color: AppColors.secondaryElement),
                    onPressed: () => _logoutFunction(context),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  getUserDetail() async {
    prefs = await Service().initializdPrefs();
    setState(() {
      _isLoading = false;
    });
  }

  Widget detail({@required String number, @required String text}) {
    return Container(
      child: Column(
        children: [
          Text(
            number,
            style: Styles.customNormalTextStyle(
                color: AppColors.secondaryElement,
                fontWeight: FontWeight.w600,
                fontSize: Sizes.TEXT_SIZE_18),
          ),
          SizedBox(height: 8.0),
          Text(text, style: Styles.foodyBiteSubtitleTextStyle),
        ],
      ),
    );
  }
}
