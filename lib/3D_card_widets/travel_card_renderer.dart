import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/card_tags.dart';
import 'demo_data.dart';
import 'styles.dart';

class TravelCardRenderer extends StatelessWidget {
  final double offset;
  final double cardWidth;
  final double cardHeight;
  // final City city;
  final  city;

  const TravelCardRenderer(this.offset,
      {Key key, this.cardWidth = 250, @required this.city, this.cardHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(top: 10),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[
          // Card background color & decoration

          Container(
            margin: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 10),
            decoration: BoxDecoration(
              color: Color(0xffdaf3f7),
              // color: city.color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4 * offset.abs()),
                BoxShadow(
                    color: Colors.black12, blurRadius: 10 + 6 * offset.abs()),
              ],
            ),
          ),
          // City image, out of card by 15px
          Positioned(top: -30, child: _buildCityImage()),
          // City information
          // _buildCityData(),
          Positioned(
            bottom: 30,
            left: 12,
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.WIDTH_14, vertical: Sizes.HEIGHT_8),
                child: Text(
                  'open'.toUpperCase(),
                  style: 'open'.toLowerCase() ==
                          StringConst.STATUS_OPEN.toLowerCase()
                      ? Styles.customNormalTextStyle(
                          color: AppColors.kFoodyBiteGreen,
                          fontSize: Sizes.TEXT_SIZE_10,
                          fontWeight: FontWeight.w700,
                        )
                      : Styles.customNormalTextStyle(
                          color: Colors.red,
                          fontSize: Sizes.TEXT_SIZE_10,
                          fontWeight: FontWeight.w700,
                        ),
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 30,
              right: 12,
              child: Card(
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes.WIDTH_8,
                    vertical: Sizes.WIDTH_4,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Image.asset(
                        ImagePath.starIcon,
                        height: Sizes.WIDTH_14,
                        width: Sizes.WIDTH_14,
                      ),
                      SizedBox(width: Sizes.WIDTH_4),
                      Text(
                        '4.2',
                        style: Styles.customTitleTextStyle(
                          color: AppColors.headingText,
                          fontWeight: FontWeight.w600,
                          fontSize: Sizes.TEXT_SIZE_14,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
       Positioned(
         bottom: 8,
         left: 0,
         right: 0,
         child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: Sizes.MARGIN_16,
                          vertical: Sizes.MARGIN_16,
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Rose, Farrington',
                                  textAlign: TextAlign.center,
                                  style:  GoogleFonts.dmSerifDisplay(textStyle:Styles.customTitleTextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Sizes.TEXT_SIZE_22,
                                  ),)
                                ),
                                // SizedBox(width: Sizes.WIDTH_4),
                                // CardTags(
                                //   title: 'Korean',
                                //   decoration: BoxDecoration(
                                //     gradient: Gradients.secondaryGradient,
                                //     boxShadow: [
                                //       Shadows.secondaryShadow,
                                //     ],
                                //     borderRadius: BorderRadius.all(
                                //       Radius.circular(100),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(width: 5.0),
                                // CardTags(
                                //   title: '3 km',
                                //   decoration: BoxDecoration(
                                //     // color: Color.fromARGB(255, 132, 141, 255),
                                //     color: AppColors.secondaryElement,
                                //     borderRadius: BorderRadius.all(
                                //         Radius.circular(100)),
                                //   ),
                                // ),
                                // Spacer(
                                //   flex: 1,
                                // ),
                                
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*0.5,
                                    // color: Colors.red,
                                    child: Text(
                                      'Roayal Avenue',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.openSans(textStyle:Styles.customNormalTextStyle(
                                        color: Colors.black54,
                                        fontSize: Sizes.TEXT_SIZE_14,
                                      ),)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
       ),
        ],
      ),
    );
  }

  Widget _buildCityImage() {
    double maxParallax = 30;
    double globalOffset = offset * maxParallax * 2;
    double cardPadding = 28;
    double containerWidth = cardWidth - cardPadding;
    return Container(
      height: cardHeight,
      width: containerWidth,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _buildPositionedLayer(
              "assets/demo_card/Budapest/Budapest-Back.png",
              containerWidth * .8,
              maxParallax * .1,
              globalOffset),
          _buildPositionedLayer(
              "assets/demo_card/Budapest/Budapest-Middle.png",
              containerWidth * .9,
              maxParallax * .6,
              globalOffset),
          _buildPositionedLayer(
              "assets/demo_card/Budapest/Budapest-Front.png",
              containerWidth * .7,
              maxParallax,
              globalOffset),
        ],
      ),
    );
  }

  Widget _buildCityData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // The sized box mock the space of the city image
        SizedBox(width: double.infinity, height: cardHeight * .57),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
        //   child: Text(city.title, style: Styles.cardTitle, textAlign: TextAlign.center),
        // ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
        //   child: Text(city.description, style: Styles.cardSubtitle, textAlign: TextAlign.center),
        // ),
        // Expanded(child: SizedBox(),),
        // FlatButton(
        //   disabledColor: Colors.transparent,
        //   color: Colors.transparent,
        //   child: Text('Learn More'.toUpperCase(), style: Styles.cardAction),
        //   onPressed: null,
        // ),
        SizedBox(height: 8)
      ],
    );
  }

  Widget _buildPositionedLayer(
      String path, double width, double maxOffset, double globalOffset) {
    double cardPadding = 24;
    double layerWidth = cardWidth - cardPadding;
    return Positioned(
        left: ((layerWidth * .5) - (width / 2) - offset * maxOffset) +
            globalOffset,
        bottom: cardHeight * .3,
        child: Image.asset(
          path,
          width: width,
          // package: 'potbelly',
        ));
  }
}
