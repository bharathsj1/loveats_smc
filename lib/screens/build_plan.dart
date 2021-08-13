import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';

class BuildPlan extends StatefulWidget {
  var data;
   BuildPlan({@required this.data});

  @override
  _BuildPlanState createState() => _BuildPlanState();
}

class _BuildPlanState extends State<BuildPlan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        centerTitle: false,
        backgroundColor: AppColors.secondaryElement,
        iconTheme: IconThemeData(color: AppColors.white),
        title: Text(
          'Eat better. Every Day.',
          style: Styles.customTitleTextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.TEXT_SIZE_18,
          ),
        ),
        actions: [ Center(
          child: Padding(
            padding: const EdgeInsets.only(right:10.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRouter.Recipes_list,arguments:{'recipe':widget.data['recipe'],'usersub':false,} );
                                    
              },
              child: Container(
                child: Text(
                  'Skip',
                  style: Styles.customTitleTextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: Sizes.TEXT_SIZE_18,
                  ),
                ),
              ),
            ),
          ),
        ),],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Container(
          height: 60,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: PotbellyButton(
                  'Build Your Plan',
                  buttonHeight: 45,
                  buttonWidth: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                      color: AppColors.secondaryElement,
                      borderRadius: BorderRadius.circular(10)),
                  buttonTextStyle:
                      TextStyle(color: AppColors.white, fontSize: 15),
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.Buy_New_Plan);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Welcome to',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black),
            ),
             SizedBox(
              height: 5,
            ),
            Image.asset('assets/images/newlogo.png', height: 80, width: 140,fit: BoxFit.fill,),
             SizedBox(
              height: 5,
            ),
            Image.asset(
              //  'assets/loginvideo2.gif',
              'assets/recipe1.gif',
              fit: BoxFit.fill,
              height: 200,
              width: MediaQuery.of(context).size.width,
              filterQuality: FilterQuality.high,
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0),
              child: Text(
                'Free Ingredients and easy to follow recipes, straight to your doorstep.',
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
