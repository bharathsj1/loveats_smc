import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/subscription_webview.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';

import 'cart_screen.dart';

class BuyNewPlan extends StatefulWidget {
  const BuyNewPlan({Key key}) : super(key: key);

  @override
  _BuyNewPlanState createState() => _BuyNewPlanState();
}

class _BuyNewPlanState extends State<BuyNewPlan> {
  List plans = [];

  int personselect = 0;
  int catselect = 0;
  int weekselect = 0;
  int totalrecipe = 0;
  double totalprice = 53.5;
  bool loader=true;

  List persons = [
    {'name': '2', 'select': true},
    {'name': '4', 'select': false},
    {'name': '6', 'select': false},
  ];
  List perweek = [
    {'name': '1', 'select': true},
    {'name': '2', 'select': false},
    {'name': '3', 'select': false},
    {'name': '4', 'select': false},
    {'name': '5', 'select': false},
  ];
  List category = [
    {'name': 'Everything', 'select': true},
    {'name': 'Veggie', 'select': false},
    {'name': 'Family', 'select': false},
    {'name': 'Quick Cook', 'select': false},
  ];

  @override
  void initState() {
    getrecipeplans();
    super.initState();
  }

  getrecipeplans() async {
    var response = await AppService().getrecipeplans();
    plans = response['data'];
    print(response);
    loader = false;
    setState(() {});
  }

  

  personlist() {
    return List.generate(
        persons.length,
        (i) => InkWell(
            onTap: () {
              for (var item in persons) {
                item['select'] = false;
              }
              persons[i]['select'] = true;
              personselect = i;

              setState(() {});
            },
            child: Material(
              elevation: persons[i]['select'] ? 5 : 1,
              child: Container(
                decoration: BoxDecoration(
                    color: persons[i]['select']
                        ? AppColors.secondaryElement
                        : null,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(width: 0.2, color: Colors.black54)),
                padding: EdgeInsets.symmetric(
                    horizontal: persons[i]['select'] ? 16.0 : 12,
                    vertical: persons[i]['select'] ? 8.0 : 6),
                margin: EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  children: [
                    Text(persons[i]['name'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: Styles.customNormalTextStyle(
                            color: persons[i]['select']
                                ? AppColors.white
                                : Colors.black54,
                            fontSize: Sizes.TEXT_SIZE_16,
                          ),
                        )),
                  ],
                ),
              ),
            )));
  }

  perweeklist() {
    return List.generate(
        perweek.length,
        (i) => InkWell(
              onTap: () {
                for (var item in perweek) {
                  item['select'] = false;
                }
                perweek[i]['select'] = true;
                weekselect = i;

                setState(() {});
              },
              child: Material(
                elevation: perweek[i]['select'] ? 5 : 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: perweek[i]['select']
                          ? AppColors.secondaryElement
                          : null,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(width: 0.2, color: Colors.black54)),
                  padding: EdgeInsets.symmetric(
                      horizontal: perweek[i]['select'] ? 16.0 : 12,
                      vertical: perweek[i]['select'] ? 8.0 : 6),
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: [
                      Text(perweek[i]['name'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            textStyle: Styles.customNormalTextStyle(
                              color: perweek[i]['select']
                                  ? AppColors.white
                                  : Colors.black54,
                              fontSize: Sizes.TEXT_SIZE_16,
                            ),
                          )),
                      // persons[i]['select']
                      //     ? Text(' Person',
                      //         textAlign: TextAlign.center,
                      //         style: GoogleFonts.openSans(
                      //           textStyle: Styles.customNormalTextStyle(
                      //             color: persons[i]['select']
                      //                 ? AppColors.white
                      //                 : Colors.black54,
                      //             fontSize: Sizes.TEXT_SIZE_16,
                      //           ),
                      //         ))
                      //     : Container(),
                    ],
                  ),
                ),
              ),
            ));
  }

  pricerow(String name, String value, info, infovalue, fontweight, color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name,
            style:
                TextStyle(fontSize: 14, color: color, fontWeight: fontweight)),
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
              style:
                  TextStyle(fontSize: 14, color: color, fontWeight: fontweight),
            ),
          ],
        )
      ],
    );
  }

  catlist() {
    return List.generate(
        category.length,
        (i) => Container(
              child: Center(
                child: PotbellyButton(
                  category[i]['name'],
                  onTap: () {
                    print('here');
                    for (var item in category) {
                      item['select'] = false;
                    }
                    category[i]['select'] = true;
                    catselect = i;

                    setState(() {});
                  },
                  buttonHeight: 42,
                  buttonWidth: MediaQuery.of(context).size.width / 2,
                  buttonTextStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: category[i]['select']
                          ? AppColors.white
                          : Colors.black87),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(width: 0.5, color: Colors.grey),
                      color: category[i]['select']
                          ? AppColors.secondaryElement
                          : Colors.transparent),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        centerTitle: false,
        backgroundColor: AppColors.secondaryElement,
        iconTheme: IconThemeData(color: AppColors.white),
        title: Text(
          'Plans',
          style: Styles.customTitleTextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.TEXT_SIZE_18,
          ),
        ),
      ),
      bottomNavigationBar: loader? Container(height: 0,width: 0,): Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Container(
          height: 60,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: PotbellyButton(
                  'Buy this Plan',
                  buttonHeight: 45,
                  buttonWidth: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                      color: AppColors.secondaryElement,
                      borderRadius: BorderRadius.circular(10)),
                  buttonTextStyle:
                      TextStyle(color: AppColors.white, fontSize: 15),
                  onTap: () async {
                    String userId = await Service().getUserId();
                    // Navigator.pushNamed(context, AppRouter.Buy_New_Plan);
                     Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubscriptionWebview(
                      planId: plans[personselect]['product']['id'],
                      userId: userId,
                      personquantity: persons[personselect]['name'],
                      perweek: (int.parse(perweek[weekselect]['name'])+1).toString(),
                      isrecipe: true,
                      
                    ),
                  ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  'Choose your plan size',
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'roboto',
                        fontWeight: FontWeight.w400,
                        color: AppColors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Center(
                child: Text(
                  "We'll use this as your default plan size, but you can customize it from month to month",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Number of persons",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: personlist()),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recipes per week",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: perweeklist()),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.grey.shade100),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Price Summary",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${perweek[weekselect]['name']} Meals for ${persons[personselect]['name']} persons per week",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    // Text(
                    //   "${(
                    //     int.parse(perweek[weekselect]['name'])* int.parse(persons[personselect]['name'])
                    //   ).toString()} Servings at ${StringConst.currency}${totalprice.toStringAsFixed(2)} per Serving",
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //       fontSize: 14.0,
                    //       fontWeight: FontWeight.w400,
                    //       color: Colors.black87),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                        height: 10,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: pricerow(
                            'Box Price',
                            '${StringConst.currency}' + '25',
                            false,
                            '',
                            FontWeight.w400,
                            Colors.grey)),
                    SizedBox(
                      height: 10,
                    ),

                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: pricerow(
                            'Shipping',
                            '${StringConst.currency}' + '3.00',
                            false,
                            '',
                            FontWeight.w400,
                            Colors.grey)),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.shade300,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: pricerow(
                          'First Box Total',
                          '${StringConst.currency}' + '28.00',
                          false,
                          '',
                          FontWeight.bold,
                          Colors.black),
                    ),
                    //  SizedBox(height: 20,),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.grey.shade100),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        'What kind of Recipes do you like?',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'roboto',
                              fontWeight: FontWeight.w400,
                              color: AppColors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Text(
                        "We'll show you recipes you like first, but you'll always have access to the full menu every month",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      children: catlist(),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        "get Cooking with our widest variety of meet, fish, and seasonal produce",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ])),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
