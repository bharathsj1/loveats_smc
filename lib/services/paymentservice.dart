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

 Future<dynamic> attachmethod(data,id) async {
    try{
// curl https://api.stripe.com/v1/payment_methods/pm_1JTCUf2eZvKYlo2C3tk1xyVy/attach 
    var resp = await this.dio.post('https://api.stripe.com/v1/payment_methods/'+id+'/attach',data:data,
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