import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/screens/notification_screen.dart';
import 'package:potbelly/services/messagepopup.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/vendor_screens.dart/vendor_notifications.dart';
import 'package:provider/provider.dart';

class FirebaseSetup {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String savedMessageId  = "";
   configureFirebase(context) async {
     await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(savedMessageId);
      print( message.messageId);
      print(savedMessageId != message.messageId);
      print(savedMessageId == message.messageId);
      if (message.data != null) {
        //  Provider.of<ProviderPage>(context, listen: false).changenoti();
        print("onMessage");
        print(message);
    if (savedMessageId != message.messageId){
        savedMessageId  = message.messageId;
        _showTopPopup(
            context,
            Platform.isIOS
                ? message.notification.title
                : message.notification.title);
      }
}
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data != null) {
        // Provider.of<ProviderPage>(context, listen: false).changenoti();
        print("onLaunch");
        print(message);
        // _showTopPopup(context, "lol", "notif");
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => NotificationsPage()));
      }
    });

    // _firebaseMessaging.configure(
    //   onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    //   onMessage: (Map<String, dynamic> message) async {
    //     Provider.of<ProviderPage>(context, listen: false).changenoti();
    //     print("onMessage");
    //     print(message);

    //     _showTopPopup(
    //         context,
    //         Platform.isIOS
    //             ? message["aps"]["alert"]["title"]
    //             : message["notification"]["title"]);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     Provider.of<ProviderPage>(context, listen: false).changenoti();
    //     print("onResume");
    //     print(message);
    //     // _showTopPopup(context, "lol", "notif");
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => NotificationsPage()));
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     Provider.of<ProviderPage>(context, listen: false).changenoti();
    //     print("onLaunch");
    //     print(message);
    //     // _showTopPopup(context, "lol", "notif");
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => NotificationsPage()));
    //   },
    // );
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    // if (message.data != null) {
    //   PushNotificationsManager()._ShowAlert(
    //       context, message.data['formId'], message.data['userId']);

    //   //       if(Platform.isIOS){
    //   //   if(message['formId'] != null){
    //   // return _ShowAlert(context, message['formId'],message['userId']);

    //   //   }

    //   // }else{

    //   //   }
    // }
    print('Handling a background message ${message.messageId}');
  }

  static void _showTopPopup(context, title) {
    Navigator.of(context, rootNavigator: false).push(
      MessagePopupRoute(
        barrierLabel: 'Notification',
        semanticsDismissible: true,
        builder: (context) {
          return GestureDetector(
            // onHorizontalDragEnd: (DragEndDetails details) {
            //   if (details.primaryVelocity > 0) {
            //     print('left');
            //     Navigator.of(context).pop();
            //     // User swiped Left
            //   } else if (details.primaryVelocity < 0) {
            //     // User swiped Right
            //     print('right');
            //     Navigator.of(context).pop();
            //   }
            // },
            onVerticalDragUpdate: (dragUpdateDetails) {
              Navigator.of(context).pop();
            },
            onTap: () async {
              Navigator.of(context).pop();
              final shared = await Service().loggedUser();
              if(shared == '2'){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationsScreen()));
              }
              else{
                 Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VendorNotificationsScreen()));
              }
            },
            child: Container(
              height: 55,
              child: Scaffold(
                body: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Image(
                          height: 30,
                          width: 30,
                          image: AssetImage(
                            'assets/images/logo.png',
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '+1 New Notification',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.1,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static Future<void> goToNotificationsNow(context) async {
    // Navigator.of(context).pop();
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    print("_backgroundMessageHandler");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print("_backgroundMessageHandler data: ${data}");
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print("_backgroundMessageHandler notification: ${notification}");
      // Fimber.d("=====>myBackgroundMessageHandler $message");
    }
    return Future<void>.value();
  }
}
