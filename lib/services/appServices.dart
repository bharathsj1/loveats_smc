import 'package:dio/dio.dart';
import 'package:potbelly/values/values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppService {
  var dio =  new Dio(
    BaseOptions(
      baseUrl: StringConst.BASE_URL,
      connectTimeout: 5000,
      receiveTimeout: 8000,
    ),
  );
  
  Future<dynamic> getRestaurant() async {
    String accessToken = await getAccessToken();
     dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
    var resp = await this.dio.get("/get-restaurents",);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
  }

  
  Future<String> getAccessToken() async {
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('accessToken');
  }
  Future<String> gettype() async {
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('accounttype');
  }

  
  Future<dynamic> getOrdersRestaurent() async {
    String accessToken = await getAccessToken();
    String accounttype = await gettype();
     dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
    var resp = await this.dio.get( accounttype == '0'? "/get-all-orders": "/getOrdersForSpecificOwnerRestaurent",);
    print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
  }

  Future<dynamic> getaddress() async {
    String accessToken = await getAccessToken();
     dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
    var resp = await this.dio.get("/get-user-address",);
    print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
  }

  Future<dynamic> getnoti() async {
    String accessToken = await getAccessToken();
     dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
    var resp = await this.dio.get("/getSpecificNotification",);
    print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
  }

  Future<dynamic> getmyorders() async {
    String accessToken = await getAccessToken();
     dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
    var resp = await this.dio.get("/get-user-orders",);
    print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
  }

  Future<dynamic> setaddress(data) async {
    String accessToken = await getAccessToken();
     dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
     FormData formData = new FormData.fromMap(data);
    var resp = await this.dio.post("/addUserAddress",data: formData);
    print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
  }
  Future<dynamic> sendnotisuperadmin(data) async {
    // String accessToken = await getAccessToken();
    //  dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
     FormData formData = new FormData.fromMap(data);
    var resp = await this.dio.post("/sendNotificationToSuperAdmin",data: formData);
    print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
  }

  Future<dynamic> sendnotispecificuser(data) async {
    // String accessToken = await getAccessToken();
    //  dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
     FormData formData = new FormData.fromMap(data);
    var resp = await this.dio.post("/send-notification-to-specific-user",data: formData);
    print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
  }

  Future<dynamic> sendnotideliveryboy(data) async {
    // String accessToken = await getAccessToken();
    //  dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
     FormData formData = new FormData.fromMap(data);
    var resp = await this.dio.post("/sendNotificationToDeliverBoy",data: formData);
    print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
  }

      Future<dynamic> deletefcm() async {
    String accessToken = await getAccessToken();
     dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
    //  FormData formData = new FormData.fromMap(data);
    var resp = await this.dio.delete("/deleteFCM");
    // print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
    }

  Future<dynamic> savedeicetoken(data) async {
    String accessToken = await getAccessToken();
     dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
     FormData formData = new FormData.fromMap(data);
    var resp = await this.dio.post("/addDeviceToken",data: formData);
    print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
  }

  Future<dynamic> setsuperadmin(data) async {
    String accessToken = await getAccessToken();
     dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
     FormData formData = new FormData.fromMap(data);
    var resp = await this.dio.post("/change-super-admin",data: formData);
    print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
  }

  Future<dynamic> setorderstatus(data) async {
    String accessToken = await getAccessToken();
     dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
     FormData formData = new FormData.fromMap(data);
    var resp = await this.dio.post("/change-order-status",data: formData);
    print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
  }

  Future<dynamic> addeorder(data) async {
    String accessToken = await getAccessToken();
     dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
     FormData formData = new FormData.fromMap(data);
    var resp = await this.dio.post("/make-order",data: formData);
    print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
  }

  Future<dynamic> addorderdetails(data) async {
    String accessToken = await getAccessToken();
     dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
     FormData formData = new FormData.fromMap(data);
    var resp = await this.dio.post("/addOrderDetails",data: formData);
    print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
  }

}