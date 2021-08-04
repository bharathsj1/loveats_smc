import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potbelly/models/restaurent_model.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FilterItems extends StatefulWidget {
  var data;
  FilterItems({@required this.data});

  @override
  _FilterItemsState createState() => _FilterItemsState();
}

class _FilterItemsState extends State<FilterItems> {
  List items = [];
  bool loader = true;
  bool itemended = false;
  int currentindex = 0;
  ScrollController _sc = new ScrollController();

  @override
  void initState() {
    if (widget.data['cat']) {
      getcatitem();
    } else {
      getitems();
    }
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData();
        // print('here');
      }
    });
    super.initState();
  }

  _getMoreData() {
    if (!itemended) {
      if (items.length > currentindex) {
        if (items.length >= currentindex + 10) {
          currentindex = currentindex + 10;
        } else {
          currentindex = items.length;
          itemended = true;
        }
      } else {
        currentindex = items.length;
        itemended = true;
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  getitems() async {
    var response = await AppService().getitems({'item_type': 'delivery'});
    items = response['data'];
    if (items.length >= 10) {
      currentindex = 10;
    } else {
      currentindex = items.length;
      itemended = true;
    }
    print(items);
    loader = false;
    setState(() {});
  }

  getcatitem() async {
    var response =
        await AppService().getcatitems(widget.data['catid'].toString());
    items = response['data'];
    if (items.length >= 10) {
      currentindex = 10;
    } else {
      currentindex = items.length;
      itemended = true;
    }
    print(items);
    loader = false;
    setState(() {});
  }

  popular() {
    return List.generate(
        currentindex,
        (i) => InkWell(
              onTap: () {
                // Navigator.pushNamed(
                //   context,
                //   AppRouter.HotspotsDetailsScreen,
                //   arguments: RestaurantDetails(
                //       imagePath: hotspotlist[i]['image'],
                //       restaurantName: hotspotlist[i]['name'],
                //       restaurantAddress: hotspotlist[i]['address'],
                //       // rating: hotspotlist[i]['rating'],
                //       rating: '3.2',
                //       category: '',
                //       distance: hotspotlist[i]['distance'] + ' Km',
                //       data: hotspotlist[i]),
                // );
                var data = RestaurentsModel.fromJson({
                  'data': [items[i]['restaurant']],
                  'success': true,
                  'message': 'ok'
                });
                print(items[i]['restaurant']);
                Navigator.pushNamed(context, AppRouter.Add_Extra, arguments: {
                  'update': false,
                  'item': items[i],
                  // 'restaurant': widget.restaurantDetails.data
                  'restaurant': data.data[0]
                });
              },
              child: Container(
                height: 270,
                width: MediaQuery.of(context).size.width / 1,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6)),
                            child:
                                //  items[i]['menu_image']
                                //             .substring(0, 4) ==
                                //         'http'
                                //     ?
                                // Image.network(
                                //     items[i]['menu_image'],
                                //     loadingBuilder: (BuildContext ctx,
                                //         Widget child,
                                //         ImageChunkEvent loadingProgress) {
                                //       if (loadingProgress == null) {
                                //         return child;
                                //       } else {
                                //         return Container(
                                //           height: 150,
                                //           child: Center(
                                //             child: CircularProgressIndicator(
                                //               valueColor:
                                //                   AlwaysStoppedAnimation<Color>(
                                //                       AppColors
                                //                           .secondaryElement),
                                //             ),
                                //           ),
                                //         );
                                //       }
                                //     },
                                //     width: MediaQuery.of(context).size.width,
                                //     height: 150,
                                //     fit: BoxFit.cover,
                                //   )
                                CachedNetworkImage(
                              imageUrl: items[i]['menu_image'],
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                              fit: BoxFit.cover,
                              // imageBuilder: (context, imageProvider) =>
                              //     Container(
                              //   decoration: BoxDecoration(
                              //     image: DecorationImage(
                              //         image: imageProvider,
                              //         fit: BoxFit.cover,
                              //         colorFilter: ColorFilter.mode(
                              //             Colors.red, BlendMode.colorBurn)),
                              //   ),
                              // ),
                              placeholder: (context, url) => Container(
                                height: 150,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.secondaryElement),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            // : Image.asset(
                            //     items[i]['menu_image'],
                            //     width: MediaQuery.of(context).size.width,
                            //     height: 150,
                            //     fit: BoxFit.cover,
                            //   ),
                          ),
                          Positioned(
                              right: 5,
                              bottom: 5,
                              child: Container(
                                width: 90,
                                padding: EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text('15 - 20\nMins',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                      textStyle: Styles.customNormalTextStyle(
                                        color: AppColors.white,
                                        fontSize: Sizes.TEXT_SIZE_12,
                                      ),
                                    )),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(items[i]['menu_name'],
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSerifDisplay(
                                  textStyle: Styles.customTitleTextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Sizes.TEXT_SIZE_22,
                                  ),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  color: AppColors.secondaryElement,
                                  size: 16,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    // width: MediaQuery.of(context).size.width*0.5,
                                    // color: Colors.red,
                                    child: Text('4.4' + ' Very good',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle:
                                              Styles.customNormalTextStyle(
                                            color: AppColors.secondaryElement,
                                            fontSize: Sizes.TEXT_SIZE_14,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    // width: MediaQuery.of(context).size.width*0.5,
                                    // color: Colors.red,
                                    child: Text(
                                        items[i]['restaurant']['rest_address'] +
                                            ' (500+)',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle:
                                              Styles.customNormalTextStyle(
                                            color: Colors.black54,
                                            fontSize: Sizes.TEXT_SIZE_14,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    // width: MediaQuery.of(context).size.width*0.5,
                                    // color: Colors.red,
                                    child: Text(
                                        // hotlist[i]['distance'] +
                                        '${StringConst.currency}' +
                                            items[i]['menu_price'],
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle:
                                              Styles.customNormalTextStyle(
                                            color: Colors.black54,
                                            fontSize: Sizes.TEXT_SIZE_14,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        title: Text(
          widget.data['name'] + ' Food',
          style: Styles.customTitleTextStyle(
            color: AppColors.secondaryElement,
            fontWeight: FontWeight.w600,
            fontSize: Sizes.TEXT_SIZE_22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _sc,
        physics: BouncingScrollPhysics(),
        // scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Column(
            children: popular(),
          ),
        ),
      ),
    );
  }
}
