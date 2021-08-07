import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/values/values.dart';

class EnjoyMeal extends StatefulWidget {
  var data;
  EnjoyMeal({@required this.data});

  @override
  _EnjoyMealState createState() => _EnjoyMealState();
}

class _EnjoyMealState extends State<EnjoyMeal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.secondaryElement,
        elevation: 0,
         title: Text(
        'Enjoy Your Meal!',
        style: TextStyle(color:AppColors.white),
      ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.white,
            
          ),
        ),
      ),
      body: Center(
        child: CachedNetworkImage(
                        imageUrl:
                           widget.data['recipe']['image'],
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 400,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.secondaryElement),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
      ),
    );
  }
}