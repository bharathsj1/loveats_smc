import 'package:dio/dio.dart';
import 'package:potbelly/values/values.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'interceptors.dart';

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

  
  Future<dynamic> getOrdersForSpecificOwnerRestaurent() async {
    String accessToken = await getAccessToken();
     dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
    var resp = await this.dio.get("/getOrdersForSpecificOwnerRestaurent",);
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
    var resp = await this.dio.post("/addOrderItem",data: formData);
    print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
  }

}