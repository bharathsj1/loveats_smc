import 'package:auto_route/auto_route.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/screens/add_ratings_screen.dart';
import 'package:potbelly/screens/bookmarks_screen.dart';
import 'package:potbelly/screens/categories_screen.dart';
import 'package:potbelly/screens/category_detail_screen.dart';
import 'package:potbelly/screens/change_language_screen.dart';
import 'package:potbelly/screens/change_password_screen.dart';
import 'package:potbelly/screens/edit_profile_screen.dart';
import 'package:potbelly/screens/filter_screen.dart';
import 'package:potbelly/screens/find_friends_screen.dart';
import 'package:potbelly/screens/forgot_password_screen.dart';
import 'package:potbelly/screens/google_map.dart';
import 'package:potbelly/screens/home_screen.dart';
import 'package:potbelly/screens/login_screen.dart';
import 'package:potbelly/screens/menu_photos_screen.dart';
import 'package:potbelly/screens/new_review_screen.dart';
import 'package:potbelly/screens/notification_screen.dart';
import 'package:potbelly/screens/preview_menu_photos.dart';
import 'package:potbelly/screens/profile_screen.dart';
import 'package:potbelly/screens/register_screen.dart';
import 'package:potbelly/screens/restaurant_details_screen.dart';
import 'package:potbelly/screens/review_rating_screen.dart';
import 'package:potbelly/screens/root_screen.dart';
import 'package:potbelly/screens/search_results.dart';
import 'package:potbelly/screens/set_location_screen.dart';
import 'package:potbelly/screens/settings_screen.dart';
import 'package:potbelly/screens/splash_screen.dart';
import 'package:potbelly/screens/trending_restaurant_screen.dart';
import 'package:meta/meta.dart';

//@MaterialAutoRouter()
//@CustomAutoRouter(transitionsBuilder: TransitionsBuilders.slideLeft, durationInMilliseconds: 200)

@CupertinoAutoRouter()
class $Router {
  // @initial
  @CustomAutoRouter(
      transitionsBuilder: TransitionsBuilders.slideRight,
      durationInMilliseconds: 2000)
  BackgroundVideo loginScreen;

  @CustomAutoRouter(
      transitionsBuilder: TransitionsBuilders.slideRight,
      durationInMilliseconds: 2000)
  SplashScreen splashScreen;

  ForgotPasswordScreen forgotPasswordScreen;

  @MaterialRoute()
  RegisterScreen registerScreen;

  SetLocationScreen setLocationScreen;

  HomeScreen homeScreen;

  RootScreen rootScreen;

  ProfileScreen profileScreen;

  NotificationsScreen notificationsScreen;

  TrendingRestaurantsScreen trendingRestaurantsScreen;
  RestaurantDetailsScreen restaurantDetailsScreen;
  BookmarksScreen bookmarksScreen;

  FilterScreen filterScreen;
  SearchResultsScreen searchResultsScreen;
  ReviewRatingScreen reviewRatingScreen;

  AddRatingsScreen addRatingsScreen;
  MenuPhotosScreen menuPhotosScreen;
  PreviewMenuPhotosScreen previewMenuPhotosScreen;
  CategoriesScreen categoriesScreen;

  CategoryDetailScreen categoryDetailScreen;
  FindFriendsScreen findFriendsScreen;
  SettingsScreen settingsScreen;
  ChangePasswordScreen changePasswordScreen;

  ChangeLanguageScreen changeLanguageScreen;
  EditProfileScreen editProfileScreen;
  NewReviewScreen newReviewScreen;
  GoogleMaps googleMaps;
}

class SearchValue {
  final String value;

  SearchValue(this.value);
}

class RestaurantDetails {
  final String imagePath;
  final String restaurantName;
  final String restaurantAddress;
  final String category;
  final String distance;
  final String rating;
  var data;

  RestaurantDetails({
    @required this.imagePath,
    @required this.restaurantName,
    @required this.restaurantAddress,
    @required this.category,
    @required this.distance,
    @required this.rating,
    this.data,
  });
}

class PromotionDetails {
  final String image;
  final String name;
  final String video;
  final String thumnail;
  final String description;
  final String id;
  var data;

  PromotionDetails({
    @required this.image,
    @required this.name,
    @required this.video,
    @required this.thumnail,
    @required this.description,
    @required this.id,
    this.data,
  });
}

class CurrentScreen {
  final Widget currentScreen;
  final int tab_no;

  CurrentScreen({
    @required this.tab_no,
    @required this.currentScreen,
  });
}
