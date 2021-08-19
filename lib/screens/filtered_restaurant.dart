import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/foody_bite_card.dart';
import 'package:potbelly/widgets/spaces.dart';

class FilteredRestaurant extends StatefulWidget {
  var data;
  FilteredRestaurant({@required this.data});

  @override
  _FilteredRestaurantState createState() => _FilteredRestaurantState();
}

class _FilteredRestaurantState extends State<FilteredRestaurant> {
List bookmarks = [];
  bool loader = false;
  @override
  void initState() {
   bookmarks= widget.data;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        centerTitle: false,
        title: Text(
          'Filtered Restaurant',
          style: Styles.customTitleTextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.TEXT_SIZE_18,
          ),
        ),
        // actions: <Widget>[
        //   Container(
        //     margin: EdgeInsets.only(right: Sizes.MARGIN_16),
        //     child: InkWell(
        //       onTap: () {},
        //       child: Image.asset(
        //         ImagePath.searchIconBlue,
        //         color: AppColors.headingText,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: loader
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
              ),
            )
          : bookmarks.length == 0
              ? Center(
                  child: Container(
                    child: Text('No Restaurant'),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(
                    left: Sizes.MARGIN_8,
                    right: Sizes.MARGIN_8,
                    top: Sizes.MARGIN_8,
                  ),
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: bookmarks.length,
                    separatorBuilder: (context, index) {
                      return SpaceH8();
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        child: FoodyBiteCard(
                          tagRadius: 5,
                         cardElevation: 2,
                          onTap: () => Navigator.pushNamed(context,
                            AppRouter.restaurantDetailsScreen,
                            arguments: RestaurantDetails(
                                 imagePath: bookmarks[index].restImage,
                              restaurantName: bookmarks[index].restName,
                              restaurantAddress: bookmarks[index].restAddress +
                                  bookmarks[index].restCity +
                                  ' ' +
                                  bookmarks[index].restCountry,
                              rating: '0.0',
                              category: bookmarks[index].restType,
                              distance: '0 Km',
                              data: bookmarks[index]),
                          ),
                          bookmark: false,
                            imagePath: bookmarks[index].restImage,
                              cardTitle: bookmarks[index].restName,
                              address: bookmarks[index].restAddress +
                                  bookmarks[index].restCity +
                                  ' ' +
                                  bookmarks[index].restCountry,
                              rating: '0.0',
                              category: bookmarks[index].restType,
                              distance: '0 Km',
                             
                          
                          status:
                              bookmarks[index].restIsOpen == 1 ? "OPEN" : "CLOSE",
                         
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
