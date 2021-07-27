import 'package:flutter/material.dart';
import 'package:potbelly/services/cartservice.dart';
import 'package:potbelly/values/values.dart';

class AddExtraScreen extends StatefulWidget {
  const AddExtraScreen({Key key}) : super(key: key);

  @override
  _AddExtraScreenState createState() => _AddExtraScreenState();
}

class _AddExtraScreenState extends State<AddExtraScreen> {
  List toppings = [
    {'name': 'Anchovies', 'check': false},
    {'name': 'Basil', 'check': false},
    {'name': 'Black Olives', 'check': false},
    {'name': 'Extra Cheese', 'check': false},
    {'name': 'Garlic Butter', 'check': false},
    {'name': 'Green Papers', 'check': false},
    {'name': 'Jalapenos', 'check': false},
    {'name': 'Mushrooms', 'check': false},
    {'name': 'Spicy Beef', 'check': false},
  ];

  List drinks = [
    {'name': '7 Up 1.5ltr', 'check': false},
    {'name': 'Pepsi 1.5ltr', 'check': false},
    {'name': 'Tango Orange 1.5ltr', 'check': false},
  ];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            color: AppColors.secondaryElement,
          ),
        ),
        title: Text(
          'Customise Item',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'roboto'),
        ),
        actions: [
          InkWell(
              onTap: () {
                // Map<String, dynamic> cartdata = {
                //   'id': data['id'],
                //   'restaurantId':
                //       data['restaurantId'],
                //   'image': data['image'],
                //   'details': data['details'],
                //   'name': data['name'],
                //   'price': data['price'],
                //   'payableAmount':
                //       data['price'].toString(),
                //   'qty': data['qty'],
                //   'data': data,
                //   'restaurantdata': widget
                //       .restaurantDetails.data,
                //   'topping': toppings
                //       .where((product) =>
                //           product['check'] ==
                //           true)
                //       .toList(),
                //   'drink': drinks
                //       .where((product) =>
                //           product['check'] ==
                //           true)
                //       .toList()
                // };
                // print(data['qty']);
                // CartProvider()
                //     .addToCart(context, cartdata);
                // if (fooditems[index]['cart'] !=
                //         null &&
                //     fooditems[index]['cart'] ==
                //         true) {
                //   var qtyy = int.parse(
                //       fooditems[index]['qty2']);
                //   qtyy++;
                //   fooditems[index]['qty2'] =
                //       qtyy.toString();
                // } else {
                //   fooditems[index]['qty2'] =
                //       fooditems[index]['qty'];
                // }

                // fooditems[index]['cart'] = true;
                // print(fooditems[index]);
                // Navigator.pop(context);
                // setState(() {});
                Navigator.pop(context);
              },
              child: Container(
                  child: Icon(
                Icons.check,
                color: AppColors.secondaryElement,
              ))),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.secondaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.MARGIN_16,
                vertical: Sizes.MARGIN_16,
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    "Please Choose Up To 2 Toppings",
                    style: textTheme.title.copyWith(
                      fontSize: Sizes.TEXT_SIZE_16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.indigoShade1,
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                  children: List.generate(
                toppings.length,
                (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsets.zero,
                    // color: Colors.red,
                    child: CheckboxListTile(
                      tileColor: AppColors.white,
                      title: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(toppings[index]['name'],
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 17,
                                fontWeight: FontWeight.normal)),
                      ),
                      value: toppings[index]['check'],

                      activeColor: AppColors.secondaryElement,
                      //  selectedTileColor: Colors.red,
                      contentPadding: EdgeInsets.all(0),
                      checkColor: AppColors.white,
                      onChanged: (newValue) {
                        setState(() {
                          toppings[index]['check'] = newValue;
                        });
                      },

                      // controlAffinity:
                      //     ListTileControlAffinity.leading, //  <-- leading Checkbox
                    )),
              )),
            ),
            Container(
              color: AppColors.secondaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.MARGIN_16,
                vertical: Sizes.MARGIN_16,
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    "Please Choose Soft Drink",
                    style: textTheme.title.copyWith(
                      fontSize: Sizes.TEXT_SIZE_16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.indigoShade1,
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                  children: List.generate(
                drinks.length,
                (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsets.zero,
                    // color: Colors.red,
                    child: CheckboxListTile(
                      tileColor: AppColors.white,
                      title: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(drinks[index]['name'],
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 17,
                                fontWeight: FontWeight.normal)),
                      ),
                      value: drinks[index]['check'],

                      activeColor: AppColors.secondaryElement,
                      //  selectedTileColor: Colors.red,
                      contentPadding: EdgeInsets.all(0),
                      checkColor: AppColors.white,
                      onChanged: (newValue) {
                        setState(() {
                          drinks[index]['check'] = newValue;
                        });
                      },

                      // controlAffinity:
                      //     ListTileControlAffinity.leading, //  <-- leading Checkbox
                    )),
              )),
            )
          ],
        ),
      ),
    );
  }
}
