import 'package:flutter/material.dart';
import 'package:potbelly/models/restaurent_menu_model.dart';
import 'package:potbelly/values/values.dart';

import 'demo_data.dart';
import 'swipe_item.dart';

// Content for the list items.
class EmailCard extends StatelessWidget {
  final email;
  final Color backgroundColor;

  EmailCard({this.email, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    print(email);
    // var food = FoodCategory.fromJson(email['foodCategoryName']);
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: w + 0.1,
      height: SwipeItem.nominalHeight,
      margin: EdgeInsets.symmetric(vertical: 0.2),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: Colors.black.withOpacity(0.5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    email['image'],
                    loadingBuilder: (BuildContext ctx, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Container(
                          // height: ,
                          width: 50,
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.secondaryElement),
                            ),
                          ),
                        );
                      }
                    },
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                  )),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(email['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: .3,
                              )),
                        ),
                        const SizedBox(width: 10.0,),
                      email['foodCategoryName'] !=null &&  email['foodCategoryName'].isDiscount == 'true'
                            ? Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red,
                                  ),
                                  padding: EdgeInsets.all(3.0),
                                  child: Text(
                                    '100% discount for subscribers',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('\$' + email['price'].toString(),
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: .3,
                            )),
                        Text(email['details'],
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: .3,
                            )),
                        if (email['cart'] != null && email['cart'] == true)
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Text('x' + email['qty2'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        letterSpacing: .3,
                                        color: Color(0xff55c8d4)
                                        // color: AppColors.secondaryElement
                                        )),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.add_shopping_cart_sharp,
                                  size: 18.0, color: Color(0xff55c8d4)),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle addressTextStyle = Styles.customNormalTextStyle(
    color: AppColors.accentText,
    fontSize: Sizes.TEXT_SIZE_12,
  );

  TextStyle subHeadingTextStyle = Styles.customTitleTextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w600,
    fontSize: Sizes.TEXT_SIZE_16,
  );
}
