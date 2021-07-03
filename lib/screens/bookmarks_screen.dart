import 'package:potbelly/services/bookmarkservice.dart';
import 'package:potbelly/values/values.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/widgets/foody_bite_card.dart';
import 'package:potbelly/widgets/spaces.dart';

class BookmarksScreen extends StatefulWidget {
  static const int TAB_NO = 1;

  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List bookmarks = [];
  bool loader = true;
  @override
  void initState() {
    getbookmark();
    super.initState();
  }

  getbookmark() async {
    bookmarks = await BookmarkService().getbookmarklist();
    print(bookmarks);
    loader = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'My Favourite',
          style: Styles.customTitleTextStyle(
            color: AppColors.headingText,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.TEXT_SIZE_22,
          ),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: Sizes.MARGIN_16),
            child: InkWell(
              onTap: () {},
              child: Image.asset(
                ImagePath.searchIconBlue,
                color: AppColors.headingText,
              ),
            ),
          ),
        ],
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
                    child: Text('No Bookmarks'),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(
                    left: Sizes.MARGIN_16,
                    right: Sizes.MARGIN_16,
                    top: Sizes.MARGIN_16,
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
                          onTap: () => AppRouter.navigator.pushNamed(
                            AppRouter.restaurantDetailsScreen,
                            arguments: RestaurantDetails(
                                imagePath: bookmarks[index]['image'],
                                restaurantName: bookmarks[index]['name'],
                                restaurantAddress: bookmarks[index]['address'] +
                                    ' ' +
                                    bookmarks[index]['city'] +
                                    ' ' +
                                    bookmarks[index]['country'],
                                rating: bookmarks[index]['ratings'],
                                category: bookmarks[index]['type'],
                                distance: bookmarks[index]['distance'],
                                data: bookmarks[index]),
                          ),
                          bookmark: true,
                          imagePath: bookmarks[index]['image'],
                          status:
                              bookmarks[index]['open'] == 1 ? "OPEN" : "CLOSE",
                          cardTitle:
                              bookmarks[index]['name'] ?? 'Not Available',
                          rating:
                              bookmarks[index]['ratings'] ?? 'Not Available',
                          category: bookmarks[index]['type'] ?? 'Not Available',
                          distance:
                              bookmarks[index]['distance'] ?? 'Not Available',
                          address: bookmarks[index]['address'] ??
                              'Not Available' +
                                  ' ' +
                                  bookmarks[index]['city'] +
                                  ' ' +
                                  bookmarks[index]['country'],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
