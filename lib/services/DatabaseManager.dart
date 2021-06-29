
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

class DatabaseManager {

 FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference usersCollection = Firestore.instance.collection('users');
  Future<void> addreview(context, review, resId) async {
    FirebaseUser _user = await _auth.currentUser();
    dynamic data = {
      'uId': _user.uid,
      'body': review,
      'stars': '4',
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now()
    };
    var documentReference =
    Firestore.instance.collection('Restaurants').document(resId);
    Firestore.instance.runTransaction((transaction) async {
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
    Firestore.instance.collection('Promotions');
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.getDocuments();
    // Get data from docs and convert map to List
    final allData = querySnapshot.documents.map((doc) => doc.data).toList();
    print(allData);
    return allData;
  }
}
