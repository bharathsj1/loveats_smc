import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';

class Myorder_Detail extends StatefulWidget {
  var orderdata;
  Myorder_Detail({@required this.orderdata});

  @override
  _Myorder_DetailState createState() => _Myorder_DetailState();
}

class _Myorder_DetailState extends State<Myorder_Detail> {

  @override
  void initState() {
    print(widget.orderdata);
    super.initState();
  }
  

  progressdetail(status,icon, date, title, body, dates, color) {
    return Row(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
              color:status? color: Colors.grey[350], borderRadius: BorderRadius.circular(100)),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 22,
          ),
        ),
        SizedBox(
          width: 25,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: status? Colors.grey[600]: Colors.grey[350],
                  fontFamily: 'roboto'),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.51,
              child: Text(body,
                  style: TextStyle(fontSize: 15, color: status? Colors.grey:Colors.grey[350])),
            ),
            SizedBox(
              height: 3,
            ),
            date
                ? Text(dates,
                    style: TextStyle(fontSize: 15, color: status? Colors.grey:Colors.grey[350]))
                : Container(),
          ],
        ),
      ],
    );
  }

  progressbutton(status,color, divider) {
    return Column(
      children: [
         divider
            ? SizedBox(
                height: 70,
                child: VerticalDivider(
                  width: 2,
                  color: status? color:Colors.grey[350],
                  thickness: 2,
                ),
              )
            : Container(),
        Container(
          height: 16,
          width: 16,
          decoration: BoxDecoration(
            color: status?color:Colors.grey[350],
            borderRadius: BorderRadius.circular(100),
          ),
        ),
       
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.secondaryElement,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22.0),
            child: Text(
              'Track Orders',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                  fontFamily: 'roboto'),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.fromLTRB(20, 20, 20, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300],
                          width: 0.5,
                        ),
                      ),
                    ),
                    // width: MediaQuery.of(context).size.width*0.8,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Order#: ' + widget.orderdata['id'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondaryElement,
                          fontFamily: 'roboto'),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300],
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.orderdata['order_detail'][0]['rest_menu']
                                      ['menu_name'] +
                                  '  x' +
                                  widget.orderdata['order_detail'][0]
                                      ['quantity'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.black.withOpacity(0.6),
                                  fontFamily: 'roboto'),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              '\$' + widget.orderdata['total_amount'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                  color: AppColors.grey,
                                  fontFamily: 'roboto'),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              widget.orderdata['order_detail'][0]['rest_menu']
                                  ['menu_image'],
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.secondaryElement),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Track Order',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.black.withOpacity(0.6),
                        fontFamily: 'roboto'),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 18),
                        child: Column(
                          children: [
                            progressbutton(true,AppColors.secondaryElement, false),
                            progressbutton( widget.orderdata['super_admin'] !=null? true:false,AppColors.secondaryElement, true),
                            progressbutton(widget.orderdata['status'] !=null? true:false,Colors.green[600], true),
                            progressbutton(widget.orderdata['status'] =='ready'||widget.orderdata['status'] =='onway'||widget.orderdata['status'] =='delivered'? true:false,Colors.green[600], true),
                            progressbutton( widget.orderdata['status'] =='onway'? true:false,Colors.green[600], true),
                            progressbutton( widget.orderdata['status'] =='delivered'? true:false,Colors.green[600], true),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          progressdetail(true,
                              Icons.fact_check_outlined,
                              true,
                              'Order Placed',
                              'We have received your order',
                              DateFormat('dd-MMM-yyy, H:mm a')
                                      .format(DateTime.parse(widget.orderdata['created_at'])).toString(),
                              AppColors.secondaryElement),
                          SizedBox(
                            height: 35,
                          ),
                          progressdetail(
                            widget.orderdata['super_admin'] !=null? true:false,
                              Icons.playlist_add_check_rounded,
                              false,
                            widget.orderdata['super_admin'] ==null||  widget.orderdata['super_admin'] =='approved'? 'Order Confirmed':'Order rejected',
                            widget.orderdata['super_admin'] ==null|| widget.orderdata['super_admin'] =='approved'?  'Order has been confirmed':'Order has been rejected',
                              '20-Dec-2020, 3:00 PM',
                              AppColors.secondaryElement),
                          SizedBox(
                            height: 40,
                          ),
                          progressdetail(
                            widget.orderdata['status'] !=null? true:false,
                              Icons.wifi_protected_setup,
                              false,
                              'Order Processed',
                              'We preparing your order',
                              '',
                              Colors.green[600]),
                          SizedBox(
                            height: 40,
                          ),
                          progressdetail(
                            widget.orderdata['status'] =='ready' ||widget.orderdata['status'] =='onway'  || widget.orderdata['status'] =='delivered'? true:false,
                              Icons.card_giftcard_outlined,
                              false,
                              'Ready to Ship',
                              'Your order is ready for shipping',
                              '',
                              Colors.green[600]),
                          SizedBox(
                            height: 42,
                          ),
                          InkWell(
                            onTap: widget.orderdata['status'] =='onway'? () {

                              print('here');
                              Navigator.pushNamed(
                                  context, AppRouter.live_tracking,
                                  arguments: {
                                    'lat': double.parse(widget.orderdata['customer_address']
                                                ['user_latitude']),
                                    'long': double.parse(widget.orderdata['customer_address']
                                                ['user_longitude']),
                                    'clat':  widget.orderdata['driver_lat'],
                                    'clong': widget.orderdata['driver_lng'],
                                    'data': widget.orderdata
                                  });
                            }:null,
                            child: progressdetail(
                              widget.orderdata['status'] =='onway'? true:false,
                                Icons.local_shipping_outlined,
                                false,
                                'Out for Delivery',
                                'Click to see live location',
                                '',
                                Colors.green[600]),
                          ),
                           SizedBox(
                            height: 40,
                          ),
                          progressdetail(
                            widget.orderdata['status'] =='delivered'? true:false,
                              Icons.card_giftcard_outlined,
                              false,
                              'Order Delivered',
                              'Order has been delivered. Enjoy!',
                              '',
                              Colors.green[600]),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
