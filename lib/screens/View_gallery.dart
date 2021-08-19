import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';

class ViewGallery extends StatefulWidget {
   var data;
  ViewGallery({@required this.data});

  @override
  _ViewGalleryState createState() => _ViewGalleryState();
}

class _ViewGalleryState extends State<ViewGallery> {
  List ratings = [];
  bool rloader = true;
  @override
  void initState() {
    print(widget.data.id);
    getreviews();
    super.initState();
  }

  getreviews() async {
    var response = await AppService().getrestratings(widget.data.id.toString());
    ratings = response['data'];
    rloader = false;
    print(response);
    setState(() {});
  }

  postlist() {
    return List.generate(
      ratings.length,
      (i) => InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRouter.Post_view, arguments: ratings);
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1.5, color: Colors.black)),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: StringConst.BASE_imageURL + ratings[i]['image'],
                width: (MediaQuery.of(context).size.width / 2) - 3,
                height: (MediaQuery.of(context).size.width / 2) - 3,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: Container(
                    // height: 150,

                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.secondaryElement),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 4,
                          // offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      // color: Colors.black.withOpacity(0.5),
                    ),
                    height: 30,
                    width: (MediaQuery.of(context).size.width / 2) - 3,
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Padding(
                           padding: const EdgeInsets.only(left:4.0),
                           child: Row(
                            children: [
                              CircleAvatar(
              radius: 9,
              backgroundColor: Colors.grey,
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/andy.png'),
                                      
                                  backgroundColor: Colors.transparent,
                                  minRadius: Sizes.RADIUS_8,
                                  maxRadius: Sizes.RADIUS_8,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              
                                   Text(
                                      toBeginningOfSentenceCase(
                                            ratings[i]['user']['cust_first_name']) ,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white))
                                 
                            ],
                        ),
                         ),
                      
                        RatingBar.builder(
                          // ratingWidget: null,
                          initialRating: double.parse(ratings[i]['rating']),
                          // minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          updateOnDrag: false,
                          itemCount: 5,
                          itemSize: 10,
                          glowColor: Colors.amber,
                          glowRadius: 0.5,
                          unratedColor: AppColors.kFoodyBiteGreyRatingStar,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: null
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        title: Text(
          'Gallery',
          style: TextStyle(color: AppColors.black),
        ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              children: postlist(),
            )
          ],
        ),
      ),
    );
  }
}
