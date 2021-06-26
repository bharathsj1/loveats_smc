import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart';
import 'package:potbelly/models/UserModel.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:potbelly/screens/login_screen.dart';

class Service {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference usersCollection = Firestore.instance.collection('users');

  Future<FirebaseUser> signInWithGoogle() async {
    try {
      GoogleSignInAccount googleSignIn = await GoogleSignIn().signIn();

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignIn.authentication;
      AuthCredential authCredential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      AuthResult _authResult = await _auth.signInWithCredential(authCredential);
      return _authResult.user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<bool> registerWithEmail(UserModel userModel, File image) async {
    print('In Register With Email Function');
    QuerySnapshot querySnapshot = await usersCollection
        .where('email', isEqualTo: userModel.email)
        .getDocuments();

    if (querySnapshot.documents.length > 0) {
      return false;
    } else {
      try {
        AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
            email: userModel.email, password: userModel.password);
        String url = await uploadImageToServer(image);

        UserModel _user = UserModel(_authResult.user.uid, userModel.name,
            userModel.email, userModel.password, userModel.phoneNo, url);
        usersCollection.document(userModel.phoneNo).setData(_user.toJson());
        return true;
      } catch (e) {
        print(e.code.toString());
        if (e.code == 'weak-password') {
          return false;
        } else if (e.code == 'email-already-in-use') {
          return false;
        }
      }
    }
    return false;
  }

  Future<FirebaseUser> signInWithApple() async {
    UserUpdateInfo userUpdateInfo;
    final result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        OAuthProvider oAuthProvider = OAuthProvider(providerId: 'apple.com');

        final credentials = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          rawNonce: String.fromCharCodes(appleIdCredential.authorizationCode),
        );

        final AuthResult authResult =
            await _auth.signInWithCredential(credentials);

        final firebaseUser = authResult.user;

        // userUpdateInfo.displayName = firebaseUser.displayName;
        // await firebaseUser.updateProfile(userUpdateInfo);
        return firebaseUser;

      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => BackgroundVideo()), (route) => false);
  }

  Future<UserModel> getUserDetail() async {
    FirebaseUser _user = await _auth.currentUser();
    final userDocs =
        await usersCollection.where('uId', isEqualTo: _user.uid).getDocuments();

    List<UserModel> userClass = userDocs.documents.map((e) {
      return UserModel.fromSnapshot(e);
    }).toList();

    if (userClass.length == 0) return null;
    return userClass[0];
  }

  Future<String> uploadImageToServer(File image) async {
    String fileName = basename(image.path);
    try {
      StorageReference reference =
          FirebaseStorage.instance.ref().child("images/$fileName");

      StorageUploadTask uploadTask = reference.putFile(image);

      //Snapshot of the uploading task
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (error) {
      print(error.toString());
    }
    return null;
  }
}
