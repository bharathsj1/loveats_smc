import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/cartservice.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';

import 'cart_screen.dart';

class BuyIngredients extends StatefulWidget {
  var data;
  BuyIngredients({@required this.data});

  @override
  _BuyIngredientsState createState() => _BuyIngredientsState();
}

class _BuyIngredientsState extends State<BuyIngredients> {
  double totalAmount = 0.0;
  double charges = 0.0;
  double shipping = 3.0;

  @override
  void initState() {
    shipping= widget.data['delivery'];
    if(widget.data['usersub']){
      totalAmount=0.0;
      charges=0.0;
      shipping=0.0;
    }
    else{
    calculate();
    }
    super.initState();
  }

  calculate() {
    var personselect = widget.data['person'];
    for (var item in widget.data['ingredients']) {
      totalAmount += personselect == 1
          ? double.parse(item['ingridient']['4_person_price'])
          : personselect == 2
              ? double.parse(item['ingridient']['6_person_price'])
              : double.parse(item['ingridient']['2_person_price']);
    }
    print(totalAmount);
  }

  ingredient() {
    var ingridient = widget.data['ingredients'];
    print(ingridient);
    var personselect = widget.data['person'];
    return List.generate(
        ingridient.length,
        (i) => Column(
              children: [
                Divider(
                  thickness: 0.3,
                  color: Colors.black54,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ingridient[i]['ingridient']['name'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: Styles.customNormalTextStyle(
                            color: Colors.black,
                            fontSize: Sizes.TEXT_SIZE_14,
                          ),
                        )),
                    Text(
                        (personselect == 1
                                ? ingridient[i]['three_person_quantity']
                                : personselect == 2
                                    ? ingridient[i]['four_person_quantity']
                                    : ingridient[i]['two_person_quantity']) +
                            ' ' +
                            ingridient[i]['ingridient']['unit'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: Styles.customNormalTextStyle(
                              color: AppColors.secondaryElement,
                              fontSize: Sizes.TEXT_SIZE_14,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ));
  }

  pricerow(String name, String value, info, infovalue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name,
            style: TextStyle(
                fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w400)),
        Row(
          children: [
            info
                ? MyTooltip(
                    message: infovalue,
                    child: Icon(
                      Icons.info_outline,
                      color: AppColors.black.withOpacity(0.2),
                      size: 16,
                    ),
                  )
                : Container(),
            SizedBox(
              width: 2,
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400),
            ),
          ],
        )
      ],
    );
  }

  items() {
    return Column(
      children: ingredient(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryElement,
        elevation: 1,
        title: Text(
          'Buy Ingredients',
          style: TextStyle(color: AppColors.white),
        ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          color: Colors.white,
          ),
          child: Column(
            children: [
               SizedBox(height: 8,),
               Padding(
                     padding: const EdgeInsets.symmetric(horizontal:20.0),
                     child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Package total',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.normal)),
                                        Text(
                                          '${StringConst.currency}' +
                                              (totalAmount + shipping + charges)
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.black,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                   ),
                   SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  
                  Center(
                    child: PotbellyButton(
                      // 'Add to cart',
                      'Buy Now',
                      buttonHeight: 45,
                      buttonWidth: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(
                          color: AppColors.secondaryElement,
                          borderRadius: BorderRadius.circular(10)),
                      buttonTextStyle:
                          TextStyle(color: AppColors.white, fontSize: 15),
                      onTap: () async {
                //        Map<String, dynamic> packcartdata = {
                //   'id': widget.data['recipe']['id'],
                //   'person': widget.data['person'],
                //   'image': widget.data['recipe']['image'],
                //   'details': widget.data['recipe']['short_description'],
                //   'name': widget.data['recipe']['title'],
                //   'price': totalAmount,
                //   'payableAmount': totalAmount.toString(),
                //   'qty': '1',
                //   'data': widget.data,
                // };
                // print(packcartdata);
                //  CartProvider().packageaddToCart(context, packcartdata);


                  // var person= widget
                  //                         .checkoutdata['packlist'][i]['person'];
                                           String userId = await Service().getUserId();
                                    var packdata = {
                                      'total_amount':(totalAmount + shipping + charges).toStringAsFixed(2),
                                      'payment_method': 'subscriber',
                                      'is_receipe': 1,
                                      'method_id':'empty',
                                          'user_id': userId,
                                      'payment_id':
                                          'empty',
                                      'customer_addressId':
                                         1,
                                        'is_subscribed_user': widget.data['usersub']? 1:0,
                                        'receipe_id': widget.data['recipe']['id'],
                                        'recipe':true,
                                        
                                        'usersub':widget.data['usersub']
                                      // 'person_quantity': person ==1? '4':person==2?'6':'2',
                                      // 'receipe_id': widget
                                      //     .checkoutdata['packlist'][i]['id']
                                    };
                                    // print(packdata);
                                    // AppService()
                                    //     .addeorder(packdata)
                                    //     .then((value) {
                                    //   print(value);
                                    // });
                                    // setState(() {}); 
                                     Navigator.pushNamed(context, AppRouter.CheckOut1,
                                  arguments: packdata);
               
                      }
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: widget.data['recipe']['image'],
            width: MediaQuery.of(context).size.width,
            height: 250,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 150,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        // text: 'Hello ',
                        style: TextStyle(fontSize: 15, fontFamily: 'roboto'),
                        children: [
                          TextSpan(
                              text: toBeginningOfSentenceCase(
                                  'Ingredients Package - '),
                              // textAlign: TextAlign.left,
                              style: Styles.customTitleTextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )),
                          TextSpan(
                              text: toBeginningOfSentenceCase(
                                  widget.data['recipe']['title']),
                              // textAlign: TextAlign.left,
                              style: Styles.customTitleTextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(toBeginningOfSentenceCase('Ingredients'),
                        // textAlign: TextAlign.left,
                        style: Styles.customTitleTextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    Column(
                      children: [items()],
                    ),
                    Divider(
                      thickness: 0.3,
                      color: Colors.black54,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          pricerow(
                              'Subtotal',
                              '${StringConst.currency}' +
                                  totalAmount.toStringAsFixed(2),
                              false,
                              ''),
                          SizedBox(
                            height: 5,
                          ),
                          pricerow(
                              'Service Fee',
                              '${StringConst.currency}' +
                                  charges.toStringAsFixed(2),
                              true,
                              'This fee is 5% of your cart before promotions or discounts are applied. It has a minimum of ${StringConst.currency}' +
                                  charges.toStringAsFixed(2)),
                          SizedBox(
                            height: 5,
                          ),
                          pricerow(
                              'Delivery Fee',
                              '${StringConst.currency}' +
                                  shipping.toStringAsFixed(2),
                              true,
                              'This restaurant provides delivery in ${StringConst.currency}' +
                                  shipping.toStringAsFixed(2)),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    )
                  ])),

                  
        ],
      )),
    );
  }
}
