import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/localstorage.dart';
import 'package:toast/toast.dart';
import 'DatabaseManager.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference profile =
      FirebaseFirestore.instance.collection('UserModel');

// registration with email and password

  Future createuser(
      context, String email, String name, String password, bool verify, image) {
    FocusScope.of(context).unfocus();

    return this
        .createNewUser(name, email, password, verify, image)
        .then((response) {
      if (response['success'] == true) {
        Navigator.pop(context);
        Toast.show("Account Created Successfully!", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show(response['message'], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    });
  }

  Future createNewUser(
      String name, String email, String password, verify, image) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images/' + DateTime.now().toString());
      final UploadTask uploadTask = storageReference.putFile(File(image.path));
      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = await downloadUrl.ref.getDownloadURL();
      print(url);
      await DatabaseManager()
          .createUserData(name, user.uid, email, verify, url);
      if (verify) {
        user.sendEmailVerification();
      }
      return {'success': true, 'user': user};
    } catch (e) {
      print(e.message);
      return {'success': false, 'message': e.message};
    }
  }

// sign with email and password

  Future loginUser(context, String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = _auth.currentUser;
      var verifier = await profile.doc(result.user.uid).get();
      if (verifier['emailverify'] == true) {
        await user.reload();
        if (user.emailVerified) {
          Toast.show("successfully logged in", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            Localstorage().setuser(user);

          AppRouter.navigator.pushNamedAndRemoveUntil(
            AppRouter.rootScreen,
            (Route<dynamic> route) => false,
          );
          
          return {'success': true, user: user};
        } else {
          Toast.show("Verify your email before login", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          return {
            'success': false,
          };
        }
      } else {
        Toast.show("successfully logged in", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            Localstorage().setuser(user);
        AppRouter.navigator.pushNamedAndRemoveUntil(
          AppRouter.rootScreen,
          (Route<dynamic> route) => false,
        );
        return {'success': true, user: user};
      }
    } catch (e) {
      print(e.toString());
      Toast.show(e.message, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return {'success': false};
    }
  }

// signout

  Future logOut(context) async {
    try {
      print('_auth.currentUser');
      print(_auth.currentUser);
      _auth.signOut();
      print('_auth.currentUser');
      print(_auth.currentUser);
      Toast.show("successfully logged out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return {'success': true};
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

// signout

  Future resetpassword(context, email) async {
    FocusScope.of(context).unfocus();
    try {
      _auth.sendPasswordResetEmail(email: email);
      Toast.show("We have emailed your password rest link!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      AppRouter.navigator.pushReplacementNamed(AppRouter.loginScreen);
      return {'success': true};
    } catch (error) {
      print(error.toString());
      Toast.show("User not found", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return {'success': true};
    }
  }
}
