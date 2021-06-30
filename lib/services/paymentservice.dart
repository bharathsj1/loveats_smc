import 'package:dio/dio.dart';


class PaymentService {
  var dio = new Dio();

 Future<dynamic> getIntent(data) async {
    try{

    var resp = await this.dio.post('https://api.stripe.com/v1/payment_intents',data:data,
     options: Options(
       contentType: 'application/x-www-form-urlencoded',
       headers: {"Authorization": 'Bearer sk_test_51ISmUBHxiL0NyAbFbzAEkXDMDC2HP0apPILEyaIYaUI8ux0yrBkHMI5ikWZ4teMNsixWP2IPv4yw9bvdqb9rTrhA004tpWU9yl'}
     )
    );
    return resp.data;
  }catch(e){
       print(e);
       return 'Error in payment';
     }
 }
 }