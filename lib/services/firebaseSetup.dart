import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/services/messagepopup.dart';
import 'package:provider/provider.dart';

class FirebaseSetup {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static configureFirebase(context) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data != null) {
        //  Provider.of<ProviderPage>(context, listen: false).changenoti();
        print("onMessage");
        print(message);

        _showTopPopup(
            context,
            Platform.isIOS
                ? message.data["aps"]["alert"]["title"]
                : message.data["notification"]["title"]);
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
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => NotificationsPage()));
            },
            child: Container(
              height: 45,
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
                            'Assets/images/icon.png',
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   title,
                            //   style: TextStyle(
                            //       color: Colors.grey[600],
                            //       fontSize: 15,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
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
