import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
  int charges = 0;
  int shipping = 3;

  ingredient() {
    var ingridient = widget.data['ingredients'];
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
        backgroundColor: AppColors.white,
        elevation: 1,
        title: Text(
          'Buy Ingredients',
          style: TextStyle(color: AppColors.black),
        ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Container(
          height: 60,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: PotbellyButton(
                  'Add to cart',
                  buttonHeight: 45,
                  buttonWidth: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                      color: AppColors.secondaryElement,
                      borderRadius: BorderRadius.circular(10)),
                  buttonTextStyle:
                      TextStyle(color: AppColors.white, fontSize: 15),
                  onTap: () {
                    // if(widget.data['stepno']+1 == widget.data['steps'].length){
                    //    print('last');
                    //    Navigator.pushNamed(context, AppRouter.Enjoy_Meal);
                    //  }
                    //  else{
                    //    Navigator.pushNamed(context, AppRouter.Steps_Screen,
                    //       arguments: {
                    //         'steps': widget.data['steps'],
                    //         'stepno': widget.data['stepno']+1
                    //       });
                    //  }
                  },
                ),
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
                            height: 5,
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
