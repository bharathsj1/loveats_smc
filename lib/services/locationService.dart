import 'package:dio/dio.dart';
import 'package:potbelly/values/values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  var dio =  new Dio(
    BaseOptions(
      baseUrl: StringConst.BASE_URL,
      connectTimeout: 3000,
      receiveTimeout: 5000,
    ),
  );
  

  Future<String> getAccessToken() async {
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('accessToken');
  }

   Future<dynamic> setdriverloc(data) async {
    String accessToken = await getAccessToken();
     dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
     FormData formData = new FormData.fromMap(data);
    var resp = await this.dio.post("/update-driver-lat-lng",data: formData);
    print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
   }


    Future<dynamic> getorderdetail(id) async {
    // String accessToken = await getAccessToken();
    //  dio.options.headers['Authorization'] = "Bearer " + accessToken;
       try{
    var resp = await this.dio.get("/get-specific-order/"+id.toString(),);
    print(resp);
    return resp.data;
  }catch(e){
       print(e);
       return null;
     }
  }
  

}