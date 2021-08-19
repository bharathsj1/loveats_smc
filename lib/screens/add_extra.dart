import 'package:flutter/material.dart';
import 'package:potbelly/main.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/cartservice.dart';
import 'package:potbelly/values/values.dart';
import 'package:skeleton_text/skeleton_text.dart';

class AddExtraScreen extends StatefulWidget {
  var data;
  AddExtraScreen({@required this.data});

  @override
  _AddExtraScreenState createState() => _AddExtraScreenState();
}

class _AddExtraScreenState extends State<AddExtraScreen> {
  var itemqty = '1';
  List addons = [];
  bool _isLoading = true;

  @override
  void initState() {
    getaddson();
    // widget.data['item']['qty']='1';
    setState(() {});
    super.initState();
  }

  getaddson() async {
    // var response=[];
    if (widget.data['update'] != null && widget.data['update'] == true) {
      var response = await AppService()
          .getaddon(widget.data['restaurant']['id'].toString());
      print(response);
      for (var item in response['data']) {
        addons.add({'data': item, 'check': false});
      }
      for (var i = 0; i < addons.length; i++) {
        var data = widget.data['addon']
            .where((x) => x['data']['id'] == addons[i]['data']['id'])
            .toList();
        print(data);
        if (data.length > 0) {
          addons[i]['check'] = true;
        }
      }
      setState(() {});
      print(addons);
      _isLoading = false;
      setState(() {});
    } else {
      var response =
          await AppService().getaddon(widget.data['restaurant'].id.toString());
      print(response);
      for (var item in response['data']) {
        addons.add({'data': item, 'check': false});
      }
      print(addons);
      _isLoading = false;
      setState(() {});
    }
    // addons= response['data'];
  }

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

  loading() {
    return List.generate(
        6,
        (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
              child: SkeletonAnimation(
                // shimmerDuration: 1500,

                borderRadius: BorderRadius.circular(5.0),
                shimmerColor: Colors.grey.shade300,
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.0),
                      color: Colors.grey[200]),
                ),
              ),
            ));
  }

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
                if (widget.data['update'] != null &&
                    widget.data['update'] == true) {
                  CartProvider().updatecartaddon(
                      context,
                      widget.data['product'],
                      addons
                          .where((product) => product['check'] == true)
                          .toList(),
                      widget.data['addon']);
                  print(widget.data['product']);
                  Navigator.pop(context, true);
                } else {
                  print(widget.data['item']);
                  Map<String, dynamic> cartdata = {
                    'id': widget.data['item']['id'],
                    'restaurantId': widget.data['item']['rest_id'],
                    'image': widget.data['item']['menu_image'],
                    'details': widget.data['item']['menu_details'],
                    'name': widget.data['item']['menu_name'],
                    'price': double.parse(widget.data['item']['menu_price']),
                    'payableAmount':
                        widget.data['item']['menu_price'].toString(),
                    'qty': this.itemqty,
                    'data': widget.data['item'],
                    'restaurantdata': widget.data['restaurant'],
                    // 'topping': toppings
                    //     .where((product) => product['check'] == true)
                    //     .toList(),
                    // 'drink': drinks
                    //     .where((product) => product['check'] == true)
                    //     .toList()
                    'addon': addons
                        .where((product) => product['check'] == true)
                        .toList()
                  };
                  print(cartdata);
                  print(this.itemqty);
                  CartProvider().addToCart(context, cartdata);
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
                  setState(() {});
                  Navigator.pop(context);
                }
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
      bottomNavigationBar: Material(
          elevation: 20,
          child: Container(
            padding: EdgeInsets.only(top: 5),
            height: 60,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    if (int.parse(this.itemqty) > 1) {
                      this.itemqty = (int.parse(this.itemqty) - 1).toString();
                      setState(() {});
                      // totalprice();
                      if (int.parse(this.itemqty) == 1) {
                        // disabled = false;
                        setState(() {});
                      }
                      setState(() {});
                    }
                    // Provider.of<CartProvider>(context, listen: false)
                    //     .removeToCart(cartlist[i]);
                  },
                  child: Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(100)),
                      width: 32,
                      height: 32,
                      // child: Text(
                      //   "-",
                      //   style: TextStyle(
                      //       color: AppColors.secondaryElement,
                      //       fontSize: 70),
                      // )
                      child: Icon(
                        Icons.minimize,
                        color: AppColors.white,
                        size: 20,
                      )),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  this.itemqty,
                  style: TextStyle(
                      fontSize: 32,
                      color: AppColors.secondaryElement,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: () {
                    print('here');
                    this.itemqty = (int.parse(this.itemqty) + 1).toString();
                    print(this.itemqty);
                    setState(() {});

                    // Provider.of<CartProvider>(context, listen: false)
                    //     .addToCart(context, data);
                  },
                  child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(100)),
                      width: 32,
                      height: 32,
                      // child: Text(
                      //   "-",
                      //   style: TextStyle(
                      //       color: AppColors.secondaryElement,
                      //       fontSize: 70),
                      // )
                      child: Icon(
                        Icons.add,
                        color: AppColors.white,
                        size: 20,
                      )),
                ),
              ],
            ),
          )),
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
                    "What would you like to add?",
                    style: textTheme.title.copyWith(
                      fontSize: Sizes.TEXT_SIZE_16,
                      // fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            _isLoading
                ? Column(children: loading())
                : SingleChildScrollView(
                    child: Column(
                        children: List.generate(
                      addons.length,
                      (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          padding: EdgeInsets.zero,
                          // color: Colors.red,
                          child: CheckboxListTile(
                            tileColor: AppColors.white,
                            title: Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                  addons[index]['data']['name'] +
                                      '  ( ${StringConst.currency}' +
                                      addons[index]['data']['price'] +
                                      ' )',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal)),
                            ),
                            value: addons[index]['check'],

                            activeColor: AppColors.secondaryElement,
                            //  selectedTileColor: Colors.red,
                            contentPadding: EdgeInsets.all(0),
                            checkColor: AppColors.white,
                            onChanged: (newValue) {
                              setState(() {
                                addons[index]['check'] = newValue;
                              });
                            },

                            // controlAffinity:
                            //     ListTileControlAffinity.leading, //  <-- leading Checkbox
                          )),
                    )),
                  ),
            // Container(
            //   color: AppColors.secondaryColor,
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: Sizes.MARGIN_16,
            //     vertical: Sizes.MARGIN_16,
            //   ),
            //   child: Row(
            //     children: <Widget>[
            //       Text(
            //         "Please Choose Soft Drink",
            //         style: textTheme.title.copyWith(
            //           fontSize: Sizes.TEXT_SIZE_16,
            //           fontWeight: FontWeight.bold,
            //           color: AppColors.indigoShade1,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SingleChildScrollView(
            //   child: Column(
            //       children: List.generate(
            //     drinks.length,
            //     (index) => Container(
            //         margin: EdgeInsets.symmetric(horizontal: 15),
            //         padding: EdgeInsets.zero,
            //         // color: Colors.red,
            //         child: CheckboxListTile(
            //           tileColor: AppColors.white,
            //           title: Padding(
            //             padding: const EdgeInsets.only(top: 2.0),
            //             child: Text(drinks[index]['name'],
            //                 style: TextStyle(
            //                     color: Colors.black54,
            //                     fontSize: 17,
            //                     fontWeight: FontWeight.normal)),
            //           ),
            //           value: drinks[index]['check'],

            //           activeColor: AppColors.secondaryElement,
            //           //  selectedTileColor: Colors.red,
            //           contentPadding: EdgeInsets.all(0),
            //           checkColor: AppColors.white,
            //           onChanged: (newValue) {
            //             setState(() {
            //               drinks[index]['check'] = newValue;
            //             });
            //           },

            //           // controlAffinity:
            //           //     ListTileControlAffinity.leading, //  <-- leading Checkbox
            //         )),
            //   )),
            // )
          ],
        ),
      ),
    );
  }
}
