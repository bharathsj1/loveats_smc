import 'package:flutter/material.dart';
import 'package:potbelly/values/values.dart';

class CircularIndicator extends StatelessWidget {
  const CircularIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
      ),
    );
  }
}
