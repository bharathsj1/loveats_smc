import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/paymentservice.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
// import 'package:stripe_payment/stripe_payment.dart';

class AddNewCart extends StatefulWidget {
  dynamic data;
  AddNewCart({@required this.data});
  @override
  _AddNewCartState createState() => _AddNewCartState();
}

class _AddNewCartState extends State<AddNewCart> {
  List statusList = [
    {'id': 1, 'name': 'Cradit/Debit'},
    {'id': 2, 'name': 'Bank Account'},
    // {'id':3,'name':'Cancelled'},
  ];
  TextEditingController cardnumber = TextEditingController();
  TextEditingController cardholder = TextEditingController();
  TextEditingController expm = TextEditingController();
  TextEditingController expy = TextEditingController();
  TextEditingController cvv = TextEditingController();
  bool checkBoxValue = true;
  // PaymentMethod _paymentMethod;
  dynamic _item;
  bool loader = false;

  var service = AppService();

  var extra = 0;
  String name = '';
  var totalprice = 0.0;
  var rental = 0.0;
  var fee_percent = 0.0;
  var discount = 0.0;
  var fee = 0.0;
  bool savecard = false;
  dynamic local = "";
  var username = "";
  var id;
  var photo = "";
  bool usecustomcard = false;

  CardDetails _card ;

  localdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
      this.local = jsonDecode(prefs.getString('data'));
      // print('local');
      // print(local);
      // this.name = this.local['user']['name'];
      // this.id = this.local['user']['id'];
      // this.photo= this.local['user']['photo'];
      // print(name);
    });
    print('local data here');
    print(this.local);
  }

  // final CreditCard testCard = CreditCard(
  //   number: '4000002760003184',
  //   expMonth: 12,
  //   expYear: 21,
  // );

  @override
  void initState() {
    this.usecustomcard = widget.data['subscribe'];
    // setState(() {});
    _card = CardDetails();
    super.initState();
  }

  createmethod(data) {
    var testCard2 = {
      'number': '4242424242424242',
      'exp_month': 6,
      'exp_year': 2022,
      'cvc': '314',
    };

    var card2 = {
      'type': 'card',
      'card': testCard2,
      'billing_details': {'name': 'spider'}
    };
  }

  void setError(dynamic error) {
    Toast.show(error.message, context, duration: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            ImagePath.arrowBackIcon,
            color: AppColors.black,
          ),
        ),
        // centerTitle: true,
        title: Text(
          usecustomcard ? 'Buy Subscription' : 'Add a Payment method',
          style: Styles.customTitleTextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: Sizes.TEXT_SIZE_16,
          ),
        ),
      ),
      // backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(15.0),
                  //   child: Card(
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(25.0),
                  //     ),
                  //     elevation: 2,
                  //     child: Padding(
                  //       padding:
                  //           const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  //       child: TextField(
                  //         // controller: password,
                  //         decoration: InputDecoration(
                  //           // contentPadding: EdgeInsets.all(5),
                  //           border: InputBorder.none,
                  //           prefixIcon: Icon(
                  //             Icons.search,
                  //             color: mainColor,
                  //             size: 20,
                  //           ),
                  //           hintText: 'Search Salons',

                  //           hintStyle: TextStyle(

                  //             fontSize: 14,
                  //             color: Colors.grey,
                  //           ),

                  //           // border:OutlineInputBorder(
                  //           //   borderRadius:BorderRadius.circular(20.0),
                  //           // ),
                  //         ),
                  //         // obscureText: true,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      // borderRadius: BorderRadius.only(
                      //     topRight: Radius.circular(20.0),
                      //     topLeft: Radius.circular(20.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 20, vertical: 0),
                          //   child: Container(
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         Text('${StringConst.currency}'+this.totalprice.toStringAsFixed(2),
                          //             style: TextStyle(
                          //                 fontSize: 40, color: Colors.black45)),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        'CARD NUMBER',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: AppColors.black),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          // elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 0),
                                            child: Container(
                                              width: 170,
                                              child: TextFormField(
                                                controller: cardnumber,
                                                autofocus: true,
                                                cursorColor:
                                                    AppColors.secondaryElement,
                                                maxLength: 16,
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (number) {
                                                  setState(() {
                                                    _card = _card.copyWith(
                                                        number: number);
                                                  });
                                                },
                                                
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                                decoration: InputDecoration(
                                                
                                                  //         border: new OutlineInputBorder(
                                                  // borderSide: new BorderSide(color: Colors.teal)),
                                                  //       contentPadding: EdgeInsets.all(5),
                                                  border: InputBorder.none,
                                                  counterText: "",

                                                  // prefixIcon: Icon(
                                                  //   Icons.person,
                                                  //   color: mainColor,
                                                  //   size: 20,
                                                  // ),
                                                  hintText:
                                                      '1234  2341  1234  3256',
                                                  hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),

                                                  // border:OutlineInputBorder(
                                                  //   borderRadius:BorderRadius.circular(20.0),
                                                  // ),
                                                  
                                                ),
                                                
                                                // obscureText: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          // elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 0),
                                            child: Row(
                                              children: [
                                                Container(
                                                    width: 40,
                                                    child: Container(
                                                      width: 30,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/images/visa2.png'))),
                                                    )),
                                                Container(
                                                    width: 40,
                                                    child: Container(
                                                      width: 30,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/images/master.png'))),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        'CARDHOLDER NAME',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: AppColors.black),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          // elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 0),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.75,
                                              child: TextField(
                                                controller: cardholder,
                                                cursorColor:
                                                    AppColors.secondaryElement,

                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                                decoration: InputDecoration(
                                                  // contentPadding: EdgeInsets.all(5),
                                                  border: InputBorder.none,
                                                  // prefixIcon: Icon(
                                                  //   Icons.person,
                                                  //   color: mainColor,
                                                  //   size: 20,
                                                  // ),
                                                  hintText: 'ENTER NAME',
                                                  hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),

                                                  // border:OutlineInputBorder(
                                                  //   borderRadius:BorderRadius.circular(20.0),
                                                  // ),
                                                ),
                                                // obscureText: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(
                                            'EXPIRE DATE',
                                            style: TextStyle(fontSize: 11),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 0),
                                                child: Container(
                                                  width: 30,
                                                  child: TextField(
                                                    controller: expm,
                                                    cursorColor: AppColors
                                                        .secondaryElement,

                                                    maxLength: 2,
                                                    onChanged: (number) {
                                                      setState(() {
                                                        _card = _card.copyWith(
                                                            expirationMonth:
                                                                int.tryParse(
                                                                    number));
                                                      });
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      // contentPadding: EdgeInsets.all(5),
                                                      border: InputBorder.none,
                                                      // prefixIcon: Icon(
                                                      //   Icons.person,
                                                      //   color: mainColor,
                                                      //   size: 20,
                                                      counterText: "",
                                                      // ),
                                                      hintText: 'MM',
                                                      hintStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                      ),

                                                      // border:OutlineInputBorder(
                                                      //   borderRadius:BorderRadius.circular(20.0),
                                                      // ),
                                                    ),
                                                    // obscureText: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              // elevation: 2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 0),
                                                child: Container(
                                                  width: 30,
                                                  child: TextField(
                                                    controller: expy,
                                                    cursorColor: AppColors
                                                        .secondaryElement,
                                                    onChanged: (number) {
                                                      setState(() {
                                                        _card = _card.copyWith(
                                                            expirationYear:
                                                                int.tryParse(
                                                                    number));
                                                      });
                                                    },
                                                    maxLength: 2,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      // contentPadding: EdgeInsets.all(5),
                                                      border: InputBorder.none,
                                                      // prefixIcon: Icon(
                                                      //   Icons.person,
                                                      //   color: mainColor,
                                                      //   size: 20,
                                                      counterText: "",
                                                      // ),
                                                      hintText: 'YY',
                                                      hintStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                      ),

                                                      // border:OutlineInputBorder(
                                                      //   borderRadius:BorderRadius.circular(20.0),
                                                      // ),
                                                    ),
                                                    // obscureText: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(
                                            'CVV',
                                            style: TextStyle(fontSize: 11),
                                          ),
                                        ),
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          // elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 0),
                                            child: Container(
                                              width: 30,
                                              child: TextField(
                                                controller: cvv,
                                                cursorColor:
                                                    AppColors.secondaryElement,
                                                onChanged: (number) {
                                                  setState(() {
                                                    _card = _card.copyWith(
                                                        cvc: number);
                                                  });
                                                },
                                                maxLength: 3,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  // contentPadding: EdgeInsets.all(5),
                                                  border: InputBorder.none,
                                                  counterText: "",
                                                  // prefixIcon: Icon(
                                                  //   Icons.person,
                                                  //   color: mainColor,
                                                  //   size: 20,
                                                  // ),
                                                  hintText: '123',
                                                  hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),

                                                  // border:OutlineInputBorder(
                                                  //   borderRadius:BorderRadius.circular(20.0),
                                                  // ),
                                                ),
                                                // obscureText: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // end--------------------------------------------------------------------------------------------
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 5,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            color: AppColors.white,
            margin: EdgeInsets.only(top: 5),
            height: 65,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                loader
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.secondaryElement),
                          ),
                        ),
                      )
                    : PotbellyButton(
                        'Save Card',
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            loader = true;
                          });
                          if (this.cardnumber.text.trim() != '' &&
                              this.cardholder.text.trim() != '' &&
                              this.expm.text.trim() != '' &&
                              this.expy.text.trim() != '' &&
                              this.cvv.text.trim() != '') {
                            if (usecustomcard) {
                              try{
                              await Stripe.instance
                                  .dangerouslyUpdateCardDetails(_card);
                              final paymentMethod = await Stripe.instance
                                  .createPaymentMethod(
                                      PaymentMethodParams.card(
                                       
                                      ));
                                   
                              setState(() {});
                              print(paymentMethod);
                               var userstripe = await Service().getStripeUserId();
                               print(userstripe);
                             var data={
                              //  'method':paymentMethod.id,
                               'customer':userstripe
                             };
                             var respo=  await PaymentService().attachmethod(data,paymentMethod.id);
                             print(respo);
                              if(respo ==null){
                                 Toast.show('Error', context, duration: 3);
                                 loader = false;
                                 setState(() { 
                                 });
                              }
                              else{
                                
                              var data2 = {
                                //  'user_id':42,
                                'payment_method_id': paymentMethod.id
                                // 'payment_method_id': 'pm_1JTCIEHxiL0NyAbFOj0g7r9Q'
                              };
                              var response = await AppService().storesub(data2);
                              print(response);
                              if(response ==null){
                                 Toast.show('Error', context, duration: 3);
                                 loader = false;
                                 setState(() { 
                                 });
                              }
                              else{
                                 loader = false;
                                Navigator.pop(context);
                                Toast.show('Subscribed', context,
                                    duration: 3);
                                setState(() {});
                              }
                              }
                              }
                              catch(error){
                                 Toast.show('Error', context, duration: 3);
                              }
                              setState(() {});
                            } else {
                              var data = {
                                'number': cardnumber.text,
                                'name': cardholder.text,
                                'phone': cardnumber.text,
                                'email': 'ali@gmail.com',
                                'cvc': cvv.text,
                                'exp_month': expm.text,
                                'exp_year': '2022',
                              };
                              var respo = await AppService().savecard(data);
                              print(respo);
                              if (respo['success'] == true) {
                                loader = false;
                                Navigator.pop(context);
                                Toast.show('New method saved', context,
                                    duration: 3);
                                setState(() {});
                              } else {
                                loader = false;
                                Toast.show('error', context, duration: 3);
                              }
                            }
                          }
                        },
                        buttonHeight: 45,
                        buttonWidth: MediaQuery.of(context).size.width * 0.89,
                        buttonTextStyle: TextStyle(
                            fontSize: 18,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: cardholder.text.trim().length > 0 &&
                                    cardnumber.text.trim().length > 0 &&
                                    expm.text.trim().length > 0 &&
                                    expy.text.trim().length > 0 &&
                                    cvv.text.trim().length > 0
                                ? AppColors.secondaryElement
                                : AppColors.grey),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
