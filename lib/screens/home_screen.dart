import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potbelly/3D_card_widets/demo_data.dart';
import 'package:potbelly/3D_card_widets/travel_card_list.dart';
import 'package:potbelly/models/menu_types_model.dart';
import 'package:potbelly/models/promotions.dart';
import 'package:potbelly/models/restaurent_model.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/DatabaseManager.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/values/data.dart';
import 'package:potbelly/widgets/category_card.dart';
import 'package:potbelly/widgets/foody_bite_card.dart';
import 'package:potbelly/widgets/heading_row.dart';
import 'package:potbelly/widgets/search_input_field.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:video_player/video_player.dart';

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
  bool loader2 = true;
  int totalRestaurent = 0;
  List resturants = [];
  List categories = [];
  List<City> _cityList;
  City _currentCity;
  bool search=false;

  List subscription = ['assets/images/mainscreen.jpg'];

  RestaurentsModel _restaurentsModel;
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var token;
    _register() {
    _firebaseMessaging.getToken().then((tokeen) {
      print(tokeen);
      this.token = tokeen;
      print(token);
    });
  }

  @override
  void initState() {
        var data = DemoData();
    _cityList = data.getCities();
    _currentCity = _cityList[1];
    checkpromo();
    _register();
    getRestaurent();
    getcateory();
    super.initState();
  }

  checkpromo() async {
    var show = await Promotion().checkpromo();
    print(show);
    if (show) {
      Navigator.pushNamed(context,AppRouter.promotionScreen);
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
    totalRestaurent = response.data.length;
    loader = false;
    print(response);
    setState(() {});
  }

  getcateory() async {
    var response = await Service().getMenuTypes();
    categories = response.data;
    loader2 = false;
    setState(() {});
    print(resturants);
  }

  getpromos() async {
    await DatabaseManager().getpromotions().then((value) {
      for (var item in value) {
        promolist.add(item);
      }

      if (promolist.length != 0 &&
          (promolist[0]['videoUrl'] != '' ||
              promolist[0]['videoUrl'] != null)) {
        print('here');
        // controllerdispo();
        initialize(promolist[0]['videoUrl']);
      }
      this.loader = false;
      setState(() {});
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
    Navigator
        .pushNamed(context,
      AppRouter.promotionDetailsScreen,
      arguments: PromotionDetails(
          image: promolist[ind]['image'],
          video: promolist[ind]['videoUrl'],
          name: promolist[ind]['name'],
          id: promolist[ind]['id'],
          thumnail: promolist[ind]['thumbnailUrl'],
          description: promolist[ind]['description'],
          data: promolist[ind]),
    )
        .then((value) {
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
        body: Container(
          margin: EdgeInsets.symmetric(
            // horizontal: Sizes.MARGIN_16,
            vertical: Sizes.MARGIN_8,
          ),
          child: ListView(
            children: <Widget>[
              InkWell(
                onTap: () => bottomSheetForLocation(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Icon(Icons.share_location_outlined,
                                color: AppColors.black),
                          ),
                       SizedBox(width: 2,),
                      Container(
                        
                        padding: EdgeInsets.only(
                          bottom: 5,
                        ),
                        // decoration: BoxDecoration(
                        //     border: Border(
                        //         bottom: BorderSide(
                        //   color: Colors.black38,
                        //   width: 0.0,
                        // ))),
                        child: Text(
                          "Preston",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom:2.0),
                        child: Icon(Icons.keyboard_arrow_down_rounded,color: AppColors.black,size: 18,),
                      )
                       ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right:15.0),
                      child: InkWell(
                        onTap: (){
                          search=!search;
                          setState(() {
                            
                          });
                        },
                        child: Icon(Icons.search_rounded,color: AppColors.black,)),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: Sizes.MARGIN_14,
              ),
            search?  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20),
                  child: FoodyBiteSearchInputField(ImagePath.searchIcon,
                      borderRadius: 20,
                      controller: searchcontroller,
                      contentPaddingVertical: 6,
                      textFormFieldStyle:
                          Styles.customNormalTextStyle(color: Colors.black54),
                      hintText: StringConst.HINT_TEXT_HOME_SEARCH_BAR,
                      hintTextStyle:
                          Styles.customNormalTextStyle(color: Colors.black54),
                      suffixIconImagePath: ImagePath.settingsIcon,
                      borderWidth: 0.0, onTapOfLeadingIcon: () {
                    pausevideo();
                    FocusScope.of(context).unfocus();
                    Navigator
                        .pushNamed(context,
                      AppRouter.searchResultsScreen,
                      arguments: SearchValue(
                        searchcontroller.text,
                      ),
                    )
                        .then((value) {
                      this.searchcontroller.text = '';
                      FocusScope.of(context).unfocus();
                      setState(() {});
                      resumevideo();
                    });
                  }, onTapOfSuffixIcon: () {
                    pausevideo();
                    Navigator
                        .pushNamed(context,AppRouter.filterScreen)
                        .then((value) => resumevideo());
                  }, borderStyle: BorderStyle.solid),
                ),
              ): Container(),
              SizedBox(height: 0,),

              Padding(
                padding: const EdgeInsets.only(left:10.0,right: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 0.5,color: AppColors.secondaryElement),
                        ),
                        child: Center(
                          child: Row(children: [
                            SizedBox(width: 5,),
                            Icon(Icons.location_pin,size: 18,color: AppColors.secondaryElement,),
                            SizedBox(width: 5,),
                            Text('Nearby',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                          ],)
                        )
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: 80,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 0.5,color: AppColors.secondaryElement),
                        ),
                        child: Center(
                          child: Row(children: [
                            SizedBox(width: 5,),
                            Icon(Icons.store_outlined,size: 18,color: AppColors.secondaryElement,),
                            SizedBox(width: 5,),
                            Text('Opened',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                          ],)
                        )
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: 105,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 0.5,color: AppColors.secondaryElement),
                        ),
                        child: Center(
                          child: Row(children: [
                            SizedBox(width: 5,),
                            Icon(Icons.attach_money,size: 18,color: AppColors.secondaryElement,),
                            SizedBox(width: 5,),
                            Text('High to Low',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                          ],)
                        )
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: 105,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 0.5,color: AppColors.secondaryElement),
                        ),
                        child: Center(
                          child: Row(children: [
                            SizedBox(width: 5,),
                            Icon(Icons.attach_money,size: 18,color: AppColors.secondaryElement,),
                            SizedBox(width: 5,),
                            Text('Low to High',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                          ],)
                        )
                      ),
                      SizedBox(width: 5,),
                      Container(
                        width: 105,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 0.5,color: AppColors.secondaryElement),
                        ),
                        child: Center(
                          child: Row(children: [
                            SizedBox(width: 5,),
                            Icon(Icons.star,size: 18,color: AppColors.secondaryElement,),
                            SizedBox(width: 5,),
                            Text('4+ Rating',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                          ],)
                        )
                      ),
                  ],),
                ),
              ),

              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:12.0),
                child: Text('What you want to order next?', textAlign: TextAlign.left, style: GoogleFonts.dmSerifDisplay(textStyle:TextStyle(fontSize: 36,color: AppColors.black)),),
              ),
//
              loader
                  ? Container(
                      height: 280,
                      child: CarouselSlider(
                          options: CarouselOptions(
                              enableInfiniteScroll: true, height: 260),
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
                  : 
              // SizedBox(height: 15.0),
               TravelCardList(
              cities: resturants,
              onCityChange: _handleCityChange,
            ),
//
              // SizedBox(height: 0.0),
              // HeadingRow(
              //     title: StringConst.TRENDING_RESTAURANTS,
              //     number: 'See all (' + resturants.length.toString() + ')',
              //     onTapOfNumber: () {
              //       pausevideo();
              //       Navigator
              //           .pushNamed(context,AppRouter.trendingRestaurantsScreen)
              //           .then((value) {
              //         resumevideo();
              //       });
              //     }),

              // // SizedBox(height: 16.0),
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
              //     : Container(
              //         height: 280,
              //         width: MediaQuery.of(context).size.width,
              //         child: ListView.builder(
              //           physics: BouncingScrollPhysics(),
              //           scrollDirection: Axis.horizontal,
              //           itemCount: resturants.length,
              //           itemBuilder: (context, index) {
              //             var res = resturants[index];
              //             return Container(
              //               margin: EdgeInsets.only(right: 4.0),
              //               child: FoodyBiteCard(
              //                 onTap: () {
              //                   if (_controller != null) {
              //                     _controller.pause();
              //                   }
              //                   Navigator
              //                       .pushNamed(context,
              //                     AppRouter.restaurantDetailsScreen,
              //                     arguments: RestaurantDetails(
              //                         imagePath: res.restImage,
              //                         restaurantName: res.restName,
              //                         restaurantAddress: res.restAddress +
              //                             res.restCity +
              //                             ' ' +
              //                             res.restCountry,
              //                         rating: '0.0',
              //                         category: res.restType,
              //                         distance: '0 Km',
              //                         data: res),
              //                   )
              //                       .then((value) {
              //                     if (_controller != null) {
              //                       _controller.play();
              //                     }
              //                   });
              //                 },
              //                 imagePath: res.restImage,
              //                 status: res.restIsOpen == 1 ? "OPEN" : "CLOSE",
              //                 cardTitle: res.restName,
              //                 rating: '0.0',
              //                 category: res.restType ?? 'Not Found',
              //                 distance: '8 KM',
              //                 address: res.restAddress ??
              //                     'Not Found' + ' ' + res.restCity ??
              //                     'Not Found' + ' ' + res.restCountry ??
              //                     'Not Available',
              //               ),
              //             );
              //           },
              //         ),
              //       ),

            
              SizedBox(height: 15.0),
              Container(
                height: 160,
                //  width: 180,
                //  color: Colors.red,

                margin: EdgeInsets.symmetric(horizontal: 12),
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: subscription.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          Navigator
                              .pushNamed(context,AppRouter.promotionScreen);
                        },
                        child: Material(
                          elevation: 6,
                          borderRadius: BorderRadius.circular(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                Image.asset(
                                  subscription[i],
                                  width:
                                      MediaQuery.of(context).size.width / 1.07,
                                  fit: BoxFit.cover,
                                  // color: Colors.red,
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child:
                                      Text('Subscription Offer!'.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                offset: Offset(1.0, 1.0),
                                                blurRadius: 5,
                                              ),
                                            ],
                                          )),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),

              promolist.length == 0 ? Container() : SizedBox(height: 16.0),
              // promolist.length == 0
              //     ? Container()
              //     : loader
              //         ? Container(
              //             height: 190,
              //             child: CarouselSlider(
              //                 options: CarouselOptions(
              //                   enableInfiniteScroll: true,
              //                 ),
              //                 items: List.generate(
              //                   1,
              //                   (ind) => SkeletonAnimation(
              //                     shimmerColor: Colors.grey[350],
              //                     shimmerDuration: 1100,
              //                     child: Container(
              //                       decoration: BoxDecoration(
              //                         color: Colors.grey[300],
              //                       ),
              //                       margin: EdgeInsets.symmetric(horizontal: 4),
              //                     ),
              //                   ),
              //                 )),
              //           )
              //         : Container(
              //             height: 190,
              //             width: 50,
              //             child: CarouselSlider(
              //                 options: CarouselOptions(
              //                   enableInfiniteScroll: true,
              //                   onPageChanged: (ind, reason) {
              //                     print(ind);
              //                     active_video = ind;
              //                     if (_controller != null) {
              //                       _controller.pause();
              //                     }
              //                     setState(() {});
              //                     print(promolist[ind]);
              //                     if (promolist[ind]['videoUrl'] != '') {
              //                       print('here');
              //                       print('here');
              //                       initialize(promolist[ind]['videoUrl']);
              //                     }
              //                   },
              //                 ),
              //                 items: List.generate(
              //                     this.promolist.length,
              //                     (ind) => _controller == null
              //                         ? Container()
              //                         : SizedBox(
              //                             height: 230,
              //                             width: MediaQuery.of(context)
              //                                     .size
              //                                     .width /
              //                                 1.2,
              //                             child: Container(
              //                               color: Colors.black,
              //                               margin: EdgeInsets.only(right: 8.0),
              //                               child: FittedBox(
              //                                 child: active_video == ind &&
              //                                         (promolist[ind]
              //                                                 ['videoUrl'] !=
              //                                             '')
              //                                     ? SizedBox(
              //                                         height: 50,
              //                                         width: 50,
              //                                         child: _controller == null
              //                                             ? Container()
              //                                             : InkWell(
              //                                                 onTap: () {
              //                                                   navigatortopromotion(
              //                                                       ind);
              //                                                 },
              //                                                 child: VideoPlayer(
              //                                                     _controller),
              //                                               ))
              //                                     : promolist[ind]['image'] !=
              //                                                 null &&
              //                                             promolist[ind]
              //                                                     ['image'] !=
              //                                                 ''
              //                                         ? promolist[ind]['image']
              //                                                     .substring(
              //                                                         0, 4) ==
              //                                                 'http'
              //                                             ? InkWell(
              //                                                 onTap: () {
              //                                                   navigatortopromotion(
              //                                                       ind);
              //                                                 },
              //                                                 child:
              //                                                     Image.network(
              //                                                   promolist[ind]
              //                                                       ['image'],
              //                                                   width: MediaQuery.of(
              //                                                           context)
              //                                                       .size
              //                                                       .width,
              //                                                   fit: BoxFit
              //                                                       .cover,
              //                                                 ),
              //                                               )
              //                                             : InkWell(
              //                                                 onTap: () {
              //                                                   navigatortopromotion(
              //                                                       ind);
              //                                                 },
              //                                                 child:
              //                                                     Image.asset(
              //                                                   promolist[ind]
              //                                                       ['image'],
              //                                                   width: MediaQuery.of(
              //                                                           context)
              //                                                       .size
              //                                                       .width,
              //                                                   fit: BoxFit
              //                                                       .cover,
              //                                                 ),
              //                                               )
              //                                         : active_video != ind &&
              //                                                 (promolist[ind][
              //                                                             'videoUrl'] !=
              //                                                         '' ||
              //                                                     promolist[ind]
              //                                                             ['videoUrl'] !=
              //                                                         null)
              //                                             ? InkWell(
              //                                                 onTap: () {
              //                                                   navigatortopromotion(
              //                                                       ind);
              //                                                 },
              //                                                 child: Stack(
              //                                                   children: [
              //                                                     Padding(
              //                                                       padding:
              //                                                           const EdgeInsets.fromLTRB(
              //                                                               5,
              //                                                               3,
              //                                                               5,
              //                                                               3),
              //                                                       child: promolist[ind]['thumbnailUrl'].substring(0,
              //                                                                   4) ==
              //                                                               'http'
              //                                                           ? Image
              //                                                               .network(
              //                                                               promolist[ind]['thumbnailUrl'],
              //                                                               width:
              //                                                                   MediaQuery.of(context).size.width,
              //                                                               height:
              //                                                                   230,
              //                                                               fit:
              //                                                                   BoxFit.cover,
              //                                                             )
              //                                                           : Image
              //                                                               .asset(
              //                                                               promolist[ind]['thumbnailUrl'],
              //                                                               width:
              //                                                                   MediaQuery.of(context).size.width,
              //                                                               height:
              //                                                                   230,
              //                                                               fit:
              //                                                                   BoxFit.cover,
              //                                                             ),
              //                                                     ),
              //                                                     Positioned(
              //                                                         right: 0,
              //                                                         child:
              //                                                             Container(
              //                                                           margin: EdgeInsets.only(
              //                                                               top:
              //                                                                   6),
              //                                                           width:
              //                                                               90,
              //                                                           height:
              //                                                               25,
              //                                                           decoration: BoxDecoration(
              //                                                               color:
              //                                                                   Colors.black38,
              //                                                               borderRadius: BorderRadius.circular(100)),
              //                                                           child:
              //                                                               Row(
              //                                                             mainAxisAlignment:
              //                                                                 MainAxisAlignment.center,
              //                                                             children: [
              //                                                               Text(
              //                                                                 'Play',
              //                                                                 style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold),
              //                                                               ),
              //                                                               SizedBox(
              //                                                                 width: 2,
              //                                                               ),
              //                                                               Icon(
              //                                                                 Icons.play_arrow_outlined,
              //                                                                 size: 22,
              //                                                                 color: AppColors.white,
              //                                                               ),
              //                                                             ],
              //                                                           ),
              //                                                         )),
              //                                                   ],
              //                                                 ),
              //                                               )
              //                                             : Container(),
              //                                 fit: BoxFit.fill,
              //                               ),
              //                             ),
              //                           ))),
              //           ),

              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:12.0),
                child: HeadingRow(
                  title: StringConst.CATEGORY,
                  number: 'See all (' + categories.length.toString() + ')',
                  onTapOfNumber: () =>
                      Navigator.pushNamed(context,AppRouter.categoriesScreen),
                ),
              ),

              SizedBox(height: 16.0),
              loader2
                  ? Container(
                      height: 200,
                      
                      child: CarouselSlider(
                          options: CarouselOptions(
                              // viewportFraction: 1.2,
                              enableInfiniteScroll: true,
                              height: 200),
                          items: List.generate(
                            2,
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
                  : Container(
                      height: 200,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          var data = categories[index];
                          return InkWell(
                            onTap: () => Navigator.pushNamed(context,
                              AppRouter.categoryDetailScreen,
                              arguments: CategoryDetailScreenArguments(
                                  categoryName: data.menuName,
                                  imagePath: data.menuTypeImage,
                                  selectedCategory: index,
                                  numberOfCategories: categories.length,
                                  gradient: gradients[index],
                                  restaurantdata: data),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(right: 12.0, bottom: 12),
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(15),
                                child: FoodyBiteCategoryCard(
                                  height: 200,
                                  borderRadius: 15,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  imagePath: data.menuTypeImage,
                                  // hasHandle: true,
                                  // gradient: gradients[index],
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.5, 0.8],
                                    colors: [
                                      Colors.black12,
                                      Colors.black87,
                                    ],
                                  ),
                                  category: data.menuName,
                                ),
                              ),
                            ),
                          );
                        },
                      )),
              SizedBox(height: 16.0),
              HeadingRow(
                title: StringConst.FRIENDS,
                number: StringConst.SEE_ALL_56,
                onTapOfNumber: () => Navigator.pushNamed(context,
                  AppRouter.findFriendsScreen,
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: createUserProfilePhotos(numberOfProfilePhotos: 6),
              ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
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

  bottomSheetForLocation(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search Location',
                    style: Styles.customNormalTextStyle(color: Colors.black),
                  ),
                  Divider(),
                  TextField(
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Image.asset(
                            ImagePath.searchIcon,
                          ),
                        ),
                        hintText: 'Search for your location',
                        hintStyle: TextStyle(
                          color: Colors.black26,
                          fontSize: 16,
                        ),
                        border: InputBorder.none),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.pushNamed(context,AppRouter.googleMap),
                    child: Row(
                      children: [
                        Icon(Icons.location_searching, size: 12.0),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text('Use current location',
                            style: Styles.customNormalTextStyle(
                                color: Colors.indigo)),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'Saved Addresses',
                    style: Styles.customNormalTextStyle(color: Colors.black),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    subtitle: Text('Habib Street, Banigala'),
                  ),
                  Divider(),
                ],
              ),
            ),
          );
        });
  }
}
