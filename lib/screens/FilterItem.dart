import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potbelly/models/restaurent_model.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/cartservice.dart';
import 'package:potbelly/values/values.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:provider/provider.dart';

class FilterItems extends StatefulWidget {
  var data;
  FilterItems({@required this.data});

  @override
  _FilterItemsState createState() => _FilterItemsState();
}

class _FilterItemsState extends State<FilterItems> {
  List items = [];
  bool loader = true;
  bool itemended = false;
  bool cartbtn = false;

  int currentindex = 0;
  ScrollController _sc = new ScrollController();

  @override
  void initState() {
    if (widget.data['cat']) {
      getcatitem();
    } else {
      getitems();
    }
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData();
        // print('here');
      }
    });
    super.initState();
  }

  _getMoreData() {
    if (!itemended) {
      if (items.length > currentindex) {
        if (items.length >= currentindex + 10) {
          currentindex = currentindex + 10;
        } else {
          currentindex = items.length;
          itemended = true;
        }
      } else {
        currentindex = items.length;
        itemended = true;
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  getitems() async {
    var response = await AppService().getitems({'item_type': 'delivery'});
    items = response['data'];
    if (items.length >= 10) {
      currentindex = 10;
    } else {
      currentindex = items.length;
      itemended = true;
    }
    print(items);
    loader = false;
    setState(() {});
  }

  bottomSheetforaddcart(BuildContext context, i) {
    var itemqty = '1';
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        // backgroundColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              // height: MediaQuery.of(context).size.height * 0.4,
              // height: dou,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: CachedNetworkImage(
                      imageUrl: items[i]['menu_image'],
                      width: MediaQuery.of(context).size.width,
                      height: 190,
                      fit: BoxFit.cover,
                      // imageBuilder: (context, imageProvider) =>
                      //     Container(
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //         image: imageProvider,
                      //         fit: BoxFit.cover,
                      //         colorFilter: ColorFilter.mode(
                      //             Colors.red, BlendMode.colorBurn)),
                      //   ),
                      // ),
                      placeholder: (context, url) => Container(
                        height: 190,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.secondaryElement),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                items[i]['cart'] !=null && items[i]['cart']?    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                         Text('Already in your cart',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .3,
                              )),
                          SizedBox(
                            height: 0,
                          ),
                       InkWell(
                              onTap: () {
                          Navigator.pushNamed(context, AppRouter.cart_Screen)
                              .then((value) {
                                Navigator.pop(context);
                            checkchanges();
                          });
                        },
                         child: Material(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 14),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text('1x',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: AppColors.secondaryElement,
                                                fontWeight: FontWeight.bold
                                                // letterSpacing: .3,
                                                )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(items[i]['menu_name'],
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87,
                                              letterSpacing: .3,
                                            )),
                                      ],
                                    ),
                                    Text('Edit in cart',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.secondaryElement,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: .3,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                       ),
                           SizedBox(
                            height: 10,
                          ),
                      ],
                    ),
                  ):Container(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                       
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(items[i]['menu_name'],
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSerifDisplay(
                                  textStyle: Styles.customTitleTextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Sizes.TEXT_SIZE_22,
                                  ),
                                )),
                            Text(
                                // hotlist[i]['distance'] +
                                '${StringConst.currency}' +
                                    items[i]['menu_price'],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.openSans(
                                  textStyle: Styles.customNormalTextStyle(
                                      color: Colors.black54,
                                      fontSize: Sizes.TEXT_SIZE_16,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(items[i]['menu_details'],
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.grey,
                              letterSpacing: .3,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            var data = RestaurentsModel.fromJson({
                              'data': [items[i]['restaurant']],
                              'success': true,
                              'message': 'ok'
                            });
                            print(items[i]['restaurant']);
                            Navigator.pushNamed(context, AppRouter.Add_Extra,
                                arguments: {
                                  'update': false,
                                  'item': items[i],
                                  // 'restaurant': widget.restaurantDetails.data
                                  'restaurant': data.data[0]
                                }).then((value) {
                              Navigator.pop(context);
                              checkchanges();
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: AppColors.secondaryElement,
                                size: 16,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Customize Food',
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: Styles.customTitleTextStyle(
                                    color: AppColors.secondaryElement,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (int.parse(itemqty) > 1) {
                                      itemqty =
                                          (int.parse(itemqty) - 1).toString();
                                      setState(() {});
                                      // totalprice();
                                      if (int.parse(itemqty) == 1) {
                                        // disabled = false;
                                        setState(() {});
                                      }
                                      setState(() {});
                                    }
                                    // Provider.of<CartProvider>(context, listen: false)
                                    //     .removeToCart(cartlist[i]);
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                          color: AppColors.black,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      width: 25,
                                      height: 25,
                                      // child: Text(
                                      //   "-",
                                      //   style: TextStyle(
                                      //       color: AppColors.secondaryElement,
                                      //       fontSize: 70),
                                      // )
                                      child: Icon(
                                        FontAwesomeIcons.minus,
                                        color: AppColors.white,
                                        size: 10,
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  itemqty,
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: AppColors.secondaryElement,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    print('here');
                                    itemqty =
                                        (int.parse(itemqty) + 1).toString();
                                    print(itemqty);
                                    setState(() {});

                                    // Provider.of<CartProvider>(context, listen: false)
                                    //     .addToCart(context, data);
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                          color: AppColors.black,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      width: 25,
                                      height: 25,
                                      // child: Text(
                                      //   "-",
                                      //   style: TextStyle(
                                      //       color: AppColors.secondaryElement,
                                      //       fontSize: 70),
                                      // )
                                      child: Icon(
                                        FontAwesomeIcons.plus,
                                        color: AppColors.white,
                                        size: 10,
                                      )),
                                ),
                              ],
                            ),
                            PotbellyButton(
                              'Add to Cart',
                              onTap: () async {
                                var data = RestaurentsModel.fromJson({
                                  'data': [items[i]['restaurant']],
                                  'success': true,
                                  'message': 'ok'
                                });
                                print(items[i]);
                                Map<String, dynamic> cartdata = {
                                  'id': items[i]['id'],
                                  'restaurantId': items[i]['rest_id'],
                                  'image': items[i]['menu_image'],
                                  'details': items[i]['menu_details'],
                                  'name': items[i]['menu_name'],
                                  'price': double.parse(items[i]['menu_price']),
                                  'payableAmount':
                                      items[i]['menu_price'].toString(),
                                  'qty': itemqty,
                                  'data': items[i],
                                  'is_free': items[i]['is_free'],
                                  'restaurantdata': data.data[0],
                                  // 'topping': toppings
                                  //     .where((product) => product['check'] == true)
                                  //     .toList(),
                                  // 'drink': drinks
                                  //     .where((product) => product['check'] == true)
                                  //     .toList()
                                  'addon': []
                                };
                                print(cartdata);
                                print(itemqty);
                                CartProvider().addToCart(context, cartdata);
                                await Provider.of<CartProvider>(context,
                                        listen: false)
                                    .getcartslist();
                                checkchanges();
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
                              },
                              buttonHeight: 40,
                              buttonWidth:
                                  MediaQuery.of(context).size.width * 0.5,
                              buttonTextStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.secondaryElement),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  getcatitem() async {
    var response =
        await AppService().getcatitems(widget.data['catid'].toString());
    items = response['data'];
    if (items.length >= 10) {
      currentindex = 10;
    } else {
      currentindex = items.length;
      itemended = true;
    }
    print(items);
    loader = false;
    setState(() {});

    var cart = [];
    cart =
        await Provider.of<CartProvider>(context, listen: false).getcartslist();
    for (var j = 0; j < items.length; j++) {
      int index = cart.indexWhere((x) => x['id'] == items[j]['id']);
      if (index == -1) {
      } else {
        items[j]['cart'] = true;
        cartbtn = true;
        items[j]['qty2'] = cart[index]['qty'];
      }
    }

    setState(() {});
  }

  checkchanges() async {
    var cart = [];
    cart =
        await Provider.of<CartProvider>(context, listen: false).getcartslist();
    if (cart.length == 0) {
      cartbtn = false;
      for (var j = 0; j < items.length; j++) {
        items[j]['cart'] = false;
        items[j]['qty2'] = '1';
      }
    }
    for (var j = 0; j < items.length; j++) {
      int index = cart.indexWhere((x) => x['id'] == items[j]['id']);
      if (index == -1) {
      } else {
        items[j]['cart'] = true;
        cartbtn = true;
        print('here');
        print(cart[index]['qty']);
        items[j]['qty2'] = cart[index]['qty'];
      }
    }

    setState(() {});
  }

  popular() {
    return List.generate(
        currentindex,
        (i) => InkWell(
              onTap: () {
                // var data = RestaurentsModel.fromJson({
                //   'data': [items[i]['restaurant']],
                //   'success': true,
                //   'message': 'ok'
                // });
                // print(items[i]['restaurant']);
                // Navigator.pushNamed(context, AppRouter.Add_Extra, arguments: {
                //   'update': false,
                //   'item': items[i],
                //   // 'restaurant': widget.restaurantDetails.data
                //   'restaurant': data.data[0]
                // });

                bottomSheetforaddcart(context, i);
              },
              child: Container(
                height: 270,
                width: MediaQuery.of(context).size.width / 1,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6)),
                            child:
                                //  items[i]['menu_image']
                                //             .substring(0, 4) ==
                                //         'http'
                                //     ?
                                // Image.network(
                                //     items[i]['menu_image'],
                                //     loadingBuilder: (BuildContext ctx,
                                //         Widget child,
                                //         ImageChunkEvent loadingProgress) {
                                //       if (loadingProgress == null) {
                                //         return child;
                                //       } else {
                                //         return Container(
                                //           height: 150,
                                //           child: Center(
                                //             child: CircularProgressIndicator(
                                //               valueColor:
                                //                   AlwaysStoppedAnimation<Color>(
                                //                       AppColors
                                //                           .secondaryElement),
                                //             ),
                                //           ),
                                //         );
                                //       }
                                //     },
                                //     width: MediaQuery.of(context).size.width,
                                //     height: 150,
                                //     fit: BoxFit.cover,
                                //   )
                                CachedNetworkImage(
                              imageUrl: items[i]['menu_image'],
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                              fit: BoxFit.cover,
                              // imageBuilder: (context, imageProvider) =>
                              //     Container(
                              //   decoration: BoxDecoration(
                              //     image: DecorationImage(
                              //         image: imageProvider,
                              //         fit: BoxFit.cover,
                              //         colorFilter: ColorFilter.mode(
                              //             Colors.red, BlendMode.colorBurn)),
                              //   ),
                              // ),
                              placeholder: (context, url) => Container(
                                height: 150,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.secondaryElement),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            // : Image.asset(
                            //     items[i]['menu_image'],
                            //     width: MediaQuery.of(context).size.width,
                            //     height: 150,
                            //     fit: BoxFit.cover,
                            //   ),
                          ),
                          Positioned(
                              right: 5,
                              bottom: 5,
                              child: Container(
                                width: 90,
                                padding: EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text('15 - 20\nMins',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                      textStyle: Styles.customNormalTextStyle(
                                        color: AppColors.white,
                                        fontSize: Sizes.TEXT_SIZE_12,
                                      ),
                                    )),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(items[i]['menu_name'],
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSerifDisplay(
                                  textStyle: Styles.customTitleTextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Sizes.TEXT_SIZE_22,
                                  ),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  color: AppColors.secondaryElement,
                                  size: 16,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    // width: MediaQuery.of(context).size.width*0.5,
                                    // color: Colors.red,
                                    child: Text('4.4' + ' Very good',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle:
                                              Styles.customNormalTextStyle(
                                            color: AppColors.secondaryElement,
                                            fontSize: Sizes.TEXT_SIZE_14,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    // width: MediaQuery.of(context).size.width*0.5,
                                    // color: Colors.red,
                                    child: Text(
                                        items[i]['restaurant']['rest_address'] +
                                            ' (500+)',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle:
                                              Styles.customNormalTextStyle(
                                            color: Colors.black54,
                                            fontSize: Sizes.TEXT_SIZE_14,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    // width: MediaQuery.of(context).size.width*0.5,
                                    // color: Colors.red,
                                    child: Text(
                                        // hotlist[i]['distance'] +
                                        '${StringConst.currency}' +
                                            items[i]['menu_price'],
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle:
                                              Styles.customNormalTextStyle(
                                            color: Colors.black54,
                                            fontSize: Sizes.TEXT_SIZE_14,
                                          ),
                                        )),
                                  ),
                                ),
                                if (items[i]['cart'] != null &&
                                    items[i]['cart'] == true)
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2.0),
                                        child: Text('x' + items[i]['qty2'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                letterSpacing: .3,
                                                color: Color(0xff55c8d4)
                                                // color: AppColors.secondaryElement
                                                )),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Icon(Icons.add_shopping_cart_sharp,
                                          size: 16.0, color: Color(0xff55c8d4)),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.secondaryElement),
        title: Text(
          widget.data['name'] + ' Food',
          style: Styles.customTitleTextStyle(
            color: AppColors.secondaryElement,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.TEXT_SIZE_22,
          ),
        ),
      ),
      bottomNavigationBar: cartbtn
          ? Material(
              // elevation: 5,
              color: Colors.transparent,
              child: Container(
                color: Colors.transparent,
                margin: EdgeInsets.only(top: 0),
                height: 65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: PotbellyButton(
                        'View Cart',
                        onTap: () {
                          Navigator.pushNamed(context, AppRouter.cart_Screen)
                              .then((value) {
                            checkchanges();
                          });
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
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: loader
          ? Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/loader.gif',
                    height: 80,
                    width: 80,
                  )),
            )
          : SingleChildScrollView(
              controller: _sc,
              // physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: Column(
                  children: popular(),
                ),
              ),
            ),
    );
  }
}
