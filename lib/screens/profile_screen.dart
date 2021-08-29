import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potbelly/Flip_nav_bar/navbar.dart';
import 'package:potbelly/grovey_startScreens/ProviderService.dart';
import 'package:potbelly/models/UserModel.dart';
import 'package:potbelly/models/specific_user_subscription_model.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/screens/settings_screen.dart';
import 'package:potbelly/services/ServiceProvider.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/bookmarkservice.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/circularIndicator.dart';
import 'package:potbelly/widgets/foody_bite_card.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:potbelly/widgets/spaces.dart';
import 'package:provider/provider.dart';
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
  List ratings = [];
  bool loader = true;
  bool rloader = true;
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
     notilist= notilist.reversed.toList();
    loader2 = false;
    setState(() {});
  }

  @override
  void initState() {
    getSpecificUserSubscription();
    getUserDetail();
    getreviews();
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
        NavBarItemData(
            "Social", OMIcons.addCircle, 105, AppColors.secondaryElement),
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
    getreviews() async {
    var response = await AppService().getratings();
    ratings = response['data'];
    rloader = false;
    print(response);
    setState(() {});
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

  social(){
    return Container();
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
            ?CircularIndicator()
            : Container(
                margin: EdgeInsets.only(top: Sizes.MARGIN_8),
                child: ListView(
                  children: <Widget>[
                  _selectedNavIndex != 4?  Column(
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
                        _specificUserSubscriptionModel == null ||
                                _specificUserSubscriptionModel.data.length <= 0
                            ? const SizedBox()
                            : checkanyactive()? Container(
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
                              ):Container(),
                      ],
                    ):Container(),
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
               
                 _selectedNavIndex == 4?   Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                        prefs.getString('photo') != null &&
                                  prefs.getString('photo') != ''
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    StringConst.LIVE_PICTURE_URL +
                                        prefs.getString('photo'),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  minRadius:50,
                                  maxRadius:50,
                                )
                              : CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/andy.png'),
                                  backgroundColor: Colors.transparent,
                                  minRadius: 50,
                                  maxRadius: 50,
                                ),
                                 IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    detail(number: "50", text: "Reviews"),
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
                     ],),
                     SizedBox(height: 10,),
                      Text(toBeginningOfSentenceCase(prefs.getString('name')) ?? 'Not Available',
                              style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black)),
                     SizedBox(height: 5,),
                      Text(toBeginningOfSentenceCase('My first priority will always be food because it is the only thing which gives us the energy to live.') ?? 'Not Available',
                              style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.black54)),
                     SizedBox(height: 15,),
                      Center(
                        child: PotbellyButton(
                            'Edit Profile',
                            onTap: () {
                            
                            },
                            buttonHeight: 42,
                            buttonWidth: MediaQuery.of(context).size.width * 0.90,
                            buttonTextStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(width: 0.5,color: Colors.grey),
                                color: Colors.transparent),
                          ),
                      ),
                      SizedBox(height: 15,)
                     
                      ],),
                      
                     
                 ):Container(),
                   _selectedNavIndex != 4?   Divider(
                      height: 24,
                      thickness: 1.0,
                      color: Colors.grey.shade300,
                    ):Container(),
                  _selectedNavIndex == 4?   Divider(
                      height: 2.5,
                      thickness: 2.0,
                      color: Colors.black87,
                    ):Container(),
                   _selectedNavIndex == 4? Padding(
                     padding: const EdgeInsets.only(top:0.0),
                     child: Wrap(children: postlist()),
                   ):Container(),
                    _selectedNavIndex == 0
                        ? homewidget()
                        : _selectedNavIndex == 1
                            ? bookmarkwidget()
                            : _selectedNavIndex == 2
                                ? notificationwidget()
                                : _selectedNavIndex == 3? profilewidget():social()
                  ],
                ),
              ));
  }

  List allpost=[
    'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://www.eatright.org/-/media/eatrightimages/health/pregnancy/fertilityandreproduction/bean-corn-tomato-salad-1056788234.jpg?h=450&w=600&la=en&hash=8E919F45C2E0A8D540BB725663DD2F7F3A8CB804',
    'https://tecadvo.com/wp-content/uploads/2020/10/13.jpg',
    'https://media.self.com/photos/5f189b76c58e27c99fbef9e3/1:1/w_850,h_849,c_limit/blackberry-vanilla-french-toast.jpg',
    'https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/10/Eat-Grains-Beans-Food-732x549-Thumbnail-732x549.jpg',
    'https://images.squarespace-cdn.com/content/v1/53621c77e4b0ab57db4d48d5/1497488872780-JUR4XENC89U8RIQ30FEY/IMG_9881.JPG?format=500w'
    'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'https://www.eatright.org/-/media/eatrightimages/health/pregnancy/fertilityandreproduction/bean-corn-tomato-salad-1056788234.jpg?h=450&w=600&la=en&hash=8E919F45C2E0A8D540BB725663DD2F7F3A8CB804',
    'https://tecadvo.com/wp-content/uploads/2020/10/13.jpg',
    'https://media.self.com/photos/5f189b76c58e27c99fbef9e3/1:1/w_850,h_849,c_limit/blackberry-vanilla-french-toast.jpg',
    'https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/10/Eat-Grains-Beans-Food-732x549-Thumbnail-732x549.jpg',
    'https://images.squarespace-cdn.com/content/v1/53621c77e4b0ab57db4d48d5/1497488872780-JUR4XENC89U8RIQ30FEY/IMG_9881.JPG?format=500w'
  ];
  
  postlist(){
     return List.generate(
       ratings.length ,
        (i) =>InkWell(
          onTap: (){
            Navigator.pushNamed(context, AppRouter.Post_view,arguments: ratings);
          },
          child: Container(
            decoration: BoxDecoration(border: Border.all(width: 1.5,color: Colors.black)),
            child: CachedNetworkImage(
                                imageUrl: StringConst.BASE_imageURL+ ratings[i]['image'],
                                width: (MediaQuery.of(context).size.width/3)-3,
                                height: (MediaQuery.of(context).size.width/3)-3,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: Container(
                                    // height: 150,
        
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.secondaryElement),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
          ),
        ),);
  }

  void getSpecificUserSubscription() async {
    _specificUserSubscriptionModel =
        await Service().getSpecificUserSubscriptionData();
    print(_specificUserSubscriptionModel.data);
      _isLoading = false;
    setState(() {});
    
  }

  checkanyactive(){
    
    for (var i = 0; i < _specificUserSubscriptionModel.data.length; i++) {
      if(_specificUserSubscriptionModel.data[i].status =='active'){
        return true;
      }
    }
    return false;
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
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.editProfileScreen),
                ),
                SettingsListTile(
                    title: "Change Password",
                    onTap: () => Navigator.pushNamed(
                        context, AppRouter.changePasswordScreen)),
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
                  onTap: () =>Navigator.pushNamed(context, AppRouter.cart_Screen)
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
                   onTap: () => Navigator
                      .pushNamed(context,AppRouter.userAddresses),
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
                      context, AppRouter.userSubscriptionList).then((value) {
                        getSpecificUserSubscription();
                        Provider.of<ServiceProvider>(context, listen: false).getsubdata(context);
                      }),
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
     Provider.of<ProviderService>(context, listen: false)
                          .allfalse();
                      Provider.of<ProviderService>(context, listen: false)
                          .reset();
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


