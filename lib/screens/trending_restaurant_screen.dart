import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/values/data.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/foody_bite_card.dart';
import 'package:potbelly/widgets/search_input_field.dart';
import 'package:potbelly/widgets/spaces.dart';

class TrendingRestaurantsScreen extends StatefulWidget {
  @override
  _TrendingRestaurantsScreenState createState() =>
      _TrendingRestaurantsScreenState();
}

class _TrendingRestaurantsScreenState extends State<TrendingRestaurantsScreen> {
  List records = [];
  List search = [];
  bool searching = false;
  var controller = TextEditingController();

  searchfromlist() {
    records = search
        .where((product) => product['name']
            .toLowerCase()
            .contains(controller.text.toLowerCase()))
        .toList();
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
          appBar: AppBar(
            elevation: 0.0,
            leading: InkWell(
              onTap: () => AppRouter.navigator.pop(),
              child: Image.asset(
                ImagePath.arrowBackIcon,
                color: AppColors.headingText,
              ),
            ),
            centerTitle: true,
            title: Text(
              'Trending Restaurant',
              style: Styles.customTitleTextStyle(
                color: AppColors.headingText,
                fontWeight: FontWeight.w600,
                fontSize: Sizes.TEXT_SIZE_20,
              ),
            ),
          ),
          body: Container(
            margin: const EdgeInsets.only(
                left: Sizes.MARGIN_16,
                right: Sizes.MARGIN_16,
                top: Sizes.MARGIN_16),
            child: Column(
              children: <Widget>[
                FoodyBiteSearchInputField(
                  ImagePath.searchIcon,
                  controller: controller,
                  onChanged: (value) {
                    setState(() {
                      this.searching = true;
                      searchfromlist();
                    });
                  },
                  textFormFieldStyle:
                      Styles.customNormalTextStyle(color: AppColors.accentText),
                  hintText: StringConst.HINT_TEXT_TRENDING_SEARCH_BAR,
                  hintTextStyle:
                      Styles.customNormalTextStyle(color: AppColors.accentText),
                  suffixIconImagePath: ImagePath.settingsIcon,
                  borderWidth: 0.0,
                  borderStyle: BorderStyle.solid,
                ),
                SizedBox(height: Sizes.WIDTH_16),
                Expanded(
                  child: StreamBuilder(
                      stream: Firestore.instance
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
                          List<DocumentSnapshot> items =
                              snapshot.data.documents;
                          // if (searching == true) {
                          // } else {
                          records.clear();
                          items.forEach((e) {
                            records.add(e.data);
                            // print(e.data());
                          });
                          search = records;
                          // }
                          if (searching == true) {
                            searchfromlist();
                          }
                          return ListView.separated(
                            scrollDirection: Axis.vertical,
                            itemCount: records.length,
                            separatorBuilder: (context, index) {
                              return SpaceH8();
                            },
                            itemBuilder: (context, index) {
                              return Container(
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
                            },
                          );
                        }
                      }),
                ),
              ],
            ),
          )),
    );
  }
}
