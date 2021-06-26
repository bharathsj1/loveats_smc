import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/models/promotions.dart';
import 'package:potbelly/models/restaurants.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/screens/preview_menu_photos.dart';
import 'package:potbelly/services/localstorage.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/values/data.dart';
import 'package:potbelly/widgets/category_card.dart';
import 'package:potbelly/widgets/foody_bite_card.dart';
import 'package:potbelly/widgets/heading_row.dart';
import 'package:potbelly/widgets/search_input_field.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:potbelly/models/Article.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  static const int TAB_NO = 0;

  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  List restaurant = [];
  VideoPlayerController _controller;

  @override
  void initState() {
    Localstorage().getlocal().then((value) {
      print(value);
      if (value == null) {
        Restaurant().createDemoRestaurants('Restaurant 1');
        Restaurant().createDemoRestaurants('Restaurant 2');
        Promotion().createDemoPromotions();
        Localstorage().setlocal();
      }
    });
    super.initState();
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
            children: <Widget>[
              FoodyBiteSearchInputField(
                ImagePath.searchIcon,
                controller: controller,
                textFormFieldStyle:
                    Styles.customNormalTextStyle(color: AppColors.accentText),
                hintText: StringConst.HINT_TEXT_HOME_SEARCH_BAR,
                hintTextStyle:
                    Styles.customNormalTextStyle(color: AppColors.accentText),
                suffixIconImagePath: ImagePath.settingsIcon,
                borderWidth: 0.0,
                onTapOfLeadingIcon: () => AppRouter.navigator.pushNamed(
                  AppRouter.searchResultsScreen,
                  arguments: SearchValue(
                    controller.text,
                  ),
                ),
                onTapOfSuffixIcon: () =>
                    AppRouter.navigator.pushNamed(AppRouter.filterScreen),
                borderStyle: BorderStyle.solid,
              ),
              SizedBox(height: 16.0),
              HeadingRow(
                title: StringConst.TRENDING_RESTAURANTS,
                number: StringConst.SEE_ALL_45,
                onTapOfNumber: () => AppRouter.navigator
                    .pushNamed(AppRouter.trendingRestaurantsScreen),
              ),
              SizedBox(height: 16.0),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Restaurants')
                      .snapshots(),
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
                      List<DocumentSnapshot> items = snapshot.data.docs;
                      List records = [];
                      items.forEach((e) {
                        records.add(e.data());
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
                                  onTap: () => AppRouter.navigator.pushNamed(
                                    AppRouter.restaurantDetailsScreen,
                                    arguments: RestaurantDetails(
                                        imagePath: records[index]['image'],
                                        restaurantName: records[index]['name'],
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
                                  ),
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
}
