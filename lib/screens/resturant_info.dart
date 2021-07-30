import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/values/values.dart';

class RestaurantInfo extends StatefulWidget {
  RestaurantDetails restaurantdata;
  RestaurantInfo({@required this.restaurantdata});

  @override
  _RestaurantInfoState createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  @override
  void initState() {
    // TODO: implement initState
    print(widget.restaurantdata.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: ImageIcon(
            AssetImage(
              ImagePath.closeIcon,
            ),
            size: 16,
            //  image: Image.asset( ImagePath.arrowBackIcon,),
            color: AppColors.secondaryElement,
          ),
        ),
        title: Text(
          'Restaurant Info',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'roboto'),
        ),
      ),
      backgroundColor: Color(0xFFF9FBFA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Hygiene rating',
                style: Theme.of(context).textTheme.title.copyWith(
                      fontSize: Sizes.TEXT_SIZE_18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black.withOpacity(0.8),
                    ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/hygiene2.jpg',
                      height: 80,
                      width: 150,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "The Food Standards Agency updates food hygiene ratings regularly. Visit the FSA's website to see the most recent rating for this restaurant. Last updated 29 Jul 2021",
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'roboto',
                          color: Colors.grey.shade600),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    height: 5,
                    color: Colors.grey.shade200,
                    thickness: 1.8,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.language_outlined,
                          color: AppColors.secondaryElement,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'View Hygiene rating',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'roboto',
                              color: AppColors.secondaryElement),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Questions about allergens?',
                style: Theme.of(context).textTheme.title.copyWith(
                      fontSize: Sizes.TEXT_SIZE_18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black.withOpacity(0.8),
                    ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Ask the restaurant about their ingredients and cooking methods.",
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'roboto',
                              color: Colors.grey.shade600),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        height: 5,
                        color: Colors.grey.shade200,
                        thickness: 1.8,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone_in_talk_outlined,
                              color: AppColors.secondaryElement,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.restaurantdata.restaurantName,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'roboto',
                                      color: AppColors.secondaryElement),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  // widget.restaurantdata.data.restPhone,
                                  '+441517078250',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'roboto',
                                      color: AppColors.secondaryElement),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 5,
                        color: Colors.grey.shade200,
                        thickness: 1.8,
                      ),
                    ])),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'More information',
                style: Theme.of(context).textTheme.title.copyWith(
                      fontSize: Sizes.TEXT_SIZE_18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black.withOpacity(0.8),
                    ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "All dishes may contain traces of the following allergens: Gluten, Crustaceans, Eggs, Fish, Peanuts, Soybeans, Milk, Nuts (e.g. almonds, hazelnuts, walnuts, cashews, pecan nuts, Brazil nuts, pistachio nuts, macadamia nuts), Celery, Mustard, Sesame, Sulphur dioxide/sulphites, Lupin, Molluscs.\n\nFor any questions regarding the allergen contents of specific dishes please contact the restaurant directly.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'roboto',
                              color: Colors.grey.shade600),
                        ),
                      ),
                      SizedBox(
                    height: 20,
                  ),
                    ])),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Restaurant notes',
                style: Theme.of(context).textTheme.title.copyWith(
                      fontSize: Sizes.TEXT_SIZE_18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black.withOpacity(0.8),
                    ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                         "Due to the importance we place on ensuring your order is taken and cooked individually for you, we are only able to accept allergy orders for eat in and not through Deliveroo.\n\nAll dishes may contain traces of the following allergens: Wheat containing Gluten; Peanuts; Nuts; Sesame Seeds; Celery; Soybeans; Milk; Eggs; Mustard; Mollusc; Crustaceans; Fish or Sulphur Dioxide.\n\nAlcohol is not for sale to people under the age of 18. By placing an order for alcohol products on this site you are declaring that you are 18 years of age or over. Identification will be requested for anyone looking under the age of 25.\n\nTo find out more about our restaurant's food safety, visit the Food Standards Agency",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'roboto',
                              color: Colors.grey.shade600),
                        ),
                      ),
                      SizedBox(
                    height: 20,
                  ),
                    ])),
                     SizedBox(
                    height: 20,
                  ),
          ],
        ),
      ),
    );
  }
}
