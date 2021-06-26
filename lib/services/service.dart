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

  Future<String> signInWithGoogle() async {
    try {
      GoogleSignInAccount googleSignIn = await GoogleSignIn().signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignIn.authentication;
      AuthCredential authCredential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      AuthResult _authResult = await _auth.signInWithCredential(authCredential);
      bool isUserAvailable =
          await checkIfUserAvailable('uId', _authResult.user.uid);
      if (isUserAvailable) {
        return 'successfully logged in';
      } else {
        return 'register screen';
      }
    } catch (error) {
      print(error.toString());
      return error;
    }
  }

  Future<String> registerWithEmail(UserModel userModel, File image) async {
    try {
      AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
          email: userModel.email, password: userModel.password);
      String url = await uploadImageToServer(image);

      UserModel _user = UserModel(_authResult.user.uid, userModel.name,
          userModel.email, userModel.password, userModel.phoneNo, url ?? '');
      usersCollection.document(userModel.phoneNo).setData(_user.toJson());
      return 'Your account has been created successfully';
    } catch (e) {
      print(e.toString());
      if (e.code == 'weak-password') {
        return 'Password is weak';
      } else if (e.code == 'ERROR_INVALID_EMAIL') {
        return 'Email is not Valid';
      } else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        return 'This user is already registed';
      } else
        return 'error';
    }
  }

  Future<String> signInWithApple() async {
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
        UserUpdateInfo userUpdateInfo = UserUpdateInfo();
        userUpdateInfo.displayName = firebaseUser.displayName;
        await firebaseUser.updateProfile(userUpdateInfo);
        bool isUserAvailable =
            await checkIfUserAvailable('uId', authResult.user.uid);
        if (isUserAvailable) {
          return 'successfully logged in';
        } else {
          return 'register screen';
        }
        break;

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

  Future<String> signInWithEmail(
      BuildContext context, String email, String password) async {
    AuthResult user;
    try {
      user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      if (error.code == 'ERROR_USER_NOT_FOUND') {
        return 'User not found';
      } else if (error.code == 'ERROR_WRONG_PASSWORD') {
        return 'Invalid Password';
      } else if (error.code == 'ERROR_INVALID_EMAIL') {
        return 'Invalid email';
      } else
        return error;
    }
    return user != null ? 'Logged in successfully' : 'Some error occured';
  }

  Future<String> uploadImageToServer(File image) async {
    if (image != null) {
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
    }
    return null;
  }

  Future<bool> checkIfUserAvailable(String key, String value) async {
    final userDocs =
        await usersCollection.where(key, isEqualTo: value).getDocuments();
    if (userDocs.documents.length > 0)
      return true;
    else
      return false;
  }

  Future<String> setDataInUserCollection(UserModel userModel) async {
    usersCollection.document(userModel.phoneNo).setData(userModel.toJson());
    return 'successfully';
  }
}
