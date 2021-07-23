import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:potbelly/models/specific_user_subscription_model.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';

class UserSubscriptionList extends StatefulWidget {
  const UserSubscriptionList({Key key}) : super(key: key);

  @override
  _UserSubscriptionListState createState() => _UserSubscriptionListState();
}

class _UserSubscriptionListState extends State<UserSubscriptionList> {
  SpecificUserSubscriptionModel _specificUserSubscriptionModel;
  bool _isLoading = true;
  @override
  void initState() {
    getCurrentUserSubscription();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Subscriptions List'),
      ),
      body: _isLoading
          ? Center(
              child: Text('Please wait ...'),
            )
          : _specificUserSubscriptionModel == null
              ? Center(
                  child: Text('You have not subscribed'),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _specificUserSubscriptionModel.data.length,
                        itemBuilder: (context, index) {
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
                                        Text(data.status)
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  void getCurrentUserSubscription() async {
    print(await Service().getStripeUserId());
    _specificUserSubscriptionModel =
        await Service().getSpecificUserSubscriptionData();
    _isLoading = false;
    setState(() {});
  }
}
