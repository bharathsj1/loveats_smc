// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:potbelly/screens/New_splash_Screen.dart';
import 'package:potbelly/screens/google_map.dart';
import 'package:potbelly/screens/Promotionalert.dart';
import 'package:potbelly/screens/checkoutScreen.dart';
import 'package:potbelly/screens/hotsport_details.dart';
import 'package:potbelly/screens/live_tracking.dart';
import 'package:potbelly/screens/login_screen.dart';
import 'package:potbelly/screens/myorder_details.dart';
import 'package:potbelly/screens/orderlist.dart';
import 'package:potbelly/screens/paymentsuccess.dart';
import 'package:potbelly/screens/splash_screen.dart';
import 'package:potbelly/screens/forgot_password_screen.dart';
import 'package:potbelly/screens/register_screen.dart';
import 'package:potbelly/screens/set_location_screen.dart';
import 'package:potbelly/screens/home_screen.dart';
import 'package:potbelly/screens/root_screen.dart';
import 'package:potbelly/screens/root_screen2.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/screens/profile_screen.dart';
import 'package:potbelly/screens/notification_screen.dart';
import 'package:potbelly/screens/subscription_page.dart';
import 'package:potbelly/screens/trending_restaurant_screen.dart';
import 'package:potbelly/screens/restaurant_details_screen.dart';
import 'package:potbelly/screens/promotions_detail_page.dart';
import 'package:potbelly/screens/bookmarks_screen.dart';
import 'package:potbelly/screens/filter_screen.dart';
import 'package:potbelly/screens/search_results.dart';
import 'package:potbelly/screens/review_rating_screen.dart';
import 'package:potbelly/screens/add_ratings_screen.dart';
import 'package:potbelly/screens/menu_photos_screen.dart';
import 'package:potbelly/screens/preview_menu_photos.dart';
import 'package:potbelly/screens/categories_screen.dart';
import 'package:potbelly/screens/category_detail_screen.dart';
import 'package:potbelly/screens/find_friends_screen.dart';
import 'package:potbelly/screens/settings_screen.dart';
import 'package:potbelly/screens/cart_screen.dart';
import 'package:potbelly/screens/change_password_screen.dart';
import 'package:potbelly/screens/change_language_screen.dart';
import 'package:potbelly/screens/edit_profile_screen.dart';
import 'package:potbelly/screens/new_review_screen.dart';
import 'package:potbelly/Checkout_Screens/Checkout1.dart';
import 'package:potbelly/Checkout_Screens/Checkout2.dart';
import 'package:potbelly/Checkout_Screens/Checkout3.dart';
import 'package:potbelly/screens/user_subscription_list.dart';
import 'package:potbelly/vendor_screens.dart/open_direction.dart';
import 'package:potbelly/vendor_screens.dart/open_map.dart';
import 'package:potbelly/vendor_screens.dart/vendor_notifications.dart';
import 'package:potbelly/vendor_screens.dart/orders_detail.dart';

class AppRouter {
  static const loginScreen = '/';
  static const splashScreen = '/splash-screen';
  static const newsplashScreen = '/new-splash-screen';
  static const forgotPasswordScreen = '/forgot-password-screen';
  static const registerScreen = '/register-screen';
  static const setLocationScreen = '/set-location-screen';
  static const homeScreen = '/home-screen';
  static const rootScreen = '/root-screen';
  static const rootScreen2 = '/root-screen2';
  static const profileScreen = '/profile-screen';
  static const notificationsScreen = '/notifications-screen';
  static const vendornotificationsScreen = '/vendornotifications-screen';
  static const trendingRestaurantsScreen = '/trending-restaurants-screen';
  static const restaurantDetailsScreen = '/restaurant-details-screen';
  static const HotspotsDetailsScreen = '/Hotspot-details-screen';
  static const promotionDetailsScreen = '/promotion-details-screen';
  static const bookmarksScreen = '/bookmarks-screen';
  static const filterScreen = '/filter-screen';
  static const searchResultsScreen = '/search-results-screen';
  static const reviewRatingScreen = '/review-rating-screen';
  static const addRatingsScreen = '/add-ratings-screen';
  static const menuPhotosScreen = '/menu-photos-screen';
  static const previewMenuPhotosScreen = '/preview-menu-photos-screen';
  static const promotionScreen = '/promotion-screen';
  static const categoriesScreen = '/categories-screen';
  static const categoryDetailScreen = '/category-detail-screen';
  static const findFriendsScreen = '/find-friends-screen';
  static const settingsScreen = '/settings-screen';
  static const changePasswordScreen = '/change-password-screen';
  static const changeLanguageScreen = '/change-language-screen';
  static const editProfileScreen = '/edit-profile-screen';
  static const newReviewScreen = '/new-review-screen';
  static const googleMap = '/google-map';
  static const checkoutScreen = '/checkout-screen';
  static const cart_Screen = '/cart_screen';
  static const paymentSuccess = '/paymentsuccess-screen';
  static const OrdersDetailScreen = '/OrdersDetails-screen';
  static const CheckOut1 = '/CheckOutScreen1';
  static const CheckOut2 = '/CheckOutScreen2';
  static const CheckOut3 = '/CheckOutScreen3';
  static const Opendirection = '/opendirection';
  static const Open_maps = '/open_maps';
  static const order_list = '/order_list';
  static const myorder_detail = '/myorder_detail';
  static const live_tracking = '/live_tracking';
  static const subscriptionPage = '/subscription-page';
  static const userSubscriptionList = '/user-subscription-list';

  Navigator navigator = Navigator();
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRouter.loginScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => BackgroundVideo(),
          settings: settings,
        );
      case AppRouter.splashScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => SplashScreen(),
          settings: settings,
        );
      case AppRouter.newsplashScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => New_Splash(),
          settings: settings,
        );
      case AppRouter.forgotPasswordScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => ForgotPasswordScreen(),
          settings: settings,
        );
      case AppRouter.registerScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => RegisterScreen(),
          settings: settings,
        );
      case AppRouter.setLocationScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => SetLocationScreen(),
          settings: settings,
        );
      case AppRouter.homeScreen:
        // if (hasInvalidArgs<Key>(args)) {
        //   return misTypedArgsRoute<Key>(args);
        // }
        final typedArgs = args as Key;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => HomeScreen(key: typedArgs),
          settings: settings,
        );
      case AppRouter.rootScreen:
        // if (hasInvalidArgs<CurrentScreen>(args)) {
        //   return misTypedArgsRoute<CurrentScreen>(args);
        // }
        final typedArgs = args as CurrentScreen;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => RootScreen(currentScreen: typedArgs),
          settings: settings,
        );
      case AppRouter.rootScreen2:
        // if (hasInvalidArgs<CurrentScreen>(args)) {
        //   return misTypedArgsRoute<CurrentScreen>(args);
        // }
        final typedArgs = args as CurrentScreen;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => RootScreen(currentScreen: typedArgs),
          settings: settings,
        );
      case AppRouter.profileScreen:
        // if (hasInvalidArgs<Key>(args)) {
        //   return misTypedArgsRoute<Key>(args);
        // }
        final typedArgs = args as Key;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => ProfileScreen(key: typedArgs),
          settings: settings,
        );
      case AppRouter.notificationsScreen:
        // if (hasInvalidArgs<Key>(args)) {
        //   return misTypedArgsRoute<Key>(args);
        // }
        final typedArgs = args as Key;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => NotificationsScreen(key: typedArgs),
          settings: settings,
        );
      case AppRouter.vendornotificationsScreen:
        // if (hasInvalidArgs<Key>(args)) {
        //   return misTypedArgsRoute<Key>(args);
        // }
        final typedArgs = args as Key;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => VendorNotificationsScreen(key: typedArgs),
          settings: settings,
        );
      case AppRouter.trendingRestaurantsScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => TrendingRestaurantsScreen(),
          settings: settings,
        );
      case AppRouter.Opendirection:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => Open_direction(
            desdirection: args,
          ),
          settings: settings,
        );
      case AppRouter.OrdersDetailScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => OrdersDetails(
            orderdata: args,
          ),
          settings: settings,
        );
      case AppRouter.order_list:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => OrderList(),
          settings: settings,
        );
      case AppRouter.myorder_detail:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => Myorder_Detail(
            orderdata: args,
          ),
          settings: settings,
        );
      case AppRouter.live_tracking:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => Live_Tracking(
            desdirection: args,
          ),
          settings: settings,
        );
      case AppRouter.Open_maps:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => Open_map(desdirection: args),
          settings: settings,
        );
      case AppRouter.CheckOut1:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => CheckOutScreen1(
            checkoutdata: args,
          ),
          settings: settings,
        );
      case AppRouter.CheckOut2:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => CheckOutScreen2(
            checkoutdata: args,
          ),
          settings: settings,
        );
      case AppRouter.CheckOut3:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => CheckOutScreen3(
            checkoutdata: args,
          ),
          settings: settings,
        );
      case AppRouter.restaurantDetailsScreen:
        // if (hasInvalidArgs<RestaurantDetails>(args, isRequired: true)) {
        //   return misTypedArgsRoute<RestaurantDetails>(args);
        // }
        final typedArgs = args as RestaurantDetails;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => RestaurantDetailsScreen(restaurantDetails: typedArgs),
          settings: settings,
        );
      case AppRouter.HotspotsDetailsScreen:
        // if (hasInvalidArgs<RestaurantDetails>(args, isRequired: true)) {
        //   return misTypedArgsRoute<RestaurantDetails>(args);
        // }
        final typedArgs = args as RestaurantDetails;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => HotSpotDetailsScreen(restaurantDetails: typedArgs),
          settings: settings,
        );
      case AppRouter.promotionDetailsScreen:
        // if (hasInvalidArgs<PromotionDetails>(args, isRequired: true)) {
        //   return misTypedArgsRoute<PromotionDetails>(args);
        // }
        final typedArgs = args as PromotionDetails;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => PromotionDetailsScreen(promotionDetails: typedArgs),
          settings: settings,
        );
      case AppRouter.bookmarksScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => BookmarksScreen(),
          settings: settings,
        );
      case AppRouter.cart_Screen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => CartScreen(),
          settings: settings,
        );
      case AppRouter.checkoutScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => CheckoutScreen(
            checkoutdata: args,
          ),
          settings: settings,
        );
      case AppRouter.paymentSuccess:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => PaymentSuccess(
            checkoutdata: args,
          ),
          settings: settings,
        );
      case AppRouter.filterScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => FilterScreen(),
          settings: settings,
        );
      case AppRouter.searchResultsScreen:
        // if (hasInvalidArgs<SearchValue>(args)) {
        //   return misTypedArgsRoute<SearchValue>(args);
        // }
        final typedArgs = args as SearchValue;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => SearchResultsScreen(typedArgs),
          settings: settings,
        );
      case AppRouter.reviewRatingScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => ReviewRatingScreen(),
          settings: settings,
        );
      case AppRouter.addRatingsScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => AddRatingsScreen(
            resId: args,
          ),
          settings: settings,
        );
      case AppRouter.menuPhotosScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => MenuPhotosScreen(
            images: args,
          ),
          settings: settings,
        );
      case AppRouter.previewMenuPhotosScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => PreviewMenuPhotosScreen(),
          settings: settings,
        );
      case AppRouter.promotionScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => PromotionPhotosScreen(),
          settings: settings,
        );
      case AppRouter.categoriesScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => CategoriesScreen(),
          settings: settings,
        );
      case AppRouter.categoryDetailScreen:
        // if (hasInvalidArgs<CategoryDetailScreenArguments>(args,
        //     isRequired: true)) {
        //   return misTypedArgsRoute<CategoryDetailScreenArguments>(args);
        // }
        final typedArgs = args as CategoryDetailScreenArguments;
        return CupertinoPageRoute<dynamic>(
          builder: (_) => CategoryDetailScreen(
            categoryName: typedArgs.categoryName,
            imagePath: typedArgs.imagePath,
            numberOfCategories: typedArgs.numberOfCategories,
            selectedCategory: typedArgs.selectedCategory,
            gradient: typedArgs.gradient,
            restaurantdata: typedArgs.restaurantdata,
          ),
          settings: settings,
        );
      case AppRouter.findFriendsScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => FindFriendsScreen(),
          settings: settings,
        );
      case AppRouter.settingsScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => SettingsScreen(),
          settings: settings,
        );
      case AppRouter.changePasswordScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => ChangePasswordScreen(),
          settings: settings,
        );
      case AppRouter.changeLanguageScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => ChangeLanguageScreen(),
          settings: settings,
        );
      case AppRouter.editProfileScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => EditProfileScreen(),
          settings: settings,
        );
      case AppRouter.newReviewScreen:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => NewReviewScreen(),
          settings: settings,
        );
      case AppRouter.googleMap:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => GoogleMaps(),
          settings: settings,
        );
      case AppRouter.subscriptionPage:
        return CupertinoPageRoute<dynamic>(
          builder: (_) => SubscriptionScreen(),
          settings: settings,
        );

        case AppRouter.userSubscriptionList:
         return CupertinoPageRoute<dynamic>(
          builder: (_) => UserSubscriptionList(),
          settings: settings,
        );

      default:
      // return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//CategoryDetailScreen arguments holder class
class CategoryDetailScreenArguments {
  final String categoryName;
  final String imagePath;
  final int numberOfCategories;
  final int selectedCategory;
  final Gradient gradient;
  var restaurantdata;
  CategoryDetailScreenArguments(
      {@required this.categoryName,
      @required this.imagePath,
      @required this.numberOfCategories,
      @required this.selectedCategory,
      @required this.restaurantdata,
      @required this.gradient});
}
