import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:potbelly/grovey_startScreens/ProviderService.dart';
import 'package:potbelly/grovey_startScreens/demo.dart';
import 'package:potbelly/models/free_meal_model.dart';
import 'package:potbelly/models/specific_user_subscription_model.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/cartservice.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool mixmatch = false;
  List cartlist = [];
  List newcart = [];
  bool loader = true;
  bool cutlery = false;
  bool addrestip = false;
  double newrestip = 0.00;
  double totalAmount = 0.0;
  double ridertip = 0.0;
  int charges = 0;
  int shipping = 3;
  int totalitems = 0;
  SpecificUserSubscriptionModel _specificUserSubscriptionModel;
  FreemealModel _freemealModel;
  bool isGuest = false;

  void getSpecificUserSubscription() async {
    isGuest = await Service().isGuest();
    if (!isGuest) {
      _specificUserSubscriptionModel =
          await Service().getSpecificUserSubscriptionData();
      _freemealModel = await Service().checkFreeMeal();
      print(_specificUserSubscriptionModel.data.length);
    }
    loader = false;
    setState(() {});
  }

  getcartlist() async {
    print(await Service().getUserdata());
    var cart = await CartProvider().getcartslist();
    cartlist.clear();
    newcart.clear();
    print(cart);
    // for (var item in cart) {
    for (var i = 0; i < cart.length; i++) {
      cartlist.add(cart[i]);
    }
    print(cartlist.length);
    List temp = [];
    for (var i = 0; i < cartlist.length; i++) {
      var res = temp
          .where((product) => product == cartlist[i]['restaurantId'])
          .toList();
      if (res.length == 0) {
        temp.add(cartlist[i]['restaurantId']);
        var data = cartlist
            .where((product) =>
                product['restaurantId'] == cartlist[i]['restaurantId'])
            .toList();

        totalitems += data.length;
        newcart.add(data);
      } else {
        print('already');
      }
    }

    if (newcart.length > 1) {
      mixmatch = true;
    }

    if (cartlist.length != 0) {
      calculate();
    }
    print(cartlist);
    //setState(() {});
  }

  calculate() {
    double total = 0;
    cartlist.forEach((f) {
      total += (f['price']) * double.parse(f['qty']);
    });
    totalAmount = total;
    print('total');
    print(totalAmount);
  }

  @override
  void initState() {
    getcartlist();
    getSpecificUserSubscription();
    super.initState();
  }

  calculateprice(i1, i2, type) {
    newcart[i1][i2]['qty'] = type == 'add'
        ? (int.parse(newcart[i1][i2]['qty']) + 1).toString()
        : (int.parse(newcart[i1][i2]['qty']) - 1).toString();
    newcart[i1][i2]['payableAmount'] =
        (((newcart[i1][i2]['price']) * int.parse(newcart[i1][i2]['qty'])))
            .toString();
  }

  List<Widget> renderAddList(i) {
    return List.generate(
        newcart[i].length,
        (index) => InkWell(
              onTap: () async {
                updateitem(context, (newcart[i][index]), i, index);
                //  await CartProvider().clearcart();
                //  getcartlist();
                //  setState(() {

                //  });
              },
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(newcart[i][index]['qty'] + 'x',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.secondaryElement,
                                  fontWeight: FontWeight.bold)),

                          // ClipRRect(
                          //     borderRadius: BorderRadius.circular(10),
                          //     child: Image.network(
                          //       newcart[i][index]['image'],
                          //       loadingBuilder: (BuildContext ctx, Widget child,
                          //           ImageChunkEvent loadingProgress) {
                          //         if (loadingProgress == null) {
                          //           return child;
                          //         } else {
                          //           return Container(
                          //             // height: ,
                          //             width: 90,
                          //             height: 90,
                          //             child: Center(
                          //               child: CircularProgressIndicator(
                          //                 valueColor:
                          //                     AlwaysStoppedAnimation<Color>(
                          //                         AppColors.secondaryElement),
                          //               ),
                          //             ),
                          //           );
                          //         }
                          //       },
                          //       fit: BoxFit.cover,
                          //       height: 90,
                          //       width: 90,
                          //     )),
                          SizedBox(
                            width: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.62,
                                      child: Text(newcart[i][index]['name'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 20,
                                              // fontWeight: FontWeight.bold
                                              color: AppColors.black)),
                                    ),
                                    Text(
                                        '${StringConst.currency}' +
                                            double.tryParse(newcart[i][index]
                                                    ['payableAmount'])
                                                .toStringAsFixed(2),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: AppColors.secondaryElement,
                                            fontWeight: FontWeight.w900)),
                                  ],
                                ),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                // Container(
                                //   // color: Colors.red,
                                //   width: MediaQuery.of(context).size.width * 0.50,
                                //   child: Text(newcart[i][index]['details'],
                                //       maxLines: 2,
                                //       overflow: TextOverflow.ellipsis,
                                //       style: TextStyle(
                                //           fontSize: 15,
                                //           fontWeight: FontWeight.bold,
                                //           color: Colors.black54)),
                                // ),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                // Row(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Container(
                                //       // color: Colors.red,
                                //       // margin: EdgeInsets.only(left: 0),
                                //       width:
                                //           MediaQuery.of(context).size.width * 0.4,
                                //       child: Text(
                                //           '${StringConst.currency}' +
                                //               newcart[i][index]['payableAmount'],
                                //           style: TextStyle(
                                //               fontSize: 18,
                                //               color: AppColors.secondaryElement,
                                //               fontWeight: FontWeight.w900)),
                                //     ),
                                //   ],
                                // ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    newcart[i][index]['addon'].length,
                                    (ind) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            newcart[i][index]['addon'][ind]
                                                ['data']['name'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.secondaryElement,
                                              letterSpacing: .3,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                // Column(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: List.generate(
                                //     newcart[i][index]['drink'].length,
                                //     (ind) => Column(
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.start,
                                //       children: [
                                //         Text(
                                //             newcart[i][index]['drink'][ind]
                                //                 ['name'],
                                //             style: TextStyle(
                                //               fontSize: 12,
                                //               color: AppColors.secondaryElement,
                                //               letterSpacing: .3,
                                //             )),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                SizedBox(
                                  height: 15,
                                ),
                                // Container(
                                //   width: MediaQuery.of(context).size.width * 0.50,
                                //   child: Row(
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       InkWell(
                                //         onTap: () async {
                                //           print('here');
                                //           await CartProvider()
                                //               .removeToCart(cartlist[index]);
                                //           // await CartProvider()
                                //           //     .clearcart();

                                //           getcartlist();
                                //         },
                                //         child: Row(
                                //           children: [
                                //             Icon(Icons.delete_outline,
                                //                 color: Colors.black54, size: 20),
                                //             Padding(
                                //               padding: const EdgeInsets.only(
                                //                   top: 5, left: 0),
                                //               child: Text('Remove',
                                //                   style: TextStyle(
                                //                       // fontSize: 18,
                                //                       color: Colors.black54,
                                //                       fontWeight:
                                //                           FontWeight.w600)),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //       Row(
                                //         mainAxisAlignment: MainAxisAlignment.end,
                                //         children: <Widget>[
                                //           InkWell(
                                //             onTap: () async {
                                //               if (int.parse(
                                //                       newcart[i][index]['qty']) >
                                //                   1) {
                                //                 // newcart[i][index]['qty'] =
                                //                 //     (int.parse(newcart[i][index]
                                //                 //                 ['qty']) -
                                //                 //             1)
                                //                 //         .toString();
                                //                 await calculateprice(
                                //                     i, index, 'minus');
                                //                 calculate();
                                //                 setState(() {});
                                //                 if (int.parse(newcart[i][index]
                                //                         ['qty']) ==
                                //                     1) {
                                //                   setState(() {});
                                //                 }
                                //                 setState(() {});
                                //               }
                                //             },
                                //             child: Container(
                                //                 alignment: Alignment.center,
                                //                 padding: EdgeInsets.zero,
                                //                 width: 40,
                                //                 child: Text(
                                //                   "-",
                                //                   style: TextStyle(
                                //                       color: AppColors
                                //                           .secondaryElement,
                                //                       fontSize: 50),
                                //                 )),
                                //           ),
                                //           Text(
                                //             newcart[i][index]['qty'],
                                //             style: TextStyle(fontSize: 18),
                                //           ),
                                //           InkWell(
                                //             onTap: () async {
                                //               print('here');
                                //               // newcart[i][index]['qty'] =
                                //               //     (int.parse(newcart[i][index]
                                //               //                 ['qty']) +
                                //               //             1)
                                //               //         .toString();
                                //               print(newcart[i][index]['qty']);
                                //               await calculateprice(
                                //                   i, index, 'add');
                                //               calculate();
                                //               setState(() {});

                                //               // Provider.of<CartProvider>(context, listen: false)
                                //               //     .addToCart(context, data);
                                //             },
                                //             child: Container(
                                //                 alignment: Alignment.center,
                                //                 padding: EdgeInsets.only(top: 2),
                                //                 width: 40,
                                //                 child: Text(
                                //                   "+",
                                //                   style: TextStyle(
                                //                       color: AppColors
                                //                           .secondaryElement,
                                //                       fontSize: 32),
                                //                 )),
                                //           ),
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Divider(
                        height: 1,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  List<Widget> resturantwithcart() {
    return List.generate(
        newcart.length,
        (i) => Column(
              children: [
                Material(
                  elevation: 1,
                  child: Container(
                    height: 50,
                    // color: Colors.grey[100],
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              newcart[i][0]['restaurantdata']['rest_image'],
                              loadingBuilder: (BuildContext ctx, Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Container(
                                    // height: ,
                                    width: 30,
                                    height: 30,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.secondaryElement),
                                      ),
                                    ),
                                  );
                                }
                              },
                              fit: BoxFit.cover,
                              height: 30,
                              width: 30,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          newcart[i][0]['restaurantdata']['rest_name'],
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: renderAddList(i),
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

  updateitem(BuildContext context, item, i, index) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mysetState) {
            return SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  item['name'],
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      item['addon'].length,
                      (ind) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['addon'][ind]['data']['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.grey,
                                letterSpacing: .3,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                // Center(
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: List.generate(
                //       item['drink'].length,
                //       (ind) => Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(item['drink'][ind]['name'],
                //               textAlign: TextAlign.center,
                //               style: TextStyle(
                //                 fontSize: 16,
                //                 color: AppColors.grey,
                //                 letterSpacing: .3,
                //               )),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.Add_Extra,
                        arguments: {
                          'update': true,
                          'drink': item['drink'],
                          'topping': item['topping']
                        });
                  },
                  child: Container(
                    child: Text(
                      'Customise Item',
                      style: TextStyle(
                          color: AppColors.secondaryElement,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 5,
                  color: Colors.grey.shade200,
                  thickness: 1.2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        if (int.parse(item['qty']) > 1) {
                          // newcart[i][index]['qty'] =
                          //     (int.parse(newcart[i][index]
                          //                 ['qty']) -
                          //             1)
                          //         .toString();
                          await calculateprice(i, index, 'minus');
                          calculate();
                          mysetState(() {});
                          setState(() {});
                          if (int.parse(item['qty']) == 1) {
                            setState(() {});
                          }
                          setState(() {});
                          mysetState(() {});
                        }
                      },
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.zero,
                          width: 40,
                          child: Text(
                            "-",
                            style: TextStyle(
                                color: AppColors.secondaryElement,
                                fontSize: 50),
                          )),
                    ),
                    Text(
                      item['qty'],
                      style: TextStyle(fontSize: 20),
                    ),
                    InkWell(
                      onTap: () async {
                        print('here');
                        // item['qty'] =
                        //     (int.parse(item
                        //                 ['qty']) +
                        //             1)
                        //         .toString();
                        print(item['qty']);
                        await calculateprice(i, index, 'add');
                        calculate();
                        mysetState(() {});
                        setState(() {});

                        // Provider.of<CartProvider>(context, listen: false)
                        //     .addToCart(context, data);
                      },
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 2),
                          width: 40,
                          child: Text(
                            "+",
                            style: TextStyle(
                                color: AppColors.secondaryElement,
                                fontSize: 32),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0,
                ),
                Text(
                    'Price: ${StringConst.currency}' +
                        double.tryParse(newcart[i][index]['payableAmount'])
                            .toStringAsFixed(2),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.grey,
                      letterSpacing: .3,
                    )),
                SizedBox(
                  height: 10,
                ),

                // Divider(
                //   height: 5,
                //   color: Colors.grey.shade200,
                //   thickness: 1.2,
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                //  Text(
                //   'Update',
                //   style: TextStyle(
                //       color: AppColors.secondaryElement,
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold),
                // ),
                SizedBox(
                  height: 20,
                ),
              ],
            ));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 1,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            ImagePath.arrowBackIcon,
            color: AppColors.black,
          ),
        ),
        // centerTitle: true,
        title: Text(
          'Shopping Cart',
          style: Styles.customTitleTextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.TEXT_SIZE_16,
          ),
        ),
      ),
      bottomNavigationBar: (loader == false && newcart.length == 0) ||
              (loader == false && newcart.length > 1 && mixmatch == false)
          ? null
          : Material(
              // elevation: 5,
              child: Container(
                color: AppColors.white,
                margin: EdgeInsets.only(top: 5),
                height: 105,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Rider Tip',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      if (this.ridertip > 0) {
                                        this.ridertip = this.ridertip - 1;
                                        setState(() {});
                                        // totalprice();
                                        if (this.ridertip == 1) {
                                          // disabled = false;
                                          setState(() {});
                                        }
                                        setState(() {});
                                      }
                                    },
                                    child: Container(
                                        alignment: Alignment.topCenter,
                                        margin: EdgeInsets.only(bottom: 5),
                                        decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        width: 16,
                                        height: 16,
                                        // child: Padding(
                                        //   padding: EdgeInsets.only(bottom: 6),
                                        //   child: Text(
                                        //     "-",
                                        //     style: TextStyle(
                                        //         color: AppColors.black,
                                        //         fontSize: 22),
                                        //   ),
                                        // )
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 0),
                                          child: Icon(
                                            Icons.minimize,
                                            color: AppColors.black,
                                            size: 14,
                                          ),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    // this.itemqty,
                                    '${StringConst.currency}' +
                                        ridertip.toStringAsFixed(2),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.secondaryElement,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    width: 0,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      print('here');
                                      print('here');
                                      this.ridertip = (this.ridertip + 1);
                                      print(this.ridertip);
                                      setState(() {});
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        width: 20,
                                        height: 20,
                                        // child: Text(
                                        //   "-",
                                        //   style: TextStyle(
                                        //       color: AppColors.secondaryElement,
                                        //       fontSize: 70),
                                        // )
                                        child: Icon(
                                          Icons.add,
                                          color: AppColors.black,
                                          size: 14,
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total',
                                  style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  '${StringConst.currency}' +
                                      (totalAmount + shipping + charges)
                                          .toStringAsFixed(2),
                                  style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0.0),
                        child: PotbellyButton(
                          'Go to Checkout',
                          onTap: () {
                            if (isGuest) {
                              _askLoginDialog(context);
                            } else {
                              var data = {
                                'cartlist': newcart,
                                'charges': charges,
                                'shipping': shipping,
                                'total': totalAmount,
                                'type': 'cart',
                                'mixmatch': mixmatch,
                              };
                              Navigator.pushNamed(context, AppRouter.CheckOut1,
                                  arguments: data);
                            }
                          },
                          buttonHeight: 45,
                          buttonWidth: MediaQuery.of(context).size.width * 0.85,
                          buttonTextStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppColors.secondaryElement),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
      body: loader
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
              ),
            )
          : newcart.length == 0
              ? Center(
                  child: Container(
                    child: Text('Cart is empty'),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Container(
                      //     width: double.infinity,
                      //     padding: EdgeInsets.all(20.0),
                      //     color: AppColors.secondaryElement,
                      //     child: Column(
                      //       children: [
                      //         Text(
                      //           _freemealModel.message,
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //       ],
                      //     )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: AppColors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/driver.gif",
                                  height: 40,
                                  width: 40,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Delivery in 15 - 30 min',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'roboto',
                                      color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     // showrating = !showrating;
                            //     setState(() {});
                            //   },
                            //   child: Container(
                            //     child: Text(
                            //       'Change',
                            //       style: TextStyle(
                            //           fontSize: 16,
                            //           fontFamily: 'roboto',
                            //           fontWeight: FontWeight.bold,
                            //           color: AppColors.secondaryElement),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: AppColors.white,
                        padding: EdgeInsets.fromLTRB(22, 10, 10, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Cutlery',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          letterSpacing: .3,
                                          color: Colors.grey.shade800)),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                      'Help us reduce plastic waste - only request cutlery when you need it',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.grey,
                                        letterSpacing: .3,
                                      )),
                                ],
                              ),
                            ),
                            Switch.adaptive(
                              value: cutlery,
                              activeColor: AppColors.secondaryElement,
                              activeTrackColor:
                                  AppColors.secondaryElement.withOpacity(0.4),
                              onChanged: (newValue) => setState(() {
                                cutlery = newValue;
                              }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      // Container(
                      //   height: 50,
                      //   color: Colors.white,
                      //   child: Center(
                      //     child: Row(
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.only(left: 20.0),
                      //           child: Text(
                      //             'Your Cart',
                      //             style: TextStyle(fontWeight: FontWeight.bold),
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           width: 10,
                      //         ),
                      //         Container(
                      //           height: 23,
                      //           width: 80,
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(5),
                      //             color: AppColors.secondaryElement,
                      //           ),
                      //           alignment: Alignment.center,
                      //           child: Text(
                      //             totalitems.toString() + ' Items',
                      //             style: TextStyle(color: AppColors.white),
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Column(
                        children: resturantwithcart(),
                      ),
                      Container(
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(horizontal: 20),
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
                            // Row(
                            //   mainAxisAlignment:
                            //       MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text('Order total',
                            //         style: TextStyle(
                            //             fontSize: 20,
                            //             fontWeight: FontWeight.bold)),
                            //     Text(
                            //       '${StringConst.currency}' +
                            //           (totalAmount + shipping + charges)
                            //               .toStringAsFixed(2),
                            //       style: TextStyle(
                            //           fontSize: 20,
                            //           fontWeight: FontWeight.bold),
                            //     )
                            //   ],
                            // ),
                            InkWell(
                              onTap: () {
                                // showrating = !showrating;
                                setState(() {});
                              },
                              child: Container(
                                color: AppColors.white,
                                child: Text(
                                  'How fees works',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'roboto',
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondaryElement),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.zero,
                          // color: Colors.red,
                          child: CheckboxListTile(
                            tileColor: AppColors.white,
                            title: Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text("Enable Mix Match Feature",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w400)),
                            ),
                            value: mixmatch,

                            activeColor: AppColors.secondaryElement,
                            //  selectedTileColor: Colors.red,
                            contentPadding: EdgeInsets.all(0),
                            checkColor: AppColors.white,
                            onChanged: (newValue) {
                              setState(() {
                                mixmatch = newValue;
                              });
                            },
                            controlAffinity: ListTileControlAffinity
                                .leading, //  <-- leading Checkbox
                          )),
                      SizedBox(
                        height: newcart.length > 1 && mixmatch == false ? 0 : 0,
                      ),
                      newcart.length > 1 && mixmatch == false
                          ? Card(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.grey[200],
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_rounded,
                                      color: AppColors.black,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        child: Text(
                                            'You have added items from more than 1 restaurant, Enable mix match feature to procced furter or add single resturant items in your cart'))
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        color: AppColors.white,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'https://media-cdn.tripadvisor.com/media/photo-s/1a/18/3a/cb/restaurant-le-47.jpg',
                                      loadingBuilder: (BuildContext ctx,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Container(
                                            // height: ,
                                            width: 70,
                                            height: 70,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        AppColors
                                                            .secondaryElement),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      fit: BoxFit.cover,
                                      height: 70,
                                      width: 70,
                                    )),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                                'Support your local restaurant',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    letterSpacing: .3,
                                                    color:
                                                        Colors.grey.shade800)),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                          'Round up your bill or add a bit extra',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: AppColors.grey,
                                            letterSpacing: .3,
                                          )),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Divider(
                              height: 5,
                              color: Colors.grey.shade200,
                              thickness: 1.2,
                            ),
                            Container(
                              color: AppColors.white,
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 150,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Restaurant tip',
                                            style: TextStyle(
                                                // fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: .3,
                                                color: Colors.grey.shade800)),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text('${StringConst.currency}0.29',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.grey,
                                            letterSpacing: .3,
                                          )),
                                      Switch.adaptive(
                                          value: addrestip,
                                          activeColor:
                                              AppColors.secondaryElement,
                                          activeTrackColor: AppColors
                                              .secondaryElement
                                              .withOpacity(0.4),
                                          onChanged: (newValue) {
                                            setState(() {
                                              addrestip = newValue;
                                              if (addrestip) {
                                                totalAmount =
                                                    totalAmount + 0.29;
                                              } else {
                                                totalAmount =
                                                    totalAmount - 0.29;
                                              }
                                            });
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 5,
                              color: Colors.grey.shade200,
                              thickness: 1.2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tip More',
                                    style: TextStyle(
                                        // fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        letterSpacing: .3,
                                        color: Colors.grey.shade800)),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Text(
                                      '${StringConst.currency}' +
                                          newrestip.toStringAsFixed(2),
                                      style: TextStyle(
                                        // fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        letterSpacing: .3,
                                        color: AppColors.grey,
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: tiplist(),
                                )),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: AppColors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Text('Add voucher code',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: .3,
                                color: AppColors.secondaryElement)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
    );
  }

  List tiplistname = [
    {'name': '2.50', 'check': false},
    {'name': '5.00', 'check': false},
    {'name':'10.00','check':false},
    {'name':'15.00','check':false}
  ];

  List<Widget> tiplist() {
    return List.generate(
        tiplistname.length,
        (i) => Padding(
              padding: const EdgeInsets.all(5.0),
              child: Material(
                elevation: 2,
                child: Container(
                  height: 70,
                  width: 120,
                  color: AppColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text('${StringConst.currency}' + tiplistname[i]['name'],
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.grey,
                              letterSpacing: .3,
                            )),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: InkWell(
                          onTap: (){
                            if( !tiplistname[i]['check']){

                            tiplistname[i]['check']=true;
                            }
                            else{
                               tiplistname[i]['check']=false;
                            }
                            setState(() {
                              
                            });
                          },
                          child: Row(
                            children: [
                              Icon(tiplistname[i]['check']?FontAwesomeIcons.minus:FontAwesomeIcons.plus,size: 15, color: AppColors.secondaryElement),
                              SizedBox(
                                width: 5,
                              ),
                              Center(
                                
                                child: Text(tiplistname[i]['check']?'Remove':'Add',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.secondaryElement,
                                      letterSpacing: .3,
                                    )),
                              ),
                            ],
                          ),
                        
                        ),
                      ),
                    
                    ],
                  ),
                ),
              ),
            ));
  }

  Future<void> _askLoginDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _buildAlertDialog(context);
      },
    );
  }

  Widget _buildAlertDialog(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(Sizes.RADIUS_32),
        ),
      ),
      child: AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(
          Sizes.PADDING_0,
          Sizes.PADDING_36,
          Sizes.PADDING_0,
          Sizes.PADDING_0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.RADIUS_20),
        ),
        elevation: Sizes.ELEVATION_4,
        content: Container(
          height: Sizes.HEIGHT_150,
          width: Sizes.WIDTH_300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SingleChildScrollView(
                child: Center(
                  child: Text(
                    'You have to login first',
                    style: textTheme.title.copyWith(
                      fontSize: Sizes.TEXT_SIZE_20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.secondaryElement,
                        minimumSize: Size(200.0, 30),
                      ),
                      child: Text(
                        'Go to Login Screen',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      onPressed: () async {
                        await Service().removeGuest();
                        Provider.of<ProviderService>(context, listen: false)
                            .allfalse();
                        Provider.of<ProviderService>(context, listen: false)
                            .reset();
                        Navigator.push(
                            context,
                            // MaterialPageRoute(builder: (_) => BackgroundVideo()), (route) => false);
                            MaterialPageRoute(builder: (_) => GooeyEdgeDemo()));
                      }),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.secondaryElement,
                      minimumSize: Size(200.0, 30),
                    ),
                    child: Text(
                      'Close ',
                      style: TextStyle(fontSize: 15.0),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyTooltip extends StatelessWidget {
  final Widget child;
  final String message;

  MyTooltip({@required this.message, @required this.child});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      // message: message,
      // // textStyle: TextStyle(color: Colors.white),decoration: BoxDecoration(color: Colors.red),preferBelow: false,
      // child: GestureDetector(
      //   behavior: HitTestBehavior.opaque,
      //   onTap: () => _onTap(key),
      //   child: child,
      // ),
      message: message,
      padding: EdgeInsets.all(6),
      margin: EdgeInsets.all(6),
      showDuration: Duration(seconds: 10),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      textStyle: TextStyle(color: Colors.white, fontSize: 15),
      preferBelow: true,
      verticalOffset: 0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
//     Tooltip(
//        key: key,
//   // child: IconButton(icon: Icon(Icons.info, size: 30.0)),
//   message: 'Lorem ipsum dolor sit amet, consectetur '
//            'adipiscing elit, sed do eiusmod tempor incididunt '
//            'ut labore et dolore magna aliqua. '
//            'Ut enim ad minim veniam, quis nostrud exercitation '
//            'ullamco laboris nisi ut aliquip ex ea commodo consequat',
//   padding: EdgeInsets.all(20),
//   margin: EdgeInsets.all(20),
//   showDuration: Duration(seconds: 10),
//   decoration: BoxDecoration(
//     color: Colors.blue.withOpacity(0.9),
//     borderRadius: const BorderRadius.all(Radius.circular(4)),
//   ),
//   textStyle: TextStyle(color: Colors.white),
//   preferBelow: true,
//   verticalOffset: 20,
//   child: child,

// );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
