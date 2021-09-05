import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/ServiceProvider.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/firebaseSetup.dart';
import 'package:potbelly/values/values.dart';
import 'package:provider/provider.dart';

class Vendor_Home_screen extends StatefulWidget {
  static const int TAB_NO = 0;
  const Vendor_Home_screen({Key key}) : super(key: key);

  @override
  _Vendor_Home_screenState createState() => _Vendor_Home_screenState();
}

class _Vendor_Home_screenState extends State<Vendor_Home_screen> {
  // List orderslist = [];
  bool loader = true;
  bool reloader = true;
  TextStyle subHeadingTextStyle = Styles.customTitleTextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w600,
    fontSize: Sizes.TEXT_SIZE_18,
  );
  TextStyle addressTextStyle = Styles.customNormalTextStyle(
    color: AppColors.accentText,
    fontSize: Sizes.TEXT_SIZE_14,
  );

  //  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // var token;
  //   _register() {
  //   _firebaseMessaging.getToken().then((tokeen) {
  //     print(tokeen);
  //     this.token = tokeen;
  //     print(token);
  //   });
  // }

  @override
  void initState() {
      Provider.of<ServiceProvider>(context, listen: false)
                          .getUserDetail();
     FirebaseSetup().configureFirebase(context);
    //  _register();
    // getorders();
   
     Provider.of<ServiceProvider>(context, listen: false)
                          .getorders();
    super.initState();
  }

  getorders() async {
    var orders = await AppService().getOrdersRestaurent();
    print(orders);
    // orderslist = orders['data'];
    // print(orderslist);
    loader = false;
    reloader = false;
    setState(() {});
  }

  List<Widget> card(orderslist) {
    return List.generate(
        orderslist.length,
        (i) => InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRouter.OrdersDetailScreen,
                        arguments: orderslist[i])
                    .then((value) {
                  setState(() {
                    reloader = true;
                    // getorders();

                    Provider.of<ServiceProvider>(context, listen: false)
                          .getorders();
                  });
                });
              },
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                       orderslist[i]['is_receipe']==1? orderslist[i]['receipe']['image']:  orderslist[i]['order_detail'][0]['rest_menu']
                              ['menu_image'],
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Container(
                                width: 50,
                                height: 50,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.secondaryElement),
                                  ),
                                ),
                              );
                            }
                          },
                          fit: BoxFit.cover,
                          height: 50,
                          width: 50,
                        )),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        // color: Colors.red,
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: Text(
                        orderslist[i]['is_receipe']==1? orderslist[i]['receipe']['title'] : orderslist[i]['order_detail'][0]['rest_menu']
                              ['menu_name'],
                          style: subHeadingTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                          orderslist[i]['is_receipe']==1? '${StringConst.currency}' +
                                orderslist[i]['total_amount']: '${StringConst.currency}' +
                                orderslist[i]['order_detail'][0]['total_price'],
                            style: TextStyle(
                              color: AppColors.secondaryElement,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'roboto',
                              fontSize: Sizes.TEXT_SIZE_16,
                            ),
                          ),

                          // Ratings(ratings[i]),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: Text(
                            orderslist[i]['is_receipe']==1? orderslist[i]['receipe']['short_description']:  orderslist[i]['order_detail'][0]['rest_menu']
                                  ['menu_details'],
                              style: addressTextStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            DateFormat.yMMMMd('en_US')
                                .format(
                                    DateTime.parse(orderslist[i]['created_at']))
                                .toString(),
                            style: addressTextStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                            orderslist[i]['is_receipe']==1?'Quantity: ' + orderslist[i]['quantity']:  'Quantity: ' + 
                                  orderslist[i]['order_detail'][0]['quantity'],
                              style: addressTextStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              DateFormat.Hm()
                                  .format(DateTime.parse(
                                      orderslist[i]['created_at']))
                                  .toString(),
                              style: addressTextStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
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
    return Consumer<ServiceProvider>(builder: (context, service, child) {
    return Scaffold(
      
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text(
          'Orders'.toUpperCase(),
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'roboto',
              color: AppColors.secondaryElement),
        ),
        actions: [
          Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: InkWell(
                                    onTap: () async {
                                      // _isGuest = await Service().isGuest();
                                      // // print(_isGuest);
                                      // // return;
                                      // if (!_isGuest) {
                                        Navigator.pushNamed(
                                          context,
                                          AppRouter.New_profile_screen,
                                        );
                                      // } else
                                      //   _askLoginDialog(context);

                                      // setState(() {});
                                    },
                                    // child: Icon(
                                    //   Icons.person,
                                    //   color: AppColors.black,
                                    //   size: 22,
                                    // )
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/images/andy.png'),
                                        backgroundColor: Colors.transparent,
                                        minRadius: Sizes.RADIUS_16,
                                        maxRadius: Sizes.RADIUS_16,
                                      ),
                                    ),
                                  ),
                                ),
                          
        ],
      ),
      
      body: service.loader
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
              ),
            )
          : service.reloader
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.secondaryElement),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Reloading...',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'roboto',
                            color: AppColors.secondaryElement),
                      ),
                    ],
                  ),
                )
              : service.orderslist.length == 0
                  ? Center(
                      child: Container(
                        child: Text('No order available'),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Column(
                            children: card(service.orderslist),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
    );
    });
  }
}
