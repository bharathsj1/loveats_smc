import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/spaces.dart';

double newstarsrating;
class Ratings extends StatelessWidget {
  final String rating;

  Ratings(this.rating);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.kFoodyBiteSkyBlue,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: <Widget>[
          Image.asset(
            ImagePath.starIcon,
            height: Sizes.WIDTH_14,
            width: Sizes.WIDTH_14,
          ),
          SizedBox(width: Sizes.WIDTH_4),
          Text(
            rating,
            style: Styles.customTitleTextStyle(
              color: AppColors.headingText,
              fontWeight: FontWeight.w600,
              fontSize: Sizes.TEXT_SIZE_14,
            ),
          )
        ],
      ),
    );
  }
}

class RatingsBar extends StatefulWidget {
  RatingsBar({
    this.title = "Rating",
    this.hasSubtitle = true,
    this.subtitle = "Rate your experience",
    this.hasTitle = true,
    this.starsrating,
  });

  final String title;
  final bool hasTitle;
  final String subtitle;
  final bool hasSubtitle;
   double starsrating;

  @override
  _RatingsBarState createState() => _RatingsBarState();
}

class _RatingsBarState extends State<RatingsBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // hasTitle
        //     ? Text(
        //         title,
        //         style: Styles.customTitleTextStyle(
        //           color: AppColors.black,
        //           fontWeight: FontWeight.w600,
        //           fontSize: Sizes.TEXT_SIZE_20,
        //         ),
        //       )
        //     : Container(),
        // hasTitle ? SpaceH16() : Container(),
        Container(
          width: MediaQuery.of(context).size.width - 60,
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: AppColors.kFoodyBiteSkyBlue,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Center(
            child: RatingBar.builder(
              // ratingWidget: null,
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 35,
              glowColor: Colors.amber,
              glowRadius: 0.5,
              unratedColor: AppColors.kFoodyBiteGreyRatingStar,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
                widget.starsrating=rating;
               newstarsrating=rating;
                setState(() {
                  
                });
              },
            ),
          ),
        ),
        SpaceH12(),
        widget.hasSubtitle
            ? Text(
                widget.subtitle,
                style: Styles.customNormalTextStyle(
                  color: AppColors.grey,
                  fontSize: Sizes.TEXT_SIZE_16,
                ),
              )
            : Container(),
      ],
    );
  }
}
