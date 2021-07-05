import 'package:flutter/material.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';

class OrdersDetails extends StatefulWidget {
  const OrdersDetails({Key key}) : super(key: key);

  @override
  _OrdersDetailsState createState() => _OrdersDetailsState();
}

class _OrdersDetailsState extends State<OrdersDetails> {
  TextStyle subHeadingTextStyle = Styles.customTitleTextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w600,
    fontSize: Sizes.TEXT_SIZE_18,
  );
  TextStyle addressTextStyle = Styles.customNormalTextStyle(
    color: AppColors.accentText,
    fontSize: Sizes.TEXT_SIZE_14,
  );

  List<Widget> card() {
    return List.generate(
        2,
        (index) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: Colors.grey[300],
            width: 0.5,
          ),
        )),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Padding(
              padding: EdgeInsets.only(top: 8),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    'https://cheetay-prod-media.s3.amazonaws.com/production/media/images/partners/2020/12/close-up-photo-of-burger-3915906-scaled.jpg',
                    loadingBuilder: (BuildContext ctx, Widget child,
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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.secondaryElement),
                            ),
                          ),
                        );
                      }
                    },
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                  )),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  // color: Colors.red,
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Text(
                    'Pizza burger',
                    style: subHeadingTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '\$' + '299.00',
                      style: TextStyle(
                        color: AppColors.secondaryElement,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'roboto',
                        fontSize: Sizes.TEXT_SIZE_16,
                      ),
                    ),

                    // Ratings(ratings[i]),
                  ],
                ),
              ],
            ),
            subtitle: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Home cooking experience',
                      style: addressTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '2019-12-11',
                      style: addressTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity: ' + '2',
                        style: addressTextStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '12:15',
                        style: addressTextStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.secondaryElement),

        elevation: 0,
        title: Text(
          'Order Details',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'roboto',
              color: AppColors.secondaryElement),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(
            color: Colors.grey[300],
            width: 0.5,
          ),
        )),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      color: AppColors.secondaryElement,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'roboto',
                      fontSize: Sizes.TEXT_SIZE_20,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '\$' + '299.00',
                    style: TextStyle(
                      color: AppColors.secondaryElement,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'roboto',
                      fontSize: Sizes.TEXT_SIZE_20,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              PotbellyButton(
                // StringConst.SUBSCRIPTION,
                'Delivered',
                buttonHeight: 50,
                buttonTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.secondaryElement),
                // onTap: () => Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => RegisterScreen()
                // ),
                // ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Material(
                elevation: 1,
                child: Container(
                  padding: EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    leading: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Color(0xFFDFE0E4),
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            Icons.history,
                            color: Colors.black,
                          ),
                        )),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          // color: Colors.red,
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Text(
                            'Order #1234',
                            style: subHeadingTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '\$' + '299.00',
                              style: TextStyle(
                                color: AppColors.secondaryElement,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'roboto',
                                fontSize: Sizes.TEXT_SIZE_16,
                              ),
                            ),

                            // Ratings(ratings[i]),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Payment Method: Card',
                              style: addressTextStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '2019-12-11',
                              style: addressTextStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Items: ' + '2',
                                style: addressTextStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '12:15',
                                style: addressTextStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_pin,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Customer',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'roboto'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Charles W. Abeyta',
                        style: TextStyle(
                            fontSize: 20,
                            // fontWeight: FontWeight.bold,
                            fontFamily: 'roboto',
                            color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Color(0xFFDFE0E4),
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.person_outline,
                              // size: 16,
                              color: Colors.black54,
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '4722 Villa Drive',
                        style: TextStyle(
                            fontSize: 20,
                            // fontWeight: FontWeight.bold,
                            fontFamily: 'roboto',
                            color: Colors.black87),
                        // maxLines: 1,
                        // overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Color(0xFFDFE0E4),
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.directions_outlined,
                              // size: 16,
                              color: Colors.black54,
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '+442292912993',
                        style: TextStyle(
                            fontSize: 20,
                            // fontWeight: FontWeight.bold,
                            fontFamily: 'roboto',
                            color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.phone,
                              // size: 16,
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.fastfood_outlined,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Food Ordered',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'roboto'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: card(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
