import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/values/data.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/foody_bite_card.dart';
import 'package:potbelly/widgets/spaces.dart';

class CategoryDetailScreen extends StatelessWidget {
  CategoryDetailScreen({
    @required this.categoryName,
    @required this.imagePath,
    @required this.numberOfCategories,
    @required this.selectedCategory,
    @required this.gradient,
    @required this.restaurantdata,
  });

  final String categoryName;
  final int numberOfCategories;
  final int selectedCategory;
  final String imagePath;
  final Gradient gradient;
  var restaurantdata;

  List fooditems = [
    {
      'name': 'Turkey Burgers',
      'image':
          'https://www.thespruceeats.com/thmb/oY67Fvga3ptpwQvOjpZNE87u6mo=/3429x2572/smart/filters:no_upscale()/juicy-baked-turkey-burgers-with-garlic-3057268-hero-01-ceea8ae8e9914a0788b9acd14e821eb3.jpg',
      'details':
          'Ground turkey, bread crumbs, egg whites, garlic, black pepper',
      'price': '20',
      'qty': '1',
      'id': '1',
      'restaurant': {
        'id': '1',
        'name': 'boundry Rooftop',
        'image': 'https://www.businesslist.pk/img/cats/restaurants.jpg',
        'open': true,
        'phone': '+2331232192139',
        'ratings': '4.6',
        'type': 'Italian',
        'distance': '5 Km',
        'address': '9122 12 Steward Street',
        'city': 'London',
        'zipcode': '100013',
        'country': 'UK',
        'open_time': '9:30',
        'close_time': '11:30',
        'menu': [
          'https://media.architecturaldigest.in/wp-content/uploads/2020/04/Mumbai-restaurant-COVID-19-2-1.jpg',
          'https://images.all-free-download.com/images/graphiclarge/food_picture_03_hd_pictures_167556.jpg',
          'https://picturecorrect-wpengine.netdna-ssl.com/wp-content/uploads/2016/11/restaurant-food-photography-tips.jpg'
        ],
        'reviews': []
      }
    },
    {
      'name': 'Margherita Pizza',
      'image':
          'https://www.abeautifulplate.com/wp-content/uploads/2015/08/the-best-homemade-margherita-pizza-1-4-480x480.jpg',
      'details':
          'San marzano, fresh mozzarella cheese, red pepper flakes, olive',
      'price': '24',
      'qty': '1',
      'id': '2',
    },
    {
      'name': 'Portobello Mushroom Burgers',
      'image':
          'https://www.wellplated.com/wp-content/uploads/2019/07/Stuffed-Portobello-Mushroom-Burger.jpg',
      'details': 'Portobello mushroom caps, balsamic vinegar, provolone',
      'price': '14',
      'qty': '1',
      'id': '4',
    },
    {
      'name': 'York-​Style Pizza',
      'image':
          'https://feelingfoodish.com/wp-content/uploads/2013/06/Pizza-sauce.jpg',
      'details': 'Olive oil, sugar, dry yeast, all purpose',
      'price': '26',
      'qty': '1',
      'id': '5',
    }
  ];

  TextStyle subHeadingTextStyle = Styles.customTitleTextStyle(
    color: AppColors.headingText,
    fontWeight: FontWeight.w600,
    fontSize: Sizes.TEXT_SIZE_16,
  );

  TextStyle addressTextStyle = Styles.customNormalTextStyle(
    color: AppColors.accentText,
    fontSize: Sizes.TEXT_SIZE_12,
  );

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var widthOfScreen = MediaQuery.of(context).size.width;
    var marginBetweenPills = 4;
    var marginAroundPills = 92;
    var margin =
        marginAroundPills + ((numberOfCategories - 1) * marginBetweenPills);
    var widthOfEachPill = (widthOfScreen - margin) / numberOfCategories;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Stack(
            children: <Widget>[
              Positioned(
                child: Image.asset(
                  imagePath,
                  width: MediaQuery.of(context).size.width,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                child: Opacity(
                  opacity: 0.85,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: gradient,
                    ),
                  ),
                ),
              ),
              Positioned(
                child: SafeArea(
                  child: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Image.asset(ImagePath.arrowBackIcon),
                            ),
                            Spacer(flex: 1),
                            Text(
                              categoryName,
                              style: textTheme.title.copyWith(
                                fontSize: Sizes.TEXT_SIZE_22,
                                color: AppColors.white,
                              ),
                            ),
                            Spacer(flex: 1),
                          ],
                        ),
                        SpaceH24(),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: generatePills(
                              numberOfPills: numberOfCategories,
                              widthOfPill: widthOfEachPill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(
          left: Sizes.MARGIN_16,
          right: Sizes.MARGIN_16,
          top: Sizes.MARGIN_16,
        ),
        child: Column(
          children: <Widget>[
            Column(
                children: List.generate(
              fooditems.length,
              (i) => Card(
                margin: EdgeInsets.symmetric(vertical: 6),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context,
                      AppRouter.restaurantDetailsScreen,
                      arguments: RestaurantDetails(
                          imagePath: restaurantdata['image'],
                          restaurantName: restaurantdata['name'],
                          restaurantAddress: restaurantdata['address'] +
                              ' ' +
                              restaurantdata['city'] +
                              ' ' +
                              restaurantdata['country'],
                          rating: restaurantdata['ratings'],
                          category: restaurantdata['type'],
                          distance: restaurantdata['distance'],
                          data: restaurantdata),
                    );
                  },
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            fooditems[i]['image'],
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
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            fooditems[i]['name'],
                            style: subHeadingTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '\$' + fooditems[i]['price'],
                              style: subHeadingTextStyle,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            // Ratings(ratings[i]),
                          ],
                        ),
                      ],
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    subtitle: Text(
                      fooditems[i]['details'],
                      style: addressTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  List<Widget> generatePills({
    @required int numberOfPills,
    @required double widthOfPill,
  }) {
    List<Widget> pills = [];
    for (var index = 0; index < numberOfPills; index++) {
      pills.add(
        Pill(
          width: widthOfPill,
          color: (index == selectedCategory)
              ? AppColors.white
              : AppColors.whiteShade_50,
          marginRight:
              (index == numberOfPills - 1) ? Sizes.MARGIN_0 : Sizes.MARGIN_4,
        ),
      );
    }

    return pills;
  }
}

class Pill extends StatelessWidget {
  Pill({
    this.width = 30,
    this.height = 4,
    this.marginRight = 4,
    this.color = AppColors.whiteShade_50,
    this.borderRadius = Sizes.RADIUS_30,
  });

  final double width;
  final double height;
  final double marginRight;
  final Color color;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, //28,
      height: height,
      margin: EdgeInsets.only(right: marginRight),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
