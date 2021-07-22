import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/bookmarkservice.dart';
import 'package:potbelly/services/cartservice.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/data.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/card_tags.dart';
import 'package:potbelly/widgets/dark_overlay.dart';
import 'package:potbelly/widgets/heading_row.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:potbelly/widgets/ratings_widget.dart';
import 'package:potbelly/widgets/spaces.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HotSpotDetailsScreen extends StatefulWidget {
  final RestaurantDetails restaurantDetails;

  HotSpotDetailsScreen({@required this.restaurantDetails});

  @override
  _HotSpotDetailsScreenState createState() => _HotSpotDetailsScreenState();
}

class _HotSpotDetailsScreenState extends State<HotSpotDetailsScreen> {
  bool bookmark = false;

  TextStyle addressTextStyle = Styles.customNormalTextStyle(
    color: Colors.black54,
    fontSize: Sizes.TEXT_SIZE_12,
  );

  TextStyle openingTimeTextStyle = Styles.customNormalTextStyle(
    color: Colors.red,
    fontSize: Sizes.TEXT_SIZE_14,
  );

  TextStyle subHeadingTextStyle = Styles.customTitleTextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w600,
    fontSize: Sizes.TEXT_SIZE_16,
  );

  BoxDecoration fullDecorations = Decorations.customHalfCurvedButtonDecoration(
    color: Colors.black.withOpacity(0.1),
    topleftRadius: 24,
    bottomleftRadius: 24,
    topRightRadius: 24,
    bottomRightRadius: 24,
  );

  BoxDecoration leftSideDecorations =
      Decorations.customHalfCurvedButtonDecoration(
    color: Colors.black.withOpacity(0.1),
    topleftRadius: 24,
    bottomleftRadius: 24,
  );

  BoxDecoration rightSideDecorations =
      Decorations.customHalfCurvedButtonDecoration(
    color: Colors.black.withOpacity(0.1),
    topRightRadius: 24,
    bottomRightRadius: 24,
  );

  @override
  void initState() {
    // checkbookmark();
    for (var item in fooditems) {
      item['restaurantId'] = widget.restaurantDetails.data['id'].toString();
      print(item);
    }
    getrest();
    super.initState();
  }

  checkbookmark() async {
    bookmark =
        await BookmarkService().checkbookmark(widget.restaurantDetails.data);
    print(bookmark);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
//    final RestaurantDetails args = ModalRoute.of(context).settings.arguments;
    var heightOfStack = MediaQuery.of(context).size.height / 2.8;
    var aPieceOfTheHeightOfStack = heightOfStack - heightOfStack / 3.5;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Positioned(
                          child: widget.restaurantDetails.imagePath
                                      .substring(0, 4) ==
                                  'http'
                              ? Image.network(
                                  widget.restaurantDetails.imagePath,
                                  width: MediaQuery.of(context).size.width,
                                  height: heightOfStack,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  widget.restaurantDetails.imagePath,
                                  width: MediaQuery.of(context).size.width,
                                  height: heightOfStack,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        DarkOverLay(
                            gradient: Gradients.restaurantDetailsGradient),
                        Positioned(
                            right: 5,
                            bottom: 5,
                            child: Container(
                              width: 120,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(100)),
                              child: Text('15 - 20\nMins',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(
                                    textStyle: Styles.customNormalTextStyle(
                                        color: AppColors.white,
                                        fontSize: Sizes.TEXT_SIZE_14,
                                        fontWeight: FontWeight.bold),
                                  )),
                            )),
                        Positioned(
                          child: Container(
                            padding: EdgeInsets.only(
                              right: Sizes.MARGIN_16,
                              top: Sizes.MARGIN_16,
                            ),
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: Sizes.MARGIN_16,
                                      right: Sizes.MARGIN_16,
                                    ),
                                    child: Image.asset(ImagePath.arrowBackIcon),
                                  ),
                                ),
                                Spacer(flex: 1),
                                InkWell(
                                  child: Icon(
                                    FeatherIcons.share2,
                                    color: AppColors.white,
                                  ),
                                ),
                                // SpaceW20(),
                                // InkWell(
                                //   onTap: () {
                                //     BookmarkService()
                                //         .addbookmark(context,
                                //             widget.restaurantDetails.data)
                                //         .then((value) {
                                //       print(value);
                                //       if (value == 'success') {
                                //         bookmark = !bookmark;
                                //         setState(() {});
                                //       }
                                //     });
                                //   },
                                //   child: Image.asset(
                                //       bookmark
                                //           ? ImagePath.activeBookmarksIcon3
                                //           : ImagePath.bookmarksIcon,
                                //       color: bookmark
                                //           ? AppColors.secondaryElement
                                //           : Colors.white),
                                // ),
                              ],
                            ),
                          ),
                        ),
//                         Positioned(
//                           top: aPieceOfTheHeightOfStack,
//                           left: 24,
//                           right: 24 - 0.5,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(24.0),
//                             child: BackdropFilter(
//                               filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(vertical: 4.0),
//                                 decoration: fullDecorations,
//                                 child: Row(
//                                   children: <Widget>[
//                                     Container(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 8.0, vertical: 8.0),
//                                       width:
//                                           (MediaQuery.of(context).size.width /
//                                                   2) -
//                                               24,
// //                                      decoration: leftSideDecorations,
//                                       child: Row(
//                                         children: <Widget>[
//                                           SizedBox(width: 4.0),
//                                           Image.asset(ImagePath.callIcon),
//                                           SizedBox(width: 8.0),
//                                           Text(
//                                             widget.restaurantDetails
//                                                 .data['phone'],
//                                             style: Styles.normalTextStyle,
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     IntrinsicHeight(
//                                       child: VerticalDivider(
//                                         width: 0.5,
//                                         thickness: 3.0,
//                                         color: Colors.red,
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 8.0, vertical: 8.0),
// //                                      width:
// //                                      (MediaQuery
// //                                          .of(context)
// //                                          .size
// //                                          .width /
// //                                          2) -
// //                                          24,
// //                                      decoration: rightSideDecorations,
//                                       child: Row(
//                                         children: <Widget>[
//                                           SizedBox(width: 4.0),
//                                           Image.asset(ImagePath.directionIcon,color: AppColors.secondaryElement,),
//                                           SizedBox(width: 8.0),
//                                           Text(
//                                             'Direction',
//                                             style: Styles.normalTextStyle,
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Row(
                              //   children: <Widget>[
                              //     Text(
                              //       widget.restaurantDetails.restaurantName,
                              //       textAlign: TextAlign.left,
                              //       style: Styles.customTitleTextStyle(
                              //         color: Colors.black87,
                              //         fontWeight: FontWeight.w600,
                              //         fontSize: Sizes.TEXT_SIZE_20,
                              //       ),
                              //     ),
                              //     SizedBox(width: 4.0),
                              //     // CardTags(
                              //     //   title: widget.restaurantDetails.category,
                              //     //   decoration: BoxDecoration(
                              //     //     gradient: Gradients.secondaryGradient,
                              //     //     boxShadow: [
                              //     //       Shadows.secondaryShadow,
                              //     //     ],
                              //     //     borderRadius: BorderRadius.all(
                              //     //         Radius.circular(8.0)),
                              //     //   ),
                              //     // ),
                              //     SizedBox(width: 4.0),
                              //     Container(
                              //       child: Opacity(
                              //         opacity: 0.8,
                              //         child: Container(
                              //           width: 45,
                              //           height: 14,
                              //           padding: EdgeInsets.only(top:1),
                              //           decoration: BoxDecoration(
                              //             // color: Color.fromARGB(255, 132, 141, 255),
                              //             color: AppColors.secondaryElement,
                              //             borderRadius: BorderRadius.all(
                              //                 Radius.circular(8.0)),
                              //           ),
                              //           child: Center(
                              //             child: Text(
                              //               widget.restaurantDetails.distance,
                              //               textAlign: TextAlign.center,
                              //               style: Styles.customNormalTextStyle(
                              //                 fontSize: Sizes.TEXT_SIZE_10,
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),

                              //     Spacer(flex: 1),
                              //     Ratings(widget.restaurantDetails.rating)
                              //   ],
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        widget.restaurantDetails
                                                .restaurantName +
                                            '- Rose, Farrington',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.dmSerifDisplay(
                                          textStyle:
                                              Styles.customTitleTextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.normal,
                                            fontSize: Sizes.TEXT_SIZE_22,
                                          ),
                                        )),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                            child: Text(
                                                widget.restaurantDetails
                                                        .rating +
                                                    ' Very good',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.openSans(
                                                  textStyle: Styles
                                                      .customNormalTextStyle(
                                                    color: AppColors
                                                        .secondaryElement,
                                                    fontSize:
                                                        Sizes.TEXT_SIZE_14,
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            // width: MediaQuery.of(context).size.width*0.5,
                                            // color: Colors.red,
                                            child: Text(
                                                widget.restaurantDetails
                                                        .restaurantAddress +
                                                    ' (500+)',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.openSans(
                                                  textStyle: Styles
                                                      .customNormalTextStyle(
                                                    color: Colors.black54,
                                                    fontSize:
                                                        Sizes.TEXT_SIZE_14,
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            // width: MediaQuery.of(context).size.width*0.5,
                                            // color: Colors.red,
                                            child: Text(
                                                widget.restaurantDetails
                                                        .distance +
                                                    ' - \$' +
                                                    '0.22' +
                                                    ' Delivery',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.openSans(
                                                  textStyle: Styles
                                                      .customNormalTextStyle(
                                                    color: Colors.black54,
                                                    fontSize:
                                                        Sizes.TEXT_SIZE_14,
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                color: AppColors.secondaryColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: Sizes.MARGIN_12,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.info_outline,
                                      color: AppColors.black.withOpacity(0.6),
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "HotSpot Info",
                                      style: Theme.of(context)
                                          .textTheme
                                          .title
                                          .copyWith(
                                            fontSize: Sizes.TEXT_SIZE_16,
                                            // fontWeight: FontWeight.bold,
                                            color: AppColors.black
                                                .withOpacity(0.6),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'The Baan Thai restaurant in Fort Wayne, Indiana makes great use of high-resolution pictures to draw in website visitors. Color abounds wherever you look and the vivid representations of the Thai region make you feel like you’re already there. Don’t settle for washed-out, blurry photos on your website. If need be, hire a professional photographer or purchase high-resolution photos online to give your website the extra kick it needs.',
                                textAlign: TextAlign.justify,
                                style: addressTextStyle,
                              ),
                              // SizedBox(height: 16.0),
                              // Text(
                              //   widget.restaurantDetails.restaurantAddress,
                              //   style: addressTextStyle,
                              // ),
                              // SizedBox(height: 8.0),
                              // RichText(
                              //   text: TextSpan(
                              //     style: openingTimeTextStyle,
                              //     children: [
                              //       TextSpan(text: "Open Now "),
                              //       TextSpan(
                              //           text: "daily time ",
                              //           style: addressTextStyle),
                              //       TextSpan(
                              //           text: widget.restaurantDetails
                              //                   .data['open_time'] +
                              //               " am to " +
                              //               widget.restaurantDetails
                              //                   .data['close_time'] +
                              //               " am "),
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                          // SpaceH24(),
                          // HeadingRow(
                          //   title: StringConst.MENU_AND_PHOTOS,
                          //   number: StringConst.SEE_ALL_32,
                          //   onTapOfNumber: () => Navigator.pushNamed(context,
                          //       AppRouter.menuPhotosScreen,
                          //       arguments:
                          //           widget.restaurantDetails.data['menu']),
                          // ),
                          // SizedBox(height: 16.0),
                          // Container(
                          //   height: 120,
                          //   width: MediaQuery.of(context).size.width,
                          //   child: ListView.builder(
                          //     scrollDirection: Axis.horizontal,
                          //     itemCount:
                          //         widget.restaurantDetails.data['menu'].length,
                          //     itemBuilder: (context, index) {
                          //       return Container(
                          //         margin: EdgeInsets.only(right: 12.0),
                          //         decoration: BoxDecoration(
                          //             borderRadius:
                          //                 BorderRadius.all(Radius.circular(8))),
                          //         child: widget.restaurantDetails.imagePath
                          //                     .substring(0, 4) ==
                          //                 'http'
                          //             ? Image.network(
                          //                 widget.restaurantDetails.data['menu']
                          //                     [index],
                          //                 fit: BoxFit.fill,
                          //                 loadingBuilder: (BuildContext ctx,
                          //                     Widget child,
                          //                     ImageChunkEvent loadingProgress) {
                          //                   if (loadingProgress == null) {
                          //                     return child;
                          //                   } else {
                          //                     return Container(
                          //                       // height: ,
                          //                       width: 160,
                          //                       child: Center(
                          //                         child:
                          //                             CircularProgressIndicator(
                          //                           valueColor:
                          //                               AlwaysStoppedAnimation<
                          //                                       Color>(
                          //                                   AppColors
                          //                                       .secondaryElement),
                          //                         ),
                          //                       ),
                          //                     );
                          //                   }
                          //                 },
                          //                 width: 160,
                          //               )
                          //             : Image.asset(
                          //                 menuPhotosImagePaths[index],
                          //                 fit: BoxFit.fill,
                          //                 width: 160,
                          //               ),
                          //       );
                          //     },
                          //   ),
                          // ),
                          // SpaceH24(),
                          // HeadingRow(
                          //   title: StringConst.REVIEWS_AND_RATINGS,
                          //   number: StringConst.SEE_ALL_32,
                          //   onTapOfNumber: () => AppRouter.navigator
                          //       .pushNamed(AppRouter.reviewRatingScreen),
                          // ),
                          SpaceH24(),
                          HeadingRow(
                            title: 'Resturants'.toUpperCase(),
                            number: '',
                          ),
                          SizedBox(height: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: itemsListTiles(context),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // PotbellyButton(
              //   'Rate Your Experience ',
              //   onTap: () => AppRouter.navigator.pushNamed(
              //       AppRouter.addRatingsScreen,
              //       arguments: restaurantDetails.data['id']),
              //   buttonHeight: 65,
              //   buttonWidth: MediaQuery.of(context).size.width,
              //   decoration: Decorations.customHalfCurvedButtonDecoration(
              //     topleftRadius: Sizes.RADIUS_24,
              //     topRightRadius: Sizes.RADIUS_24,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> createUserListTiles({@required numberOfUsers}) {
    List<Widget> userListTiles = [];
    List<String> imagePaths = [
      ImagePath.profile1,
      ImagePath.profile4,
      ImagePath.profile3,
      ImagePath.profile4,
      ImagePath.profile1,
    ];
    List<String> userNames = [
      "Collin Fields",
      "Sherita Burns",
      "Bill Sacks",
      "Romeo Folie",
      "Pauline Cobbina",
    ];
    List<String> description = [
      "Lorem Ipsum baga fada",
      "Lorem Ipsum baga fada",
      "Lorem Ipsum baga fada",
      "Lorem Ipsum baga fada",
      "Lorem Ipsum baga fada",
    ];
    List<String> ratings = [
      "4.0",
      "3.0",
      "5.0",
      "2.0",
      "4.0",
    ];

    List<int> list = List<int>.generate(numberOfUsers, (i) => i + 1);

    list.forEach((i) {
      userListTiles.add(ListTile(
        leading: Image.asset(imagePaths[i - 1]),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              userNames[i - 1],
              style: subHeadingTextStyle,
            ),
            Ratings(ratings[i - 1]),
          ],
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        subtitle: Text(
          description[i - 1],
          style: addressTextStyle,
        ),
      ));
    });
    return userListTiles;
  }

  List fooditems = [
    {
      'name': 'Rose, Farrington',
      'image':
          'https://www.thespruceeats.com/thmb/oY67Fvga3ptpwQvOjpZNE87u6mo=/3429x2572/smart/filters:no_upscale()/juicy-baked-turkey-burgers-with-garlic-3057268-hero-01-ceea8ae8e9914a0788b9acd14e821eb3.jpg',
      'details':
          'The Baan Thai restaurant in Fort Wayne, Indiana makes great use of high-resolution pictures to draw in website visitors.',
      'price': '20',
      'qty': '1',
      'id': '1',
    },
    {
      'name': 'The Italian Club',
      'image':
          'https://www.abeautifulplate.com/wp-content/uploads/2015/08/the-best-homemade-margherita-pizza-1-4-480x480.jpg',
      'details':
          'The Baan Thai restaurant in Fort Wayne, Indiana makes great use of high-resolution pictures to draw in website visitors.',
      'price': '24',
      'qty': '1',
      'id': '2',
    },
    {
      'name': 'Love Kimchi',
      'image':
          'https://www.wellplated.com/wp-content/uploads/2019/07/Stuffed-Portobello-Mushroom-Burger.jpg',
      'details':
          'The Baan Thai restaurant in Fort Wayne, Indiana makes great use of high-resolution pictures to draw in website visitors.',
      'price': '14',
      'qty': '1',
      'id': '4',
    },
  ];

  void getrest() async {
    fooditems.clear();
    var data = await Service().getRestaurentsData();
    print('this is a data');
    print(data.data);
    data.data.forEach((element) {
      fooditems.add({
        'name': element.restName,
        // 'image': element.restImage,
        // 'image': 'assets/demo_card/Budapest/Budapest-Front.png',
        'image': 'https://www.abeautifulplate.com/wp-content/uploads/2015/08/the-best-homemade-margherita-pizza-1-4-480x480.jpg',
        'details':
            'The Baan Thai restaurant in Fort Wayne, Indiana makes great use of high-resolution pictures to draw in website visitors.',
        'price': '',
        'qty': '1',
        // 'id': element.id,
        'restaurantId': element.id,
        'restaurantdata': element
      });
    });
    setState(() {
      
    });
  }

  List<Widget> itemsListTiles(context) {
    return List.generate(
      fooditems.length,
      (i) =>
          // Slidable(
          //       actionPane: SlidableDrawerActionPane(),
          //       actionExtentRatio: 0.25,
          //       secondaryActions: <Widget>[
          //         ClipRRect(
          //           borderRadius: BorderRadius.circular(10),
          //           // color: Colors.red,
          //           child: Container(
          //             color: Colors.grey[350],
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: <Widget>[
          //                 InkWell(
          //                   onTap: () {
          //                     if (int.parse(fooditems[i]['qty']) > 1) {
          //                       fooditems[i]['qty'] =
          //                           (int.parse(fooditems[i]['qty']) - 1)
          //                               .toString();
          //                       setState(() {});
          //                       // totalprice();
          //                       if (int.parse(fooditems[i]['qty']) == 1) {
          //                         // disabled = false;
          //                         setState(() {});
          //                       }
          //                       setState(() {});
          //                     }
          //                     // Provider.of<CartProvider>(context, listen: false)
          //                     //     .removeToCart(cartlist[i]);
          //                   },
          //                   child: Container(
          //                       alignment: Alignment.center,
          //                       padding: EdgeInsets.zero,
          //                       width: 40,
          //                       child: Text(
          //                         "-",
          //                         style: TextStyle(
          //                             color: AppColors.secondaryElement,
          //                             fontSize: 50),
          //                       )),
          //                 ),
          //                 Text(
          //                   fooditems[i]['qty'],
          //                   style: TextStyle(fontSize: 18),
          //                 ),
          //                 InkWell(
          //                   onTap: () {
          //                     print('here');
          //                     fooditems[i]['qty'] =
          //                         (int.parse(fooditems[i]['qty']) + 1).toString();
          //                     print(fooditems[i]['qty']);
          //                     setState(() {});

          //                     // Provider.of<CartProvider>(context, listen: false)
          //                     //     .addToCart(context, data);
          //                   },
          //                   child: Container(
          //                       alignment: Alignment.center,
          //                       padding: EdgeInsets.only(top: 2),
          //                       width: 40,
          //                       child: Text(
          //                         "+",
          //                         style: TextStyle(
          //                             color: AppColors.secondaryElement,
          //                             fontSize: 32),
          //                       )),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         Container(
          //           // color: Colors.red,
          //           margin: EdgeInsets.only(left: 5),
          //           child: ClipRRect(
          //             borderRadius: BorderRadius.circular(10),
          //             child: IconSlideAction(
          //               // caption: '+Cart',
          //               color: AppColors.secondaryElement,
          //               foregroundColor: AppColors.white,
          //               icon: Icons.add_shopping_cart,
          //               onTap: () {
          //                 if (int.parse(fooditems[i]['qty']) >= 1) {
          //                   // disabled = true;
          //                 }
          //                 setState(() {});
          //                 Map<String, dynamic> data = {
          //                   'id': fooditems[i]['id'],
          //                   'restaurantId': fooditems[i]['restaurantId'],
          //                   'image': fooditems[i]['image'],
          //                   'details': fooditems[i]['details'],
          //                   'name': fooditems[i]['name'],
          //                   'price': fooditems[i]['price'],
          //                   'payableAmount': fooditems[i]['price'],
          //                   'qty': fooditems[i]['qty'],
          //                   'data': fooditems[i],
          //                   'restaurantdata': widget.restaurantDetails.data
          //                 };
          //                 CartProvider().addToCart(context, data);
          //               },
          //             ),
          //           ),
          //         ),
          //       ],
          // child:
          InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRouter.restaurantDetailsScreen,
            arguments: RestaurantDetails(
                // imagePath: fooditems[i]['restaurantdata']['rest_image'],
                // restaurantName: fooditems[i]['restaurantdata']['rest_name'],
                // restaurantAddress: fooditems[i]['restaurantdata']['rest_address'] +
                //     fooditems[i]['restaurantdata']['rest_city'] +
                //     ' ' +
                //     fooditems[i]['restaurantdata']['rest_country'],
                // rating: '0.0',
                // category: fooditems[i]['restaurantdata']['rest_type'],
                // distance: '0 Km',
                // data: fooditems[i]['restaurantdata']
                imagePath: fooditems[i]['restaurantdata'].restImage,
                                      restaurantName: fooditems[i]['restaurantdata'].restName,
                                      restaurantAddress: fooditems[i]['restaurantdata'].restAddress +
                                          fooditems[i]['restaurantdata'].restCity +
                                          ' ' +
                                          fooditems[i]['restaurantdata'].restCountry,
                                      rating: '0.0',
                                      category: fooditems[i]['restaurantdata'].restType,
                                      distance: '0 Km',
                                      data: fooditems[i]['restaurantdata']
            )
          );
        },
        child: ListTile(
          leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                fooditems[i]['image'],
                loadingBuilder: (BuildContext ctx, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Container(
                      // height: ,
                      width: 50,
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.secondaryElement),
                        ),
                      ),
                    );
                  }
                },
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              )),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                // color: Colors.red,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  fooditems[i]['name'],
                  style: subHeadingTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  // Text(
                  //   '\$' + fooditems[i]['price'],
                  //   style: subHeadingTextStyle,
                  // ),
                  //        Card(
                  //   elevation: 0.5,
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: Sizes.WIDTH_14, vertical: Sizes.HEIGHT_8),
                  //     child: Text(
                  //       'open'.toUpperCase(),
                  //       style: 'open'.toLowerCase() ==
                  //               StringConst.STATUS_OPEN.toLowerCase()
                  //           ? Styles.customNormalTextStyle(
                  //               color: AppColors.kFoodyBiteGreen,
                  //               fontSize: Sizes.TEXT_SIZE_10,
                  //               fontWeight: FontWeight.w700,
                  //             )
                  //           : Styles.customNormalTextStyle(
                  //               color: Colors.red,
                  //               fontSize: Sizes.TEXT_SIZE_10,
                  //               fontWeight: FontWeight.w700,
                  //             ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: 10,
                  ),
                  // Ratings(ratings[i]),
                ],
              ),
            ],
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          subtitle: Column(
            children: [
              Text(
                fooditems[i]['details'],
                style: addressTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
                          widget.restaurantDetails.distance +
                              ' - \$' +
                              '0.22' +
                              ' Delivery',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            textStyle: Styles.customNormalTextStyle(
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
      ),
      // )
    );
  }
}
