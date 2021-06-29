import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Promotion {
  final CollectionReference promotionlist =
  Firestore.instance.collection('Promotions');
  String _tempDir;
  File imapath;

  List promotiondata=[
    {
      'id': '0',
        'name': 'Subscription 1',
        'videoUrl': 'assets/p1.mp4',
        'thumbnailUrl': "assets/p1thum.png",
        'description':
            'What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing',
        "image": "",
        'createdAt': DateTime.now()
    },
    {
      'id': '1',
        'name': 'Subscription 2',
        'videoUrl': '',
        'thumbnailUrl': "",
        'description':
            'What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing',
        "image": "assets/p2.jpeg",
        'createdAt': DateTime.now()
    },
    {
      'id': '2',
        'name': 'Subscription 3',
        'videoUrl': 'assets/p5.mp4',
        'thumbnailUrl': "assets/p5thum.png",
        'description':
            'What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing',
        "image": "",
        'createdAt': DateTime.now()
    },
    {
      'id': '3',
        'name': 'Subscription 4',
        'videoUrl': '',
        'thumbnailUrl': "",
        'description':
            'What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing',
        "image": "assets/p3.jpeg",
        'createdAt': DateTime.now()
    },
    {
      'id': '4',
        'name': 'Subscription 5',
        'videoUrl': '',
        'thumbnailUrl': "",
        'description':
            'What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing',
        "image": "assets/p4.jpeg",
        'createdAt': DateTime.now()
    },
  ];

  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.mp4'; // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<File> writeToFile2(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.png'; // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  _getImage(videoPathUrl) async {
    try {
      final uint8list = await VideoThumbnail.thumbnailFile(
        thumbnailPath: _tempDir,
        video: videoPathUrl,
        imageFormat: ImageFormat.PNG,
        quality: 50,
        timeMs: 2000
      );

      imapath = File(uint8list);
      print(imapath);
    } catch (e) {
      // return name;
    }
  }

  Future<void> createDemoPromotions() async {
    // var date = DateTime.now().millisecondsSinceEpoch.toString();
    // for (var item in videolist) {
    //   promotionlist
    //       .document(DateTime.now().millisecondsSinceEpoch.toString())
    //       .setData({});
    // }
  }

  uploadvideopromotion(video, name) async {
    File file;
    var id = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      file = await writeToFile(video); // <= returns File
      _getImage(file.path);
      print(file);
      final StorageReference storageRef = FirebaseStorage.instance
          .ref()
          .child('videos/' + DateTime.now().toString());
      final StorageReference storageRef2 = FirebaseStorage.instance
          .ref()
          .child('images/' + DateTime.now().toString());
      StorageUploadTask uploadTask = storageRef.putFile(
        file,
        StorageMetadata(
          contentType: 'video/mp4',
        ),
      );
      StorageTaskSnapshot download = await uploadTask.onComplete;
      String url = await download.ref.getDownloadURL();
      StorageUploadTask uploadTask2 = storageRef2.putFile(
        imapath,
        StorageMetadata(
          contentType: 'image/jpg',
        ),
      );
      StorageTaskSnapshot download2 = await uploadTask2.onComplete;

      String url2 = await download2.ref.getDownloadURL();
      promotionlist.document(id).setData({
        'id': id,
        'name': name,
        'videoUrl': url,
        'thumbnailUrl': url2,
        'image': '',
        'description':
            'What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing',
        'createdAt': DateTime.now()
      });
    } catch (e) {
      // catch errors here
    }
  }

  uploadimagepromotion(video, name) async {
    File file;
    var id = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      file = await writeToFile2(video); // <= returns File
      print(file);
      final StorageReference storageRef = FirebaseStorage.instance
          .ref()
          .child('images/' + DateTime.now().toString());
      StorageUploadTask uploadTask = storageRef.putFile(
        file,
        StorageMetadata(
          contentType: 'image/png',
        ),
      );
      StorageTaskSnapshot download = await uploadTask.onComplete;
      String url = await download.ref.getDownloadURL();
      promotionlist.document(id).setData({
        'id': id,
        'name': name,
        'videoUrl': "",
        'thumbnailUrl': "",
        "image": url,
        'description':
            'What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing',
        'createdAt': DateTime.now()
      });
    } catch (e) {
      // catch errors here
    }
  }
}