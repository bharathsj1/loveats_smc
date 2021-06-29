
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/models/promotions.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/DatabaseManager.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/values/data.dart';
import 'package:potbelly/widgets/category_card.dart';
import 'package:potbelly/widgets/foody_bite_card.dart';
import 'package:potbelly/widgets/heading_row.dart';
import 'package:potbelly/widgets/search_input_field.dart';
import 'package:video_player/video_player.dart';
import 'package:skeleton_text/skeleton_text.dart';

import 'google_map.dart';

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
  List records = [];

  @override
  void initState() {
    // initialize();
    // Localstorage().getlocal().then((value) {
    // Promotion().createDemoPromotions();
    // Restaurant().createDemoRestaurants('Restaurant 1');
    // Restaurant().createDemoRestaurants('Restaurant 2');
    // Localstorage().setlocal();
    // });
    // setpromos();
    // getpromos();
    getlocalpromos();
    super.initState();
  }

  // setpromos() async {
  //   Promotion().uploadvideopromotion(await rootBundle.load('assets/p1.mp4'), 'Promotion 1');
  //   Promotion().uploadimagepromotion(await rootBundle.load('assets/p2.jpeg'), 'Promotion 2');
  //   Promotion().uploadvideopromotion(await rootBundle.load('assets/p5.mp4'), 'Promotion 3');
  //    Promotion().uploadimagepromotion(await rootBundle.load('assets/p3.jpeg'), 'Promotion 4');
  //   Promotion().uploadimagepromotion(await rootBundle.load('assets/p4.jpeg'), 'Promotion 5');

  // }

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
    AppRouter.navigator
        .pushNamed(
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
            horizontal: Sizes.MARGIN_16,
            vertical: Sizes.MARGIN_8,
          ),
          child: ListView(
            children: [
              InkWell(
                onTap: () => bottomSheetForLocation(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Icon(Icons.location_on,
                          size: Sizes.HEIGHT_22, color: AppColors.indigo),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: 5,
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Colors.black38,
                        width: 1.0,
                      ))),
                      child: Text(
                        "Preston",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: Sizes.MARGIN_14,
              ),
              FoodyBiteSearchInputField(ImagePath.searchIcon,
                  controller: searchcontroller,
                  textFormFieldStyle:
                      Styles.customNormalTextStyle(color: AppColors.accentText),
                  hintText: StringConst.HINT_TEXT_HOME_SEARCH_BAR,
                  hintTextStyle:
                      Styles.customNormalTextStyle(color: AppColors.accentText),
                  suffixIconImagePath: ImagePath.settingsIcon,
                  borderWidth: 0.0, onTapOfLeadingIcon: () {
                pausevideo();
                FocusScope.of(context).unfocus();
                AppRouter.navigator
                    .pushNamed(
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
                AppRouter.navigator
                    .pushNamed(AppRouter.filterScreen)
                    .then((value) => resumevideo());
              }, borderStyle: BorderStyle.solid),
              SizedBox(height: 16.0),
              HeadingRow(
                  title: StringConst.TRENDING_RESTAURANTS,
                  number: StringConst.SEE_ALL_45,
                  onTapOfNumber: () {
                    pausevideo();
                    AppRouter.navigator
                        .pushNamed(AppRouter.trendingRestaurantsScreen)
                        .then((value) {
                      resumevideo();
                    });
                  }),
              SizedBox(height: 16.0),
              StreamBuilder(
                  stream:
                      Firestore.instance.collection('Restaurants').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.secondaryElement,
                          ),
                        ),
                      );
                    } else {
                      List<DocumentSnapshot> items = snapshot.data.documents;
                      records.clear();
                      items.forEach((e) {
                        records.add(e.data);
                        // print(e.data());
                      });

                      return Container(
                        height: 280,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: records.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(right: 4.0),
                                child: FoodyBiteCard(
                                  onTap: () {
                                    if (_controller != null) {
                                      _controller.pause();
                                    }
                                    AppRouter.navigator
                                        .pushNamed(
                                      AppRouter.restaurantDetailsScreen,
                                      arguments: RestaurantDetails(
                                          imagePath: records[index]['image'],
                                          restaurantName: records[index]
                                              ['name'],
                                          restaurantAddress: records[index]
                                                  ['address'] +
                                              ' ' +
                                              records[index]['city'] +
                                              ' ' +
                                              records[index]['country'],
                                          rating: records[index]['ratings'],
                                          category: records[index]['type'],
                                          distance: records[index]['distance'],
                                          data: records[index]),
                                    )
                                        .then((value) {
                                      if (_controller != null) {
                                        _controller.play();
                                      }
                                    });
                                  },
                                  imagePath: records[index]['image'],
                                  status:
                                      records[index]['open'] ? "OPEN" : "CLOSE",
                                  cardTitle: records[index]['name'],
                                  rating: records[index]['ratings'],
                                  category: records[index]['type'],
                                  distance: records[index]['distance'],
                                  address: records[index]['address'] +
                                      ' ' +
                                      records[index]['city'] +
                                      ' ' +
                                      records[index]['country'],
                                ),
                              );
                            }),
                      );
                    }
                  }),
              // promolist.length == 0 ? Container() : SizedBox(height: 16.0),
              // promolist.length == 0
              //     ? Container()
              //     : HeadingRow(
              //         title: StringConst.PROMOTIONS,
              //         number: StringConst.SEE_ALL_45,
              //         onTapOfNumber: () => AppRouter.navigator
              //             .pushNamed(AppRouter.trendingRestaurantsScreen),
              //       ),
              promolist.length == 0 ? Container() : SizedBox(height: 16.0),
              promolist.length == 0
                  ? Container()
                  : loader
                      ? Container(
                          height: 190,
                          child: CarouselSlider(
                              options: CarouselOptions(
                                enableInfiniteScroll: true,
                              ),
                              items: List.generate(
                                3,
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
                          height: 190,
                          width: 50,
                          child: CarouselSlider(
                              options: CarouselOptions(
                                enableInfiniteScroll: true,
                                onPageChanged: (ind, reason) {
                                  print(ind);
                                  active_video = ind;
                                  if (_controller != null) {
                                    _controller.pause();
                                  }
                                  setState(() {});
                                  print(promolist[ind]);
                                  if (promolist[ind]['videoUrl'] != '') {
                                    print('here');
                                    print('here');
                                    initialize(promolist[ind]['videoUrl']);
                                  }
                                },
                              ),
                              items: List.generate(
                                  this.promolist.length,
                                  (ind) => _controller == null
                                      ? Container()
                                      : SizedBox(
                                          height: 230,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.2,
                                          child: Container(
                                            color: Colors.black,
                                            margin: EdgeInsets.only(right: 8.0),
                                            child: FittedBox(
                                              child: active_video == ind &&
                                                      (promolist[ind]
                                                              ['videoUrl'] !=
                                                          '')
                                                  ? SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child: _controller == null
                                                          ? Container()
                                                          : InkWell(
                                                              onTap: () {
                                                                navigatortopromotion(
                                                                    ind);
                                                              },
                                                              child: VideoPlayer(
                                                                  _controller),
                                                            ))
                                                  : promolist[ind]['image'] !=
                                                              null &&
                                                          promolist[ind]
                                                                  ['image'] !=
                                                              ''
                                                      ? promolist[ind]['image']
                                                                  .substring(
                                                                      0, 4) ==
                                                              'http'
                                                          ? InkWell(
                                                              onTap: () {
                                                                navigatortopromotion(
                                                                    ind);
                                                              },
                                                              child:
                                                                  Image.network(
                                                                promolist[ind]
                                                                    ['image'],
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                navigatortopromotion(
                                                                    ind);
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                promolist[ind]
                                                                    ['image'],
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            )
                                                      : active_video != ind &&
                                                              (promolist[ind][
                                                                          'videoUrl'] !=
                                                                      '' ||
                                                                  promolist[ind]
                                                                          ['videoUrl'] !=
                                                                      null)
                                                          ? InkWell(
                                                              onTap: () {
                                                                navigatortopromotion(
                                                                    ind);
                                                              },
                                                              child: Stack(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            5,
                                                                            3,
                                                                            5,
                                                                            3),
                                                                    child: promolist[ind]['thumbnailUrl'].substring(0,
                                                                                4) ==
                                                                            'http'
                                                                        ? Image
                                                                            .network(
                                                                            promolist[ind]['thumbnailUrl'],
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            height:
                                                                                230,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )
                                                                        : Image
                                                                            .asset(
                                                                            promolist[ind]['thumbnailUrl'],
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            height:
                                                                                230,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                  ),
                                                                  Positioned(
                                                                      right: 0,
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                6),
                                                                        width:
                                                                            90,
                                                                        height:
                                                                            25,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.black38,
                                                                            borderRadius: BorderRadius.circular(100)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              'Play',
                                                                              style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 2,
                                                                            ),
                                                                            Icon(
                                                                              Icons.play_arrow_outlined,
                                                                              size: 22,
                                                                              color: AppColors.white,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                            )
                                                          : Container(),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ))),
                        ),
              SizedBox(height: 16.0),
              HeadingRow(
                title: StringConst.CATEGORY,
                number: StringConst.SEE_ALL_9,
                onTapOfNumber: () =>
                    AppRouter.navigator.pushNamed(AppRouter.categoriesScreen),
              ),
              SizedBox(height: 16.0),
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryImagePaths.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: 8.0),
                      child: FoodyBiteCategoryCard(
                        imagePath: categoryImagePaths[index],
                        gradient: gradients[index],
                        category: category[index],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.0),
              HeadingRow(
                title: StringConst.FRIENDS,
                number: StringConst.SEE_ALL_56,
                onTapOfNumber: () => AppRouter.navigator.pushNamed(
                  AppRouter.findFriendsScreen,
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: createUserProfilePhotos(numberOfProfilePhotos: 6),
              ),
              SizedBox(height: 16.0),
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
      profilePhotos
          .add(CircleAvatar(backgroundImage: AssetImage(imagePaths[i - 1])));
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
                  onTap: ()=>AppRouter.navigator.pushNamed(AppRouter.googleMap),
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
