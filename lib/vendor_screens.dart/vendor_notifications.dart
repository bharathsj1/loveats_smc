import 'package:flutter/material.dart';
import 'package:potbelly/values/values.dart';

class VendorNotificationsScreen extends StatefulWidget {
  // static const int TAB_NO = 2;

  VendorNotificationsScreen({Key key}) : super(key: key);

  @override
  _VendorNotificationsScreenState createState() => _VendorNotificationsScreenState();
}

class _VendorNotificationsScreenState extends State<VendorNotificationsScreen> {
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
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Sizes.MARGIN_8, vertical: Sizes.MARGIN_16),
        child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 1,
                child: ListTile(
                  
                  leading: Image.asset(notifications[index].imageUrl),
                  onTap: () {},
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        notifications[index].title,
                        style: Styles.customTitleTextStyle(
                          color: AppColors.headingText,
                          fontWeight: FontWeight.w400,
                          fontSize: Sizes.TEXT_SIZE_20,
                        ),
                      ),
                      Text(
                        notifications[index].time,
                        style: Styles.customNormalTextStyle(
                          color: AppColors.accentText,
                          fontSize: Sizes.TEXT_SIZE_14,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Container(
                    margin: EdgeInsets.only(top: 8.0),
                    child: Text(
                      notifications[index].subtitle,
                      style: Styles.customNormalTextStyle(
                        color: AppColors.accentText,
                        fontSize: Sizes.TEXT_SIZE_14,
                      ),
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
