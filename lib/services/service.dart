import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart';
import 'package:potbelly/models/UserModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:potbelly/models/user.dart';
import 'package:potbelly/screens/login_screen.dart';
import 'package:potbelly/values/values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Service {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference usersCollection = Firestore.instance.collection('users');
  String accessToken;
  Dio dio = Dio(
    BaseOptions(
        baseUrl: StringConst.BASE_URL,
        connectTimeout: 5000,
        receiveTimeout: 3000),
  );

  Future<SharedPreferences> initializdPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  Future<String> registerUserWithEmail(
      UserModel userModel, File image, String uid, int type) async {
    print('In Register WIth Email Function');
    bool _isEverthingFine = false;
    print('this is type $type');
    String message;
    String udid;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      udid = androidInfo.id;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      udid = iosInfo.identifierForVendor;
    }

    FormData _data = FormData.fromMap({
      'name': userModel.name,
      'email': userModel.email,
      'password': userModel.password,
      'phone_number': userModel.phoneNo,
      'type': type,
      'device_id': udid,
      // ignore: sdk_version_ui_as_code
      if (uid != null) 'uid': uid,
      // ignore: sdk_version_ui_as_code
      if (image != null)
        'photo': await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last)
    });
    print(StringConst.BASE_URL);
    print(dio.options.baseUrl);
    await dio
        .request('/register_user',
            data: _data, options: Options(method: 'POST'))
        .then((value) async {
      if (value.data['success'] == true) {
        print('success');
        _isEverthingFine = true;
        accessToken = value.data['access_token'];
        message = 'success';
        await setKeyData('accessToken', accessToken);
      } else {
        print(value.data['message']);
        _isEverthingFine = false;
        message = value.data['message'];
        print(message);
      }
    }).catchError((onError) {
      message = 'server error';
    }).timeout(
      Duration(seconds: 15),
      onTimeout: () {},
    );

    if (_isEverthingFine) {
      var pref = await initializdPrefs();
      pref.setString('accessToken', accessToken);
    }

    return message;
  }

  Future<String> signInWithGoogle() async {
    try {
      GoogleSignInAccount googleSignIn = await GoogleSignIn().signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignIn.authentication;
      AuthCredential authCredential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      AuthResult _authResult = await _auth.signInWithCredential(authCredential);
      bool isUserAvailable = await checkIfUserAvailable(_authResult.user.uid);
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
        bool isUserAvailable = await checkIfUserAvailable(firebaseUser.uid);
        if (isUserAvailable) {
          print('vailbale');
          return 'successfully logged in';
        } else {
          print('not avai');
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
    loggedoutr();
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
    print('SIGNIN_WITH_EMAIL');
    String message;
    User _user;

    FormData _form = FormData.fromMap({
      'email': email,
      'password': password,
    });

    await dio
        .request('/login', data: _form, options: Options(method: 'POST'))
        .then((value) async {
      print(value.data);
      if (value.data['status'] == false) {
        message = 'Invalid Login Details';
      } else {
        message = 'success';
        _user = User.fromJson(value.data);
        await setKeyData('accessToken', _user.accessToken);
        await setKeyData('name', _user.data.name);
        await setKeyData('email', _user.data.email);
        await setKeyData('photo', _user.data.photo);
      }
    }).catchError((onError) {
      print('Here it is');
      print(onError.toString());
    });

    return message;
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

  Future<bool> checkIfUserAvailable(String uid) async {
    FormData _data = FormData.fromMap({
      'uid': uid,
    });
    bool _isAvailable = true;
    await dio
        .request('/check-uid', data: _data, options: Options(method: 'POST'))
        .then((value) {
      print(value.data);
      if (value.data['status'] == 1)
        _isAvailable = false;
      else
        _isAvailable = true;
    }).catchError((onError) {
      print(onError.toString());
      print('Error in ( CheckIfUSERAvailable )');
    });
    print(_isAvailable);
    return _isAvailable;
  }

  Future<String> setDataInUserCollection(UserModel userModel) async {
    usersCollection.document(userModel.phoneNo).setData(userModel.toJson());
    return 'successfully';
  }

  Future<String> loggedUser() async {
    final shared = await initializdPrefs();
    String accessToken = shared.get('accessToken');
    return accessToken;
  }

  Future<String> loggedoutr() async {
    final shared = await initializdPrefs();
   shared.clear();
   return null;
  }

  Future<void> clearAllPrefs() async {
    final shared = await initializdPrefs();
    await shared.clear();
  }

  Future<void> setKeyData(String key, String value) async {
    final shared = await initializdPrefs();
    await shared.setString(key, value);
  }
}
