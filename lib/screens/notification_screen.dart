import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';

class NotificationsScreen extends StatefulWidget {
  static const int TAB_NO = 2;

  NotificationsScreen({Key key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List notilist = [];

  bool loader = true;

  getnoti() async {
    var noti = await AppService().getnoti();
    print(noti);
    notilist = noti['data'];
    loader = false;
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
        title: Text(
          'Notifications',
          style: Styles.customTitleTextStyle(
            color: AppColors.secondaryElement,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.TEXT_SIZE_22,
          ),
        ),
      ),
      body: loader
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
              ),
            )
          : notilist == null || notilist.length == 0
              ? Center(
                  child: Container(
                    child: Text('No Notification available'),
                  ),
                )
              : Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: Sizes.MARGIN_8, vertical: Sizes.MARGIN_16),
                  child: ListView.builder(
                      itemCount: notilist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 1,
                          child: ListTile(
                            leading: Image.asset('assets/images/logo.png'),
                            onTap: () {},
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: Text(
                                    notilist[index]['title'],
                                    style: Styles.customTitleTextStyle(
                                      color: AppColors.headingText,
                                      fontWeight: FontWeight.w400,
                                      fontSize: Sizes.TEXT_SIZE_20,
                                    ),
                                  ),
                                ),
                                Text(
                                  DateFormat('MMM d, yyyy')
                                      .format(DateTime.parse(
                                          notilist[index]['created_at']))
                                      .toString(),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.42,
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
                                        .format(DateTime.parse(
                                            notilist[index]['created_at']))
                                        .toString(),
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
