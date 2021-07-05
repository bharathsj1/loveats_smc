import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/cartservice.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';

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
  double totalAmount = 0.0;
  int charges = 0;
  int shipping = 3;
  int totalitems = 0;

  getcartlist() async {
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

  if(newcart.length > 1){
    mixmatch=true;
  }

    loader = false;
    if (cartlist.length != 0) {
      calculate();
    }
    print(cartlist);
    setState(() {});
  }

  calculate() {
    double total = 0;
    cartlist.forEach((f) {
      total += f['price'] * double.parse(f['qty']);
    });
    totalAmount = total;
    print('total');
    print(totalAmount);
  }

  @override
  void initState() {
    getcartlist();
    super.initState();
  }

  calculateprice(i1, i2, type) {
    newcart[i1][i2]['qty'] = type == 'add'
        ? (int.parse(newcart[i1][i2]['qty']) + 1).toString()
        : (int.parse(newcart[i1][i2]['qty']) - 1).toString();
    newcart[i1][i2]['payableAmount'] = (newcart[i1][i2]['price'] *
            double.parse(newcart[i1][i2]['qty']))
        .toString();
  }

  List<Widget> renderAddList(i) {
    return List.generate(
        newcart[i].length,
        (index) => Container(
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
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              newcart[i][index]['image'],
                              loadingBuilder: (BuildContext ctx, Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Container(
                                    // height: ,
                                    width: 90,
                                    height: 90,
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
                              height: 90,
                              width: 90,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.64,
                                child: Text(newcart[i][index]['name'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                // color: Colors.red,
                                width: MediaQuery.of(context).size.width * 0.64,
                                child: Text(newcart[i][index]['details'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    // color: Colors.red,
                                    // margin: EdgeInsets.only(left: 0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Text(
                                        '\$' +
                                            newcart[i][index]['payableAmount'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: AppColors.secondaryElement,
                                            fontWeight: FontWeight.w900)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.64,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                         print('here');
                                                await CartProvider()
                                                    .removeToCart(
                                                        cartlist[index]);
                                                getcartlist();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete_outline,
                                              color: Colors.black54, size: 20),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, left: 0),
                                            child: Text('Remove',
                                                style: TextStyle(
                                                    // fontSize: 18,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w600)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () async {
                                            if (int.parse(
                                                    newcart[i][index]['qty']) >
                                                1) {
                                              // newcart[i][index]['qty'] =
                                              //     (int.parse(newcart[i][index]
                                              //                 ['qty']) -
                                              //             1)
                                              //         .toString();
                                              await calculateprice(
                                                  i, index, 'minus');
                                              calculate();
                                              setState(() {});
                                              if (int.parse(newcart[i][index]
                                                      ['qty']) ==
                                                  1) {
                                                setState(() {});
                                              }
                                              setState(() {});
                                            }
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.zero,
                                              width: 40,
                                              child: Text(
                                                "-",
                                                style: TextStyle(
                                                    color: AppColors
                                                        .secondaryElement,
                                                    fontSize: 50),
                                              )),
                                        ),
                                        Text(
                                          newcart[i][index]['qty'],
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            print('here');
                                            // newcart[i][index]['qty'] =
                                            //     (int.parse(newcart[i][index]
                                            //                 ['qty']) +
                                            //             1)
                                            //         .toString();
                                            print(newcart[i][index]['qty']);
                                            await calculateprice(
                                                i, index, 'add');
                                            calculate();
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
                                                    color: AppColors
                                                        .secondaryElement,
                                                    fontSize: 32),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
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
                    color: Colors.grey[100],
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
                              fontSize: 20, fontWeight: FontWeight.bold),
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

  pricerow(String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: TextStyle(fontWeight: FontWeight.w400)),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w400),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 1,
        leading: InkWell(
          onTap: () => AppRouter.navigator.pop(),
          child: Image.asset(
            ImagePath.arrowBackIcon,
            color: AppColors.headingText,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Shopping Cart',
          style: Styles.customTitleTextStyle(
            color: AppColors.headingText,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.TEXT_SIZE_20,
          ),
        ),
      ),
      bottomNavigationBar: (loader ==false && newcart.length==0) ||(loader ==false  && newcart.length>1 && mixmatch == false)? null: Material(
        // elevation: 5,
        child: Container(
          color: AppColors.white,
          margin: EdgeInsets.only(top: 5),
          height: 65,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(totalitems.toString() + ' Items in cart',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                        '\$' +
                            (totalAmount + shipping + charges)
                                .toStringAsFixed(2),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: PotbellyButton(
                  'Secure Checkout',
                  onTap: () {
                     var data={
                                  'cartlist': newcart,
                                  'charges':charges,
                                  'shipping':shipping,
                                  'total': totalAmount,
                                  'type': 'cart',
                                  'mixmatch': mixmatch,
                                };
                    AppRouter.navigator.pushNamed(AppRouter.CheckOut1,arguments: data);
                  },
                  buttonHeight: 45,
                  buttonWidth: 170,
                  buttonTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.secondaryElement),
                ),
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
        :newcart.length == 0
            ? Center(
                child: Container(
                  child: Text('Cart is empty'),
                ),
              )
            :  SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              color: Colors.white,
              child: Center(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Your Cart',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 23,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.secondaryElement,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        totalitems.toString() + ' Items',
                        style: TextStyle(color: AppColors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: resturantwithcart(),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.zero,
                // color: Colors.red,
                child: CheckboxListTile(
                  tileColor: AppColors.white,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text("Enable Mix Match Feature",
                        style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold)),
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
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                )),
            SizedBox(
              height: newcart.length > 1  && mixmatch == false? 10 : 40,
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
                            width: MediaQuery.of(context).size.width*0.75,
                              child: Text(
                                  'You have added items from more than 1 restaurant, Enable mix match feature to procced furter or add single resturant items in your cart'))
                        ],
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        pricerow(
                            'Subtotal', '\$' + totalAmount.toStringAsFixed(2)),
                        SizedBox(
                          height: 10,
                        ),
                        pricerow('Value Added Tax',
                            '\$' + charges.toStringAsFixed(2)),
                        SizedBox(
                          height: 10,
                        ),
                        pricerow('Delivery Charges',
                            '\$' + shipping.toStringAsFixed(2)),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order total',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(
                              '\$' +
                                  (totalAmount + shipping + charges)
                                      .toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
