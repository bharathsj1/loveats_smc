import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioConfig {
  var dio = Dio();
  DioConfig() {
    print('agaya');
    
    this
        .dio
        .interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options,) async {
          options.headers["accept"] = "application/json";
          try {
             SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
           var token=  sharedPreferences.getString('accessToken');
           
            options.headers["Authorization"] = "Bearer "+ token;
            print('good');
            print(options.headers["Authorization"] );
            // return options;
          } catch (e) {
            print('error here');
          }
          // print(options.toString());
          return options;
        }, onResponse: (Response response) async {
          print('here2');
          return response;
        }, 
        onError: (DioError e,) async {
          print(e.message);
          return e;
        }
        ));
  }
}