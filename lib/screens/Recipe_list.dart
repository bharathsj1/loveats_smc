import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';
import 'package:skeleton_text/skeleton_text.dart';

class RecipeList extends StatefulWidget {
  var data;
  RecipeList({@required this.data});

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  bool loader = true;
  List recipes = [];
  @override
  void initState() {
    getrecipes();
    super.initState();
  }

  getrecipes() async {
    var response = await AppService().getrecipe();
    recipes = response['data'];
    print(recipes);
    loader = false;
    setState(() {});
  }

  popular() {
    return List.generate(
        recipes.length,
        (i) => InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRouter.Recipe_details,
                    arguments: {
                      'recipe': recipes[i],
                      'usersub': widget.data['usersub'],
                      'subdata': widget.data['subdata']
                    });
              },
              child: Container(
                // height: 215,
                width: MediaQuery.of(context).size.width / 1,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4)),
                              child: CachedNetworkImage(
                                imageUrl: recipes[i]['image'],
                                width: MediaQuery.of(context).size.width,
                                height: 150,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.secondaryElement),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(recipes[i]['title'],
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: GoogleFonts.dmSerifDisplay(
                                  textStyle: Styles.customTitleTextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Sizes.TEXT_SIZE_18,
                                  ),
                                )),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(recipes[i]['total_time'] + ' prep',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.openSans(
                                            textStyle:
                                                Styles.customNormalTextStyle(
                                              color: Colors.black54,
                                              fontSize: Sizes.TEXT_SIZE_14,
                                            ),
                                          )),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: VerticalDivider(
                                          thickness: 1,
                                          width: 10,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text('Serves ' + '2, 4, 6',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.openSans(
                                            textStyle:
                                                Styles.customNormalTextStyle(
                                              color: Colors.black54,
                                              fontSize: Sizes.TEXT_SIZE_14,
                                            ),
                                          )),
                                      SizedBox(
                                        width: 2,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Text(
                                    recipes[i]['calories'] +
                                        ' (KCal) - ' +
                                        recipes[i]['total_time'] +
                                        ' Min',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                      textStyle: Styles.customNormalTextStyle(
                                        color: Colors.black54,
                                        fontSize: Sizes.TEXT_SIZE_12,
                                      ),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        centerTitle: false,
        backgroundColor: AppColors.secondaryElement,
        iconTheme: IconThemeData(color: AppColors.white),
        title: Text(
          'Recipes',
          style: Styles.customTitleTextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.TEXT_SIZE_18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 0.0),
            loader
                ? Column(
                    // options: CarouselOptions(
                    //     enableInfiniteScroll: true, height: 260),
                    children: List.generate(
                        5,
                        (ind) => Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 215,
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: SkeletonAnimation(
                                  shimmerColor: Colors.grey[350],
                                  shimmerDuration: 1100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                    ),
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                  ),
                                ),
                              ),
                            )))
                : Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 0.0),
                      // Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 12.0),
                      //     child: Text(
                      //       'Most Popular'.toUpperCase(),
                      //       textAlign: TextAlign.left,
                      //       style: Styles.customTitleTextStyle2(
                      //         color: Colors.black87,
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: Sizes.TEXT_SIZE_16,
                      //       ),
                      //     )),
                      SizedBox(height: 0.0),

                      // TravelCardList(
                      //   cities: resturants,
                      //   onCityChange: _handleCityChange,
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          children: popular(),
                        ),
                      ),
                      SizedBox(height: 0.0),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
