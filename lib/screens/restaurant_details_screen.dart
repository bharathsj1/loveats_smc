import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/bookmarkservice.dart';
import 'package:potbelly/services/cartservice.dart';
import 'package:potbelly/values/data.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/card_tags.dart';
import 'package:potbelly/widgets/dark_overlay.dart';
import 'package:potbelly/widgets/heading_row.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
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

  bool bookmark =false;
  
  TextStyle addressTextStyle = Styles.customNormalTextStyle(
    color: AppColors.accentText,
    fontSize: Sizes.TEXT_SIZE_12,
  );

  TextStyle openingTimeTextStyle = Styles.customNormalTextStyle(
    color: Colors.red,
    fontSize: Sizes.TEXT_SIZE_14,
  );

  TextStyle subHeadingTextStyle = Styles.customTitleTextStyle(
    color: AppColors.headingText,
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
        item['restaurantId']= widget.restaurantDetails.data['id'];
        print(item);
      }
      super.initState();
    }

  checkbookmark() async {
   bookmark = await  BookmarkService().checkbookmark(widget.restaurantDetails.data);
   print(bookmark);
   setState(() { });
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
                              children: <Widget>[
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
                                  onTap: (){
                                    BookmarkService().addbookmark(context, widget.restaurantDetails.data).then((value) {
                                      print(value);
                                      if(value == 'success'){
                                      bookmark = !bookmark;
                                      setState(() {});
                                      }
                                    });
                                  },
                                  child: Image.asset( bookmark? ImagePath.activeBookmarksIcon3: ImagePath.bookmarksIcon,
                                      color:  bookmark? AppColors.secondaryElement: Colors.white),
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
                                        children: <Widget>[
                                          SizedBox(width: 4.0),
                                          Image.asset(ImagePath.callIcon),
                                          SizedBox(width: 8.0),
                                          Text(
                                            widget.restaurantDetails
                                                .data['phone'],
                                            style: Styles.normalTextStyle,
                                          )
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
//                                      width:
//                                      (MediaQuery
//                                          .of(context)
//                                          .size
//                                          .width /
//                                          2) -
//                                          24,
//                                      decoration: rightSideDecorations,
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(width: 4.0),
                                          Image.asset(ImagePath.directionIcon,color: AppColors.secondaryElement,),
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
                                        text: widget.restaurantDetails
                                                .data['open_time'] +
                                            " am to " +
                                            widget.restaurantDetails
                                                .data['close_time'] +
                                            " am "),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SpaceH24(),
                          HeadingRow(
                            title: StringConst.MENU_AND_PHOTOS,
                            number: StringConst.SEE_ALL_32,
                            onTapOfNumber: () => AppRouter.navigator.pushNamed(
                                AppRouter.menuPhotosScreen,
                                arguments:
                                    widget.restaurantDetails.data['menu']),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  widget.restaurantDetails.data['menu'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 12.0),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: widget.restaurantDetails.imagePath
                                              .substring(0, 4) ==
                                          'http'
                                      ? Image.network(
                                          widget.restaurantDetails.data['menu']
                                              [index],
                                          fit: BoxFit.fill,
                                          loadingBuilder: (BuildContext ctx,
                                              Widget child,
                                              ImageChunkEvent loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Container(
                                                // height: ,
                                                width: 160,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            AppColors
                                                                .secondaryElement),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          width: 160,
                                        )
                                      : Image.asset(
                                          menuPhotosImagePaths[index],
                                          fit: BoxFit.fill,
                                          width: 160,
                                        ),
                                );
                              },
                            ),
                          ),
                          // SpaceH24(),
                          // HeadingRow(
                          //   title: StringConst.REVIEWS_AND_RATINGS,
                          //   number: StringConst.SEE_ALL_32,
                          //   onTapOfNumber: () => AppRouter.navigator
                          //       .pushNamed(AppRouter.reviewRatingScreen),
                          // ),
                          SpaceH24(),
                          HeadingRow(
                            title: StringConst.Food_Items.toUpperCase(),
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
      'name': 'Turkey Burgers',
      'image':
          'https://www.thespruceeats.com/thmb/oY67Fvga3ptpwQvOjpZNE87u6mo=/3429x2572/smart/filters:no_upscale()/juicy-baked-turkey-burgers-with-garlic-3057268-hero-01-ceea8ae8e9914a0788b9acd14e821eb3.jpg',
      'details':
          'Ground turkey, bread crumbs, egg whites, garlic, black pepper',
      'price': '20',
      'qty': '1',
      'id': '1',
    },
    {
      'name': 'Margherita Pizza',
      'image':
          'https://www.abeautifulplate.com/wp-content/uploads/2015/08/the-best-homemade-margherita-pizza-1-4-480x480.jpg',
      'details':
          'San marzano, fresh mozzarella cheese, red pepper flakes, olive',
      'price': '24',
      'qty': '1',
      'id': '2',
    },
    {
      'name': 'Portobello Mushroom Burgers',
      'image':
          'https://www.wellplated.com/wp-content/uploads/2019/07/Stuffed-Portobello-Mushroom-Burger.jpg',
      'details': 'Portobello mushroom caps, balsamic vinegar, provolone',
      'price': '14',
      'qty': '1',
      'id': '4',
    },
    {
      'name': 'York-​Style Pizza',
      'image':
          'https://feelingfoodish.com/wp-content/uploads/2013/06/Pizza-sauce.jpg',
      'details': 'Olive oil, sugar, dry yeast, all purpose',
      'price': '26',
      'qty': '1',
      'id': '5',
    }
  ];
  List<Widget> itemsListTiles(context) {
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
                              'payableAmount': fooditems[i]['price'],
                              'qty': fooditems[i]['qty'],
                              'data': fooditems[i],
                              'restaurantdata': widget.restaurantDetails.data
                            };
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
                          '\$' + fooditems[i]['price'],
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
}
