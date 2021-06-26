import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
class DatabaseManager {
  final CollectionReference profileList =
      FirebaseFirestore.instance.collection('UserModel');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createUserData(
    String name,
    String uid,
    String email,
    bool verify,
    String image
  ) async {
     
    return await profileList.doc(uid).set({'userId':uid,'profileImage':image, 'name': name, 'email': email,'emailverify':verify});
  }


    void addreview(context,review,resId) {

    dynamic data={
      'uId':_auth.currentUser.uid,
      'body': review,
      'stars': '4',
      'createdAt':DateTime.now(),
      'updatedAt':DateTime.now()
    };
     var documentReference = FirebaseFirestore.instance.collection('Restaurants').doc(resId);
     FirebaseFirestore.instance.runTransaction((transaction) async {
    //  _controller.jumpTo(_controller.position.maxScrollExtent);
      transaction.update(
        documentReference,
        {"reviews": FieldValue.arrayUnion(data)},
      );
    }).then((value) {
      Toast.show("successfully added review", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.pop(context);
    });
  }

 
}
