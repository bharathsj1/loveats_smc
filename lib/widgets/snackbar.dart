import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message?? 'Some weird error occured'),
      backgroundColor:
          message.contains('successfully') ? Colors.green : Colors.red,
    ),
  );
}
