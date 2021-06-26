import 'package:cloud_firestore/cloud_firestore.dart';

class Promotion {
  final CollectionReference Promotionlist =
      FirebaseFirestore.instance.collection('Promotions');

  Future<void> createDemoPromotions() {
    // var date = DateTime.now().millisecondsSinceEpoch.toString();

    List<Map<String, Object>> videolist = [
      {
        'id': "2",
        'name': "Elephant Dream",
        'videoUrl':
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        'thumbnailUrl':
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg",
        'createdAt': DateTime.now()
      },
      {
        'id': "3",
        'name': "Big Buck Bunny",
        'videoUrl':
            "",
        'thumbnailUrl':
            "",
          "image": 'https://media.architecturaldigest.in/wp-content/uploads/2020/04/Mumbai-restaurant-COVID-19-2-1.jpg',
        'createdAt': DateTime.now()
      },
      {
        'id': "4",
        'name': "For Bigger Blazes",
        'videoUrl':
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
        'thumbnailUrl':
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerBlazes.jpg",
        'createdAt': DateTime.now()
      }
    ];

    for (var item in videolist) {
      Promotionlist.doc(DateTime.now().millisecondsSinceEpoch.toString()).set(item);
    }
  }
}
