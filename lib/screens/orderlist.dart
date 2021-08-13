import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';

class OrderList extends StatefulWidget {


  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {

  
   List orderlist = [];

  bool loader = true;
  
   getorders() async {
    var order = await AppService().getmyorders();
    print(order);
    orderlist = order['data'];
    loader = false;
    setState(() {});
  }




  

  @override
  void initState() {
    getorders();
    super.initState();
  }
  
  List<Widget> card() {
    return List.generate(
        orderlist.length,
        (i) => Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator
                    .pushNamed(context,AppRouter.myorder_detail,arguments:orderlist[i]).then((value) {
                      loader=true;
                      setState(() {
                        
                      });
                      getorders();
                    });
                },
                child: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: i == 3
                      ? null
                      : BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[300],
                              width: 0.5,
                            ),
                          ),
                        ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order#: '+orderlist[i]['id'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontFamily: 'roboto'),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text( DateFormat('dd-MMM-yyy, H:mm a')
                                      .format(DateTime.parse(orderlist[i]['created_at'])).toString(),
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey)),
                          SizedBox(
                            height: 12,
                          ),
                          Text(orderlist[i]['status'] == 'delivered'? 'Delivered' : 'Delivery will be soon',
                              style:
                                  TextStyle(fontSize: 15, color: orderlist[i]['status'] == 'delivered'? AppColors.secondaryElement: Colors.green)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 50,
                          width: 50,
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.secondaryElement,
          ),
        ),
        // centerTitle: true,
        // title: Text(
        //   'Shopping Cart',
        //   style: Styles.customTitleTextStyle(
        //     color: AppColors.headingText,
        //     fontWeight: FontWeight.w600,
        //     fontSize: Sizes.TEXT_SIZE_20,
        //   ),
        // ),
      ),
      body:  loader
        ? Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
            ),
          ):orderlist.length == 0
            ? Center(
                child: Container(
                  child: Text('No order available'),
                ),
              )
            :   SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22.0),
            child: Text(
              'My Orders',
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
          Container(
            margin: EdgeInsets.all(15),
            child: Card(
              elevation: 5,
              child: Column(
                children: card(),
              ),
            ),
          )
        ],
      )),
    );
  }
}
