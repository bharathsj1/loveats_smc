import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/models/restaurent_model.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/service.dart';
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
  RestaurentsModel search;
  bool searching = false;
  var controller = TextEditingController();
  int totalRestaurent = 0;
  RestaurentsModel _restaurentsModel;

  Future<RestaurentsModel> getAllRestaurents() async {
    _restaurentsModel = await Service().getRestaurentsData();
    search = await Service().getRestaurentsData();
    return _restaurentsModel;
  }

  searchfromlist() {
    records = search.data
        .where((product) =>
            product.restName.toLowerCase().contains(controller.text.toLowerCase()))
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
                FutureBuilder<RestaurentsModel>(
                    future: getAllRestaurents(),
                    // builder: (context, snapshot) {
                    //   if (!snapshot.hasData) {
                    builder:
                        (context, AsyncSnapshot<RestaurentsModel> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.secondaryElement,
                            ),
                          ),
                        );
                      } else {
                        // List<DocumentSnapshot> items =
                        //     snapshot.data.documents;
                        // // if (searching == true) {
                        // // } else {
                        // records.clear();
                        // items.forEach((e) {
                        //   records.add(e.data);
                        //   // print(e.data());
                        // });
                        totalRestaurent = _restaurentsModel.data.length;
                        // search = snapshot.data;
                        // }
                        if (searching == true) {
                          searchfromlist();
                        }
                        return Container(
                          height: 300,
                          // color: Colors.red,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.data.length,
                            itemBuilder: (context, index) {
                              var res = snapshot.data.data[index];
                              return Container(
                                height: 300,
                                width: MediaQuery.of(context).size.width * 0.92,
                                child: FoodyBiteCard(
                                  cardElevation: 1,
                                  onTap: () => AppRouter.navigator.pushNamed(
                                    AppRouter.restaurantDetailsScreen,
                                    arguments: RestaurantDetails(
                                        imagePath: res.restImage,
                                        restaurantName: res.restName,
                                        restaurantAddress: res.restAddress +
                                            res.restCity +
                                            ' ' +
                                            res.restCountry,
                                        rating: '0.0',
                                        category: res.restType,
                                        distance: '0 Km',
                                        data: res),
                                  ),
                                  imagePath: res.restImage,
                                  status: res.restIsOpen == 1 ? "OPEN" : "CLOSE",
                                  cardTitle: res.restName,
                                  rating: '0.0',
                                  category: res.restType,
                                  distance: '8 KM',
                                  address: res.restAddress +
                                      ' ' +
                                      res.restCity +
                                      ' ' +
                                      res.restCountry,
                                ),
                              );
                            },
                          ),
                        );
                      }
                    }),
              ],
            ),
          )),
    );
  }
}
