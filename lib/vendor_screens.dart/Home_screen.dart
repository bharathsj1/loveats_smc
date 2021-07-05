import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';

class Vendor_Home_screen extends StatefulWidget {
  static const int TAB_NO = 0;
  const Vendor_Home_screen({Key key}) : super(key: key);

  @override
  _Vendor_Home_screenState createState() => _Vendor_Home_screenState();
}

class _Vendor_Home_screenState extends State<Vendor_Home_screen> {
  List orders=[];
  TextStyle subHeadingTextStyle = Styles.customTitleTextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w600,
    fontSize: Sizes.TEXT_SIZE_18,
  );
  TextStyle addressTextStyle = Styles.customNormalTextStyle(
    color: AppColors.accentText,
    fontSize: Sizes.TEXT_SIZE_14,
  );
  
  @override
  void initState() {
   getorders();
    super.initState();
    }

    getorders() async {
    var orders= await AppService().getOrdersForSpecificOwnerRestaurent();
    print(orders);
    }

  List<Widget> card() {
    return List.generate(
        5,
        (index) => InkWell(
              onTap: () {
                AppRouter.navigator
                    .pushNamed(AppRouter.OrdersDetailScreen);
              },
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          'https://www.businesslist.pk/img/cats/restaurants.jpg',
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
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text(
          'Orders'.toUpperCase(),
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'roboto',
              color: AppColors.secondaryElement),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Column(
              children: card(),
            ),
          ],
        ),
      ),
    );
  }
}
