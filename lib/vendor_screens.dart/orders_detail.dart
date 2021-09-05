import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/ServiceProvider.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/vendor_screens.dart/open_direction.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class OrdersDetails extends StatefulWidget {
  var orderdata;
  OrdersDetails({@required this.orderdata});

  @override
  _OrdersDetailsState createState() => _OrdersDetailsState();
}

class _OrdersDetailsState extends State<OrdersDetails> {
  TextStyle subHeadingTextStyle = Styles.customTitleTextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w600,
    fontSize: Sizes.TEXT_SIZE_18,
  );
  TextStyle addressTextStyle = Styles.customNormalTextStyle(
    color: AppColors.accentText,
    fontSize: Sizes.TEXT_SIZE_14,
  );

  String accounttype = '';
  bool loader = false;

  @override
  void initState() {
    gettype();
    super.initState();
  }

  gettype() async {
    accounttype = await AppService().gettype();
    print(accounttype);
    setState(() {});
  }


   ingredient() {
     print(widget.orderdata);
    var ingridient = widget.orderdata['receipe']['ingridients'];
    print(ingridient);
    var personselect = widget.orderdata['person_quantity'];
    return List.generate(
        ingridient.length,
        (i) => Column(
              children: [
                Divider(
                  thickness: 0.3,
                  color: Colors.black54,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ingridient[i]['ingridient']['name'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: Styles.customNormalTextStyle(
                            color: Colors.black,
                            fontSize: Sizes.TEXT_SIZE_14,
                          ),
                        )),
                    Text(
                        (personselect == '1'
                                ? ingridient[i]['three_person_quantity']
                                : personselect == '2'
                                    ? ingridient[i]['four_person_quantity']
                                    : ingridient[i]['two_person_quantity']) +
                            ' ' +
                            ingridient[i]['ingridient']['unit'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: Styles.customNormalTextStyle(
                              color: AppColors.secondaryElement,
                              fontSize: Sizes.TEXT_SIZE_14,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ));
  }

  List<Widget> card() {
    return List.generate(
        widget.orderdata['order_detail'].length,
        (i) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300],
                  width: 0.5,
                ),
              )),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        widget.orderdata['order_detail'][i]['rest_menu']
                            ['menu_image'],
                        loadingBuilder: (BuildContext ctx, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Container(
                              // height: ,
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
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Text(
                        widget.orderdata['order_detail'][i]['rest_menu']
                            ['menu_name'],
                        style: subHeadingTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${StringConst.currency}' +
                              widget.orderdata['order_detail'][i]
                                  ['total_price'],
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
                            widget.orderdata['order_detail'][0]['rest_menu']
                                ['menu_details'],
                            style: addressTextStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          DateFormat.yMMMMd('en_US')
                              .format(DateTime.parse(widget
                                  .orderdata['order_detail'][i]['created_at']))
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
                            'Quantity: ' +
                                widget.orderdata['order_detail'][i]['quantity'],
                            style: addressTextStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            DateFormat.Hm()
                                .format(DateTime.parse(
                                    widget.orderdata['order_detail'][i]
                                        ['created_at']))
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
            ));
  }

  _onAlertButtonsPressed(context, type, Api, detail) {
    //  StatefulBuilder(
    //       builder: (BuildContext context, StateSetter setState) {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "Are you sure?",
      desc: detail,
      buttons: [
        DialogButton(
          child: Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.grey,
        ),
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () async {
             if (Api == 'superadmin&vendor') {
                 var data = {
                'order_id': widget.orderdata['id'],
                'super_admin_status': type
              };
              Navigator.pop(context);
              loader = true;
              setState(() {});
              AppService().setsuperadmin(data).then((value) {
                print(value);
                if (value['message'].contains('Successfully')) {
                  
                  print('done');
                  if (type == 'approved') {
                     var data01 = {'order_id': widget.orderdata['id'], 'status': 'ready'};
                    AppService().setorderstatus(data01).then((value) {
                      print(value);
                    });
                    var data = {
                      'title': 'Order Approved',
                      'body':
                          'Your recipe order has been approved by admin.',
                      // 'data': value.toString(),
                      'user_id': widget.orderdata['customer_id']
                    };
                    AppService().sendnotispecificuser(data);
                     var data2 = {
                      'title': 'New Recipe Order to Deliver',
                      'body': 'Order#'+widget.orderdata['id'].toString()+' was assigned you to deliver',
                      // 'data': value.toString(),
                      // 'user_id': widget.orderdata['customer_id']
                    };
                    AppService().sendnotideliveryboy(data2);
                    Provider.of<ServiceProvider>(context, listen: false)
                          .getorders();
                  } else {
                    var data = {
                      'title': 'Order Rejected',
                      'body': 'Your order has been reject by admin',
                      // 'data': value.toString(),
                      'user_id': widget.orderdata['customer_id']
                    };
                    AppService().sendnotispecificuser(data);
                  }
                  widget.orderdata['super_admin'] = type;
                  loader = false;
                  setState(() {});
                  Provider.of<ServiceProvider>(context, listen: false)
                          .getorders();
                }
              });
             }
           else if (Api == 'superadmin') {
              var data = {
                'order_id': widget.orderdata['id'],
                'super_admin_status': type
              };
              Navigator.pop(context);
              loader = true;
              setState(() {});
              AppService().setsuperadmin(data).then((value) {
                print(value);
                if (value['message'].contains('Successfully')) {
                  print('done');
                  if (type == 'approved') {
                    var data = {
                      'title': 'Order Approved',
                      'body':
                          'Your order has been approved by admin. Your order will be ready in few minutes',
                      // 'data': value.toString(),
                      'user_id': widget.orderdata['customer_id']
                    };
                    AppService().sendnotispecificuser(data);
                    print(widget.orderdata['rest_details']);
                     var data2 = {
                        'title': 'New Order',
                        'body':
                            'Order#'+widget.orderdata['id'].toString()+' was assigned to you',
                        // 'title': 'Order Delivered',
                        // 'body': 'Thanks for ordering, Enjoy you meal',
                        // 'data': value.toString(),
                        'user_id': widget.orderdata['order_detail'][0]['rest_details']['user_id']
                      };
                       
                      AppService().sendnotispecificuser(data2);
                       loader = false;

                  setState(() {});
                  Provider.of<ServiceProvider>(context, listen: false)
                          .getorders();
                  } else {
                    var data = {
                      'title': 'Order Rejected',
                      'body': 'Your order has been reject by admin',
                      // 'data': value.toString(),
                      'user_id': widget.orderdata['customer_id']
                    };
                    AppService().sendnotispecificuser(data);
                  }
                  widget.orderdata['super_admin'] = type;
                  loader = false;
                  setState(() {});
                  Provider.of<ServiceProvider>(context, listen: false)
                          .getorders();
                }
              });
            } else {
              var data = {'order_id': widget.orderdata['id'], 'status': type};
              Navigator.pop(context);
              loader = true;
              setState(() {});
              if (type == 'ready') {
                AppService().setorderstatus(data).then((value) {
                  print(value);
                  if (value['message'].contains('Successfully')) {
                    print('done');

                    var data = {
                      'title': 'Order Ready',
                      'body': 'Your order is ready to deliver',
                      // 'data': value.toString(),
                      'user_id': widget.orderdata['customer_id']
                    };
                    AppService().sendnotispecificuser(data);
                    var data2 = {
                      'title': 'New Order to Deliver',
                      'body': 'Order#'+widget.orderdata['id'].toString()+' was assigned you to deliver',
                      // 'data': value.toString(),
                      // 'user_id': widget.orderdata['customer_id']
                    };
                    AppService().sendnotideliveryboy(data2);
                    Provider.of<ServiceProvider>(context, listen: false)
                          .getorders();
                  }
                });
              } else if (type == 'onway') {
                var location = await _determinePosition();
                print(location);
                if (location != null) {
                  AppService().setorderstatus(data).then((value) {
                    print(value);
                    if (value['message'].contains('Successfully')) {
                      var data = {
                        'title': 'Out for Delivery',
                        'body':
                            'You can track live location of the order in orders list section',
                        // 'title': 'Order Delivered',
                        // 'body': 'Thanks for ordering, Enjoy you meal',
                        // 'data': value.toString(),
                        'user_id': widget.orderdata['customer_id']
                      };
                      AppService().sendnotispecificuser(data);
                      Provider.of<ServiceProvider>(context, listen: false)
                          .getorders();
                    }
                  });
                   SharedPreferences pref = await SharedPreferences.getInstance();
                    pref.setBool('driving', true);
                    pref.setString('drivingorder', jsonEncode(widget.orderdata));
                  // Navigator.pushNamed(context, AppRouter.Opendirection,
                  //     arguments: {
                  //       'lat': double.parse(
                  //           widget.orderdata['user_address']['user_latitude']),
                  //       'long': double.parse(
                  //           widget.orderdata['user_address']['user_longitude']),
                  //       'clat': location.latitude,
                  //       'clong': location.longitude,
                  //       'data': widget.orderdata,
                  //       'driving': true
                  //     });
                  Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
                builder: (_) => Open_direction(desdirection:  {
                        'lat': double.parse(
                            widget.orderdata['user_address']['user_latitude']),
                        'long': double.parse(
                            widget.orderdata['user_address']['user_longitude']),
                        'clat': location.latitude,
                        'clong': location.longitude,
                        'data': widget.orderdata,
                        'driving': true
                      })), (route) => false);
                }
              }
              widget.orderdata['status'] = type;
              loader = false;
              setState(() {});
              // Navigator.pop(context);

            }
          },
          color: AppColors.secondaryElement,
        )
      ],
    ).show();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Toast.show(
          'Location services are disabled. Turn on your location', context,
          duration: 4);
      // return Future.error('Location services are disabled.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Toast.show(
            'Location permissions are denied. Turn on your location', context,
            duration: 4);
        // return Future.error('Location permissions are denied');
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Toast.show(
          'Location permissions are permanently denied, we cannot request permissions. Turn on your location',
          context,
          duration: 4);
      // return Future.error(
      //   'Location permissions are permanently denied, we cannot request permissions.');
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.secondaryElement),
        elevation: 0,
        title: Text(
          'Order Details',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'roboto',
              color: AppColors.secondaryElement),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(
            color: Colors.grey[300],
            width: 0.5,
          ),
        )),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: loader
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.secondaryElement),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            color: AppColors.secondaryElement,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'roboto',
                            fontSize: Sizes.TEXT_SIZE_20,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${StringConst.currency}' + widget.orderdata['total_amount'],
                          style: TextStyle(
                            color: AppColors.secondaryElement,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'roboto',
                            fontSize: Sizes.TEXT_SIZE_20,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    accounttype == '0'
                        ? widget.orderdata['super_admin'] != null
                            ? PotbellyButton(toBeginningOfSentenceCase(widget.orderdata['super_admin']).toString(),
                                buttonHeight: 50,
                                buttonTextStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey.withOpacity(0.8)),
                                onTap: () {})
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  PotbellyButton('Reject',
                                      buttonHeight: 50,
                                      buttonWidth:
                                          MediaQuery.of(context).size.width /
                                              2.5,
                                      buttonTextStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.red[500]), onTap: () {
                                   widget.orderdata['is_receipe']==1?   _onAlertButtonsPressed(
                                        context,
                                        'rejected',
                                        'superadmin&vendor',
                                        "Do you want to reject this order?"):  _onAlertButtonsPressed(
                                        context,
                                        'rejected',
                                        'superadmin',
                                        "Do you want to reject this order?");
                                  }),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  PotbellyButton('Accept',
                                      buttonHeight: 50,
                                      buttonWidth:
                                          MediaQuery.of(context).size.width /
                                              2.5,
                                      buttonTextStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: AppColors.secondaryElement),
                                      onTap: () {
                                 widget.orderdata['is_receipe']==1? 
                                       _onAlertButtonsPressed(
                                        context,
                                        'approved',
                                        'superadmin&vendor',
                                        "Do you want to accept this order?"):
                                      _onAlertButtonsPressed(
                                        context,
                                        'approved',
                                        'superadmin',
                                        "Do you want to accept this order?");
                                  }),
                                ],
                              )
                        : accounttype == '4'
                            ? widget.orderdata['status'] != null
                                ? PotbellyButton(toBeginningOfSentenceCase(widget.orderdata['status'].toString()),
                                    buttonHeight: 50,
                                    buttonTextStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.grey.withOpacity(0.8)),
                                    onTap: () {
                                    print(1);
                                  })
                                : PotbellyButton('Ready',
                                    buttonHeight: 50,
                                    buttonTextStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.secondaryElement),
                                    onTap: () {
                                    print(2);
                                    _onAlertButtonsPressed(context, 'ready',
                                        'status', 'Food is ready to deliver?');
                                  })
                            : accounttype == '3'
                                ? widget.orderdata['status'] == 'delivered'
                                    ? PotbellyButton(
                                        toBeginningOfSentenceCase(widget
                                            .orderdata['status']
                                            .toString()),
                                        buttonHeight: 50,
                                        buttonTextStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color:
                                                Colors.grey.withOpacity(0.8)),
                                        // onTap: () {}
                                      )
                                    : PotbellyButton('Start Driving',
                                        buttonHeight: 50,
                                        buttonTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.secondaryElement), onTap: () {
                                        _onAlertButtonsPressed(
                                            context,
                                            'onway',
                                            'status',
                                            'Do you wants to start driving?');
                                      })
                                // PotbellyButton('Delivered',
                                //     buttonHeight: 50,
                                //     buttonTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.secondaryElement), onTap: () {
                                //     _onAlertButtonsPressed(
                                //         context,
                                //         'delivered',
                                //         'status',
                                //         'Food has been delivered to the customer?');
                                //   })
                                : Container(),
                  ],
                ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Material(
                elevation: 1,
                child: Container(
                  padding: EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    leading: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Color(0xFFDFE0E4),
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            Icons.history,
                            color: Colors.black,
                          ),
                        )),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          // color: Colors.red,
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Text(
                            'Order #' + widget.orderdata['id'].toString(),
                            style: subHeadingTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${StringConst.currency}' + (double.parse(widget.orderdata['total_amount'])).toStringAsFixed(2),
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
                            Text(
                              'Payment Method: ' +
                                  widget.orderdata['payment_method'],
                              style: addressTextStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              DateFormat.yMMMMd('en_US')
                                  .format(DateTime.parse(
                                      widget.orderdata['created_at']))
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
                           widget.orderdata['is_receipe']==1?     'Recipe: ' +
                                 widget.orderdata['quantity']+'x'   :   'Items: ' +
                                    widget.orderdata['order_detail'].length
                                        .toString(),
                                style: addressTextStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                DateFormat.Hm()
                                    .format(DateTime.parse(
                                        widget.orderdata['created_at']))
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
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_pin,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Customer',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'roboto'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        toBeginningOfSentenceCase(
                            widget.orderdata['user_address']['name']),
                        style: TextStyle(
                            fontSize: 20,
                            // fontWeight: FontWeight.bold,
                            fontFamily: 'roboto',
                            color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Color(0xFFDFE0E4),
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.person_outline,
                              // size: 16,
                              color: Colors.black54,
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          widget.orderdata['user_address']['address'] +
                              ', ' +
                              widget.orderdata['user_address']['city'] +
                              ', ' +
                              widget.orderdata['user_address']['country'],
                          style: TextStyle(
                              fontSize: 20,
                              // fontWeight: FontWeight.bold,
                              fontFamily: 'roboto',
                              color: Colors.black87),
                          // maxLines: 1,
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: InkWell(
                            onTap: () async {
                              // LocationData currentLocation;
                              // Location location;
                              // currentLocation = await location.getLocation();
                              if (accounttype == '3') {
                                var location = await _determinePosition();
                                print(location);
                                if (location != null) {
                                  Navigator.pushNamed(
                                      context, AppRouter.Opendirection,
                                      arguments: {
                                        'lat': double.parse(
                                            widget.orderdata['user_address']
                                                ['user_latitude']),
                                        'long': double.parse(
                                            widget.orderdata['user_address']
                                                ['user_longitude']),
                                        'clat': location.latitude,
                                        'clong': location.longitude,
                                        'data': widget.orderdata,
                                        'driving': false
                                      });
                                }
                                //  Navigator.pushNamed(
                                //     context, AppRouter.Open_maps,
                                //     arguments: {
                                //       'lat': double.parse(
                                //           widget.orderdata['user_address']
                                //               ['user_latitude']),
                                //       'long': double.parse(
                                //           widget.orderdata['user_address']
                                //               ['user_longitude']),
                                //       'address':
                                //           widget.orderdata['user_address']
                                //                   ['address'] +
                                //               ', ' +
                                //               widget.orderdata['user_address']
                                //                   ['city'] +
                                //               ', ' +
                                //               widget.orderdata['user_address']
                                //                   ['country'],
                                //     });
                              
                              } else {
                                Navigator.pushNamed(
                                    context, AppRouter.Open_maps,
                                    arguments: {
                                      'lat': double.parse(
                                          widget.orderdata['user_address']
                                              ['user_latitude']),
                                      'long': double.parse(
                                          widget.orderdata['user_address']
                                              ['user_longitude']),
                                      'address':
                                          widget.orderdata['user_address']
                                                  ['address'] +
                                              ', ' +
                                              widget.orderdata['user_address']
                                                  ['city'] +
                                              ', ' +
                                              widget.orderdata['user_address']
                                                  ['country'],
                                    });
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Color(0xFFDFE0E4),
                                  borderRadius: BorderRadius.circular(100)),
                              child: Icon(
                                Icons.directions_outlined,
                                // size: 16,
                                color: Colors.black54,
                              ),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.orderdata['user_address']['phone_no'],
                        style: TextStyle(
                            fontSize: 20,
                            // fontWeight: FontWeight.bold,
                            fontFamily: 'roboto',
                            color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.phone,
                              // size: 16,
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.fastfood_outlined,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                      widget.orderdata['is_receipe']==1? 'Recipe Ordered':  'Food Ordered',
                        style: TextStyle(
                            fontSize: 20,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'roboto'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                 widget.orderdata['is_receipe']==1?  Padding(
                   padding: const EdgeInsets.only(bottom:10.0),
                   child: Column(
                        children: ingredient(),
                      ),
                 ):
                  Column(
                    children: card(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
