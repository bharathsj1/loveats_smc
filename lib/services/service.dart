import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:potbelly/grovey_startScreens/demo.dart';
import 'package:potbelly/models/UserModel.dart';
import 'package:potbelly/models/free_meal_model.dart';
import 'package:potbelly/models/get_all_subscription_model.dart';
import 'package:potbelly/models/menu_types_model.dart';
import 'package:potbelly/models/restaurent_menu_model.dart';
import 'package:potbelly/models/restaurent_model.dart';
import 'package:potbelly/models/specific_user_subscription_model.dart';
import 'package:potbelly/models/user.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class Service {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String accessToken;
  Dio dio = Dio(
    BaseOptions(
      baseUrl: StringConst.BASE_URL,
      connectTimeout: 5000,
      receiveTimeout: 5000,
    ),
  );
  SharedPreferences storagePref;

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
        var pref = await initializdPrefs();

        _user = UserData.fromJson(value.data);
        await pref.setInt('USERID', _user.data.id);
        await setKeyData('accessToken', accessToken);
        await setKeyData('accounttype', _user.data.custAccountType);
        await setKeyData('photo', _user.data.custProfileImage ?? '');

        await setKeyData('userdata', jsonEncode(value.data['data']));
      } else {
        print(value.data['message']);
        _isEverthingFine = false;
        message = value.data['message'];
        print(message);
      }
    });
    if (_isEverthingFine) {
      var pref = await initializdPrefs();
      pref.setString('accessToken', accessToken);
    }

    return message;
  }

  Future<String> signInWithGoogle() async {
    await Service().removeGuest();
    try {
      GoogleSignInAccount googleSignIn = await GoogleSignIn().signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignIn.authentication;
      AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      UserCredential _authResult =
          await _auth.signInWithCredential(authCredential);
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
    await Service().removeGuest();

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
        // await firebaseUser.updateDisplayName(firebaseUser.displayName);
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
    await Service().removeGuest();

    await _auth.signOut();
    loggedoutr();
    Navigator.pushAndRemoveUntil(
        context,
        // MaterialPageRoute(builder: (_) => BackgroundVideo()), (route) => false);
        MaterialPageRoute(builder: (_) => GooeyEdgeDemo()),
        (route) => false);
  }

  Future signInWithEmail(
      BuildContext context, String email, String password) async {
    await Service().removeGuest();
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
        var pref = await initializdPrefs();

        message = 'success';
        _user = UserData.fromJson(value.data);
        pref.setInt('USERID', _user.data.id);
        pref.setString('STRIPE_CUS_ID', _user.data.stripeCusId ?? '');
        print('thats the user id is ${_user.data.id}');
        await setKeyData('accessToken', _user.accessToken);
        await setKeyData('name', _user.data.custFirstName);
        await setKeyData('email', _user.data.email);
        await setKeyData('accounttype', _user.data.custAccountType);
        await setKeyData('photo', _user.data.custProfileImage ?? '');
        await setKeyData('userId', _user.data.id.toString());
        await setKeyData('userdata', jsonEncode(value.data['data']));
      }
    }).catchError((onError) {
      print('Here it is');
      print(onError.toString());
    });

    return {'message': message, 'user': _user};
  }

  // Future<String> uploadImageToServer(File image) async {
  //   if (image != null) {
  //     String fileName = basename(image.path);
  //     try {
  //       Reference reference =
  //           FirebaseStorage.instance.ref().child("images/$fileName");

  //       UploadTask uploadTask = reference.putFile(image);

  //       //Snapshot of the uploading task
  //       TaskSnapshot taskSnapshot = (await uploadTask);
  //       String url = await taskSnapshot.ref.getDownloadURL();
  //       return url;
  //     } catch (error) {
  //       print(error.toString());
  //     }
  //   }
  //   return null;
  // }

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
      else {
        _isAvailable = true;
        UserData _user;
        var pref = await initializdPrefs();

        _user = UserData.fromJson(value.data);
        print(_user.data);
        await setKeyData('accessToken', _user.accessToken);
        await setKeyData('name', _user.data.custFirstName);
        await setKeyData('email', _user.data.email);
        await setKeyData('accounttype', _user.data.custAccountType);
        await setKeyData('photo', _user.data.custProfileImage ?? '');
        await pref.setInt('USERID', value.data['data']['id']);
        if (_user.data.stripeCusId != null)
          await setKeyData('STRIPE_CUS_ID', _user.data.stripeCusId);

        await setKeyData('userdata', jsonEncode(value.data['data']));
      }
    }).catchError((onError) {
      print(onError.toString());
      print('Error in ( CheckIfUSERAvailable )');
    });
    print(_isAvailable);
    return _isAvailable;
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

  Future<void> saveGuest() async {
    print('SAVING ISGUEST TO TRUE');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('ISGUEST', true);
  }

  Future<void> removeGuest() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('ISGUEST', false);
  }

  Future<bool> isGuest() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('ISGUEST');
  }

  Future<void> clearAllPrefs() async {
    final shared = await initializdPrefs();
    await shared.clear();
  }

  Future<void> setKeyData(String key, String value) async {
    final shared = await initializdPrefs();
    print(key);
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
    print(response);
    return RestaurentMenuModel.fromJson(response.data);
  }

  Future<String> getAccessToken() async {
    final shared = await initializdPrefs();
    return shared.getString('accessToken');
  }

  Future<String> getUserId() async {
    final shared = await initializdPrefs();
    return shared.getInt('USERID').toString();
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

  Future<bool> subscribedOffer(String planID) async {
    FormData formData = FormData.fromMap({
      'subscription_plan_id': planID,
      'subscription_status': 'active',
      'subscription_start_date': DateTime.now().toString(),
      'subscription_end_date': DateTime.now()
          .add(Duration(
            days: 30,
          ))
          .toString()
    });
    accessToken = await getAccessToken();

    dio.options.headers['Authorization'] = "Bearer " + accessToken;

    await dio
        .request('/storeSubscription',
            data: formData, options: Options(method: 'post'))
        .then((value) {
      if (value.data['success'] == 200) {
        return true;
      }
    }).catchError((onError) {
      print(onError.toString());
    });

    return false;
  }

  Future<SpecificUserSubscriptionModel>
      getSpecificUserSubscriptionData() async {
    accessToken = await getAccessToken();

    dio.options.headers['Authorization'] = "Bearer " + accessToken;

    Response response = await dio.request(
      '/get-specific-user-subs',
    );
    print(response.data);

    if (response.data['success'] == true) {
      try {
        return SpecificUserSubscriptionModel.fromJson(response.data);
      } catch (onError) {
        print('ERROR hai');
        print(onError.toString());
        return null;
      }
    } else {
      return null;
    }
  }

  Future<GetAllSubscriptionModel> getAllSubscription() async {
    try {
      Response response = await dio.request('/get-all-subscription-plans');
      if (response.data['success'] == true)
        return GetAllSubscriptionModel.fromJson(response.data);
      else
        return null;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<FreemealModel> checkFreeMeal() async {
    String _userID = await getUserId();
    Response response = await dio.request('/get-free-meal/$_userID');
    return FreemealModel.fromJson(response.data);
  }

  Future<String> getUserdata() async {
    final shared = await initializdPrefs();
    return shared.getString('userdata');
  }

  Future<String> getStripeUserId() async {
    final shared = await initializdPrefs();
    return shared.getString('STRIPE_CUS_ID');
  }

  Future<bool> cancelStripeSubscription(subsID) async {
    try {
      Response response = await dio.request('/cancel-subscription/$subsID');
      print(response.data);
      if (response.data['success'] == true)
        return true;
      else
        return false;
    } catch (onError) {
      print(onError.toString());
      return false;
    }
  }

  Future<bool> checkAlreadyHaveSubscription(userId, planId) async {
    print(userId + ' ' + planId);
    FormData data = FormData.fromMap({
      'user_id': userId,
      'plan_id': planId,
    });
    try {
      Response response = await dio.request('/checkAlreadySubscribed',
          options: Options(method: 'post'), data: data);
      print(response.data);
      return response.data['success'];
    } catch (onError) {
      print(onError);
      return null;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    var pref = await initializdPrefs();
    FormData _formData = FormData.fromMap(data);
    String accessToken = await getAccessToken();
    dio.options.headers['Authorization'] = "Bearer " + accessToken;
    try {
      Response response = await dio.request('/updateUser',
          options: Options(method: 'POST'), data: _formData);
      if (response.data['success'] == true) {
        await setKeyData('userdata', jsonEncode(response.data['data']));
        return true;
      } else {
        return false;
      }
    } catch (onError) {
      print(onError.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>> changePassword(Map<String, dynamic> data) async {
    var pref = await initializdPrefs();
    FormData _formData = FormData.fromMap(data);
    String accessToken = await getAccessToken();
    dio.options.headers['Authorization'] = "Bearer " + accessToken;
    try {
      Response response = await dio.request('/changePassword',
          options: Options(method: 'POST'), data: _formData);
      if (response.data['success'] == true) {
        return {'success': true, 'message': response.data['message']};
      } else {
        return {'success': false, 'message': response.data['message']};
      }
    } catch (onError) {
      print(onError.toString());

      return {
        'success': false,
        'message': onError.toString(),
      };
    }
  }
}
