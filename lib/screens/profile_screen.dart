import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potbelly/Flip_nav_bar/navbar.dart';
import 'package:potbelly/models/UserModel.dart';
import 'package:potbelly/models/specific_user_subscription_model.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/screens/settings_screen.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/bookmarkservice.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/foody_bite_card.dart';
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
  List<NavBarItemData> _navBarItems;
  List<Widget> _viewsByIndex;
  int _selectedNavIndex = 0;
  List notilist = [];
  bool loader2 = true;
  SpecificUserSubscriptionModel _specificUserSubscriptionModel;

  getbookmark() async {
    bookmarks = await BookmarkService().getbookmarklist();
    print(bookmarks);
    loader = false;
    setState(() {});
  }

  getnoti() async {
    var noti = await AppService().getnoti();
    print(noti);
    notilist = noti['data'];
    loader2 = false;
    setState(() {});
  }

  @override
  void initState() {
    getSpecificUserSubscription();
    getUserDetail();
    getbookmark();
    getnoti();
    var type = '2';
    if (type == '2') {
      _navBarItems = [
        NavBarItemData("Home", OMIcons.home, 100, AppColors.secondaryElement),
        NavBarItemData(
            "Bookmarks", OMIcons.bookmarks, 140, AppColors.secondaryElement),
        // NavBarItemData("Cart", OMIcons.shoppingCart, 90, AppColors.secondaryElement),
        NavBarItemData("Notification", OMIcons.notificationsActive, 140,
            AppColors.secondaryElement),
        NavBarItemData(
            "Profile", OMIcons.person, 105, AppColors.secondaryElement),
      ];

      // initialize();
    } else {
      _navBarItems = [
        NavBarItemData("Home", OMIcons.home, 100, Colors.black),
        NavBarItemData(
            "Notification", OMIcons.notificationsActive, 140, Colors.black),
        NavBarItemData("Profile", OMIcons.person, 105, Colors.black),
      ];
      _viewsByIndex = <Widget>[
        // Vendor_Home_screen(),
        // VendorNotificationsScreen(),
        // ProfileScreen(),
      ];
    }
    super.initState();
  }

  initialize() {
    _viewsByIndex = <Widget>[
      homewidget(),
      bookmarkwidget(),

      notificationwidget(),
      profilewidget()
      // HomeScreen(),
      // BookmarksScreen(),
      // CartScreen(),
      // NotificationsScreen(),
      // ProfileScreen(),
    ];
    setState(() {});
  }

  void _handleNavBtnTapped(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
  }

  homewidget() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _HomeBasicSettings(context: context),
        ],
      ),
    );
  }

  bookmarkwidget() {
    return loader
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
                  left: Sizes.MARGIN_10,
                  right: Sizes.MARGIN_10,
                  top: Sizes.MARGIN_16,
                ),
                child:
                    //  ListView.separated(
                    //   shrinkWrap: true,
                    //   scrollDirection: Axis.vertical,
                    //   itemCount: bookmarks.length,
                    //   separatorBuilder: (context, index) {
                    //     return SpaceH8();
                    //   },
                    //   itemBuilder: (context, index) {
                    //     return
                    Column(
                  children: List.generate(
                      bookmarks.length,
                      (index) => Container(
                            child: FoodyBiteCard(
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRouter.restaurantDetailsScreen,
                                arguments: RestaurantDetails(
                                    imagePath: bookmarks[index]['rest_image'],
                                    restaurantName: bookmarks[index]['name'],
                                    restaurantAddress: bookmarks[index]
                                            ['address'] +
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
                              status: bookmarks[index]['rest_isOpen'] == 1
                                  ? "OPEN"
                                  : "CLOSE",
                              cardTitle: bookmarks[index]['name'] ??
                                  'Rose, Farrington',
                              rating: bookmarks[index]['rest_rating'] ?? '4.2',
                              category: bookmarks[index]['rest_type'] ??
                                  'Not Available',
                              distance: bookmarks[index]['distance'] ??
                                  'Not Available',
                              address: bookmarks[index]['rest_address'] ??
                                  'Not Available' +
                                      ' ' +
                                      bookmarks[index]['rest_city'] +
                                      ' ' +
                                      bookmarks[index]['rest_country'],
                            ),
                          )),
                ));
  }

  notificationwidget() {
    return loader2
        ? Center(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
              ),
            ),
          )
        : notilist.length == 0
            ? Center(
                child: Container(
                  child: Text('No Notification available'),
                ),
              )
            : Container(
                margin: EdgeInsets.symmetric(
                    horizontal: Sizes.MARGIN_8, vertical: Sizes.MARGIN_16),
                child: Column(
                  children: List.generate(
                      notilist.length,
                      (index) =>
                          // itemCount: ,
                          // shrinkWrap: true,
                          // itemBuilder: (BuildContext context, int index) {
                          Card(
                            elevation: 1,
                            child: ListTile(
                              leading: Image.asset('assets/images/logo.png'),
                              onTap: () {},
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Text(
                                      notilist[index]['title'],
                                      style: Styles.customTitleTextStyle(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: Sizes.TEXT_SIZE_18,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MMM d, yyyy')
                                        .format(DateTime.parse(
                                            notilist[index]['created_at']))
                                        .toString(),
                                    style: Styles.customNormalTextStyle(
                                      color: AppColors.grey,
                                      fontSize: Sizes.TEXT_SIZE_12,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Container(
                                margin: EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.52,
                                      child: Text(
                                        notilist[index]['subtitle'],
                                        style: Styles.customNormalTextStyle(
                                          color: AppColors.grey,
                                          fontSize: Sizes.TEXT_SIZE_12,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      DateFormat('h:mm a')
                                          .format(DateTime.parse(
                                              notilist[index]['created_at']))
                                          .toString(),
                                      style: Styles.customNormalTextStyle(
                                        color: AppColors.grey,
                                        fontSize: Sizes.TEXT_SIZE_12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                ));
  }

  profilewidget() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildAccountSettings(context: context),
          _buildOtherSettings(context: context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var navBar = NavBar(
      items: _navBarItems,
      itemTapped: _handleNavBtnTapped,
      currentIndex: _selectedNavIndex,
    );
    // var contentView =
    //     _viewsByIndex[min(_selectedNavIndex, _viewsByIndex.length - 1)];
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
        bottomNavigationBar: navBar,
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
                        prefs.getString('photo') != null &&
                                prefs.getString('photo') != ''
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                  StringConst.LIVE_PICTURE_URL +
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
                        _specificUserSubscriptionModel == null
                            ? const SizedBox()
                            : Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: AppColors.secondaryColor),
                                alignment: Alignment.center,
                                child: Text(
                                  'Subscribed'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                      ],
                    ),
                    _selectedNavIndex == 3
                        ? Column(
                            children: [
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
                            ],
                          )
                        : Container(),
                    Divider(
                      height: Sizes.HEIGHT_24,
                      thickness: 3.0,
                      color: Colors.grey[200],
                    ),
                    _selectedNavIndex == 0
                        ? homewidget()
                        : _selectedNavIndex == 1
                            ? bookmarkwidget()
                            : _selectedNavIndex == 2
                                ? notificationwidget()
                                : profilewidget()
                  ],
                ),
              ));
  }

  void getSpecificUserSubscription() async {
    _specificUserSubscriptionModel =
        await Service().getSpecificUserSubscriptionData();
    print(_specificUserSubscriptionModel.data.length);
    setState(() {});
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
                SettingsListTile(
                  title: "Edit Profile",
                  onTap: () => Navigator.pushNamed(context, AppRouter.editProfileScreen),
                ),
                SettingsListTile(
                  title: "Change Password",
                  onTap: () => Navigator.pushNamed(context, AppRouter.changePasswordScreen)
                ),
                // SettingsListTile(
                //     title: "Change Language",
                //     titleColor: AppColors.black,
                //     onTap: () => Navigator.pushNamed(
                //         context, AppRouter.changeLanguageScreen)
                //     // .pushNamed(AppRouter.changeLanguageScreen),
                //     ),
                // SettingsListTile(
                //   title: "Order List",
                //   titleColor: AppColors.black,
                //   onTap: () =>
                //       Navigator.pushNamed(context, AppRouter.order_list),
                // ),
                // SettingsListTile(
                //   title: "Payment",
                //   titleColor: AppColors.black,
                //   // onTap: () => AppRouter.navigator
                //   //     .pushNamed(AppRouter.changeLanguageScreen),
                // )
              ],
            ).toList(),
          )
        ],
      ),
    );
  }

  Widget _HomeBasicSettings({@required BuildContext context}) {
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
                SettingsListTile(
                  titleColor: AppColors.black,
                  title: "Cart",
                  // onTap: () => AppRouter.navigator
                  //     .pushNamed(AppRouter.changePasswordScreen),
                ),
                SettingsListTile(
                  titleColor: AppColors.black,
                  title: "Orders History",
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.order_list),
                ),
                SettingsListTile(
                  titleColor: AppColors.black,
                  title: "My Address",
                  //  onTap: () => Navigator
                  //     .pushNamed(context,AppRouter.order_list),
                ),
                SettingsListTile(
                  titleColor: AppColors.black,
                  title: "Payments",
                  //  onTap: () => Navigator
                  //     .pushNamed(context,AppRouter.order_list),
                ),
                SettingsListTile(
                  titleColor: AppColors.black,
                  title: "Subscriptions",
                  onTap: () => Navigator.pushNamed(
                      context, AppRouter.userSubscriptionList),
                ),
                // SettingsListTile(
                //     title: "Change Language",
                //     titleColor: AppColors.black,
                //     onTap: () => Navigator.pushNamed(
                //         context, AppRouter.changeLanguageScreen)
                //     // .pushNamed(AppRouter.changeLanguageScreen),
                //     ),
                // SettingsListTile(
                //   title: "Order List",
                //   titleColor: AppColors.black,
                //   onTap: () =>
                //       Navigator.pushNamed(context, AppRouter.order_list),
                // ),
                // SettingsListTile(
                //   title: "Payment",
                //   titleColor: AppColors.black,
                //   // onTap: () => AppRouter.navigator
                //   //     .pushNamed(AppRouter.changeLanguageScreen),
                // )
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
                SettingsListTile(
                  titleColor: AppColors.black,
                  title: "Privacy Policy",
                  onTap: () {},
                ),
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
