import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/ServiceProvider.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:potbelly/widgets/spaces.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySocial extends StatefulWidget {
  const MySocial({ Key key }) : super(key: key);

  @override
  _MySocialState createState() => _MySocialState();
}

class _MySocialState extends State<MySocial> {
  // SharedPreferences prefs;
  List ratings = [];
  bool rloader = true;

  @override
  void initState() {
    getreviews();
    super.initState();
  }

  
  getreviews() async {
    var response = await AppService().getratings();
    ratings = response['data'];
    rloader = false;
    print(response);
    setState(() {});
  }


   getUserDetail() async {
    // prefs = await Service().initializdPrefs();
  }
  @override
  Widget build(BuildContext context) {
     return Consumer<ServiceProvider>(builder: (context, service, child) {
    return Scaffold(
       appBar: AppBar(
          elevation: 1.5,
          // centerTitle: true,
          title: Text(
            'Home',
            style: Styles.customTitleTextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
              fontSize: Sizes.TEXT_SIZE_22,
            ),
          ),
        ),

        body: SingleChildScrollView(child: Column(children: [
          SizedBox(height: 10,),
          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    service.userData['profile_picture'] !=null && service.userData['profile_picture'].isNotEmpty
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(StringConst.BASE_imageURL+ service.userData['profile_picture']),
                                            backgroundColor: Colors.transparent,
                                            minRadius: 50,
                                            maxRadius: 50,
                                          )
                                        : CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/andy.png'),
                                            backgroundColor: Colors.transparent,
                                            minRadius: 50,
                                            maxRadius: 50,
                                          ),
                                    IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          detail(number: "50", text: "Reviews"),
                                          VerticalDivider(
                                            width: Sizes.WIDTH_40,
                                            thickness: 1.0,
                                          ),
                                          detail(
                                              number: "100k",
                                              text: "Followers"),
                                          VerticalDivider(
                                            width: Sizes.WIDTH_40,
                                            thickness: 1.0,
                                          ),
                                          detail(
                                              number: "30", text: "Following"),
                                          SpaceH24(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    toBeginningOfSentenceCase(
                                            service.prefs.getString('name')) ??
                                        'Not Available',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    toBeginningOfSentenceCase(
                                            'My first priority will always be food because it is the only thing which gives us the energy to live.') ??
                                        'Not Available',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black54)),
                                SizedBox(
                                  height: 15,
                                ),
                                Center(
                                  child: PotbellyButton(
                                    'Edit Profile',
                                    onTap: () {},
                                    buttonHeight: 42,
                                    buttonWidth:
                                        MediaQuery.of(context).size.width *
                                            0.90,
                                    buttonTextStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            width: 0.5, color: Colors.grey),
                                        color: Colors.transparent),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                )
                              ],
                            ),
                          ),
                       
                  Divider(
                            height: 1.5,
                            thickness: 2.0,
                            color: Colors.black87,
                          ),
                      
                     Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: rloader
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Image.asset(
                                            'assets/images/loader.gif',
                                            height: 80,
                                            width: 80,
                                          )),
                                    ),
                                  )
                                : ratings.length == 0
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(
                                            'No Post Available',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    : Wrap(children: postlist()),
                          )
                       
        ],),),
    
    );
     });
  }


    Widget detail({@required String number, @required String text}) {
    return Container(
      child: Column(
        children: [
          Text(
            number,
            style: Styles.customNormalTextStyle(
                color: AppColors.secondaryElement,
                fontWeight: FontWeight.w600,
                fontSize: Sizes.TEXT_SIZE_18),
          ),
          SizedBox(height: 8.0),
          Text(text, style: Styles.foodyBiteSubtitleTextStyle),
        ],
      ),
    );
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
          child: CachedNetworkImage(
            imageUrl: StringConst.BASE_imageURL + ratings[i]['image'],
            width: (MediaQuery.of(context).size.width / 3) - 3,
            height: (MediaQuery.of(context).size.width / 3) - 3,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: Container(
                // height: 150,

                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }


}