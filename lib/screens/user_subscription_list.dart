import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:intl/intl.dart';
import 'package:potbelly/models/specific_user_subscription_model.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:toast/toast.dart';

class UserSubscriptionList extends StatefulWidget {
  const UserSubscriptionList({Key key}) : super(key: key);

  @override
  _UserSubscriptionListState createState() => _UserSubscriptionListState();
}

class _UserSubscriptionListState extends State<UserSubscriptionList> {
  SpecificUserSubscriptionModel _specificUserSubscriptionModel;
  SpecificUserSubscriptionModel _specificUserrecipeSubscriptionModel;
  bool _isLoading = true;
  bool _isLoading2 = true;
  @override
  void initState() {
    getCurrentUserSubscription();
    getrescipeSubscription();
    super.initState();
  }

   mealsubscription() {
   
    return List.generate(
        _specificUserSubscriptionModel.data.length,
        (index) {
        var data = _specificUserSubscriptionModel.data[index];
        return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2.0),
                                  color: AppColors.secondaryColor,
                                ),
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    data.status == 'active'
                                        ? Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.delete_outlined,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                cancelSubsc(data.id);
                                              },
                                            ),
                                          )
                                        : const SizedBox(),
                                    Row(
                                      children: [
                                        Text('Interval'),
                                        Spacer(),
                                        Text(data.plan.interval.toUpperCase()),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Text('Subcription Id'),
                                        Spacer(),
                                        Text(data.id),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Text('Start Date'),
                                        Spacer(),
                                        Text(
                                          DateFormat('dd-MMM-yyy').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                data.currentPeriodStart * 1000),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Text('End Date'),
                                        Spacer(),
                                        Text(
                                          DateFormat('dd-MMM-yyy').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                data.currentPeriodEnd * 1000),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Text('Amount '),
                                        Spacer(),
                                        Text((double.tryParse(data
                                                        .items
                                                        .data[0]
                                                        .price
                                                        .unitAmountDecimal) /
                                                    100)
                                                .toString() +
                                            ' ' +
                                            data.items.data[0].price.currency
                                                .toUpperCase()),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Text('Type'),
                                        Spacer(),
                                        Text(data.items.data[0].price.type
                                            .toUpperCase()),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Text('Status'),
                                        Spacer(),
                                        Text(toBeginningOfSentenceCase(data.status))
                                      ],
                                    ),
                                      const Divider(),
                                _specificUserSubscriptionModel.allowedPerweek==null?Container():    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text('Meal Per Week',style: TextStyle(fontWeight: FontWeight.bold)),
                                            Spacer(),
                                            Text(_specificUserSubscriptionModel.allowedPerweek.toString(),style: TextStyle(fontWeight: FontWeight.bold),)
                                          ],
                                        ),
                                    const Divider(),
                                      ],
                                    ),
                               _specificUserSubscriptionModel.leftThisweek==null?Container():     Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text('Meal Left (Weekly)',style: TextStyle(fontWeight: FontWeight.bold)),
                                            Spacer(),
                                            Text(_specificUserSubscriptionModel.leftThisweek.toString(),style: TextStyle(fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                    const Divider(),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Next Free Meal',style: TextStyle(fontWeight: FontWeight.bold)),
                                        Spacer(),
                                        Text(_specificUserSubscriptionModel.nextfreeMeal ==null? 'Available': _specificUserSubscriptionModel.nextfreeMeal,style: TextStyle(fontSize: 15,color: AppColors.secondaryElement,fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              )
                            ],
                          );
        });}

   recipesubscription() {
   
    return List.generate(
        _specificUserrecipeSubscriptionModel.data.length,
        (index) {
        var data = _specificUserrecipeSubscriptionModel.data[index];
        return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2.0),
                                  color: AppColors.secondaryColor,
                                ),
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    data.status == 'active'
                                        ? Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.delete_outlined,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                cancelSubsc(data.id);
                                              },
                                            ),
                                          )
                                        : const SizedBox(),
                                    Row(
                                      children: [
                                        Text('Interval'),
                                        Spacer(),
                                        Text(data.plan.interval.toUpperCase()),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Text('Subcription Id'),
                                        Spacer(),
                                        Text(data.id),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Text('Start Date'),
                                        Spacer(),
                                        Text(
                                          DateFormat('dd-MMM-yyy').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                data.currentPeriodStart * 1000),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Text('End Date'),
                                        Spacer(),
                                        Text(
                                          DateFormat('dd-MMM-yyy').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                data.currentPeriodEnd * 1000),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Text('Amount '),
                                        Spacer(),
                                        Text((double.tryParse(data
                                                        .items
                                                        .data[0]
                                                        .price
                                                        .unitAmountDecimal) /
                                                    100)
                                                .toString() +
                                            ' ' +
                                            data.items.data[0].price.currency
                                                .toUpperCase()),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Text('Type'),
                                        Spacer(),
                                        Text(data.items.data[0].price.type
                                            .toUpperCase()),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Text('Status'),
                                        Spacer(),
                                        Text(toBeginningOfSentenceCase(data.status))
                                      ],
                                    ),
                                    // const Divider(),
                                    // Row(
                                    //   children: [
                                    //     Text('Total Recipes'),
                                    //     Spacer(),
                                    //     Text(_specificUserrecipeSubscriptionModel.slotleft.toString())
                                    //   ],
                                    // ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Text('Recipes Per Week',style: TextStyle(fontWeight: FontWeight.bold)),
                                        Spacer(),
                                        Text(_specificUserrecipeSubscriptionModel.allowedPerweek.toString(),style: TextStyle(fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Text('Recipes Left (Weekly)',style: TextStyle(fontWeight: FontWeight.bold)),
                                        Spacer(),
                                        Text(_specificUserrecipeSubscriptionModel.leftThisweek.toString(),style: TextStyle(fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Text('Next Free Recipe',style: TextStyle(fontWeight: FontWeight.bold)),
                                        Spacer(),
                                        // Text(_specificUserrecipeSubscriptionModel.nextfreeMeal ==null? 'Available': _specificUserrecipeSubscriptionModel.nextfreeMeal,style: TextStyle(fontSize: 15,color: AppColors.secondaryElement,fontWeight: FontWeight.bold))
                                      CountdownTimer(
             
              onEnd: (){},
              endTime: endTime,
          ),
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              )
                            ],
                          );
        });}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Subscriptions List'),
      ),
      body: _isLoading || _isLoading2
          ? Center(
              child: Text('Please wait ...'),
            )
          : (_specificUserSubscriptionModel == null ||
                  _specificUserSubscriptionModel.data.length == 0) && ( _specificUserrecipeSubscriptionModel == null ||
                  _specificUserrecipeSubscriptionModel.data.length == 0)
              ? Center(
                  child: Text('You have not subscribed'),
                )
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  _specificUserSubscriptionModel == null ||
                    _specificUserSubscriptionModel.data.length == 0? Container():   Padding(
                       padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                       child: Text(
                        'LovEats Plans',
                        style: Styles.customTitleTextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: Sizes.TEXT_SIZE_18,
                        ),
                      ),
                     ),
                    Column(
                        children: 
                        // [
                          // Expanded(
                          //   child: ListView.builder(
                          //     itemCount: _specificUserSubscriptionModel.data.length,
                          //     itemBuilder: (context, index) {
                          //       var data = _specificUserSubscriptionModel.data[index];
                          //       return
                          //     },
                          //   ),
                          // ),
                        // ],
                        mealsubscription()
                      ),
              
                       _specificUserSubscriptionModel == null ||
                    _specificUserSubscriptionModel.data.length == 0? Container():   Padding(
                       padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                       child: Text(
                        'Recipe Plans',
                        style: Styles.customTitleTextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: Sizes.TEXT_SIZE_18,
                        ),
                      ),
                     ),
                    Column(
                        children: recipesubscription())
                  ],
                ),
              ),
    );
  }

  void getCurrentUserSubscription() async {
    print(await Service().getStripeUserId());
    _specificUserSubscriptionModel =
        await Service().getSpecificUserSubscriptionData();
    _isLoading = false;
    print(_specificUserSubscriptionModel);
    setState(() {});
  }
  void getrescipeSubscription() async {
    print(await Service().getStripeUserId());
    _specificUserrecipeSubscriptionModel =
        await Service().getrescipeSubscription();
    _isLoading2 = false;

    // print(_specificUserrecipeSubscriptionModel);
    // final startTime = DateTime.parse(_specificUserrecipeSubscriptionModel.nextfreeMeal);
    // final currentTime = DateTime.now();
    // final diff_dy = currentTime.difference(startTime).inDays;

    // print(diff_dy);

  
    setState(() {});
  }

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  cancelSubsc(id) async {
    bool isOK = await Service().cancelStripeSubscription(id);
    if (isOK) {
      Toast.show('Subscription Canceled', context);
      getCurrentUserSubscription();
    } else
      Toast.show('Some Error Occured', context);
  }
}
