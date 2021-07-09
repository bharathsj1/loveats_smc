import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';

class VendorNotificationsScreen extends StatefulWidget {
  // static const int TAB_NO = 2;

  VendorNotificationsScreen({Key key}) : super(key: key);

  @override
  _VendorNotificationsScreenState createState() => _VendorNotificationsScreenState();
}

class _VendorNotificationsScreenState extends State<VendorNotificationsScreen> {
  List notilist=[];
    bool loader = true;
  List<NotificationInfo> notifications = [
    NotificationInfo(
      imageUrl: ImagePath.branson,
      title: "New Order",
      time: "5:30 am",
      subtitle: "Order#12 was assigned to you",
    ),
    NotificationInfo(
      imageUrl: ImagePath.juliet,
      title: "New Order",
      time: "Yesterday",
      subtitle: "Order#40 was assigned to you",
    ),
    NotificationInfo(
      imageUrl: ImagePath.andy,
      title: "New Order",
      time: "Yesterday",
      subtitle: "Order#19 was assigned to you",
    ),
    NotificationInfo(
      imageUrl: ImagePath.anabel,
      title: "New Order",
      time: "26/05/2019",
      subtitle: "Order#90 was assigned to you",
    ),
    NotificationInfo(
      imageUrl: ImagePath.ashlee,
      title: "New Order",
      time: "26/05/2019",
      subtitle: "Order#22 was assigned to you",
    ),
  ];

     getnoti() async {
    var noti= await AppService().getnoti();
    print(noti);
    notilist= noti['data'];
    loader= false;
    setState(() {});
    }

   @override
  void initState() {
   getnoti();
    super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.secondaryElement),
        title: Text(
          'Notifications',
          style: Styles.customTitleTextStyle(
            color: AppColors.secondaryElement,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.TEXT_SIZE_22,
          ),
        ),
      ),
      body:  loader
        ? Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
            ),
          ):notilist.length == 0
            ? Center(
                child: Container(
                  child: Text('No Notification available'),
                ),
              )
            :  Container(
        margin: EdgeInsets.symmetric(
            horizontal: Sizes.MARGIN_8, vertical: Sizes.MARGIN_16),
        child: ListView.builder(
            itemCount: notilist.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 1,
                child: ListTile(
                  
                  leading: Image.asset(notifications[index].imageUrl),
                  onTap: () {},
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width*0.5,
                        child: Text(
                          notilist[index]['title'] ,
                          style: Styles.customTitleTextStyle(
                            color: AppColors.headingText,
                            fontWeight: FontWeight.w400,
                            fontSize: Sizes.TEXT_SIZE_16,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('MMM d, yyyy')
                                    .format(DateTime.parse(notilist[index]['created_at'])).toString(),
                        style: Styles.customNormalTextStyle(
                          color: AppColors.accentText,
                          fontSize: Sizes.TEXT_SIZE_14,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Container(
                    margin: EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.55,
                          child: Text(
                            notilist[index]['subtitle'],
                            style: Styles.customNormalTextStyle(
                              color: AppColors.accentText,
                              fontSize: Sizes.TEXT_SIZE_14,
                            ),
                          ),
                        ),
                        Text(
                        DateFormat('h:mm a')
                                    .format(DateTime.parse(notilist[index]['created_at'])).toString(),
                        style: Styles.customNormalTextStyle(
                          color: AppColors.accentText,
                          fontSize: Sizes.TEXT_SIZE_14,
                        ),
                      ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class NotificationInfo {
  final String imageUrl;
  final String title;
  final String time;
  final String subtitle;

  NotificationInfo({
    @required this.imageUrl,
    @required this.title,
    @required this.time,
    @required this.subtitle,
  });
}
