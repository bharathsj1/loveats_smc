import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage {
  File _image;

  Future<File> imgFromCamera() async {
    PickedFile image = await ImagePicker().getImage(source: ImageSource.camera);

    _image = File(image.path);
    return _image;
  }

  Future<File> imgFromGallery() async {
    PickedFile image =
        await ImagePicker().getImage(source: ImageSource.gallery);

    _image = File(image.path);

    return _image;
  }
}
