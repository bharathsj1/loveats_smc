import 'package:flutter/material.dart';
import 'package:potbelly/models/menu_types_model.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/service.dart';
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
            color: AppColors.headingText,
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
        actions: <Widget>[
          InkWell(
            onTap: () {},
            child: Image.asset(
              ImagePath.searchIcon,
              color: AppColors.headingText,
            ),
          )
        ],
      ),
      body: FutureBuilder<MenuTypesModel>(
        future: Service().getMenuTypes(),
        builder: (context, AsyncSnapshot<MenuTypesModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Container(
              margin: EdgeInsets.symmetric(
                  horizontal: Sizes.MARGIN_16, vertical: Sizes.MARGIN_16),
              child: ListView.separated(
                itemCount: snapshot.data.data.length,
                separatorBuilder: (context, index) {
                  return SpaceH12();
                },
                itemBuilder: (context, index) {
                  var res = snapshot.data.data[index];
                  return Container(
                    child: FoodyBiteCategoryCard(
                      onTap: () => AppRouter.navigator.pushNamed(
                        AppRouter.categoryDetailScreen,
                        arguments: CategoryDetailScreenArguments(
                          categoryName: res.menuName,
                          imagePath: res.menuTypeImage,
                          selectedCategory: index,
                          numberOfCategories: snapshot.data.data.length,
                          gradient: gradients[index],
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      imagePath: res.menuTypeImage,
                      gradient: gradients[index],
                      category: res.menuName,
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
            );
          }
        },
      ),
    );
  }
}
