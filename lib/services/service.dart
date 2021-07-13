import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart';
import 'package:potbelly/grovey_startScreens/demo.dart';
import 'package:potbelly/models/UserModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:potbelly/models/menu_types_model.dart';
import 'package:potbelly/models/restaurent_menu_model.dart';
import 'package:potbelly/models/restaurent_model.dart';
import 'package:potbelly/models/user.dart';
import 'package:potbelly/screens/login_screen.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class Service {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  String accessToken;
  Dio dio = Dio(
    BaseOptions(
      baseUrl: StringConst.BASE_URL,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    ),
  );

  Future<SharedPreferences> initializdPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  Future<String> registerUserWithEmail(
      UserModel userModel, File image, String uid, int type) async {
    print('In Register WIth Email Function');
    bool _isEverthingFine = false;
    String message;
    UserData _user;
    String udid;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      udid = androidInfo.id;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      udid = iosInfo.identifierForVendor;
    }
    print(uid);
    FormData _data = FormData.fromMap({
      'cust_first_name': userModel.name,
      'email': userModel.email,
      'password': userModel.password,
      'cust_phone_number': userModel.phoneNo,
      'cust_registration_type': type,
      'cust_account_status': '0',
      'cust_account_type': '2',
      // ignore: sdk_version_ui_as_code
      if (uid != null) 'cust_uid': uid,
      // ignore: sdk_version_ui_as_code
      if (image != null)
        'cust_profile_image': await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last)
    });
    print(dio.options.baseUrl);
    await dio
        .request('/register_user',
            data: _data, options: Options(method: 'POST'))
        .then((value) async {
      print(value.data);
      if (value.data['success'] == true) {
        print('success');
        _isEverthingFine = true;
        accessToken = value.data['access_token'];
        message = 'success';
        _user = UserData.fromJson(value.data);
        await setKeyData('accessToken', accessToken);
        await setKeyData('accounttype', _user.data.custAccountType);
        await setKeyData('photo', _user.data.custProfileImage);
        await setKeyData('userdata', jsonEncode(value.data['data']));
      } else {
        print(value.data['message']);
        _isEverthingFine = false;
        message = value.data['message'];
        print(message);
      }
    }).catchError((onError) {
      print(onError.toString());
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
      AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      UserCredential _authResult = await _auth.signInWithCredential(authCredential);
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
    final result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        OAuthProvider oAuthProvider = OAuthProvider('apple.com');

        final credentials = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          rawNonce: String.fromCharCodes(appleIdCredential.authorizationCode),
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credentials);

        final firebaseUser = authResult.user;
        // UserUpdateInfo userUpdateInfo = UserUpdateInfo();
        // userUpdateInfo.displayName = firebaseUser.displayName;
        await firebaseUser.updateDisplayName(firebaseUser.displayName);
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
        // MaterialPageRoute(builder: (_) => BackgroundVideo()), (route) => false);
        MaterialPageRoute(builder: (_) => GooeyEdgeDemo()), (route) => false);
  }

  Future<UserModel> getUserDetail() async {
    User _user =  _auth.currentUser;
    final userDocs =
        await usersCollection.where('uId', isEqualTo: _user.uid).get();

    List<UserModel> userClass = userDocs.docs.map((e) {
      return UserModel.fromSnapshot(e);
    }).toList();

    if (userClass.length == 0) return null;
    return userClass[0];
  }

  Future signInWithEmail(
      BuildContext context, String email, String password) async {
    print('SIGNIN_WITH_EMAIL');
    String message;
    UserData _user;

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
        _user = UserData.fromJson(value.data);
        await setKeyData('accessToken', _user.accessToken);
        await setKeyData('name', _user.data.custFirstName);
        await setKeyData('email', _user.data.email);
        await setKeyData('accounttype', _user.data.custAccountType);
        await setKeyData('photo', _user.data.custProfileImage);
        await setKeyData('userdata', jsonEncode(value.data['data']));
      }
    }).catchError((onError) {
      print('Here it is');
      print(onError.toString());
    });

    return {'message':message,'user':_user};
  }

  Future<String> uploadImageToServer(File image) async {
    if (image != null) {
      String fileName = basename(image.path);
      try {
        Reference reference =
            FirebaseStorage.instance.ref().child("images/$fileName");

        UploadTask uploadTask = reference.putFile(image);

        //Snapshot of the uploading task
        TaskSnapshot taskSnapshot = (await uploadTask);
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
    bool _isAvailable = false;
    await dio
        .request('/check-uid', data: _data, options: Options(method: 'POST'))
        .then((value) async {
      print(value.data);
      if (value.data['status'] == 1)
        _isAvailable = false;
      else{
        _isAvailable = true;
    UserData _user;
    _user = UserData.fromJson(value.data);
        await setKeyData('accessToken', _user.accessToken);
        await setKeyData('name', _user.data.custFirstName);
        await setKeyData('email', _user.data.email);
        await setKeyData('accounttype', _user.data.custAccountType);
        await setKeyData('photo', _user.data.custProfileImage);
        await setKeyData('userdata', jsonEncode(value.data['data']));
      }
    }).catchError((onError) {
      print(onError.toString());
      print('Error in ( CheckIfUSERAvailable )');
    });
    print(_isAvailable);
    return _isAvailable;
  }

  Future<String> setDataInUserCollection(UserModel userModel) async {
    usersCollection.doc(userModel.phoneNo).set(userModel.toJson());
    return 'successfully';
  }

  Future<String> loggedoutr() async {
   AppService().deletefcm().then((value) async {
    final shared = await initializdPrefs();
   shared.clear();
   return null;
   });
  }



  Future<String> loggedUser() async {
    final shared = await initializdPrefs();
    // String accessToken = shared.get('accessToken');
    String accounttype = shared.get('accounttype');
    return accounttype;
  }

  Future<bool> checkdriving() async {
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('driving');
  }

  Future<void> clearAllPrefs() async {
    final shared = await initializdPrefs();
    await shared.clear();
  }

  Future<void> setKeyData(String key, String value) async {
    final shared = await initializdPrefs();
    await shared.setString(key, value);
  }

  Future<RestaurentsModel> getRestaurentsData() async {
    print(dio.options.baseUrl);
    Response response =
        await dio.request('/get-restaurents', options: Options(method: 'Post'));
    print('hello g');
    print(response.data);

    return RestaurentsModel.fromJson(response.data);
  }

  Future<MenuTypesModel> getMenuTypes() async {
    print(dio.options.baseUrl);
    Response response = await dio.request(
      '/get-menu-types',
    );
    return MenuTypesModel.fromJson(response.data);
  }

  Future<RestaurentMenuModel> getMenus(int restId) async {
    Response response = await dio.request(
      '/get-menus/$restId',
    );
    return RestaurentMenuModel.fromJson(response.data);
  }

  Future<String> getAccessToken() async {
    final shared = await initializdPrefs();
    return shared.getString('accessToken');
  }

  Future<bool> makeOrder(int total) async {
    accessToken = await getAccessToken();
    print('make Order functon');
    print(accessToken);

    dio.options.headers['Authorization'] = "Bearer " + accessToken;
    FormData formData = FormData.fromMap({
      'total_amount': total,
      'payment_id': -1,
    });
    bool isOk = false;
    await dio
        .request('/make-order',
            data: formData, options: Options(method: 'post'))
        .then((value) {
      print(value);
      if (value.data['success'] == true) {
        isOk = true;
      }
    }).catchError((onError) {
      print(onError.toString());
      isOk = false;
    });

    return isOk;
  }

  Future addOrderItems(var data) async {
    print('sfs');
    accessToken = await getAccessToken();
    dio.options.headers['Authorization'] = "Bearer " + accessToken;
    FormData formData = FormData.fromMap({
      'data': data,
    });
    bool isOk = false;
    await dio
        .request('/addOrderTime',
            data: formData, options: Options(method: 'post'))
        .then((value) {
      print(value);
      if (value.data['success'] == true) {
        isOk = true;
      }
    }).catchError((onError) {
      isOk = false;
    });

    return isOk;
  }

  Future<bool> paymentStored(data) async {
    FormData formData = FormData.fromMap({
      'amount': data,
    });
    accessToken = await getAccessToken();

    dio.options.headers['Authorization'] = "Bearer " + accessToken;
    bool isPaymentStored = false;

    await dio
        .request('/make-payment',
            data: formData, options: Options(method: 'post'))
        .then((value) {
      if (value.data['success'] == true)
        isPaymentStored = true;
      else if (value.data['success'] == false) isPaymentStored = false;
    }).catchError((onError) {
      print(onError.toString());
      isPaymentStored = false;
    });

    return isPaymentStored;
  }
}
