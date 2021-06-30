import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage {
  File _image;

  Future<File> imgFromCamera() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);

    _image = File(image.path);
    return _image;
  }

  Future<File> imgFromGallery() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);

    _image = File(image.path);

    return _image;
  }
}
