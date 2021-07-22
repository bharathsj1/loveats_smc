import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:potbelly/3D_card_widets/city_scenery.dart';
import 'package:potbelly/models/restaurent_menu_model.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/bookmarkservice.dart';
import 'package:potbelly/services/cartservice.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/swipe_particles/components/sprite_sheet.dart';
import 'package:potbelly/swipe_particles/demo_data.dart';
import 'package:potbelly/swipe_particles/list_model.dart';
import 'package:potbelly/swipe_particles/particle_field.dart';
import 'package:potbelly/swipe_particles/particle_field_painter.dart';
import 'package:potbelly/swipe_particles/removed_swipe_item.dart';
import 'package:potbelly/swipe_particles/swipe_item.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/card_tags.dart';
import 'package:potbelly/widgets/dark_overlay.dart';
import 'package:potbelly/widgets/heading_row.dart';
import 'package:potbelly/widgets/ratings_widget.dart';
import 'package:potbelly/widgets/spaces.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/scheduler.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final RestaurantDetails restaurantDetails;

  RestaurantDetailsScreen({@required this.restaurantDetails});

  @override
  _RestaurantDetailsScreenState createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool bookmark = false;
  bool _isLoading = true;
  RestaurentMenuModel _restaurentMenuModel;
  var controller = ScrollController();
  double prevOffset = 0.0;
  double nearLength = 80;
  double farLength = 120;
  double prodcutFontSize = 20.0;
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ListModel _model;
  SpriteSheet _spriteSheet;
  ParticleField _particleField;
  List data = DemoData().getData();
  Ticker _ticker;

  TextStyle addressTextStyle = Styles.customNormalTextStyle(
    color: AppColors.grey,
    fontSize: Sizes.TEXT_SIZE_12,
  );

  TextStyle subHeadingTextStyle = Styles.customTitleTextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w600,
    fontSize: Sizes.TEXT_SIZE_16,
  );

  TextStyle openingTimeTextStyle = Styles.customNormalTextStyle(
    color: Colors.red,
    fontSize: Sizes.TEXT_SIZE_14,
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
    controller.addListener(() {
      // print(controller.offset);
      var currentOffset = controller.offset;
      var mse = controller.position.maxScrollExtent;
      var fsof = (currentOffset / mse) * 100;
      var fivePer = (10 / 100) * fsof;
      var marginPer = (30 / 100) * fsof;
      if (currentOffset > prevOffset) {
        setState(() {
          prodcutFontSize = 20 + fivePer;
          productContainerMarginTop = 0 + marginPer;
        });
      } else {
        setState(() {
          prodcutFontSize = 30 - (10 - fivePer);
          productContainerMarginTop = 30 - (30 - marginPer);
        });
      }
      prevOffset = currentOffset;
      // print(fsof);
      // print(prodcutFontSize);
      // print(mse);

      // if (controller.offset >= controller.position.maxScrollExtent -20 &&
      //     !controller.position.outOfRange) {
      //   setState(() {
      //     prodcutFontSize = 22.0;
      //     productContainerMarginTop = 30.0;
      //   });
      // } else {
      //   setState(() {
      //     prodcutFontSize = 15.0;
      //     productContainerMarginTop = 0.0;
      //   });
      // }
    });
    // Create the "sparkle" sprite sheet for the particles:
    _spriteSheet = SpriteSheet(
      imageProvider: AssetImage("assets/swipe/circle_spritesheet.png"),
      length: 15, // number of frames in the sprite sheet.
      frameWidth: 10,
      frameHeight: 10,
    );

    // This synchronizes the data with the animated list:
    // _model = ListModel(
    //   initialItems: data,
    //   listKey:
    //       _listKey, // ListModel uses this to look up the list its acting on.
    //   removedItemBuilder: (dynamic removedItem, BuildContext context,
    //           Animation<double> animation) =>
    //       RemovedSwipeItem(animation: animation),
    // );

    _particleField = ParticleField();
    _ticker = createTicker(_particleField.tick)..start();

    checkbookmark();
    for (var item in fooditems) {
      item['restaurantId'] = widget.restaurantDetails.data.id.toString();
      print(item);
    }
    getProducts();
    super.initState();
  }

  checkbookmark() async {
    bookmark =
        await BookmarkService().checkbookmark(widget.restaurantDetails.data);
    print(bookmark);
    print('boosss');
    setState(() {});
  }

  Widget _buildHeroWidget(context) {
    return Hero(
      tag: widget.restaurantDetails.restaurantName,
      flightShuttleBuilder: _buildFlightWidget,
      child: Container(
        height: MediaQuery.of(context).size.height * .4,
        width: double.infinity,
        child: CityScenery(
          animationValue: 1,
          city: widget.restaurantDetails,
        ),
      ),
    );
  }

  Widget _buildFlightWidget(
      BuildContext flightContext,
      Animation<double> heroAnimation,
      HeroFlightDirection flightDirection,
      BuildContext fromHeroContext,
      BuildContext toHeroContext) {
    return AnimatedBuilder(
      animation: heroAnimation,
      builder: (context, child) {
        return DefaultTextStyle(
          style: DefaultTextStyle.of(toHeroContext).style,
          child: CityScenery(
            city: widget.restaurantDetails,
            animationValue: heroAnimation.value,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    final RestaurantDetails args = ModalRoute.of(context).settings.arguments;
    var heightOfStack = MediaQuery.of(context).size.height / 2.8;
    var aPieceOfTheHeightOfStack = heightOfStack - heightOfStack / 3.5;
    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(
            child: IgnorePointer(
          child: CustomPaint(
              painter: ParticleFieldPainter(
                  field: _particleField, spriteSheet: _spriteSheet)),
        )),
        NestedScrollView(
          controller: controller,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 0.0,
                expandedHeight: MediaQuery.of(context).size.height * 0.64,
                collapsedHeight: MediaQuery.of(context).size.height*0.5,

                floating: true,
                forceElevated: false,
                pinned: false,
                titleSpacing: 0,
                automaticallyImplyLeading: false,
                
                backgroundColor: Colors.white,
                // leading: BackButton(
                //   color: AppColors.white,
                // ),
                flexibleSpace: FlexibleSpaceBar(
                  // title: Text("Hello Baby"),
                  // centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                  background: Column(
                    // alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.64,
                        // color: Colors.blue,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                // shrinkWrap: true,
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Positioned(
                                          child:
                                              //  widget.restaurantDetails.imagePath
                                              //             .substring(0, 4) ==
                                              //         'http'
                                              //     ? Image.network(
                                              //         widget.restaurantDetails.imagePath,
                                              //         width: MediaQuery.of(context).size.width,
                                              //         height: heightOfStack,
                                              //         fit: BoxFit.cover,
                                              //       )
                                              //     : Image.asset(
                                              //         widget.restaurantDetails.imagePath,
                                              //         width: MediaQuery.of(context).size.width,
                                              //         height: heightOfStack,
                                              //         fit: BoxFit.cover,
                                              //       ),
                                              _buildHeroWidget(context)),
                                      DarkOverLay(
                                          gradient: Gradients
                                              .restaurantDetailsGradient),
                                      Positioned(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            right: Sizes.MARGIN_16,
                                            top: Sizes.MARGIN_40,
                                          ),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () =>
                                                    Navigator.pop(context),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: Sizes.MARGIN_16,
                                                    right: Sizes.MARGIN_16,
                                                  ),
                                                  child: Image.asset(
                                                      ImagePath.arrowBackIcon),
                                                ),
                                              ),
                                              Spacer(flex: 1),
                                              InkWell(
                                                child: Icon(
                                                  FeatherIcons.share2,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                              SpaceW20(),
                                              InkWell(
                                                onTap: () {
                                                  BookmarkService()
                                                      .addbookmark(
                                                          context,
                                                          widget
                                                              .restaurantDetails
                                                              .data)
                                                      .then((value) {
                                                    print(value);
                                                    if (value == 'success') {
                                                      bookmark = !bookmark;
                                                      setState(() {});
                                                    }
                                                  });
                                                },
                                                child: Image.asset(
                                                    bookmark
                                                        ? ImagePath
                                                            .activeBookmarksIcon3
                                                        : ImagePath
                                                            .bookmarksIcon,
                                                    color: bookmark
                                                        ? AppColors
                                                            .secondaryElement
                                                        : Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 10,
                                          right: 15,
                                          child: Container(
                                            height: 30,
                                            width: 120,
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.grid_view_rounded,
                                                  color: AppColors.white,
                                                  size: 16,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  'View Gallery',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppColors.white),
                                                )
                                              ],
                                            ),
                                          ))
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
//                                         children: [
//                                           SizedBox(width: 4.0),
//                                           Image.asset(ImagePath.callIcon),
//                                           SizedBox(width: 8.0),
//                                           Text(
//                                             widget.restaurantDetails.data
//                                                 .restPhone,
//                                             style: Styles.normalTextStyle,
//                                           ),
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
//                                       child: Row(
//                                         children: <Widget>[
//                                           SizedBox(width: 4.0),
//                                           Image.asset(
//                                             ImagePath.directionIcon,
//                                             color: AppColors.secondaryElement,
//                                           ),
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
                                        horizontal: 0.0, vertical: 16.0),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    widget.restaurantDetails
                                                        .restaurantName,
                                                    textAlign: TextAlign.left,
                                                    style: Styles
                                                        .customTitleTextStyle(
                                                      color:
                                                          AppColors.headingText,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          Sizes.TEXT_SIZE_20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.0),
                                                  CardTags(
                                                    title: widget
                                                        .restaurantDetails
                                                        .category,
                                                    decoration: BoxDecoration(
                                                      gradient: Gradients
                                                          .secondaryGradient,
                                                      boxShadow: [
                                                        Shadows.secondaryShadow,
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8.0)),
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.0),
                                                  CardTags(
                                                    title: widget
                                                        .restaurantDetails
                                                        .distance,
                                                    decoration: BoxDecoration(
                                                      // color: Color.fromARGB(255, 132, 141, 255),
                                                      color: AppColors
                                                          .secondaryElement,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8.0)),
                                                    ),
                                                  ),
                                                  Spacer(flex: 1),
                                                  Ratings(widget
                                                      .restaurantDetails.rating)
                                                ],
                                              ),
                                              SizedBox(height: 10.0),
                                              Text(
                                                widget.restaurantDetails
                                                    .restaurantAddress,
                                                style: addressTextStyle,
                                              ),
                                              SizedBox(height: 5.0),
                                              RichText(
                                                text: TextSpan(
                                                  style: openingTimeTextStyle,
                                                  children: [
                                                    TextSpan(
                                                        text: "Open Now - "),
                                                    // TextSpan(
                                                    //     text: "daily time ",
                                                    //     style:
                                                    //         addressTextStyle),
                                                    TextSpan(
                                                        text: widget
                                                                .restaurantDetails
                                                                .data
                                                                .restOpenTime +
                                                            "am - " +
                                                            widget
                                                                .restaurantDetails
                                                                .data
                                                                .restCloseTime +
                                                            "am ",
                                                        style:
                                                            addressTextStyle),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10.0),
                                              Text(
                                                'The Baan Thai restaurant in Fort Wayne, Indiana makes great use of high-resolution pictures to draw in website visitors. Color abounds wherever you look and the vivid representations of the Thai region make you feel like you’re already there. Don’t settle for washed-out, blurry photos on your website. If need be, hire a professional photographer or purchase high-resolution photos online to give your website the extra kick it needs.',
                                                textAlign: TextAlign.justify,
                                                style: addressTextStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        // SpaceH24(),
                                        // _isLoading
                                        //     ? Center(
                                        //         child:
                                        //             CircularProgressIndicator(
                                        //           valueColor:
                                        //               AlwaysStoppedAnimation<
                                        //                   Color>(
                                        //             AppColors
                                        //                 .secondaryElement,
                                        //           ),
                                        //         ),
                                        //       )
                                        //     : Padding(
                                        //         padding: EdgeInsets.symmetric(
                                        //             horizontal: 12.0),
                                        //         child: Column(
                                        //           children: [
                                        //             HeadingRow(
                                        //               title: StringConst
                                        //                   .MENU_AND_PHOTOS,
                                        //               number: 'See All (' +
                                        //                   _restaurentMenuModel
                                        //                       .data.length
                                        //                       .toString() +
                                        //                   ')',
                                        //               onTapOfNumber: () =>
                                        //                   Navigator.pushNamed(
                                        //                       context,
                                        //                       AppRouter
                                        //                           .menuPhotosScreen,
                                        //                       arguments:
                                        //                           _restaurentMenuModel
                                        //                               .data),
                                        //             ),
                                        //             SizedBox(height: 16.0),
                                        //             fooditems.length == 0
                                        //                 ? Center(
                                        //                     child: Text(
                                        //                         'Not Available'),
                                        //                   )
                                        //                 : Container(
                                        //                     height: 120,
                                        //                     width:
                                        //                         MediaQuery.of(
                                        //                                 context)
                                        //                             .size
                                        //                             .width,
                                        //                     child: ListView
                                        //                         .builder(
                                        //                       scrollDirection:
                                        //                           Axis.horizontal,
                                        //                       itemCount:
                                        //                           _restaurentMenuModel
                                        //                               .data
                                        //                               .length,
                                        //                       itemBuilder:
                                        //                           (context,
                                        //                               index) {
                                        //                         var data =
                                        //                             _restaurentMenuModel
                                        //                                     .data[
                                        //                                 index];
                                        //                         return Container(
                                        //                             margin: EdgeInsets.only(
                                        //                                 right:
                                        //                                     12.0),
                                        //                             decoration: BoxDecoration(
                                        //                                 borderRadius: BorderRadius.all(Radius.circular(
                                        //                                     8))),
                                        //                             child: Image
                                        //                                 .network(
                                        //                               data.menuImage,
                                        //                               fit: BoxFit
                                        //                                   .fill,
                                        //                               loadingBuilder: (BuildContext ctx,
                                        //                                   Widget
                                        //                                       child,
                                        //                                   ImageChunkEvent
                                        //                                       loadingProgress) {
                                        //                                 if (loadingProgress ==
                                        //                                     null) {
                                        //                                   return child;
                                        //                                 } else {
                                        //                                   return Container(
                                        //                                     // height: ,
                                        //                                     width: 160,
                                        //                                     child: Center(
                                        //                                       child: CircularProgressIndicator(
                                        //                                         valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
                                        //                                       ),
                                        //                                     ),
                                        //                                   );
                                        //                                 }
                                        //                               },
                                        //                               width:
                                        //                                   160,
                                        //                             ));
                                        //                       },
                                        //                     ),
                                        //                   ),
                                        //           ],
                                        //         ),
                                        //       )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
              child: Container(
                  // color: Colors.pink,
                  child: Stack(children: [
            // Positioned(
            //     top: 0,
            //     child: Container(
            //         margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            //         width: MediaQuery.of(context).size.width,
            //         child: Image.asset("Assets/images/divider1.png"))),
            AnimatedContainer(
                duration: Duration(microseconds: 100),
                padding:
                    EdgeInsets.only(top: productContainerMarginTop, bottom: 60),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   margin: EdgeInsets.only(top: 10, left: 10),
                      //   child: AnimatedDefaultTextStyle(
                      //     duration: Duration(milliseconds: 100),
                      //     child: Text("Products"),
                      //     style: TextStyle(
                      //         fontSize: prodcutFontSize,
                      //         color: Colors.black,
                      //         fontFamily: "Intro_Regular_Regular"),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Container(
                          child: DefaultTabController(
                              length: 8,
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
                                  isScrollable: true,
                                  indicator: UnderlineTabIndicator(
                                      borderSide: BorderSide(
                                          width: 1.8, color: AppColors.black),
                                      insets: EdgeInsets.symmetric(
                                          horizontal: 20.0)),
                                  // labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                  tabs: [
                                    Tab(
                                      text: "Starters",
                                    ),
                                    Tab(
                                      text: "Fast Food",
                                    ),
                                    Tab(
                                      text: "BBQ",
                                    ),
                                    Tab(
                                      text: "Korean",
                                    ),
                                    Tab(
                                      text: "Starters",
                                    ),
                                    Tab(
                                      text: "Fast Food",
                                    ),
                                    Tab(
                                      text: "BBQ",
                                    ),
                                    Tab(
                                      text: "Korean",
                                    ),
                                  ],
                                ),
                                SingleChildScrollView(
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.58,
                                      color: Colors.transparent,
                                      child: TabBarView(children: [
                                        _isLoading
                                            ? Container()
                                            : fooditems.length > 0
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    // width: MediaQuery.of(context).size.width,
                                                    // height: 500,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: _buildList(),
                                                    ))
                                                : Text(
                                                    'No Items Avaialble Right Now'),
                                        _isLoading
                                            ? Container()
                                            : fooditems.length > 0
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    // width: MediaQuery.of(context).size.width,
                                                    // height: 500,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: _buildList(),
                                                    ))
                                                : Text(
                                                    'No Items Avaialble Right Now'),
                                        _isLoading
                                            ? Container()
                                            : fooditems.length > 0
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    // width: MediaQuery.of(context).size.width,
                                                    // height: 500,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: _buildList(),
                                                    ))
                                                : Text(
                                                    'No Items Avaialble Right Now'),
                                        _isLoading
                                            ? Container()
                                            : fooditems.length > 0
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    // width: MediaQuery.of(context).size.width,
                                                    // height: 500,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: _buildList(),
                                                    ))
                                                : Text(
                                                    'No Items Avaialble Right Now'),
                                        Container(),
                                        Container(),
                                        Container(),
                                        Container(),
                                      ])),
                                )
                              ])))
                    ]))
          ]))),
        ),
      ],
    ));
  }

  double productContainerMarginTop = 0.0;

  Widget _buildList() {
    return AnimatedList(
      key: _listKey, // used by the ListModel to find this AnimatedList
      initialItemCount: fooditems.length,
      // shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index, _) {
        print(fooditems.length);
        print(index);
        var item = fooditems[0];
        return SwipeItem(
            data: item,
            // isEven: index.isEven,
            onSwipe: (key, {action}) {
              print('here');
              _performSwipeAction(index, item, key, action);
            });
      },
    );
  }

  void _performSwipeAction(index, data, GlobalKey key, SwipeAction action) {
    // Get item's render box, and use it to calculate the position for the particle effect:
    final RenderBox box = key.currentContext.findRenderObject();
    Offset position =
        box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
    double x = position.dx;
    double y = position.dy;
    double w = box.size.width;

    if (action == SwipeAction.remove) {
      // Delay the start of the effect a little bit, so the item is mostly closed before it begins.
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => _particleField.lineExplosion(x, y, w));

      // Remove the item (using the ItemModel to sync everything), and redraw the UI (to update count):
      setState(() {
        // _model.removeAt(_model.indexOf(data),
        // _model.removeAt(_model.indexOf(data),

        //     duration: Duration(milliseconds: 600));
        // this.data.remove(data);
        Map<String, dynamic> cartdata = {
          'id': data['id'],
          'restaurantId': data['restaurantId'],
          'image': data['image'],
          'details': data['details'],
          'name': data['name'],
          'price': data['price'],
          'payableAmount': data['price'].toString(),
          'qty': data['qty'],
          'data': data,
          'restaurantdata': widget.restaurantDetails.data
        };
        print(data['qty']);
        CartProvider().removeqtyCart(context, cartdata);
        print(fooditems[index]);
        if (fooditems[index]['cart'] != null &&
            fooditems[index]['cart'] == true) {
          var qtyy = int.parse(fooditems[index]['qty2']);
          qtyy--;
          fooditems[index]['qty2'] = qtyy.toString();
          if (int.parse(fooditems[index]['qty2']) == 0) {
            fooditems[index]['cart'] = false;
          }
        } else {
          // fooditems[index]['qty2']= fooditems[index]['qty'] ;
        }
      });
    }
    if (action == SwipeAction.favorite) {
      // Map<String, dynamic> cartdata = {
      //   'id': data['id'],
      //   'restaurantId': data['restaurantId'],
      //   'image': data['image'],
      //   'details': data['details'],
      //   'name': data['name'],
      //   'price': data['price'],
      //   'payableAmount': data['price'].toString(),
      //   'qty': data['qty'],
      //   'data': data,
      //   'restaurantdata': widget.restaurantDetails.data
      // };
      // print(data['qty']);
      // CartProvider().addToCart(context, cartdata);
      // if (fooditems[index]['cart'] != null &&
      //     fooditems[index]['cart'] == true) {
      //   var qtyy = int.parse(fooditems[index]['qty2']);
      //   qtyy++;
      //   fooditems[index]['qty2'] = qtyy.toString();
      // } else {
      //   fooditems[index]['qty2'] = fooditems[index]['qty'];
      // }

      // fooditems[index]['cart'] = true;
      // print(fooditems[index]);
      // setState(() {});
      bottomsheet(index, data);
      _particleField.pointExplosion(x + 60, y + 46, 100);
      // }
    }
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

  List fooditems = [];
  List toppings = [
    {'name': 'Anchovies', 'check': false},
    {'name': 'Basil', 'check': false},
    {'name': 'Black Olives', 'check': false},
    {'name': 'Extra Cheese', 'check': false},
    {'name': 'Garlic Butter', 'check': false},
    {'name': 'Green Papers', 'check': false},
    {'name': 'Jalapenos', 'check': false},
    {'name': 'Mushrooms', 'check': false},
    {'name': 'Spicy Beef', 'check': false},
  ];

  List drinks = [
    {'name': '7 Up 1.5ltr', 'check': false},
    {'name': 'Pepsi 1.5ltr', 'check': false},
    {'name': 'Tango Orange 1.5ltr', 'check': false},
  ];

  List<Widget> itemsListTiles(
    context,
  ) {
    return List.generate(
        fooditems.length,
        (i) => Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              secondaryActions: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  // color: Colors.red,
                  child: Container(
                    color: Colors.grey[350],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            if (int.parse(fooditems[i]['qty']) > 1) {
                              fooditems[i]['qty'] =
                                  (int.parse(fooditems[i]['qty']) - 1)
                                      .toString();
                              setState(() {});
                              // totalprice();
                              if (int.parse(fooditems[i]['qty']) == 1) {
                                // disabled = false;
                                setState(() {});
                              }
                              setState(() {});
                            }
                            // Provider.of<CartProvider>(context, listen: false)
                            //     .removeToCart(cartlist[i]);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.zero,
                              width: 40,
                              child: Text(
                                "-",
                                style: TextStyle(
                                    color: AppColors.secondaryElement,
                                    fontSize: 50),
                              )),
                        ),
                        Text(
                          fooditems[i]['qty'],
                          style: TextStyle(fontSize: 18),
                        ),
                        InkWell(
                          onTap: () {
                            print('here');
                            fooditems[i]['qty'] =
                                (int.parse(fooditems[i]['qty']) + 1).toString();
                            print(fooditems[i]['qty']);
                            setState(() {});

                            // Provider.of<CartProvider>(context, listen: false)
                            //     .addToCart(context, data);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 2),
                              width: 40,
                              child: Text(
                                "+",
                                style: TextStyle(
                                    color: AppColors.secondaryElement,
                                    fontSize: 32),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  // color: Colors.red,
                  margin: EdgeInsets.only(left: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: IconSlideAction(
                      // caption: '+Cart',
                      color: AppColors.secondaryElement,
                      foregroundColor: AppColors.white,
                      icon: Icons.add_shopping_cart,
                      onTap: () {
                        if (int.parse(fooditems[i]['qty']) >= 1) {
                          // disabled = true;
                        }
                        setState(() {});
                        Map<String, dynamic> data = {
                          'id': fooditems[i]['id'],
                          'restaurantId': fooditems[i]['restaurantId'],
                          'image': fooditems[i]['image'],
                          'details': fooditems[i]['details'],
                          'name': fooditems[i]['name'],
                          'price': fooditems[i]['price'],
                          'payableAmount': fooditems[i]['price'].toString(),
                          'qty': fooditems[i]['qty'],
                          'data': fooditems[i],
                          'restaurantdata': widget.restaurantDetails.data
                        };
                        print(fooditems[i]['qty']);
                        CartProvider().addToCart(context, data);
                      },
                    ),
                  ),
                ),
              ],
              child: ListTile(
                leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
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
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        fooditems[i]['name'],
                        style: subHeadingTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '\$' + fooditems[i]['price'].toString(),
                          style: subHeadingTextStyle,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        // Ratings(ratings[i]),
                      ],
                    ),
                  ],
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                subtitle: Text(
                  fooditems[i]['details'],
                  style: addressTextStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ));
  }

  bool mixmatch = false;
  bottomsheet(index, data) {
    var textTheme = Theme.of(context).textTheme;
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        // backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            // side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(0.0),
                topRight: const Radius.circular(0.0))),
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: ClipRRect(
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(0.0),
                        topRight: const Radius.circular(0.0)),
                    child: new Container(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 1.2,
                        color: Colors.white60,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 0.5, color: Colors.grey))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Icon(
                                          Icons.close,
                                          color: AppColors.secondaryElement,
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          'Customise Item',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'roboto'),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Map<String, dynamic> cartdata = {
                                                'id': data['id'],
                                                'restaurantId':
                                                    data['restaurantId'],
                                                'image': data['image'],
                                                'details': data['details'],
                                                'name': data['name'],
                                                'price': data['price'],
                                                'payableAmount':
                                                    data['price'].toString(),
                                                'qty': data['qty'],
                                                'data': data,
                                                'restaurantdata': widget
                                                    .restaurantDetails.data,
                                                'topping': toppings
                                                    .where((product) =>
                                                        product['check'] ==
                                                        true)
                                                    .toList(),
                                                'drink': drinks
                                                    .where((product) =>
                                                        product['check'] ==
                                                        true)
                                                    .toList()
                                              };
                                              print(data['qty']);
                                              CartProvider()
                                                  .addToCart(context, cartdata);
                                              if (fooditems[index]['cart'] !=
                                                      null &&
                                                  fooditems[index]['cart'] ==
                                                      true) {
                                                var qtyy = int.parse(
                                                    fooditems[index]['qty2']);
                                                qtyy++;
                                                fooditems[index]['qty2'] =
                                                    qtyy.toString();
                                              } else {
                                                fooditems[index]['qty2'] =
                                                    fooditems[index]['qty'];
                                              }

                                              fooditems[index]['cart'] = true;
                                              print(fooditems[index]);
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            child: Container(
                                                child: Icon(
                                              Icons.check,
                                              color: AppColors.secondaryElement,
                                            ))),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                color: AppColors.secondaryColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.MARGIN_16,
                                  vertical: Sizes.MARGIN_16,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Please Choose Up To 2 Toppings",
                                      style: textTheme.title.copyWith(
                                        fontSize: Sizes.TEXT_SIZE_16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.indigoShade1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                child: Column(
                                    children: List.generate(
                                  toppings.length,
                                  (index) => Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      padding: EdgeInsets.zero,
                                      // color: Colors.red,
                                      child: CheckboxListTile(
                                        tileColor: AppColors.white,
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Text(toppings[index]['name'],
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 17,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ),
                                        value: toppings[index]['check'],

                                        activeColor: AppColors.secondaryElement,
                                        //  selectedTileColor: Colors.red,
                                        contentPadding: EdgeInsets.all(0),
                                        checkColor: AppColors.white,
                                        onChanged: (newValue) {
                                          setState(() {
                                            toppings[index]['check'] = newValue;
                                          });
                                        },

                                        // controlAffinity:
                                        //     ListTileControlAffinity.leading, //  <-- leading Checkbox
                                      )),
                                )),
                              ),
                              Container(
                                color: AppColors.secondaryColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.MARGIN_16,
                                  vertical: Sizes.MARGIN_16,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Please Choose Soft Drink",
                                      style: textTheme.title.copyWith(
                                        fontSize: Sizes.TEXT_SIZE_16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.indigoShade1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                child: Column(
                                    children: List.generate(
                                  drinks.length,
                                  (index) => Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      padding: EdgeInsets.zero,
                                      // color: Colors.red,
                                      child: CheckboxListTile(
                                        tileColor: AppColors.white,
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Text(drinks[index]['name'],
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 17,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ),
                                        value: drinks[index]['check'],

                                        activeColor: AppColors.secondaryElement,
                                        //  selectedTileColor: Colors.red,
                                        contentPadding: EdgeInsets.all(0),
                                        checkColor: AppColors.white,
                                        onChanged: (newValue) {
                                          setState(() {
                                            drinks[index]['check'] = newValue;
                                          });
                                        },

                                        // controlAffinity:
                                        //     ListTileControlAffinity.leading, //  <-- leading Checkbox
                                      )),
                                )),
                              )
                            ],
                          ),
                        ),
                      ),
                    )));
          });
        }).whenComplete(() {
      print('here');
      setState(() {
        
      });
    });
  }

  void getProducts() async {
    _restaurentMenuModel =
        await Service().getMenus(widget.restaurantDetails.data.id);
    print('this is a data');
    print(_restaurentMenuModel.data);
    _restaurentMenuModel.data.forEach((element) {
      fooditems.add({
        'name': element.menuName,
        'image': element.menuImage,
        'details': element.menuDetails,
        'price': element.menuPrice,
        'qty': '1',
        'id': element.id,
        'restaurantId': element.restId,
        'restaurantdata': widget.restaurantDetails.data
      });
    });

    setState(() {
      _isLoading = false;
    });
    //      _model = ListModel(
    //   initialItems: fooditems,
    //   listKey:
    //       _listKey, // ListModel uses this to look up the list its acting on.
    //   removedItemBuilder: (dynamic removedItem, BuildContext context,
    //           Animation<double> animation) =>
    //       RemovedSwipeItem(animation: animation),
    // );
    var cart;
    cart = await CartProvider().getcartslist();
    for (var i = 0; i < fooditems.length; i++) {
      int index = cart.indexWhere((x) => x['id'] == fooditems[i]['id']);
      if (index == -1) {
      } else {
        fooditems[i]['cart'] = true;
        fooditems[i]['qty2'] = cart[index]['qty'];
      }
    }
    setState(() {});
  }
}
