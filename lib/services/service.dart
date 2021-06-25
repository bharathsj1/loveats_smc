import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:potbelly/models/UserModel.dart';
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

  Future<bool> registerWithEmail(UserModel userModel) async {
    QuerySnapshot querySnapshot = await usersCollection
        .where('email', isEqualTo: userModel.email)
        .getDocuments();

    if (querySnapshot.documents.length > 0) {
      return null;
    } else {
      try {
        AuthResult _authResult = await _auth.createUserWithEmailAndPassword(
            email: userModel.email, password: userModel.password);
        usersCollection.document(userModel.phoneNo).setData(userModel.toJson());
        return true;
      } catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
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

    return UserModel(_user.displayName ?? '', _user.email ?? '', '', '');
  }
}
