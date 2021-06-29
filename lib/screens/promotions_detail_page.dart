import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/values/data.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/card_tags.dart';
import 'package:potbelly/widgets/dark_overlay.dart';
import 'package:potbelly/widgets/heading_row.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:potbelly/widgets/ratings_widget.dart';
import 'package:potbelly/widgets/spaces.dart';
import 'package:image_viewer/image_viewer.dart';

class PromotionDetailsScreen extends StatelessWidget {
  final PromotionDetails promotionDetails;

  PromotionDetailsScreen({@required this.promotionDetails});

  TextStyle addressTextStyle = Styles.customNormalTextStyle(
    color: AppColors.accentText,
    fontSize: Sizes.TEXT_SIZE_14,
  );

  TextStyle openingTimeTextStyle = Styles.customNormalTextStyle(
    color: Colors.red,
    fontSize: Sizes.TEXT_SIZE_14,
  );

  TextStyle subHeadingTextStyle = Styles.customTitleTextStyle(
    color: AppColors.headingText,
    fontWeight: FontWeight.w600,
    fontSize: Sizes.TEXT_SIZE_18,
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
  Widget build(BuildContext context) {
//    final promotionDetails args = ModalRoute.of(context).settings.arguments;
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
                        InkWell(
                          onTap: () {},
                          child: Positioned(
                            child: promotionDetails.image != null &&
                                    promotionDetails.image != ''
                                ? promotionDetails.image.substring(0, 4) ==
                                        'http'
                                    ? Image.network(
                                        promotionDetails.image,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: heightOfStack,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        promotionDetails.image,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: heightOfStack,
                                        fit: BoxFit.cover,
                                      )
                                : promotionDetails.thumnail.substring(0, 4) ==
                                        'http'
                                    ? Image.network(
                                        promotionDetails.thumnail,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: heightOfStack,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        promotionDetails.thumnail,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: heightOfStack,
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        ),
                        DarkOverLay(
                            gradient: Gradients.promotionDetailsGradient),
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
                                // SpaceW20(),
                                // InkWell(
                                //   child: Image.asset(ImagePath.bookmarksIcon,
                                //       color: Colors.white),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              color: Colors.black45,
                              padding: EdgeInsets.fromLTRB(20, 13, 20, 0),
                              child: Text(
                                promotionDetails.name,
                                textAlign: TextAlign.left,
                                style: Styles.customTitleTextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: Sizes.TEXT_SIZE_20,
                                ),
                              ),
                            ))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        children: <Widget>[
                          SpaceH24(),
                          HeadingRow(
                            title: StringConst.Description,
                            number: '',
                            // onTapOfNumber: () => AppRouter.navigator
                            //     .pushNamed(AppRouter.reviewRatingScreen),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(promotionDetails.description)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              PotbellyButton(
                'Buy Subscription',
                // onTap: () =>
                //     AppRouter.navigator.pushNamed(AppRouter.addRatingsScreen,arguments: promotionDetails.data['id'] ),
                buttonHeight: 65,
                buttonWidth: MediaQuery.of(context).size.width,
                decoration: Decorations.customHalfCurvedButtonDecoration(
                  topleftRadius: Sizes.RADIUS_24,
                  topRightRadius: Sizes.RADIUS_24,
                ),
              ),
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
}
