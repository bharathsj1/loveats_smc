import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class PostView extends StatefulWidget {
  var postdata;
  PostView({@required this.postdata});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  SharedPreferences prefs;
  var postdata;
  @override
  void initState() {
    super.initState();
    checkuserlikes();
    getUserDetail();
  }

  getUserDetail() async {
    prefs = await Service().initializdPrefs();
    // this.postdata=widget.postdata;
    setState(() {});
  }

  checkuserlikes() async {
    int userId = await Service().getUserId_int();
    for (var j = 0; j < widget.postdata.length; j++) {
      for (var i = 0; i < widget.postdata[j]['likes'].length; i++) {
        if (widget.postdata[j]['likes'][i]['user_id'] == userId &&
            widget.postdata[j]['likes'][i]['is_like'] == 1) {
          widget.postdata[j]['Is_liked'] = true;
          break;
        }
      }
    }
  }

  postlist() {
    var ratings = widget.postdata;
    return List.generate(
        ratings.length,
        (i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/andy.png'),
                              backgroundColor: Colors.transparent,
                              minRadius: Sizes.RADIUS_14,
                              maxRadius: Sizes.RADIUS_14,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            prefs != null
                                ? Text(
                                    toBeginningOfSentenceCase(ratings[i]['user']
                                            ['cust_first_name']) ??
                                        'Not Available',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    color: AppColors.white,
                    height: 350,
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      imageUrl: StringConst.BASE_imageURL + ratings[i]['image'],
                      height: 350,
                      width: MediaQuery.of(context).size.width,
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
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  ratings[i]['Is_liked'] =
                                      ratings[i]['Is_liked'] != null
                                          ? !ratings[i]['Is_liked']
                                          : true;
                                  // print(ratings);
                                  setState(() {});
                                  like(ratings[i]);
                                },
                                child: Icon(
                                  ratings[i]['Is_liked'] != null &&
                                          ratings[i]['Is_liked']
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  color: ratings[i]['Is_liked'] != null &&
                                          ratings[i]['Is_liked']
                                      ? Colors.red
                                      : Colors.grey.shade600,
                                  size: 28,
                                )),
                            SizedBox(
                              width: 12,
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.pushNamed(context, AppRouter.Add_post_comments,arguments: ratings[i]);
                              },
                                child: Container(
                                    child: Icon(
                              Icons.messenger_outline_sharp,
                              color: Colors.grey.shade600,
                              size: 24,
                            ))),
                            SizedBox(
                              width: 12,
                            ),
                            Icon(
                              Icons.share_outlined,
                              color: Colors.grey.shade600,
                              size: 24,
                            ),
                          ],
                        ),
                        Icon(
                          Icons.bookmark_border,
                          color: Colors.grey.shade600,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ratings[i]['likes'].length > 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                              'Liked by ${ratings[i]['likes'].length} users',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                        )
                      : Container(),
                  SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        prefs != null
                            ? Text(
                                toBeginningOfSentenceCase(
                                            prefs.getString('name')) +
                                        ':' ??
                                    'Not Available',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))
                            : Container(),
                        //   SizedBox(width: 4,),
                        // ratings[i]['comment'] !=null ||  ratings[i]['comment'] !=''?  Text(
                        //       toBeginningOfSentenceCase(
                        //               ratings[i]['comment']),
                        //       style: TextStyle(
                        //           fontSize: 12,

                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.black)):Container()
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  like(reviewdata) async {
    var data = {
      'review_id': reviewdata['id'],
      // 'Is_liked': reviewdata['Is_liked'] ? 1:0,
      'is_like': reviewdata['Is_liked'] ? 1 : 0
    };
    print(data);
    AppService().likepost(data).then((value) {
      print(value);
      if (value['success'] == true) {
      } else {
        // Toast.show('error', context, duration: 3);
        print('error');
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        title: Text(
          'Posts',
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
            SizedBox(
              height: 0,
            ),
            Column(
              children: postlist(),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
