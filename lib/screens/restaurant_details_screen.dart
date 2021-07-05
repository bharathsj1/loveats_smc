import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:potbelly/models/restaurent_menu_model.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/bookmarkservice.dart';
import 'package:potbelly/services/cartservice.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/card_tags.dart';
import 'package:potbelly/widgets/dark_overlay.dart';
import 'package:potbelly/widgets/heading_row.dart';
import 'package:potbelly/widgets/ratings_widget.dart';
import 'package:potbelly/widgets/spaces.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final RestaurantDetails restaurantDetails;

  RestaurantDetailsScreen({@required this.restaurantDetails});

  @override
  _RestaurantDetailsScreenState createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  bool bookmark = false;
  bool _isLoading = true;
  RestaurentMenuModel _restaurentMenuModel;

  TextStyle addressTextStyle = Styles.customNormalTextStyle(
    color: AppColors.accentText,
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
                          child: Container(
                            padding: EdgeInsets.only(
                              right: Sizes.MARGIN_16,
                              top: Sizes.MARGIN_16,
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () => AppRouter.navigator.pop(),
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
                                SpaceW20(),
                                InkWell(
                                  onTap: () {
                                    BookmarkService()
                                        .addbookmark(context,
                                            widget.restaurantDetails.data)
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
                                          ? ImagePath.activeBookmarksIcon3
                                          : ImagePath.bookmarksIcon,
                                      color: bookmark
                                          ? AppColors.secondaryElement
                                          : Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: aPieceOfTheHeightOfStack,
                          left: 24,
                          right: 24 - 0.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24.0),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 4.0),
                                decoration: fullDecorations,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 8.0),
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  2) -
                                              24,
//                                      decoration: leftSideDecorations,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 4.0),
                                          Image.asset(ImagePath.callIcon),
                                          SizedBox(width: 8.0),
                                          Text(
                                            widget.restaurantDetails.data
                                                .restPhone,
                                            style: Styles.normalTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    IntrinsicHeight(
                                      child: VerticalDivider(
                                        width: 0.5,
                                        thickness: 3.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 8.0),
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(width: 4.0),
                                          Image.asset(
                                            ImagePath.directionIcon,
                                            color: AppColors.secondaryElement,
                                          ),
                                          SizedBox(width: 8.0),
                                          Text(
                                            'Direction',
                                            style: Styles.normalTextStyle,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
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
                              Row(
                                children: <Widget>[
                                  Text(
                                    widget.restaurantDetails.restaurantName,
                                    textAlign: TextAlign.left,
                                    style: Styles.customTitleTextStyle(
                                      color: AppColors.headingText,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Sizes.TEXT_SIZE_20,
                                    ),
                                  ),
                                  SizedBox(width: 4.0),
                                  CardTags(
                                    title: widget.restaurantDetails.category,
                                    decoration: BoxDecoration(
                                      gradient: Gradients.secondaryGradient,
                                      boxShadow: [
                                        Shadows.secondaryShadow,
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                  ),
                                  SizedBox(width: 4.0),
                                  CardTags(
                                    title: widget.restaurantDetails.distance,
                                    decoration: BoxDecoration(
                                      // color: Color.fromARGB(255, 132, 141, 255),
                                      color: AppColors.secondaryElement,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                  ),
                                  Spacer(flex: 1),
                                  Ratings(widget.restaurantDetails.rating)
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                widget.restaurantDetails.restaurantAddress,
                                style: addressTextStyle,
                              ),
                              SizedBox(height: 8.0),
                              RichText(
                                text: TextSpan(
                                  style: openingTimeTextStyle,
                                  children: [
                                    TextSpan(text: "Open Now "),
                                    TextSpan(
                                        text: "daily time ",
                                        style: addressTextStyle),
                                    TextSpan(
                                        text: widget.restaurantDetails.data
                                                .restOpenTime +
                                            " am to " +
                                            widget.restaurantDetails.data
                                                .restCloseTime +
                                            " am "),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SpaceH24(),

                          _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.secondaryElement,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    HeadingRow(
                                      title: StringConst.MENU_AND_PHOTOS,
                                      number: 'See All ('+_restaurentMenuModel.data.length.toString()+')'
                                          ,
                                      onTapOfNumber: () => AppRouter.navigator
                                          .pushNamed(AppRouter.menuPhotosScreen,
                                              arguments:
                                                  _restaurentMenuModel.data),
                                    ),
                                    SizedBox(height: 16.0),
                                    fooditems.length == 0
                                        ? Center(
                                            child: Text('Not Available'),
                                          )
                                        : Container(
                                            height: 120,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: _restaurentMenuModel
                                                  .data.length,
                                              itemBuilder: (context, index) {
                                                var data = _restaurentMenuModel
                                                    .data[index];
                                                return Container(
                                                    margin: EdgeInsets.only(
                                                        right: 12.0),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8))),
                                                    child: Image.network(
                                                      data.menuImage,
                                                      fit: BoxFit.fill,
                                                      loadingBuilder: (BuildContext
                                                              ctx,
                                                          Widget child,
                                                          ImageChunkEvent
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        } else {
                                                          return Container(
                                                            // height: ,
                                                            width: 160,
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                valueColor: AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    AppColors
                                                                        .secondaryElement),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      width: 160,
                                                    ));
                                              },
                                            ),
                                          ),
                                  ],
                                ),
                          // SpaceH24(),
                          // HeadingRow(
                          //   title: StringConst.REVIEWS_AND_RATINGS,
                          //   number: StringConst.SEE_ALL_32,
                          //   onTapOfNumber: () => AppRouter.navigator
                          //       .pushNamed(AppRouter.reviewRatingScreen),
                          // ),
                          SpaceH24(),
                          _isLoading
                              ? Container()
                              : HeadingRow(
                                  title: StringConst.Food_Items.toUpperCase(),
                                  number: 'See All ('+fooditems.length.toString()+')',
                                ),
                          SizedBox(height: 16.0),
                          _isLoading
                              ? Container()
                              : fooditems.length > 0
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: itemsListTiles(context),
                                    )
                                  : Text('No Items Avaialble Right Now')
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

  List fooditems = [];
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
  }
}
