import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/values/data.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/category_card.dart';
import 'package:potbelly/widgets/spaces.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: InkWell(
          onTap: () => AppRouter.navigator.pop(),
          child: Image.asset(
            ImagePath.arrowBackIcon,
            color: AppColors.secondaryElement,
          ),
        ),
        centerTitle: true,
        title: Text(
          StringConst.CATEGORY,
          style: Styles.customTitleTextStyle(
            color: AppColors.headingText,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.TEXT_SIZE_20,
          ),
        ),
        // actions: <Widget>[
        //   InkWell(
        //     onTap: () {},
        //     child: Image.asset(
        //       ImagePath.searchIcon,
        //       color: AppColors.headingText,
        //     ),
        //   )
        // ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Sizes.MARGIN_16, vertical: Sizes.MARGIN_16),
        child: ListView.separated(
          itemCount: categoryListImagePaths.length,
          separatorBuilder: (context, index) {
            return SpaceH12();
          },
          itemBuilder: (context, index) {
            return Container(
              child: FoodyBiteCategoryCard(
                onTap: () => AppRouter.navigator.pushNamed(
                  AppRouter.categoryDetailScreen,
                  arguments: CategoryDetailScreenArguments(
                      categoryName: category[index],
                      imagePath: categoryListImagePaths[index],
                      selectedCategory: index,
                      numberOfCategories: categoryListImagePaths.length,
                      gradient: gradients[index],
                      restaurantdata: {
                        'id': '1',
                        'name': 'boundry Rooftop',
                        'image':
                            'https://www.businesslist.pk/img/cats/restaurants.jpg',
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
                      }),
                ),
                width: MediaQuery.of(context).size.width,
                imagePath: categoryListImagePaths[index],
                gradient: gradients[index],
                category: category[index],
                hasHandle: true,
                opacity: 0.85,
                categoryTextStyle: textTheme.title.copyWith(
                  color: AppColors.primaryColor,
                  fontSize: Sizes.TEXT_SIZE_22,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
