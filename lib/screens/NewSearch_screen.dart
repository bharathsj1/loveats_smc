import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:potbelly/models/restaurent_model.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';

class NewSearchScreen extends StatefulWidget {
  const NewSearchScreen({Key key}) : super(key: key);

  @override
  _NewSearchScreenState createState() => _NewSearchScreenState();
}

class _NewSearchScreenState extends State<NewSearchScreen> {
  TextEditingController searchController = TextEditingController();
  List categorieslist = [];
  List searchcategorieslist = [];
  List restaurantlist = [];
  List searchrestaurantlist = [];
  List itemlist = [];
  List searchitemlist = [];
  bool issearch = false;

  TextStyle subHeadingTextStyle = Styles.customTitleTextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w600,
    fontSize: Sizes.TEXT_SIZE_16,
  );
  TextStyle addressTextStyle = Styles.customNormalTextStyle(
    color: Colors.black54,
    fontSize: Sizes.TEXT_SIZE_14,
  );

  @override
  void initState() {
    getallitems();
    getRestaurent();
    categorieslist = [
      {
        'name': 'Korean',
      },
      {
        'name': 'Indian',
      },
      {
        'name': 'Italian',
      },
      {
        'name': 'Pakistani',
      },
    ];
    searchcategorieslist = categorieslist;
    super.initState();
  }

  getRestaurent() async {
    var response = await Service().getRestaurentsData();
    restaurantlist = response.data;
    searchrestaurantlist = response.data;
    setState(() {});
  }

  getallitems() async {
    var response = await AppService().getallitems();
    itemlist = response['data'];
    searchitemlist = response['data'];
    print(itemlist);
    // searchrestaurantlist = response.data;
    setState(() {});
  }

  searchfromlist() {
    categorieslist = searchcategorieslist
        .where((product) => product['name']
            .toLowerCase()
            .contains(searchController.text.toLowerCase()))
        .toList();
    restaurantlist = searchrestaurantlist
        .where((product) => product.restName
            .toLowerCase()
            .contains(searchController.text.toLowerCase()))
        .toList();
    itemlist = searchitemlist
        .where((product) => product['menu_name']
            .toLowerCase()
            .contains(searchController.text.toLowerCase()))
        .toList();
    setState(() {});
  }

  titlewidget(name) {
    return Material(
      elevation: 2,
      child: Container(
        color: AppColors.secondaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 2,
          vertical: Sizes.MARGIN_18,
        ),
        child: Row(
          children: <Widget>[
            // Icon(
            //   Icons.info_outline,
            //   color: AppColors.black.withOpacity(0.6),
            //   size: 18,
            // ),
            SizedBox(
              width: 20,
            ),
            Text(
              name,
              style: Theme.of(context).textTheme.title.copyWith(
                    fontSize: Sizes.TEXT_SIZE_18,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> catListTiles(context) {
    return List.generate(
        categorieslist.length,
        (i) => Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.black87,
                    size: 25,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    categorieslist[i]['name'],
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ));
  }

  List<Widget> restListTiles(context) {
    return List.generate(
      restaurantlist.length,
      (i) => Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, AppRouter.restaurantDetailsScreen,
                arguments: RestaurantDetails(
                    imagePath: restaurantlist[i].restImage,
                    restaurantName:
                        restaurantlist[i].restName,
                    restaurantAddress:
                        restaurantlist[i].restAddress +
                            restaurantlist[i].restCity +
                            ' ' +
                            restaurantlist[i].restCountry,
                    rating: '0.0',
                    category: restaurantlist[i].restType,
                    distance: '0 Km',
                    data: restaurantlist[i]));
          },
          child: ListTile(
            dense: true,
            leading: Padding(
              padding: EdgeInsets.only(left: 15),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    restaurantlist[i].restImage,
                    loadingBuilder: (BuildContext ctx, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Container(
                          // height: ,
                          margin: EdgeInsets.only(left: 15),
                          width: 50,
                          height: 80,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.secondaryElement),
                            ),
                          ),
                        );
                      }
                    },
                    fit: BoxFit.cover,
                    height: 80,
                    width: 50,
                  )),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  // color: Colors.red,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    restaurantlist[i].restName,
                    style: subHeadingTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    // Ratings(ratings[i]),
                  ],
                ),
              ],
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            subtitle: Column(
              children: [
                // Text(
                //   restaurantlist[i]['details'],
                //   style: addressTextStyle,
                //   maxLines: 2,
                //   overflow: TextOverflow.ellipsis,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        // width: MediaQuery.of(context).size.width*0.5,
                        // color: Colors.red,
                        child: Text(
                            '0.2 Miles away' + ' - \$' + '0.22' + ' Delivery',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                              textStyle: Styles.customNormalTextStyle(
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
        ),
      ),
    );
  }

  List<Widget> itemListTiles(context) {
    return List.generate(
      itemlist.length,
      (i) => Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: InkWell(
          onTap: () {
            var data =
                RestaurentsModel.fromJson({'data': [itemlist[i]['restaurant']],'success':true,'message':'ok'});
                print(data);
             Navigator.pushNamed(context, AppRouter.restaurantDetailsScreen,
                arguments: RestaurantDetails(
                    imagePath: itemlist[i]['restaurant']['rest_image'],
                    restaurantName: itemlist[i]['restaurant']
                        ['rest_name'],
                    restaurantAddress: itemlist[i]['restaurant']
                            ['rest_address'] +
                        itemlist[i]['restaurant']['rest_city'] +
                        ' ' +
                        itemlist[i]['restaurant']['rest_country'],
                    rating: '0.0',
                    category: itemlist[i]['restaurant']['rest_type'],
                    distance: '0 Km',
                    data: data.data[0] )); 
          },
          child: ListTile(
            dense: true,
            leading: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      itemlist[i]['menu_image'],
                      loadingBuilder: (BuildContext ctx, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Container(
                            // height: ,
                            margin: EdgeInsets.only(left: 15),
                            width: 60,
                            height: 140,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.secondaryElement),
                              ),
                            ),
                          );
                        }
                      },
                      fit: BoxFit.cover,
                      height: 140,
                      width: 60,
                    )),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  // color: Colors.red,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    itemlist[i]['menu_name'],
                    style: subHeadingTextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    // Ratings(ratings[i]),
                  ],
                ),
              ],
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 5),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 4,),
                Text(
                  '\$' +
                      itemlist[i]['menu_price'] +
                      ' - ' +
                      itemlist[i]['menu_details'],
                  style: addressTextStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('4.4' + ' Very good',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: Styles.customNormalTextStyle(
                            color: AppColors.secondaryElement,
                            fontSize: Sizes.TEXT_SIZE_14,
                          ),
                        )),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        // width: MediaQuery.of(context).size.width*0.5,
                        // color: Colors.red,

                        child: Text(' - 0.2 Miles away',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                              textStyle: Styles.customNormalTextStyle(
                                color: Colors.black54,
                                fontSize: Sizes.TEXT_SIZE_14,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                // Row(
                //               mainAxisAlignment: MainAxisAlignment.start,
                //               children: <Widget>[
                //                 Icon(
                //                   Icons.star,
                //                   color: AppColors.secondaryElement,
                //                   size: 16,
                //                 ),
                //                 Align(
                //                   alignment: Alignment.topLeft,
                //                   child: Container(
                //                     // width: MediaQuery.of(context).size.width*0.5,
                //                     // color: Colors.red,
                //                     child: Text(
                //                         '4.4' + ' Very good',
                //                         textAlign: TextAlign.center,
                //                         style: GoogleFonts.openSans(
                //                           textStyle:
                //                               Styles.customNormalTextStyle(
                //                             color: AppColors.secondaryElement,
                //                             fontSize: Sizes.TEXT_SIZE_14,
                //                           ),
                //                         )),
                //                   ),
                //                 ),
                //               ],
                //             ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        toolbarHeight: 60.0,
        title: TextField(
          controller: searchController,
          autofocus: true,
          cursorColor: Colors.grey,
          onChanged: (val) {
            if (searchController.text.trim() != '') {
              issearch = true;
            } else {
              issearch = false;
            }
            searchfromlist();
            setState(() {});
          },
          decoration: InputDecoration(
              hintText: "Dishes, Restaurants or Cuisines",
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(top: searchController.text != '' ? 15 : 0),
              suffixIcon: searchController.text != ''
                  ? IconButton(
                      icon: Icon(Icons.close),
                      color: Colors.grey,
                      onPressed: () {},
                    )
                  : null),
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: issearch
            ? Column(
                children: [
                  categorieslist.length != 0
                      ? titlewidget('Categories')
                      : Container(),
                  Column(
                    children: catListTiles(context),
                  ),
                  restaurantlist.length != 0
                      ? titlewidget('Restaurants')
                      : Container(),
                  Column(
                    children: restListTiles(context),
                  ),
                  itemlist.length != 0 ? titlewidget('Dishes') : Container(),
                  Column(
                    children: itemListTiles(context),
                  )
                ],
              )
            : Container(),
      ),
    );
  }
}
