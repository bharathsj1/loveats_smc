import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';

final List<String> images = [
  'assets/images/mainscreen.jpg',
  'assets/images/Slide1.jpg',
  'assets/images/Slide2.jpg',
  'assets/images/Slide3.jpg',
  'assets/images/Slide4.jpg',
];

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

final List child = map<Widget>(
  images,
  (index, i) {
    return Container(
      child: Image.asset(
        i,
        fit: BoxFit.cover,
        width: 1000,
      ),
    );
  },
).toList();

class PromotionPhotosScreen extends StatefulWidget {
  @override
  _PromotionPhotosScreenState createState() => _PromotionPhotosScreenState();
}

class _PromotionPhotosScreenState extends State<PromotionPhotosScreen> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kFoodyBiteDarkBackground,
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // SizedBox(
            //   height: 120,
            // ),
            Align(
              alignment: Alignment.center,
              child: CarouselSlider(
                  items: List.generate(
                      images.length,
                      (i) => Image.asset(
                            images[i],
                            fit: BoxFit.cover,
                            width: 1000,
                          )),
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height,
                    autoPlay: false,
                    enlargeCenterPage: false,
                    reverse: false,
                    enableInfiniteScroll: false,
                    scrollPhysics: BouncingScrollPhysics(),
                    viewportFraction: 1.0,
                    onPageChanged: (index, reaseon) {
                      setState(() {
                        _current = index;
                      });
                    },
                  )),
            ),
            //  Padding(
            //    padding: EdgeInsets.symmetric(horizontal: 20),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Text(
            //         'Trying to Join Netflix?',
            //         style: TextStyle(
            //           fontSize: 40,
            //           fontWeight: FontWeight.bold,
            //           color: AppColors.white
            //         ),
            //       ),
            //       SizedBox(
            //         height: 15,
            //       ),
            //       Text(
            //         'What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing. What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing',
            //         style: TextStyle(
            //           fontSize: 22,
            //           color: AppColors.secondaryElement,
            //           fontWeight: FontWeight.w500
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: map<Widget>(
                    images,
                    (index, url) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin:
                            EdgeInsets.symmetric(vertical: 16.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? AppColors.secondaryElement
                              : AppColors.kFoodyBiteUnselectedSliderDot,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 15,
              right: 15,
              child: PotbellyButton(
                StringConst.SUBSCRIPTION,

                onTap: (){
                   var data={
                                  'cartlist': null,
                                  'charges':0.0,
                                  'shipping':0.0,
                                  'total': 1,
                                  'type': 'promo'
                                };
                            AppRouter.navigator.pushNamed(
                              AppRouter.checkoutScreen, arguments: data
                            );
                },
              ),
            ),
            Positioned(
              top: 40,
              left: 15,
              
              child:  InkWell(
          onTap: () => AppRouter.navigator.pop(context),
          child: Image.asset(
            ImagePath.closeIcon,
            color: AppColors.primaryColor,
            height: 15,
            width: 15,
          ),
        ),
            ),
          ],
        ),
      ),
    );
  }
}
