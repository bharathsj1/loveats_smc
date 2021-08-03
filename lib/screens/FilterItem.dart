import 'package:flutter/material.dart';
import 'package:potbelly/values/values.dart';

class FilterItems extends StatefulWidget {
  var data;
  FilterItems({ @required this.data});

  @override
  _FilterItemsState createState() => _FilterItemsState();
}

class _FilterItemsState extends State<FilterItems> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          widget.data['name']+' Food',
          style: Styles.customTitleTextStyle(
            color: AppColors.secondaryElement,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.TEXT_SIZE_22,
          ),
        ),
      ),
    );
  }
}