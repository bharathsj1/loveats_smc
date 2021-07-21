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
                    const SizedBox(
                      height: 50.0,
                    ),
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: _specificUserSubscriptionModel.data.length,
                        itemBuilder: (context, index) {
                          var data = _specificUserSubscriptionModel.data[index];
                          return Column(
                            children: [
                              ListTile(
                                tileColor: AppColors.white,
                                title: Text(data.subscriptionPlan.planDetails),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Expired at : ' +
                                          DateFormat('dd-MMM-yyy').format(
                                            DateTime.parse(data.createdAt).add(
                                              Duration(days: 30),
                                            ),
                                          ),
                                    ),
                                    Chip(
                                      backgroundColor: AppColors.secondaryColor,
                                      label: Text(
                                        data.subscriptionStatus,
                                      ),
                                    )
                                  ],
                                ),
                                trailing: data.subscriptionStatus == 'active'
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => print('hello'),
                                      )
                                    : const SizedBox(),
                              ),
                              Divider(),
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
    _specificUserSubscriptionModel =
        await Service().getSpecificUserSubscriptionData();
    _isLoading = false;
    setState(() {});
  }
}
