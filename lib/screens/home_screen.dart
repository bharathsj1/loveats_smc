import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:potbelly/3D_card_widets/demo_data.dart';
import 'package:potbelly/3D_card_widets/travel_card_list.dart';
import 'package:potbelly/grovey_startScreens/ProviderService.dart';
import 'package:potbelly/grovey_startScreens/demo.dart';
import 'package:potbelly/models/promotions.dart';
import 'package:potbelly/models/restaurent_model.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/screens/FilterItem.dart';
import 'package:potbelly/screens/settings_screen.dart';
import 'package:potbelly/services/DatabaseManager.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/firebaseSetup.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/heading_row.dart';
import 'package:potbelly/widgets/search_input_field.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';

import 'Recipe_list.dart';

class HomeScreen extends StatefulWidget {
  static const int TAB_NO = 0;

  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchcontroller = TextEditingController();
  List promolist = [];
  VideoPlayerController _controller;
  int active_video = 0;
  bool loader = true;
  bool loader3 = true;
  bool loader4 = true;
  bool loader2 = true;
  int totalRestaurent = 0;
  List resturants = [];
  List categories = [];
  List hotspotlist = [];
  List recipes = [];
  List recipessub = [];
  List popularitem = [];
  List<City> _cityList;
  City _currentCity;
  bool search = true;
  List searchlist = [];
  bool _isGuest = false;
  bool lottie = false;
  bool lottie2 = false;
  String selected_address = 'Your Location';
  List subscription = [
    'assets/images/sub3.png',
    'assets/images/sub1.png',
  ];

  RestaurentsModel _restaurentsModel;

  @override
  void initState() {
    FirebaseSetup().configureFirebase(context);
    var data = DemoData();
    _cityList = data.getCities();
    _currentCity = _cityList[1];
    checkpromo();
    // _register();
    getRestaurent();
    getcateory();
    getrecipes();
    getsubrecipe();
    getpopularitem();
    isUserGuest();
    super.initState();
  }

  isUserGuest() async {
    print('Checking if user is guest');
    _isGuest = await Service().isGuest();
  }

  checkpromo() async {
    String stripeCusId = await Service().getStripeUserId();
    if (stripeCusId != null) {
      return;
    }
    var show = await Promotion().checkpromo();
    print(show);
    if (show) {
      Navigator.pushNamed(context, AppRouter.promotionScreen);
      Promotion().setpromo();
    } else {
      print('promo already viewed');
    }
  }

  Future<RestaurentsModel> getAllRestaurents() async {
    _restaurentsModel = await Service().getRestaurentsData();
    totalRestaurent = _restaurentsModel.data.length;
    return _restaurentsModel;
  }

  getRestaurent() async {
    var response = await Service().getRestaurentsData();
    resturants = response.data;
    searchlist = response.data;
    totalRestaurent = response.data.length;
    loader = false;
    print(searchlist);
    setState(() {});
  }

  getcateory() async {
    var response = await Service().getMenuTypes();
    categories = response.data;
    loader2 = false;
    setState(() {});
  }

  gethotspot() async {
    var response = await AppService().getallhotspot();
    hotspotlist = response['data'];
    print(hotspotlist);
    loader3 = false;
    setState(() {});
  }

  getrecipes() async {
    var response = await AppService().getrecipe();
    recipes = response['data'];
    print(recipes);
    // loader3 = false;
    setState(() {});
  }

  getsubrecipe() async {
    var response = await AppService().getrecipesub();
    recipessub = response['data'];
    print(recipessub);
    loader3 = false;
    setState(() {});
  }

  getpopularitem() async {
    var response = await AppService().getpopularitem();
    popularitem = response['data'];
    print(popularitem);
    loader4 = false;
    setState(() {});
  }

  searchfromlist() {
    // print(searchlist[0].delivery);
    // print(searchlist[0].pickup);
    // print(searchlist[0].tableService);
    resturants = searchlist
        .where((product) => product.restName
                .toLowerCase()
                .contains(searchcontroller.text.toLowerCase())
            //         &&
            //     deliverytype == 0
            // ? product.delivery == '1'
            // : deliverytype == 1
            //     ? product.pickup == '1'
            //     : product.tableServive == '1'
            )
        .toList();

    setState(() {});
  }

  getpromos() async {
    await DatabaseManager().getpromotions().then((value) {
      for (var item in value) {
        promolist.add(item);
      }
    });
  }

  getlocalpromos() async {
    promolist = Promotion().promotiondata;
    //  for (var item in Promotion().promotiondata) {
    //    promolist.add(item);
    //  }
    print(promolist.length);

    if (promolist.length != 0 &&
        (promolist[0]['videoUrl'] != '' || promolist[0]['videoUrl'] != null)) {
      print('here');
      // controllerdispo();
      initialize(promolist[0]['videoUrl']);
    }
    this.loader = false;
    setState(() {});
  }

  initialize(videourl) {
    print(videourl);
    if (_controller != null) {
      _controller.dispose();
    }
    _controller = VideoPlayerController.asset(videourl)
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
    }
  }

  controllerdispo() {
    if (_controller != null) {
      _controller.dispose();
    }
  }

  navigatortopromotion(ind) {
    if (_controller != null) {
      _controller.pause();
    }
    Navigator.pushNamed(
      context,
      AppRouter.promotionDetailsScreen,
      arguments: PromotionDetails(
          image: promolist[ind]['image'],
          video: promolist[ind]['videoUrl'],
          name: promolist[ind]['name'],
          id: promolist[ind]['id'],
          thumnail: promolist[ind]['thumbnailUrl'],
          description: promolist[ind]['description'],
          data: promolist[ind]),
    ).then((value) {
      if (_controller != null) {
        _controller.play();
      }
    });
  }

  pausevideo() {
    if (_controller != null) {
      this._controller.pause();
    }
  }

  resumevideo() {
    if (_controller != null) {
      this._controller.play();
    }
  }

  void _handleCityChange(City city) {
    setState(() {
      this._currentCity = city;
    });
  }

  int deliverytype = null;

  categorieslist() {
    return List.generate(
        5,
        (i) => Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.18,
                      height: MediaQuery.of(context).size.height * 0.22,
                      margin: EdgeInsets.only(
                          top: 50, bottom: 5, left: 5, right: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // color: Colors.red,
                        // border: Border.all(width: 0.5,color: AppColors.grey),
                      ),
                      // child: Center(
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //     // SizedBox(width: 5,),
                      //     Padding(
                      //       padding: const EdgeInsets.only(left:12.0),
                      //       child: Icon(Icons.fastfood_outlined,size: 18,color:  i != 0? AppColors.black: AppColors.white,),
                      //     ),
                      //     SizedBox(width: 15,),
                      //     Text('Burgers',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: i != 0? AppColors.black: AppColors.white),)
                      //   ],)
                      // )
                      child: Material(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            // side: BorderSide(width: 0.5,color: AppColors.green),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Container()),
                    ),
                    Positioned(
                        top: 10,
                        //  bottom: 10,
                        left: 25,
                        right: 25,
                        child: Image.asset(
                          'assets/images/d${i + 1}.png',
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: MediaQuery.of(context).size.width / 2.8,
                          fit: BoxFit.fill,
                        )),

                    // SizedBox(height: 10,),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.075,
                      left: 0,
                      right: 0,
                      child: Text('Chopped Spring',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSerifDisplay(
                            textStyle: Styles.customTitleTextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.normal,
                              fontSize: 22,
                            ),
                          )),
                    ),

                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.05,
                      left: 0,
                      right: 0,
                      child: Text('Scallions & Radishes',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            textStyle: Styles.customNormalTextStyle(
                              color: Colors.black54,
                              fontSize: Sizes.TEXT_SIZE_12,
                            ),
                          )),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.02,
                      left: 0,
                      right: 0,
                      child: Text('250 Kcal',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSerifDisplay(
                            textStyle: Styles.customTitleTextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ));
  }

  List<Widget> createUserProfilePhotos({@required numberOfProfilePhotos}) {
    List<Widget> profilePhotos = [];
    List<String> imagePaths = [
      ImagePath.profile1,
      ImagePath.profile2,
      ImagePath.profile3,
      ImagePath.profile4,
      ImagePath.profile1,
      ImagePath.profile2,
    ];

    List<int> list = List<int>.generate(numberOfProfilePhotos, (i) => i + 1);

    list.forEach((i) {
      profilePhotos.add(Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(1000),
              child: CircleAvatar(
                  backgroundImage: AssetImage(imagePaths[i - 1])))));
    });
    return profilePhotos;
  }

  List hotlist = [
    {
      'name': 'LovesatNew',
      'image': 'assets/images/avocado.png',
      'distance': '0.3 Miles away',
      'delivery': '3.22',
      'id': 1,
      'address': '9122 12 Steward Street',
      'rating': '4.4'
    },
    {
      'name': 'Bollywoord BBQ',
      'image': 'assets/images/black_berries.png',
      'distance': '1 Km',
      'delivery': '1.2',
      'id': 2,
      'address': '12 Steward Street',
      'rating': '4.1'
    }
  ];

  hotspot() {
    return List.generate(
        hotspotlist.length,
        (i) => InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.HotspotsDetailsScreen,
                  arguments: RestaurantDetails(
                      imagePath: hotspotlist[i]['image'],
                      restaurantName: hotspotlist[i]['name'],
                      restaurantAddress: hotspotlist[i]['address'],
                      // rating: hotspotlist[i]['rating'],
                      rating: '3.2',
                      category: '',
                      distance: hotspotlist[i]['distance'] + ' Km',
                      data: hotspotlist[i]),
                );
              },
              child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width / 1.2,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6)),
                            child: hotspotlist[i]['image'].substring(0, 4) !=
                                    'http'
                                ? Image.network(
                                    hotspotlist[i]['image'],
                                    loadingBuilder: (BuildContext ctx,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Container(
                                          height: 150,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      AppColors
                                                          .secondaryElement),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/hot${i + 1}.jpeg',
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          Positioned(
                              right: 5,
                              bottom: 5,
                              child: Container(
                                width: 90,
                                padding: EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text('15 - 20\nMins',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                      textStyle: Styles.customNormalTextStyle(
                                        color: AppColors.white,
                                        fontSize: Sizes.TEXT_SIZE_12,
                                      ),
                                    )),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(hotspotlist[i]['name'],
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSerifDisplay(
                                  textStyle: Styles.customTitleTextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Sizes.TEXT_SIZE_22,
                                  ),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  color: AppColors.secondaryElement,
                                  size: 16,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    // width: MediaQuery.of(context).size.width*0.5,
                                    // color: Colors.red,
                                    child: Text('4.4' + ' Very good',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle:
                                              Styles.customNormalTextStyle(
                                            color: AppColors.secondaryElement,
                                            fontSize: Sizes.TEXT_SIZE_14,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.25,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      // width: MediaQuery.of(context).size.width*0.5,
                                      // color: Colors.red,
                                      child: Text(
                                          hotspotlist[i]['address'] + ' (500+)',
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.openSans(
                                            textStyle:
                                                Styles.customNormalTextStyle(
                                              color: Colors.black54,
                                              fontSize: Sizes.TEXT_SIZE_14,
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    // width: MediaQuery.of(context).size.width*0.5,
                                    // color: Colors.red,
                                    child: Text(
                                        hotspotlist[i]['distance'] +
                                            ' - ${StringConst.currency}' +
                                            hotspotlist[i]['charges'] +
                                            ' Delivery',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle:
                                              Styles.customNormalTextStyle(
                                            color: Colors.black54,
                                            fontSize: Sizes.TEXT_SIZE_14,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  popular() {
    return List.generate(
        popularitem.length,
        (i) => InkWell(
              onTap: () {
                // Navigator.pushNamed(
                //   context,
                //   AppRouter.HotspotsDetailsScreen,
                //   arguments: RestaurantDetails(
                //       imagePath: hotspotlist[i]['image'],
                //       restaurantName: hotspotlist[i]['name'],
                //       restaurantAddress: hotspotlist[i]['address'],
                //       // rating: hotspotlist[i]['rating'],
                //       rating: '3.2',
                //       category: '',
                //       distance: hotspotlist[i]['distance'] + ' Km',
                //       data: hotspotlist[i]),
                // );
                var data = RestaurentsModel.fromJson({
                  'data': [popularitem[i]['restaurant']],
                  'success': true,
                  'message': 'ok'
                });
                print(popularitem[i]['restaurant']);
                Navigator.pushNamed(context, AppRouter.Add_Extra, arguments: {
                  'update': false,
                  'item': popularitem[i],
                  // 'restaurant': widget.restaurantDetails.data
                  'restaurant': data.data[0]
                });
              },
              child: Container(
                // height: 245,
                width: MediaQuery.of(context).size.width / 1,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6)),
                            child: popularitem[i]['menu_image']
                                        .substring(0, 4) ==
                                    'http'
                                ?
                                // Image.network(
                                //     popularitem[i]['menu_image'],
                                //     loadingBuilder: (BuildContext ctx,
                                //         Widget child,
                                //         ImageChunkEvent loadingProgress) {
                                //       if (loadingProgress == null) {
                                //         return child;
                                //       } else {
                                //         return Container(
                                //           height: 150,
                                //           child: Center(
                                //             child: CircularProgressIndicator(
                                //               valueColor:
                                //                   AlwaysStoppedAnimation<Color>(
                                //                       AppColors
                                //                           .secondaryElement),
                                //             ),
                                //           ),
                                //         );
                                //       }
                                //     },
                                //     width: MediaQuery.of(context).size.width,
                                //     height: 150,
                                //     fit: BoxFit.cover,
                                //   )
                                CachedNetworkImage(
                                    imageUrl: popularitem[i]['menu_image'],
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColors.secondaryElement),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                : Image.asset(
                                    popularitem[i]['menu_image'],
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                              right: 5,
                              bottom: 5,
                              child: Container(
                                width: 90,
                                padding: EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text('15 - 20\nMins',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                      textStyle: Styles.customNormalTextStyle(
                                        color: AppColors.white,
                                        fontSize: Sizes.TEXT_SIZE_12,
                                      ),
                                    )),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(popularitem[i]['menu_name'],
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSerifDisplay(
                                  textStyle: Styles.customTitleTextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Sizes.TEXT_SIZE_22,
                                  ),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  color: AppColors.secondaryElement,
                                  size: 16,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    // width: MediaQuery.of(context).size.width*0.5,
                                    // color: Colors.red,
                                    child: Text('4.4' + ' Very good',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle:
                                              Styles.customNormalTextStyle(
                                            color: AppColors.secondaryElement,
                                            fontSize: Sizes.TEXT_SIZE_14,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width-30,
                                    // color: Colors.red,
                                    child: Text(
                                        popularitem[i]['restaurant']
                                                ['rest_address'] +
                                            ' (500+)',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.openSans(
                                          textStyle:
                                              Styles.customNormalTextStyle(
                                            color: Colors.black54,
                                            fontSize: Sizes.TEXT_SIZE_14,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    // width: MediaQuery.of(context).size.width*0.5,
                                    // color: Colors.red,
                                    child: Text(
                                        // hotlist[i]['distance'] +
                                        '${StringConst.currency}' +
                                            popularitem[i]['menu_price'],
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle:
                                              Styles.customNormalTextStyle(
                                            color: Colors.black54,
                                            fontSize: Sizes.TEXT_SIZE_14,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8,)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  List catlist = [
    'All',
    'Korean',
    'Indian',
  ];
  int selectedcat = 0;

  newcategorieslist() {
    return List.generate(
        categories.length + 1,
        (i) => InkWell(
              onTap: () {
                // selectedcat = i;
                // Navigator.pushNamed(context, AppRouter.Filter_Items,
                //     arguments: {
                //       // 'name': name == 'Delivery' ? 'Deliverable' : 'Pickup',
                //       'name': i == 0 ? 'All' : categories[i - 1].menuName,
                //       'cat': true,
                //       'catid': i == 0 ? 1 : categories[i - 1].id
                //     });
                // setState(() {});

                Navigator.push(
                          context,
                          // MaterialPageRoute(builder: (_) => BackgroundVideo()), (route) => false);
                          CupertinoPageRoute(builder: (_) => FilterItems(data:  {
                      // 'name': name == 'Delivery' ? 'Deliverable' : 'Pickup',
                      'name': i == 0 ? 'All' : categories[i - 1].menuName,
                      'cat': true,
                      'catid': i == 0 ? 1 : categories[i - 1].id
                    },)));
              },
              child: Container(
                // padding: EdgeInsets.symmetric(vertical:selectedcat== i?0: 4),
                decoration: selectedcat == i
                    ? BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey.withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 4,
                            // offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      )
                    : null,
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Stack(
                    children: [
                      Container(
                        child: Material(
                          elevation: i == 0 ? 10 : 0,
                          color: i == 0
                              ? Color(0xFFFF8E5D)
                              : i == 1
                                  ? Color(0xFF00808D)
                                  : Color(0xFF4C0065),
                          shape: RoundedRectangleBorder(
                            // side: i== 0? BorderSide(width: 1,color: AppColors.black): BorderSide.none,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            // height: MediaQuery.of(context).size.height * 0.12,
                            height: selectedcat == i
                                ? MediaQuery.of(context).size.height * 0.12
                                : MediaQuery.of(context).size.height * 0.116,
                            // margin: EdgeInsets.only(
                            //     top: 50, bottom: 5, left: 5, right: 0),
                            // margin: EdgeInsets.all(i==0? 5:0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: i == 0
                                  ? Color(0xFFFF8E5D)
                                  : i == 1
                                      ? Color(0xFF00808D)
                                      : Color(0xFF4C0065),
                              // border: Border.all(width: 0.5,color: AppColors.grey),
                            ),
                            // child: Center(
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: [
                            //     // SizedBox(width: 5,),
                            //     Padding(
                            //       padding: const EdgeInsets.only(left:12.0),
                            //       child: Icon(Icons.fastfood_outlined,size: 18,color:  i != 0? AppColors.black: AppColors.white,),
                            //     ),
                            //     SizedBox(width: 15,),
                            //     Text('Burgers',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: i != 0? AppColors.black: AppColors.white),)
                            //   ],)
                            // )
                            // child: Material(
                            //     elevation: i== 0?10: 0,
                            //     color: i== 0? Color(0xFFFF8E5D): i== 1? Color(0xFF00808D): Color(0xFF4C0065),
                            //     shape: RoundedRectangleBorder(
                            //       // side: i== 0? BorderSide(width: 1,color: AppColors.black): BorderSide.none,
                            //       borderRadius: BorderRadius.circular(6),
                            //     ),
                            //     child: Container()),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 5,
                          bottom: 0,
                          // left: 25,
                          right: -45,
                          child: Image.asset(
                            'assets/images/d${i + 1}.png',
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.12,
                            fit: BoxFit.fill,
                          )),
                      // Positioned(
                      //     top: 10,
                      //     //  bottom: 10,
                      //     left: 25,
                      //     right: 25,
                      //     child: Image.asset(
                      //       'assets/images/d${i + 1}.png',
                      //       width: MediaQuery.of(context).size.width / 2.5,
                      //       height: MediaQuery.of(context).size.width / 2.8,
                      //       fit: BoxFit.fill,
                      //     )),

                      // SizedBox(height: 10,),
                      // Positioned(
                      //   bottom: MediaQuery.of(context).size.height * 0.075,
                      //   left: 0,
                      //   right: 0,
                      //   child: Text('Chopped Spring',
                      //       textAlign: TextAlign.center,
                      //       style: GoogleFonts.dmSerifDisplay(
                      //         textStyle: Styles.customTitleTextStyle(
                      //           color: Colors.black87,
                      //           fontWeight: FontWeight.normal,
                      //           fontSize: 22,
                      //         ),
                      //       )),
                      // ),

                      // Positioned(
                      //   bottom: MediaQuery.of(context).size.height * 0.05,
                      //   left: 0,
                      //   right: 0,
                      //   child: Text('Scallions & Radishes',
                      //       textAlign: TextAlign.center,
                      //       style: GoogleFonts.openSans(
                      //         textStyle: Styles.customNormalTextStyle(
                      //           color: Colors.black54,
                      //           fontSize: Sizes.TEXT_SIZE_12,
                      //         ),
                      //       )),
                      // ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.01,
                        left: 10,
                        // right: 0,
                        child: Text(i == 0 ? 'All' : categories[i - 1].menuName,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSerifDisplay(
                              textStyle: Styles.customTitleTextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  filterswidget(id, name, iconsize, icon, border, width, active) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Container(
        decoration: deliverytype == id
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondaryElement.withOpacity(0.4),
                    spreadRadius: 0,
                    blurRadius: 4,
                    // offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              )
            : null,
        child: Material(
          elevation: active ? 1 : 0,
          shape: active
              ? RoundedRectangleBorder(
                  side: BorderSide(width: 0.5, color: border),
                  borderRadius: BorderRadius.circular(6),
                )
              : null,
          child: InkWell(
            onTap: () {
              // if (deliverytype == id) {
              //   deliverytype = null;
              //   resturants = searchlist;
              //   setState(() {});
              // } else {
              //   deliverytype = id;
              //   print(resturants);
              //   resturants = searchlist
              //       .where((pro) => deliverytype == 0
              //           ? pro.delivery == 1
              //           : deliverytype == 1
              //               ? pro.pickup == 1
              //               : pro.tableService == 1)
              //       .toList();
              //   setState(() {});
              // }
              if (name == 'Table Service') {
                Navigator.pushNamed(context, AppRouter.Table_Scanner);
              } else {
                Navigator.pushNamed(context, AppRouter.Filter_Items,
                    arguments: {
                      'name': name == 'Delivery' ? 'Deliverable' : 'Pickup',
                      'cat': false
                    });
              }
            },
            child: Container(
                width: width,
                height: 30,
                decoration: active
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(width: 0.5, color: border),
                      )
                    : null,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    // Icon(
                    //   icon,
                    //   size: iconsize,
                    //   color: AppColors.black,
                    // ),
                    // SizedBox(
                    //   width: 5,
                    // ),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 15,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ))),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size(MediaQuery.of(context).size.width, 0),
        //   child: AppBar(
        //     elevation: 0,
        //     // backwardsCompatibility: false,
        //     // systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.white),
        //   ),
        // ),
        body: NestedScrollView(
          //  controller: controller,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                // collapsedHeight: 40,
                toolbarHeight: 135,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: InkWell(
                                onTap: () => bottomSheetForLocation(context),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 0.0),
                                      // child: Icon(Icons.share_location_outlined,
                                      //     color: AppColors.black),
                                      child: Image.asset(
                                        "assets/images/driver.gif",
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        bottom: 0,
                                      ),
                                      // decoration: BoxDecoration(
                                      //     border: Border(
                                      //         bottom: BorderSide(
                                      //   color: Colors.black38,
                                      //   width: 0.0,
                                      // ))),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 2.0),
                                            child: RotationTransition(
                                              turns: new AlwaysStoppedAnimation(
                                                  40 / 360),
                                              child: Icon(
                                                Icons.navigation_rounded,
                                                color: AppColors.black,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.40,
                                            child: Text(
                                              selected_address,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: AppColors.black,
                                        size: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: InkWell(
                                      onTap: () async {
                                        Navigator.pushNamed(
                                          context,
                                          AppRouter.cart_Screen,
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey[300],
                                                  blurRadius: 7.0,
                                                  spreadRadius: 0.5),
                                            ]),
                                        child: Icon(
                                          OMIcons.shoppingCart,
                                          color: AppColors.black,
                                          size: 21,
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: InkWell(
                                    onTap: () async {
                                      _isGuest = await Service().isGuest();
                                      print(_isGuest);
                                      // return;
                                      if (_isGuest == null || !_isGuest) {
                                        Navigator.pushNamed(
                                          context,
                                          AppRouter.profileScreen,
                                        );
                                      } else
                                        _askLoginDialog(context);

                                      setState(() {});
                                    },
                                    // child: Icon(
                                    //   Icons.person,
                                    //   color: AppColors.black,
                                    //   size: 22,
                                    // )
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Material(
                                        elevation: 10,
                                        shadowColor: Colors.grey[400],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: CircleAvatar(
                                          backgroundImage: AssetImage(
                                              'assets/images/andy.png'),
                                          backgroundColor: Colors.transparent,
                                          minRadius: Sizes.RADIUS_14,
                                          maxRadius: Sizes.RADIUS_14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // filterswidget('Filters', 12.0, FontAwesomeIcons.slidersH,
                              //     AppColors.secondaryElement, 75.0, true),
                              // SizedBox(
                              //   width: 10,
                              // ),
                              filterswidget(
                                  0,
                                  'Delivery',
                                  16.0,
                                  Icons.store_outlined,
                                  deliverytype == 0
                                      ? AppColors.secondaryElement
                                      : AppColors.grey,
                                  80.0,
                                  deliverytype == 0 ? true : false),
                              SizedBox(
                                width: 10,
                              ),
                              filterswidget(
                                  1,
                                  'Pickup',
                                  16.0,
                                  Icons.attach_money,
                                  deliverytype == 1
                                      ? AppColors.secondaryElement
                                      : AppColors.grey,
                                  75.0,
                                  deliverytype == 1 ? true : false),
                              SizedBox(
                                width: 10,
                              ),
                              filterswidget(
                                  2,
                                  'Table Service',
                                  16.0,
                                  Icons.attach_money,
                                  deliverytype == 2
                                      ? AppColors.secondaryElement
                                      : AppColors.grey,
                                  105.0,
                                  deliverytype == 2 ? true : false),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      search
                          ? Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    print('here');
                                    Navigator.pushNamed(
                                        context, AppRouter.newsearch);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0),
                                    ),

                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    // width: MediaQuery.of(context).size.width * 0.82,
                                    width: MediaQuery.of(context).size.width,
                                    child: Material(
                                      elevation: 0,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey[400],
                                                  blurRadius: 5.0,
                                                  spreadRadius: 0.5),
                                            ]),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0),
                                              child: FoodyBiteSearchInputField(
                                                  ImagePath.searchIcon,
                                                  borderRadius: 8,
                                                  controller: searchcontroller,
                                                  fillColor: Colors.grey[200],
                                                  filled: true,
                                                  borderColor:
                                                      Colors.transparent,
                                                  contentPaddingVertical: 11,
                                                  contentPaddingHorizontal: 50,
                                                  textFormFieldStyle: Styles
                                                      .customNormalTextStyle(
                                                          color:
                                                              Colors.black54),
                                                  hintText: StringConst
                                                      .HINT_TEXT_HOME_SEARCH_BAR,
                                                  hintTextStyle: Styles
                                                      .customNormalTextStyle(
                                                          color:
                                                              Colors.black54),
                                                  suffixIconImagePath:
                                                      ImagePath.settingsIcon,
                                                  hasSuffixIcon: false,
                                                  borderWidth: 0.0,
                                                  onChanged: (value) {
                                                searchfromlist();
                                              }, onTapOfLeadingIcon: () {
                                                pausevideo();
                                                FocusScope.of(context)
                                                    .unfocus();
                                                Navigator.pushNamed(
                                                  context,
                                                  AppRouter.searchResultsScreen,
                                                  arguments: SearchValue(
                                                    searchcontroller.text,
                                                  ),
                                                ).then((value) {
                                                  this.searchcontroller.text =
                                                      '';
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  setState(() {});
                                                  resumevideo();
                                                });
                                              }, onTapOfSuffixIcon: () {
                                                // pausevideo();
                                                print('herrrrr');
                                                Navigator.pushNamed(
                                                        context,
                                                        AppRouter
                                                            .Filter_Screens)
                                                    .then((value) =>
                                                        resumevideo());
                                              },
                                                  borderStyle:
                                                      BorderStyle.solid),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                        context,
                                                        AppRouter
                                                            .Filter_Screens)
                                                    .then((value) =>
                                                        resumevideo());
                                              },
                                              child: Container(
                                                height: 46,
                                                width: 50,
                                                // margin: EdgeInsets.only(right: 15),
                                                // color: Colors.red,
                                                //   decoration: BoxDecoration(
                                                //      boxShadow: [
                                                //   BoxShadow(
                                                //     color: Colors.grey.withOpacity(0.2),
                                                //     spreadRadius: 0,
                                                //     blurRadius: 2,
                                                //     // offset: Offset(0, 3), // changes position of shadow
                                                //   ),
                                                // ],
                                                //   ),
                                                child: ImageIcon(
                                                  AssetImage(
                                                    ImagePath.settingsIcon,
                                                  ),
                                                  color: AppColors.black,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              )
            ];
          },
          body: Container(
            margin: EdgeInsets.symmetric(
              // horizontal: Sizes.MARGIN_16,
              vertical: 2,
            ),
            child: SingleChildScrollView(
              // physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // shrinkWrap: true,
                children: <Widget>[
                  SizedBox(
                    height: search ? 5 : 0,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: newcategorieslist(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Text('Eat In /'.toUpperCase(),
                              textAlign: TextAlign.left,
                              style: GoogleFonts.dmSerifDisplay(
                                textStyle: Styles.customTitleTextStyle2(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.TEXT_SIZE_32,
                                ),
                              )),
                          Text(' Eat out'.toUpperCase(),
                              textAlign: TextAlign.left,
                              style: GoogleFonts.dmSerifDisplay(
                                textStyle: Styles.customTitleTextStyle2(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.TEXT_SIZE_32,
                                ),
                              )),
                        ],
                      )),
                  SizedBox(
                    height: 6,
                  ),
                  loader || lottie == false
                      ? Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width - 16,
                            height: 200,
                            child: SkeletonAnimation(
                              shimmerColor: Colors.grey[350],
                              shimmerDuration: 1100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4),
                              ),
                            ),
                          ),
                        )
                      : Container(),

                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.restaurantDetailsScreen,
                          arguments: RestaurantDetails(
                              imagePath: resturants[0].restImage,
                              restaurantName: resturants[0].restName,
                              restaurantAddress: resturants[0].restAddress +
                                  resturants[0].restCity +
                                  ' ' +
                                  resturants[0].restCountry,
                              rating: '0.0',
                              category: resturants[0].restType,
                              distance: '0 Km',
                              data: resturants[0]),
                        );
                      },
                      child: Lottie.asset('assets/restaurant2.json',
                          width: MediaQuery.of(context).size.width - 25,
                          height: lottie && !loader ? 200 : 0,
                          fit: BoxFit.fill, onLoaded: (value) {
                        setState(() {
                          lottie = true;
                        });
                        print('value');
                      }),
                    ),
                  ),
                   SizedBox(
                    height: 8,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text('Offers'.toUpperCase(),
                          textAlign: TextAlign.left,
                          style: GoogleFonts.dmSerifDisplay(
                            textStyle: Styles.customTitleTextStyle2(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              fontSize: Sizes.TEXT_SIZE_22,
                            ),
                          ))),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 200,
                    //  width: 180,
                    //  color: Colors.red,

                    margin: EdgeInsets.symmetric(horizontal: 8),
                    // padding: EdgeInsets.all(8),
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: subscription.length,
                        itemBuilder: (context, i) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 2),
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRouter.promotionScreen);
                              },
                              child: Material(
                                elevation: 1,
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        subscription[i],
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.08,
                                        fit: BoxFit.contain,
                                        // color: Colors.red,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text('Recipes'.toUpperCase(),
                          textAlign: TextAlign.left,
                          style: GoogleFonts.dmSerifDisplay(
                            textStyle: Styles.customTitleTextStyle2(
                              color: Colors.black,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                              fontSize: Sizes.TEXT_SIZE_22,
                            ),
                          ))),
                  SizedBox(
                    height: 8,
                  ),
                  loader3
                      ? Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width - 16,
                            height: 200,
                            child: SkeletonAnimation(
                              shimmerColor: Colors.grey[350],
                              shimmerDuration: 1100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: InkWell(
                              onTap: () {
                                // Navigator.pushNamed(
                                //   context,
                                //   AppRouter.HotspotsDetailsScreen,
                                //   arguments: RestaurantDetails(
                                //       imagePath: hotspotlist[0]['image'],
                                //       restaurantName: hotspotlist[0]['name'],
                                //       restaurantAddress: hotspotlist[0]['address'],
                                //       // rating: hotspotlist[0]['rating'],
                                //       rating: '3.2',
                                //       category: '',
                                //       distance: hotspotlist[0]['distance'] + ' Km',
                                //       data: hotspotlist[0]),
                                // );

                                if (recipessub.length > 0) {
                                  // Navigator.pushNamed(
                                  //     context, AppRouter.Recipes_list,
                                  //     arguments: {
                                  //       'recipe': recipes[0],
                                  //       'usersub': true,
                                  //       'subdata': recipessub[0]
                                  //     });
                                  Navigator.push(
                          context,
                          // MaterialPageRoute(builder: (_) => BackgroundVideo()), (route) => false);
                          CupertinoPageRoute(builder: (_) => RecipeList(data:  {
                                        'recipe': recipes[0],
                                        'usersub': true,
                                        'subdata': recipessub[0]
                                      },)));
                                } else {
                                  Navigator.pushNamed(
                                      context, AppRouter.Build_Plan,
                                      arguments: {
                                        'recipe': recipes[0],
                                        'usersub': false,
                                      });
                                }
                              },
                              child: Image.asset(
                                //  'assets/loginvideo2.gif',
                                'assets/recipe1.gif',
                                fit: BoxFit.fill,
                                height: 200,
                                width: MediaQuery.of(context).size.width - 25,
                                filterQuality: FilterQuality.high,
                              )),
                        ),
                  // SizedBox(height: 15.0),

                  // : Container(),
                  // loader
                  //     ? Container(
                  //         height: 280,
                  //         child: CarouselSlider(
                  //             options: CarouselOptions(
                  //                 enableInfiniteScroll: true, height: 260),
                  //             items: List.generate(
                  //               1,
                  //               (ind) => SkeletonAnimation(
                  //                 shimmerColor: Colors.grey[350],
                  //                 shimmerDuration: 1100,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.grey[300],
                  //                   ),
                  //                   margin: EdgeInsets.symmetric(horizontal: 4),
                  //                 ),
                  //               ),
                  //             )),
                  //       )
                  //     :
                  //     // SizedBox(height: 15.0),
                  //     Column(
                  //         // mainAxisAlignment: MainAxisAlignment.start,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           SizedBox(height: 5.0),
                  //           Padding(
                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 12.0),
                  //               child: Text(
                  //                 'Resturant'.toUpperCase(),
                  //                 textAlign: TextAlign.left,
                  //                 style: Styles.customTitleTextStyle2(
                  //                   color: Colors.black87,
                  //                   fontWeight: FontWeight.bold,
                  //                   fontSize: Sizes.TEXT_SIZE_16,
                  //                 ),
                  //               )),
                  //           // SizedBox(height: 200.0),

                  //           TravelCardList(
                  //             cities: resturants,
                  //             onCityChange: _handleCityChange,
                  //           ),
                  //           SizedBox(height: 5.0),
                  //         ],
                  //       ),
                  //

                  //hotspot start
                  // SizedBox(height: 0.0),
                  // loader3
                  //     ? Container(
                  //         height: 280,
                  //         child: CarouselSlider(
                  //             options: CarouselOptions(
                  //                 enableInfiniteScroll: true, height: 260),
                  //             items: List.generate(
                  //               1,
                  //               (ind) => SkeletonAnimation(
                  //                 shimmerColor: Colors.grey[350],
                  //                 shimmerDuration: 1100,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.grey[300],
                  //                   ),
                  //                   margin: EdgeInsets.symmetric(horizontal: 4),
                  //                 ),
                  //               ),
                  //             )),
                  //       )
                  //     : Column(
                  //         // mainAxisAlignment: MainAxisAlignment.start,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           SizedBox(height: 15.0),
                  //           Padding(
                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 12.0),
                  //               child: Text(
                  //                 'Hot Spot'.toUpperCase(),
                  //                 textAlign: TextAlign.left,
                  //                 style: Styles.customTitleTextStyle2(
                  //                   color: Colors.black87,
                  //                   fontWeight: FontWeight.bold,
                  //                   fontSize: Sizes.TEXT_SIZE_16,
                  //                 ),
                  //               )),
                  //           SizedBox(height: 5.0),

                  //           // TravelCardList(
                  //           //   cities: resturants,
                  //           //   onCityChange: _handleCityChange,
                  //           // ),
                  //           SingleChildScrollView(
                  //             scrollDirection: Axis.horizontal,
                  //             child: Padding(
                  //               padding:
                  //                   const EdgeInsets.symmetric(horizontal: 8.0),
                  //               child: Row(
                  //                 children: hotspot(),
                  //               ),
                  //             ),
                  //           ),
                  //           SizedBox(height: 0.0),
                  //         ],
                  //       ),
                  //hotspot ended

                 
                  SizedBox(height: 10.0),
                  loader4
                      ? Container(
                          height: 280,
                          child: CarouselSlider(
                              options: CarouselOptions(
                                  enableInfiniteScroll: true, height: 280),
                              items: List.generate(
                                1,
                                (ind) => SkeletonAnimation(
                                  shimmerColor: Colors.grey[350],
                                  shimmerDuration: 1100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                    ),
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                  ),
                                ),
                              )),
                        )
                      : Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 0.0),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  'Most Popular'.toUpperCase(),
                                  textAlign: TextAlign.left,
                                  style: Styles.customTitleTextStyle2(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Sizes.TEXT_SIZE_16,
                                  ),
                                )),
                            SizedBox(height: 5.0),

                            // TravelCardList(
                            //   cities: resturants,
                            //   onCityChange: _handleCityChange,
                            // ),
                            SingleChildScrollView(
                              // scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: popular(),
                                ),
                              ),
                            ),
                            SizedBox(height: 0.0),
                          ],
                        ),
                  SizedBox(height: 0.0),

                  promolist.length == 0 ? Container() : SizedBox(height: 16.0),

                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: HeadingRow(
                      title: StringConst.FRIENDS,
                      number: StringConst.SEE_ALL_56,
                      onTapOfNumber: () => Navigator.pushNamed(
                        context,
                        AppRouter.findFriendsScreen,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                          createUserProfilePhotos(numberOfProfilePhotos: 6),
                    ),
                  ),

                  SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bottomSheetForLocation(BuildContext context) async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              "AIzaSyCkoLh9yZhcAtP9R-KsP90JaqFiooRuEmg",
              displayLocation: LatLng(53.4083714, -2.991572600000012),
            )));

    // Handle the result in your way
    if (result != null) {
      print(result.latLng);
      selected_address = result.formattedAddress;
      setState(() {});
    }

    // return showModalBottomSheet(
    //     context: context,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10.0),
    //     ),
    //     builder: (context) {
    //       return Container(
    //         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    //         child: Container(
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.only(
    //               topLeft: const Radius.circular(10.0),
    //               topRight: const Radius.circular(10.0),
    //             ),
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 'Search Location',
    //                 style: Styles.customNormalTextStyle(color: Colors.black),
    //               ),
    //               Divider(),
    //               TextField(
    //                 decoration: InputDecoration(
    //                     prefixIcon: Padding(
    //                       padding: const EdgeInsets.all(0.0),
    //                       child: Image.asset(
    //                         ImagePath.searchIcon,
    //                       ),
    //                     ),
    //                     hintText: 'Search for your location',
    //                     hintStyle: TextStyle(
    //                       color: Colors.black26,
    //                       fontSize: 16,
    //                     ),
    //                     border: InputBorder.none),
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               InkWell(
    //                 onTap: () =>
    //                     Navigator.pushNamed(context, AppRouter.googleMap),
    //                 child: Row(
    //                   children: [
    //                     Icon(Icons.location_searching, size: 12.0),
    //                     SizedBox(
    //                       width: 5.0,
    //                     ),
    //                     Text('Use current location',
    //                         style: Styles.customNormalTextStyle(
    //                             color: Colors.indigo)),
    //                   ],
    //                 ),
    //               ),
    //               Divider(),
    //               SizedBox(
    //                 height: 5.0,
    //               ),
    //               Text(
    //                 'Saved Addresses',
    //                 style: Styles.customNormalTextStyle(color: Colors.black),
    //               ),
    //               ListTile(
    //                 leading: Icon(Icons.home),
    //                 title: Text('Home'),
    //                 onTap: () {
    //                   Navigator.pop(context);
    //                 },
    //                 subtitle: Text('Habib Street, Banigala'),
    //               ),
    //               Divider(),
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }

  Future<void> _askLoginDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _buildAlertDialog(context);
      },
    );
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
                    'Please login to access full features',
                    style: textTheme.headline6.copyWith(
                      fontSize: Sizes.TEXT_SIZE_16,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.secondaryElement,
                      minimumSize: Size(200.0, 30),
                    ),
                    child: Text(
                      'Go to Login Screen',
                      style: TextStyle(fontSize: 15.0),
                    ),
                    onPressed: () async {
                      await Service().removeGuest();
                      Provider.of<ProviderService>(context, listen: false)
                          .allfalse();
                      Provider.of<ProviderService>(context, listen: false)
                          .reset();
                      Navigator.push(
                          context,
                          // MaterialPageRoute(builder: (_) => BackgroundVideo()), (route) => false);
                          MaterialPageRoute(builder: (_) => GooeyEdgeDemo()));
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.secondaryElement,
                      minimumSize: Size(200.0, 30),
                    ),
                    child: Text(
                      'Close ',
                      style: TextStyle(fontSize: 15.0),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
