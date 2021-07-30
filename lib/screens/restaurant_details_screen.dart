import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:potbelly/3D_card_widets/city_scenery.dart';
import 'package:potbelly/models/restaurent_menu_model.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/bookmarkservice.dart';
import 'package:potbelly/services/cartservice.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';
// import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:potbelly/services/service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:potbelly/services/url_launcher.dart';
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
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter/scheduler.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:skeleton_text/skeleton_text.dart';
// import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

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
    _tabcontroller = TabController(length: catlist.length, vsync: this);
    //  _tabcontroller.index=2;

    _autoScrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: scrollDirection,
    )..addListener(_scrollListener2);
    // ..addListener(
    //     () => _isAppBarExpanded
    //         ? isExpaned != false
    //             ? setState(
    //                 () {
    //                   isExpaned = false;
    //                   print('setState is called');
    //                 },
    //               )
    //             : {}
    //         : isExpaned != true
    //             ? setState(() {
    //                 print('setState is called');
    //                 isExpaned = true;
    //               })
    //             : {},
    //   );

    _scrollController2 = ScrollController();
    // controller.addListener(() {
    //   // print(controller.offset);
    //   var currentOffset = controller.offset;
    //   var mse = controller.position.maxScrollExtent;
    //   var fsof = (currentOffset / mse) * 100;
    //   var fivePer = (10 / 100) * fsof;
    //   var marginPer = (30 / 100) * fsof;
    //   if (currentOffset > prevOffset) {
    //     setState(() {
    //       prodcutFontSize = 20 + fivePer;
    //       productContainerMarginTop = 0 + marginPer;
    //     });
    //   } else {
    //     setState(() {
    //       prodcutFontSize = 30 - (10 - fivePer);
    //       productContainerMarginTop = 30 - (30 - marginPer);
    //     });
    //   }
    //   prevOffset = currentOffset;
    // });
    // Create the "sparkle" sprite sheet for the particles:
    _spriteSheet = SpriteSheet(
      imageProvider: AssetImage("assets/swipe/circle_spritesheet.png"),
      length: 15, // number of frames in the sprite sheet.
      frameWidth: 10,
      frameHeight: 10,
    );
    _scrollController = ScrollController()..addListener(_scrollListener);
    _particleField = ParticleField();
    // _ticker = createTicker(_particleField.tick)..start();
    checkbookmark();
    for (var item in fooditems) {
      item['restaurantId'] = widget.restaurantDetails.data.id.toString();
      print(item);
    }
    getProducts2();
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
    if (_scrollController != null) {
      _scrollController.dispose();
    }
    if (_scrollController2 != null) {
      _scrollController2.dispose();
    }
    if (_tabcontroller != null) {
      _tabcontroller.dispose();
    }
    if (_ticker != null) {
      _ticker.dispose();
    }
    super.dispose();
  }

  ScrollController _scrollController;
  ScrollController _scrollController2;
  bool lastStatus = true;
  double height = 490;
  bool visible = false;

  void _scrollListener() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      visible = true;
    } else {
      visible = false;
    }
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  void _scrollListener2() {
    _isAppBarExpanded
        ? isExpaned != false
            ? setState(
                () {
                  isExpaned = false;
                  print('setState is called');
                },
              )
            : {}
        : isExpaned != true
            ? setState(() {
                print('setState is called');
                isExpaned = true;
              })
            : {};

    // if(_scrollController.offset == _scrollController.position.maxScrollExtent){
    //   visible= true;
    // }
    // else{
    //   visible=false;
    // }
    if (_autoScrollController.offset == 100) {
      _tabcontroller.index = 1;
      setState(() {});
    }
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _autoScrollController.hasClients &&
        _autoScrollController.offset > (250 - kToolbarHeight);
  }

  final _controller = SwiperController();
  TabController _tabcontroller;

  AutoScrollController _autoScrollController;
  final scrollDirection = Axis.vertical;

  bool isExpaned = true;
  bool get _isAppBarExpanded {
    return _autoScrollController.hasClients &&
        _autoScrollController.offset > (160 - kToolbarHeight);
  }

  Future _scrollToIndex(int index) async {
    print(_autoScrollController.position);
    await _autoScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.begin);
    _autoScrollController.highlight(index);
  }

  Widget _wrapScrollTag({int index, Widget child}) {
    return AutoScrollTag(
      key: ValueKey(index),
      controller: _autoScrollController,
      index: index,
      child: child,
      highlightColor: Colors.black.withOpacity(0.1),
    );
  }

  bool showrating = false;
  ratelist(name, slide) {
    return Row(
      children: [
        Text(
          name,
          style: TextStyle(
              fontSize: 12,
              fontFamily: 'roboto',
              color: AppColors.black,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          height: 3,
          width: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey.shade300),
          child: Container(
            margin: EdgeInsets.only(right: slide),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.secondaryElement),
          ),
        ),
      ],
    );
  }

  List catlist = [
    'Desi Food',
    'Fast Food',
    'Korean',
  ];

  _buildSliverAppbar(context, heightOfStack) {
    return SliverAppBar(
      brightness: Brightness.light,
      pinned: true,
      floating: false,
      expandedHeight: 225,
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: const EdgeInsets.only(
            left: Sizes.MARGIN_16,
            right: Sizes.MARGIN_16,
          ),
          child: Image.asset(
            ImagePath.arrowBackIcon,
            color: _isShrink ? AppColors.black : AppColors.white,
          ),
        ),
      ),
      //  pinned: true,
      actions: [
        InkWell(
          child: Icon(
            FeatherIcons.share2,
            size: 20,
            color: _isShrink ? AppColors.black : Colors.white,
          ),
        ),
        //  Spacer(flex: 1),
        SizedBox(
          width: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: InkWell(
            onTap: () {},
            child: Icon(Icons.search,
                color: _isShrink ? AppColors.black : Colors.white),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        titlePadding: EdgeInsets.zero,
        background: Column(
          // alignment: Alignment.bottomRight,
          children: <Widget>[
            Expanded(
              // height: MediaQuery.of(context).size.height * 0.64,
              // color: Colors.blue,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      // shrinkWrap: true,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 0),
                              height: 250,
                              child: Hero(
                                tag: widget.restaurantDetails.restaurantName,
                                child: new Swiper(
                                  autoplay: true,
                                  autoplayDelay: 4000,
                                  // index: indxx,
                                  // curve:  Curves.easeInBack,
                                  duration: 1500,
                                  //  outer: true,

                                  itemBuilder: (BuildContext context, int i) {
                                    return GestureDetector(
                                      onTap: () {
                                        print('clicked');
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) => ProductPage(
                                        //             id: this.banner[i]['id'],
                                        //             name: this.banner[i]['name'],
                                        //             api: 'banner',
                                        //             arabicname: this.banner[i]['name'],
                                        //             maincat: '',
                                        //             maincatAR: '',
                                        //             mainid: null,
                                        //             catlist: null)));
                                      },
                                      child: Center(
                                        child: new ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(0)
                                              // topLeft: Radius.circular(8)
                                              ),
                                          child:
                                              // widget.restaurantDetails
                                              //             .imagePath
                                              //             .substring(
                                              //                 0, 4) !=
                                              //         'http'
                                              //     ? Image
                                              //         .network(
                                              //       widget
                                              //           .restaurantDetails
                                              //           .imagePath,
                                              //       width: MediaQuery.of(
                                              //               context)
                                              //           .size
                                              //           .width,
                                              //       height:
                                              //           250,
                                              //       fit: BoxFit
                                              //           .cover,
                                              //     )
                                              //     : Image.asset(
                                              //           'assets/images/logo.png',
                                              //           width: MediaQuery.of(
                                              //           context)
                                              //       .size
                                              //       .width,
                                              //           height:
                                              //       250,
                                              //           fit: BoxFit
                                              //       .cover,
                                              //         ),
                                              Image.asset(
                                            'assets/images/d${i + 1}.png',
                                            width: 180,
                                            height: 180,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  // onIndexChanged: (value) {
                                  //   // print(value);
                                  //   if (mounted) {
                                  //     setState(() {
                                  //       // indxx = value;
                                  //     });
                                  //   }
                                  // },
                                  loop: true,
                                  indicatorLayout: PageIndicatorLayout.COLOR,
                                  // customLayoutOption: CustomLayoutOption(),
                                  // autoplay: true,
                                  // controller: _controller,
                                  itemCount: catlist.length,
                                  scrollDirection: Axis.horizontal,
                                  pagination: new SwiperPagination(
                                      alignment: Alignment.bottomCenter,
                                      // margin: EdgeInsets.only(right: 20, bottom: 8),
                                      builder: new DotSwiperPaginationBuilder(
                                        activeColor: AppColors.secondaryElement,
                                        color:
                                            Color(0xFF858585).withOpacity(0.8),
                                        // space: 5,
                                      )),
                                ),
                              ),
                            ),
                            DarkOverLay(
                                gradient: Gradients.restaurantDetailsGradient),
                            Positioned(
                              child: Container(
                                padding: EdgeInsets.only(
                                  right: Sizes.MARGIN_16,
                                  top: Sizes.MARGIN_40,
                                ),
                                child: Row(
                                  children: [],
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
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.grid_view,
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottom: _isShrink
          ? PreferredSize(
              preferredSize: Size.fromHeight(45),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: isExpaned ? 0.0 : 1,
                child: DefaultTabController(
                  length: catlist.length,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 10, bottom: 0),
                    margin: EdgeInsets.all(5),
                    child: TabBar(
                      controller: _tabcontroller,
                      unselectedLabelColor: AppColors.secondaryElement,
                      // indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.secondaryElement),
                      //      indicatorPadding: EdgeInsets.zero,
                      labelPadding: EdgeInsets.zero,

                      labelColor: Colors.white,
                      onTap: (index) async {
                        print('here');
                        _scrollToIndex(index);
                      },
                      tabs: List.generate(
                        catlist.length,
                        (i) {
                          return Tab(
                            text: catlist[i],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    var heightOfStack = MediaQuery.of(context).size.height / 2.8;
    return Scaffold(
      body: CustomScrollView(
        controller: _autoScrollController,
        slivers: <Widget>[
          _buildSliverAppbar(context, heightOfStack),
          SliverList(
              delegate: SliverChildListDelegate([
            // SizedBox(height: 10,),
            // InkWell(
            //   onTap: () {
            //     // print('here');
            //     // _tabcontroller.index = 1;
            //     // setState(() {});
            //   },
            //   child: Container(
            //     // color: Colors.red,
            //     margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
            //     child: Column(
            //       children: <Widget>[
            //         Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: <Widget>[
            //               Row(
            //                 children: <Widget>[
            //                   Text(
            //                     widget.restaurantDetails.restaurantName,
            //                     textAlign: TextAlign.left,
            //                     style: Styles.customTitleTextStyle(
            //                       color: AppColors.headingText,
            //                       fontWeight: FontWeight.w600,
            //                       fontSize: Sizes.TEXT_SIZE_20,
            //                     ),
            //                   ),
            //                   SizedBox(width: 4.0),
            //                   CardTags(
            //                     title: widget.restaurantDetails.category,
            //                     decoration: BoxDecoration(
            //                       gradient: Gradients.secondaryGradient,
            //                       boxShadow: [
            //                         Shadows.secondaryShadow,
            //                       ],
            //                       borderRadius:
            //                           BorderRadius.all(Radius.circular(8.0)),
            //                     ),
            //                   ),
            //                   SizedBox(width: 4.0),
            //                   CardTags(
            //                     title: widget.restaurantDetails.distance,
            //                     decoration: BoxDecoration(
            //                       // color: Color.fromARGB(255, 132, 141, 255),
            //                       color: AppColors.secondaryElement,
            //                       borderRadius:
            //                           BorderRadius.all(Radius.circular(8.0)),
            //                     ),
            //                   ),
            //                   Spacer(flex: 1),
            //                   Ratings(widget.restaurantDetails.rating)
            //                 ],
            //               ),
            //               SizedBox(height: 10.0),
            //               Text(
            //                 widget.restaurantDetails.restaurantAddress,
            //                 style: addressTextStyle,
            //               ),
            //               SizedBox(height: 5.0),
            //               RichText(
            //                 text: TextSpan(
            //                   style: openingTimeTextStyle,
            //                   children: [
            //                     TextSpan(text: "Open Now - "),
            //                     // TextSpan(
            //                     //     text: "daily time ",
            //                     //     style:
            //                     //         addressTextStyle),
            //                     TextSpan(
            //                         text: widget.restaurantDetails.data
            //                                 .restOpenTime +
            //                             "am - " +
            //                             widget.restaurantDetails.data
            //                                 .restCloseTime +
            //                             "am ",
            //                         style: addressTextStyle),
            //                   ],
            //                 ),
            //               ),
            //               SizedBox(height: 10.0),
            //               Text(
            //                 'The Baan Thai restaurant in Fort Wayne, Indiana makes great use of high-resolution pictures to draw in website visitors. Color abounds wherever you look and the vivid representations of the Thai region make you feel like you’re already there. Don’t settle for washed-out, blurry photos on your website. If need be, hire a professional photographer or purchase high-resolution photos online to give your website the extra kick it needs.',
            //                 textAlign: TextAlign.justify,
            //                 style: addressTextStyle,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    widget.restaurantDetails.restaurantName,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black87,
                        fontFamily: 'roboto',
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Lebanese' + ' , ',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'roboto',
                            color: AppColors.grey),
                      ),
                      Text(
                        'Vegen Friendly' + ' , ',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'roboto',
                            color: AppColors.grey),
                      ),
                      Text(
                        'Mezze' + ' ',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'roboto',
                            color: AppColors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Wrap(
                          runAlignment: WrapAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: Icon(
                                    Icons.place_outlined,
                                    size: 22,
                                    color: AppColors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      // text: 'Hello ',
                                      style: TextStyle(
                                          fontSize: 15, fontFamily: 'roboto'),
                                      children: [
                                        TextSpan(
                                          text: '0.75 miles away' +
                                              ' , ' +
                                              'Free delivery' +
                                              ' ',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'roboto',
                                              color: AppColors.grey),
                                        ),
                                        TextSpan(
                                          text: widget.restaurantDetails
                                              .restaurantAddress,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'roboto',
                                              color: AppColors.grey),
                                        ),
                                        
                                        TextSpan(
                                          text: ' View Map',
                                          recognizer: new TapGestureRecognizer()..onTap = () {
                                            print('here');
                                            // MapsLauncher.launchCoordinates(37.4220041, -122.0862462);
                                            print(widget.restaurantDetails.data.restLatitude);
                                            print(widget.restaurantDetails.data.restLongitude);
                                            MapUtils.openMap(widget.restaurantDetails.data.restLatitude,widget.restaurantDetails.data.restLongitude);
                                          },
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'roboto',
                                              color:
                                                  AppColors.secondaryElement),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            //  Text('0.75 miles away'+' , '+ 'Free delivery delivery delivery'+' , '+widget.restaurantDetails.restaurantAddress+' ',style: TextStyle(fontSize: 15,fontFamily:'roboto',color: AppColors.grey),),
                            //          Text('View Map',style: TextStyle(fontSize: 15,fontFamily:'roboto',color: AppColors.secondaryElement),),
                          ],
                        ),
                      ),
                      //
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'The Baan Thai restaurant in Fort Wayne, Indiana makes great use of high-resolution pictures to draw in website visitors. Color abounds wherever you look and the vivid representations of the Thai region make you feel like you’re already there. Don’t settle for washed-out, blurry photos on your website. If need be, hire a professional photographer or purchase high-resolution photos online to give your website the extra kick it needs.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'roboto',
                        color: AppColors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: 4.4,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: AppColors.secondaryElement,
                        ),
                        itemCount: 5,
                        itemSize: 15.0,
                        direction: Axis.horizontal,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        '4.4 ',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'roboto',
                            color: AppColors.black),
                      ),
                      Text(
                        '(500+)',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'roboto',
                            color: AppColors.grey),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () {
                      showrating = !showrating;
                      setState(() {});
                    },
                    child: Container(
                      child: Text(
                        'Show rating details',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'roboto',
                            color: AppColors.secondaryElement),
                      ),
                    ),
                  ),
                  showrating
                      ? Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              ratelist('5', 40.0),
                              ratelist('4', 80.0),
                              ratelist('3', 100.0),
                              ratelist('2', 130.0),
                              ratelist('1', 140.0),
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/driver.gif",
                            height: 40,
                            width: 40,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Delivery in 15 - 30 min',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'roboto',
                                color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          showrating = !showrating;
                          setState(() {});
                        },
                        child: Container(
                          child: Text(
                            'Change',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'roboto',
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryElement),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, AppRouter.Restaurant_info,arguments: widget.restaurantDetails);
                    },
                    child: Container(
                      color: Colors.grey.shade50,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: Sizes.MARGIN_12,
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.info_outline,
                            color: AppColors.black.withOpacity(0.2),
                            size: 25,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Restaurant info",
                                style: Theme.of(context).textTheme.title.copyWith(
                                      fontSize: Sizes.TEXT_SIZE_14,
                                      // fontWeight: FontWeight.bold,
                                      color: AppColors.black.withOpacity(0.8),
                                    ),
                              ),
                              Text(
                                'Maps, Allergens and hygiene rating',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'roboto',
                                    color: AppColors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),

            _isLoading
                ? Column(children: loading())
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal:15.0),
                  child: Column(
                      children: mainfoodlist(context),
                    ),
                ),

            // _wrapScrollTag(
            //   index: 2,
            //   child: Column(
            //     children: [
            //       Container(
            //         color: AppColors.secondaryColor,
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: Sizes.MARGIN_16,
            //           vertical: Sizes.MARGIN_16,
            //         ),
            //         child: Row(
            //           children: <Widget>[
            //             Text(
            //               "Korean",
            //               style: Theme.of(context).textTheme.title.copyWith(
            //                     fontSize: Sizes.TEXT_SIZE_16,
            //                     fontWeight: FontWeight.bold,
            //                     color: AppColors.black.withOpacity(0.6),
            //                   ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       !_isLoading
            //           ? Column(children:loading())
            //           : fooditems.length > 0
            //               ? Column(children: itemsListTiles2(context))
            //               : Text('No Items Avaialble Right Now'),
            //     ],
            //   ),
            // ),

            SizedBox(
              height: 10,
            ),
          ])),
        ],
      ),
    );
  }

  int deliverytype;

  loading() {
    return List.generate(
        4,
        (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
              child: SkeletonAnimation(
                // shimmerDuration: 1500,

                borderRadius: BorderRadius.circular(5.0),
                shimmerColor: Colors.grey.shade300,
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.grey[200]),
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
              if (deliverytype == id) {
                deliverytype = null;
                // resturants = searchlist;
                setState(() {});
              } else {
                deliverytype = id;
                // print(resturants);
                // resturants = searchlist
                //     .where((pro) => deliverytype == 0
                //         ? pro.delivery == 1
                //         : deliverytype == 1
                //             ? pro.pickup == 1
                //             : pro.tableService == 1)
                //     .toList();
                setState(() {});
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

  double productContainerMarginTop = 0.0;

  _buildList() {
    return List.generate(
        fooditems.length + 5,
        (index) => InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRouter.Add_Extra);
              },
              child: SwipeItem(
                data: fooditems[0],
                // isEven: index.isEven,
                // onSwipe: (key, {action}) {
                //   print('here');
                //   _performSwipeAction(0, fooditems[0], key, action);
                // }
              ),
            ));
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

  List<BoxShadow> shadowList = [
    BoxShadow(color: Colors.grey[300], blurRadius: 30, offset: Offset(0, 10))
  ];

  List<Widget> itemsListTiles2(context, newfooditems) {
    return List.generate(
      newfooditems.length,
      (i) => InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRouter.Add_Extra, arguments: {
            'item': newfooditems[i],
            'restaurant': widget.restaurantDetails.data
          }).then((value) {
            checkchanges(newfooditems);
          });
        },
        child: Container(
          // elevation: 0,
          // shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade200)),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                   
                   
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Text(newfooditems[i]['menu_name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      letterSpacing: .3,
                                      color: Colors.grey.shade800
                                    )),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              newfooditems[i]['foodCategoryName'] != null &&
                                      newfooditems[i]['foodCategoryName']
                                              .isDiscount ==
                                          'true'
                                  ? Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.red,
                                        ),
                                        padding: EdgeInsets.all(3.0),
                                        child: Text(
                                          '100% discount for subscribers',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.0),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(newfooditems[i]['menu_details'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.grey,
                                    letterSpacing: .3,
                                  )),
                                  SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  '\$' +
                                      newfooditems[i]['menu_price'].toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppColors.grey,
                                    letterSpacing: .3,
                                  )),
                              
                              if (newfooditems[i]['cart'] != null &&
                                  newfooditems[i]['cart'] == true)
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 2.0),
                                      child: Text('x' + newfooditems[i]['qty2'],
                                          style: TextStyle(
                                              fontSize: 18,
                                              letterSpacing: .3,
                                              color: Color(0xff55c8d4)
                                              // color: AppColors.secondaryElement
                                              )),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(Icons.add_shopping_cart_sharp,
                                        size: 16.0, color: Color(0xff55c8d4)),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                     SizedBox(
                      width: 16.0,
                    ),
                     ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          newfooditems[i]['menu_image'],
                          cacheHeight: 70,
                          cacheWidth: 70,
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Container(
                                // height: ,
                                width: 70,
                                height: 70,
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
                          height: 70,
                          width: 70,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
      setState(() {});
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
        'restaurantdata': widget.restaurantDetails.data,
        'foodCategoryName': element.foodCategory,
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

  List fooditemswithcat = [];

  List<Widget> mainfoodlist(
    context,
  ) {
    return List.generate(
      fooditemswithcat.length,
      (i) => _wrapScrollTag(
        index: i,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   color: AppColors.secondaryColor,
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: Sizes.MARGIN_16,
            //     vertical: Sizes.MARGIN_16,
            //   ),
            //   child: Row(
            //     children: <Widget>[
            //       Text(
            //         fooditemswithcat[i]['menutype']['menu_name'],
            //         style: Theme.of(context).textTheme.title.copyWith(
            //               fontSize: Sizes.TEXT_SIZE_16,
            //               fontWeight: FontWeight.bold,
            //               color: AppColors.black.withOpacity(0.6),
            //             ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 12,),
             Text(
                    fooditemswithcat[i]['menutype']['menu_name'],
                    style: Theme.of(context).textTheme.title.copyWith(
                          fontSize: Sizes.TEXT_SIZE_20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black.withOpacity(0.8),
                        ),
                  ),
                  SizedBox(height: 4,),
                  Text(
                              'Made with high quality prime beef, Customize your choice with 15 free toppings.',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'roboto',
                                  color: Colors.grey.shade600),
                            ),
                            SizedBox(height: 5,),
                            Divider(color: Colors.grey.shade200,height: 6,),
            fooditemswithcat[i]['menuItems'].length > 0
                ? Column(
                    children: itemsListTiles2(
                        context, fooditemswithcat[i]['menuItems']))
                : Text('No Items Avaialble Right Now'),
          ],
        ),
      ),
    );
  }

  void getProducts2() async {
    print(widget.restaurantDetails.data.id);
    var data = await AppService()
        .menuwithcat(widget.restaurantDetails.data.id.toString());
    // print('this is a data');
    print(data);
    fooditemswithcat = data;
    print(fooditemswithcat);
    print('Helol');

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
    for (var j = 0; j < fooditemswithcat.length; j++) {
      for (var i = 0; i < fooditemswithcat[j]['menuItems'].length; i++) {
        int index = cart.indexWhere(
            (x) => x['id'] == fooditemswithcat[j]['menuItems'][i]['id']);
        if (index == -1) {
        } else {
          fooditemswithcat[j]['menuItems'][i]['cart'] = true;
          fooditemswithcat[j]['menuItems'][i]['qty2'] = cart[index]['qty'];
        }
      }
    }

    setState(() {});
  }

  checkchanges(newfooditems) async {
    var cart;
    cart = await CartProvider().getcartslist();
    for (var i = 0; i < newfooditems.length; i++) {
      int index = cart.indexWhere((x) => x['id'] == newfooditems[i]['id']);
      if (index == -1) {
      } else {
        newfooditems[i]['cart'] = true;
        newfooditems[i]['qty2'] = cart[index]['qty'];
      }
    }
    setState(() {});
  }
}
