import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/screens/custom_header.dart';
import 'package:potbelly/services/cartservice.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';

class Cart extends StatefulWidget {
  static const int TAB_NO = 1;
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> with TickerProviderStateMixin {
  TabController _tabController;
  List cartlist = [];
  bool loader = true;
  double totalAmount = 0.0;
  int charges = 0;
  int shipping = 3;

  getcartlist() async {
    var cart = await CartProvider().getcartslist();
    cartlist.clear();
    for (var item in cart) {
      cartlist.add(item);
    }
    loader = false;
    calculate();
    print(cartlist);
    setState(() {});
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

  final List<Map<String, String>> foods = [
    {
      'name': 'Rice and meat',
      'price': '130.00',
      'rate': '4.8',
      'clients': '150',
      'image': 'assets/images/plate-003.png'
    },
    {
      'name': 'Vegan food',
      'price': '400.00',
      'rate': '4.2',
      'clients': '150',
      'image': 'assets/images/plate-007.png'
    },
  ];

  @override
  void initState() {
    this._tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    getcartlist();
    super.initState();
  }

  calculateprice(index, type) {
    cartlist[index]['qty'] = type == 'add'
        ? (int.parse(cartlist[index]['qty']) + 1).toString()
        : (int.parse(cartlist[index]['qty']) - 1).toString();
    cartlist[index]['payableAmount'] =
        ((cartlist[index]['price']) * double.parse(cartlist[index]['qty']))
            .toString();
  }

  Widget renderAddList() {
    return loader
        ? Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
            ),
          )
        : cartlist.length == 0
            ? Center(
                child: Container(
                  child: Text('Cart is empty'),
                ),
              )
            : ListView.builder(
                itemCount: cartlist.length,
                itemBuilder: (BuildContext context, int index) {
                  Color primaryColor = Theme.of(context).primaryColor;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.pushNamed(
                        //   context,
                        //   'details',
                        //   arguments: {
                        //     'product': food,
                        //     'index': index,
                        //   },
                        // );
                      },
                      child: Hero(
                        tag: 'cartlist$index',
                        child: Card(
                          // color: Colors.red,

                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 100,
                                width: 100,
                                // decoration: BoxDecoration(
                                child: Image.network(
                                  cartlist[index]['image'],
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext ctx,
                                      Widget child,
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
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    AppColors.secondaryElement),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(left: 5),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.53,
                                            child: Text(
                                              cartlist[index]['name'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                        InkWell(
                                            onTap: () async {
                                              print('here');
                                              await CartProvider().removeToCart(
                                                  cartlist[index]);
                                              getcartlist();
                                            },
                                            child: Icon(
                                              Icons.delete_outline,
                                              color: AppColors.secondaryElement,
                                            ))
                                      ],
                                    ),
                                    // SizedBox(
                                    //   height: 4,
                                    // ),
                                    // Text('x' + cartlist[index]['qty']),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text('\$' +
                                          cartlist[index]['payableAmount']
                                              .toString()),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () async {
                                            if (int.parse(
                                                    cartlist[index]['qty']) >
                                                1) {
                                              // cartlist[index]['qty'] =
                                              //     (int.parse(cartlist[index]
                                              //                 ['qty']) -
                                              //             1)
                                              //         .toString();
                                              await calculateprice(0, 'minus');
                                              calculate();
                                              setState(() {});
                                              if (int.parse(
                                                      cartlist[index]['qty']) ==
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
                                          cartlist[index]['qty'],
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            print('here');
                                            // cartlist[index]['qty'] =
                                            //     (int.parse(cartlist[index]
                                            //                 ['qty']) +
                                            //             1)
                                            //         .toString();
                                            print(cartlist[index]['qty']);
                                            await calculateprice(0, 'add');
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
  }

  Widget renderTracking() {
    return ListView.builder(
      itemCount: this.foods.length,
      itemBuilder: (BuildContext context, int index) {
        Map<String, String> food = foods[index];
        Color primaryColor = Theme.of(context).primaryColor;
        return Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                'details',
                arguments: {
                  'product': food,
                  'index': index,
                },
              );
            },
            child: Hero(
              tag: 'detail_food$index',
              child: Card(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(food['image']),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(food['name']),
                                  Text(
                                    'Item-2',
                                    style: TextStyle(color: primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            Text('\$${food['price']}'),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'View Detail',
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget renderDoneOrder() {
    return ListView.builder(
      itemCount: this.foods.length,
      itemBuilder: (BuildContext context, int index) {
        Map<String, String> food = foods[index];
        Color primaryColor = Theme.of(context).primaryColor;
        return Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                'details',
                arguments: {
                  'product': food,
                  'index': index,
                },
              );
            },
            child: Hero(
              tag: 'detail_food$index',
              child: Card(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(food['image']),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(food['name']),
                            ),
                            Text('\$${food['price']}'),
                            Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(food['rate']),
                                    Text(
                                      'Give your review',
                                      style: TextStyle(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Column(
        children: <Widget>[
          CustomHeader(
            title: 'Cart Food',
            quantity: this.foods.length,
            internalScreen: false,
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 10.0,
            ),
            child: TabBar(
              controller: this._tabController,
              indicatorColor: theme.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black87,
              tabs: <Widget>[
                Tab(text: 'Add Food'),
                Tab(text: 'Tracking Order'),
                Tab(text: 'Done Order'),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: TabBarView(
                controller: this._tabController,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: this.renderAddList(),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Subtotal'),
                              Text('\$' + totalAmount.toStringAsFixed(2))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Shipping'),
                              Text('\$' + shipping.toStringAsFixed(2))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Service Charges'),
                              Text('\$' + charges.toStringAsFixed(2))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(height: 3, color: AppColors.headingText),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '\$' +
                                    (totalAmount + shipping + charges)
                                        .toStringAsFixed(2),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          PotbellyButton(StringConst.CHECKOUT, buttonHeight: 50,
                              onTap: () {
                            var data = {
                              'cartlist': cartlist,
                              'charges': charges,
                              'shipping': shipping,
                              'total': totalAmount,
                              'type': 'cart'
                              // 'rest_id':widget.
                            };
                            AppRouter.navigator.pushNamed(
                                AppRouter.checkoutScreen,
                                arguments: data);
                          }),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        height: size.height * 0.20 * this.foods.length,
                        width: size.width,
                        child: this.renderTracking(),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 65.0),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 35.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: theme.primaryColor,
                        ),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.location_searching,
                                size: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'View Tracking Order',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  this.renderDoneOrder(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
