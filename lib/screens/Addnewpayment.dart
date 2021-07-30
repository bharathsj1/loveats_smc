import 'package:flutter/material.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';

class AddNewPayment extends StatefulWidget {
  const AddNewPayment({Key key}) : super(key: key);

  @override
  _AddNewPaymentState createState() => _AddNewPaymentState();
}

class _AddNewPaymentState extends State<AddNewPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            ImagePath.arrowBackIcon,
            color: AppColors.headingText,
          ),
        ),
        // centerTitle: true,
        title: Text(
          'Add a new payment method',
          style: Styles.customTitleTextStyle(
            color: AppColors.headingText,
            fontWeight: FontWeight.bold,
            fontSize: Sizes.TEXT_SIZE_16,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: PotbellyButton(
              'Add Card',
              onTap: () {},
              buttonHeight: 45,
              buttonWidth: MediaQuery.of(context).size.width * 0.89,
              buttonTextStyle: TextStyle(
                  fontSize: 15,
                  fontFamily: 'roboto',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.secondaryElement),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(children: <Widget>[
            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 50.0, right: 10.0),
                  child: Divider(
                    color: Colors.black,
                    height: 36,
                  )),
            ),
            Text(
              "OR",
              style: TextStyle(fontSize: 14),
            ),
            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 50.0),
                  child: Divider(
                    color: Colors.black,
                    height: 36,
                  )),
            ),
          ]),
          SizedBox(
            height: 20,
          ),
          Center(
              child: Container(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.89,
            decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0.5,color: Colors.grey.shade300)
            ),
            child: Center(
             child: Image.asset('assets/images/paypal.png',height:25,width:60,)
            ),
          )
          ),
        ],
      ),
    );
  }
}
