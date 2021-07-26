import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potbelly/values/values.dart';

class NewFilterScreen extends StatefulWidget {
  const NewFilterScreen({ Key key }) : super(key: key);

  @override
  _NewFilterScreenState createState() => _NewFilterScreenState();
}

class _NewFilterScreenState extends State<NewFilterScreen> {
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
    {'icon':OMIcons.sort,'name': 'Sort', 'check': false},
    {'icon':OMIcons.fastfood,'name': 'Hygiene rating', 'check': false},
    {'icon':OMIcons.localOffer,'name': 'Offers', 'check': false},
    // {'icon':OMIcons.healing,'name': 'Dietary', 'check': false},
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
          'Filters',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'roboto'),
        ),
        // actions: [
        //   InkWell(
        //       onTap: () {
        //         // Map<String, dynamic> cartdata = {
        //         //   'id': data['id'],
        //         //   'restaurantId':
        //         //       data['restaurantId'],
        //         //   'image': data['image'],
        //         //   'details': data['details'],
        //         //   'name': data['name'],
        //         //   'price': data['price'],
        //         //   'payableAmount':
        //         //       data['price'].toString(),
        //         //   'qty': data['qty'],
        //         //   'data': data,
        //         //   'restaurantdata': widget
        //         //       .restaurantDetails.data,
        //         //   'topping': toppings
        //         //       .where((product) =>
        //         //           product['check'] ==
        //         //           true)
        //         //       .toList(),
        //         //   'drink': drinks
        //         //       .where((product) =>
        //         //           product['check'] ==
        //         //           true)
        //         //       .toList()
        //         // };
        //         // print(data['qty']);
        //         // CartProvider()
        //         //     .addToCart(context, cartdata);
        //         // if (fooditems[index]['cart'] !=
        //         //         null &&
        //         //     fooditems[index]['cart'] ==
        //         //         true) {
        //         //   var qtyy = int.parse(
        //         //       fooditems[index]['qty2']);
        //         //   qtyy++;
        //         //   fooditems[index]['qty2'] =
        //         //       qtyy.toString();
        //         // } else {
        //         //   fooditems[index]['qty2'] =
        //         //       fooditems[index]['qty'];
        //         // }

        //         // fooditems[index]['cart'] = true;
        //         // print(fooditems[index]);
        //         // Navigator.pop(context);
        //         // setState(() {});
        //         Navigator.pop(context);
        //       },
        //       child: Container(
        //           child: Icon(
        //         Icons.check,
        //         color: AppColors.secondaryElement,
        //       ))),
        //   SizedBox(
        //     width: 15,
        //   )
        // ],
      ),
      body: new Container(
        child: Container(
          // height: MediaQuery.of(context).size.height / 1.2,
          color: Colors.white60,
          child: SingleChildScrollView(
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
                        "",
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
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child:Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Row(
                                children: [
                                  Icon(drinks[index]['icon'],color: Colors.black54,),
                                  SizedBox(width: 20,),
                                  Text(drinks[index]['name'],
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 17,
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                          ),
                          ),
                        ),
                        // child: CheckboxListTile(
                        //   tileColor: AppColors.white,
                        //   title: Padding(
                        //     padding: const EdgeInsets.only(top: 2.0),
                        //     child: Row(
                        //       children: [
                        //         Icon(drinks[index]['icon']),
                        //         SizedBox(width: 10,),
                        //         Text(drinks[index]['name'],
                        //             style: TextStyle(
                        //                 color: Colors.black54,
                        //                 fontSize: 17,
                        //                 fontWeight: FontWeight.normal)),
                        //       ],
                        //     ),
                        //   ),
                        //   value: drinks[index]['check'],

                        //   activeColor: AppColors.secondaryElement,
                        //   //  selectedTileColor: Colors.red,
                        //   contentPadding: EdgeInsets.all(0),
                        //   checkColor: AppColors.white,
                        //   onChanged: (newValue) {
                        //     setState(() {
                        //       drinks[index]['check'] = newValue;
                        //     });
                        //   },

                        //   // controlAffinity:
                        //   //     ListTileControlAffinity.leading, //  <-- leading Checkbox
                        // )
                        
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
                        "Categories",
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
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}