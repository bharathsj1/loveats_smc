import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/values/values.dart';
import 'package:toast/toast.dart';

class Imagepicker {


  Future opencamera(BuildContext context) async {
    final image = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );
      if (image != null) {
        return image;
      
    }
  }

  Future opengallery(BuildContext context) async {
    final image = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
      if (image != null) {
        return image;
      }
      else{
         Toast.show("File is not selected", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
