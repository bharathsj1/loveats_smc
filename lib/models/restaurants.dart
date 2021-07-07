import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final CollectionReference restaurantlist =
      FirebaseFirestore.instance.collection('Restaurants');

  Future<void> createDemoRestaurants(name) {
    var date= DateTime.now().millisecondsSinceEpoch.toString();
    List menu= [
      'https://media.architecturaldigest.in/wp-content/uploads/2020/04/Mumbai-restaurant-COVID-19-2-1.jpg',
      'https://images.all-free-download.com/images/graphiclarge/food_picture_03_hd_pictures_167556.jpg',
      'https://picturecorrect-wpengine.netdna-ssl.com/wp-content/uploads/2016/11/restaurant-food-photography-tips.jpg'
    ];
    restaurantlist.doc(date).set({
      'id': date,
      'name': name,
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
      'close_time':'11:30',
      'menu': menu,
      'reviews': []
    });
  }

}
