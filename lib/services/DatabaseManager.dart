
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

class DatabaseManager {

 FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  Future<void> addreview(context, review, resId) async {
    User _user =  _auth.currentUser;
    dynamic data = {
      'uId': _user.uid,
      'body': review,
      'stars': '4',
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now()
    };
    var documentReference =
    FirebaseFirestore.instance.collection('Restaurants').doc(resId);
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

  Future getpromotions() async {
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection('Promotions');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data).toList();
    print(allData);
    return allData;
  }
}
