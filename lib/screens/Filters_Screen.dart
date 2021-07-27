import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';
import 'package:skeleton_text/skeleton_text.dart';

class NewFilterScreen extends StatefulWidget {
  const NewFilterScreen({ Key key }) : super(key: key);

  @override
  _NewFilterScreenState createState() => _NewFilterScreenState();
}

class _NewFilterScreenState extends State<NewFilterScreen> {
 bool loader=true;
  List categories=[];
 @override
 void initState(){
   getcats();
   super.initState();
 }

 getcats() async {
   var data= await AppService().filtercats();
   print(data);
   for (var item in data['data']) {
     categories.add({
       'id': item['id'],
       'name': item['menu_name'],
       'image': item['menu_type_image'],
       'check': false
     });
   }
  //  categories=data['data'];
  loader=false;
   setState(() {});
 }

  loading() {
    return List.generate(
        5,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical:2.0,horizontal: 5),
          child: SkeletonAnimation(
            // shimmerDuration: 1500,

                borderRadius: BorderRadius.circular(0.0),
                shimmerColor: Colors.grey.shade300,
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width*0.95,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.0),
                      color: Colors.grey[200]),
                ),
              ),
        ));
  }

  //  List toppings = [
  //   {'name': 'Anchovies', 'check': false},
  //   {'name': 'Basil', 'check': false},
  //   {'name': 'Black Olives', 'check': false},
  //   {'name': 'Extra Cheese', 'check': false},
  //   {'name': 'Garlic Butter', 'check': false},
  //   {'name': 'Green Papers', 'check': false},
  //   {'name': 'Jalapenos', 'check': false},
  //   {'name': 'Mushrooms', 'check': false},
  //   {'name': 'Spicy Beef', 'check': false},
  // ];

  List mainfilters = [
    {'icon':OMIcons.sort,'name': 'Sort', 'check': false},
    {'icon':OMIcons.fastfood,'name': 'Hygiene rating', 'check': false},
    {'icon':OMIcons.localOffer,'name': 'Offers', 'check': false},
    // {'icon':OMIcons.healing,'name': 'Dietary', 'check': false},
  ];
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: ImageIcon(
           AssetImage(ImagePath.arrowBackIcon),
          //  image: Image.asset( ImagePath.arrowBackIcon,),
            color: AppColors.secondaryElement,
          ),
        ),
        title: Text(
          'Filters',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'roboto'),
        ),
        // actions: [
        //   InkWell(
        //       onTap: () {
        //         // Map<String, dynamic> cartdata = {
        //         //   'id': data['id'],
        //         //   'restaurantId':
        //         //       data['restaurantId'],
        //         //   'image': data['image'],
        //         //   'details': data['details'],
        //         //   'name': data['name'],
        //         //   'price': data['price'],
        //         //   'payableAmount':
        //         //       data['price'].toString(),
        //         //   'qty': data['qty'],
        //         //   'data': data,
        //         //   'restaurantdata': widget
        //         //       .restaurantDetails.data,
        //         //   'topping': toppings
        //         //       .where((product) =>
        //         //           product['check'] ==
        //         //           true)
        //         //       .toList(),
        //         //   'drink': mainfilters
        //         //       .where((product) =>
        //         //           product['check'] ==
        //         //           true)
        //         //       .toList()
        //         // };
        //         // print(data['qty']);
        //         // CartProvider()
        //         //     .addToCart(context, cartdata);
        //         // if (fooditems[index]['cart'] !=
        //         //         null &&
        //         //     fooditems[index]['cart'] ==
        //         //         true) {
        //         //   var qtyy = int.parse(
        //         //       fooditems[index]['qty2']);
        //         //   qtyy++;
        //         //   fooditems[index]['qty2'] =
        //         //       qtyy.toString();
        //         // } else {
        //         //   fooditems[index]['qty2'] =
        //         //       fooditems[index]['qty'];
        //         // }

        //         // fooditems[index]['cart'] = true;
        //         // print(fooditems[index]);
        //         // Navigator.pop(context);
        //         // setState(() {});
        //         Navigator.pop(context);
        //       },
        //       child: Container(
        //           child: Icon(
        //         Icons.check,
        //         color: AppColors.secondaryElement,
        //       ))),
        //   SizedBox(
        //     width: 15,
        //   )
        // ],
      ),
      body: new Container(
        child: Container(
          // height: MediaQuery.of(context).size.height / 1.2,
          color: Colors.white60,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: AppColors.secondaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.MARGIN_16,
                    vertical: Sizes.MARGIN_8,
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "",
                        style: textTheme.title.copyWith(
                          fontSize: Sizes.TEXT_SIZE_16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.indigoShade1,
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                      children: List.generate(
                    mainfilters.length,
                    (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        padding: EdgeInsets.zero,
                        // color: Colors.red,
                        child: InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, AppRouter.Filter_SortScreen,arguments: index == 0? true:false);
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child:Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Row(
                                  children: [
                                    Icon(mainfilters[index]['icon'],color: Colors.black54,),
                                    SizedBox(width: 20,),
                                    Text(mainfilters[index]['name'],
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 17,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                            ),
                            ),
                        ),
                        ),
                        // child: CheckboxListTile(
                        //   tileColor: AppColors.white,
                        //   title: Padding(
                        //     padding: const EdgeInsets.only(top: 2.0),
                        //     child: Row(
                        //       children: [
                        //         Icon(mainfilters[index]['icon']),
                        //         SizedBox(width: 10,),
                        //         Text(mainfilters[index]['name'],
                        //             style: TextStyle(
                        //                 color: Colors.black54,
                        //                 fontSize: 17,
                        //                 fontWeight: FontWeight.normal)),
                        //       ],
                        //     ),
                        //   ),
                        //   value: mainfilters[index]['check'],

                        //   activeColor: AppColors.secondaryElement,
                        //   //  selectedTileColor: Colors.red,
                        //   contentPadding: EdgeInsets.all(0),
                        //   checkColor: AppColors.white,
                        //   onChanged: (newValue) {
                        //     setState(() {
                        //       mainfilters[index]['check'] = newValue;
                        //     });
                        //   },

                        //   // controlAffinity:
                        //   //     ListTileControlAffinity.leading, //  <-- leading Checkbox
                        // )
                        
                  )),
                ),
             loader? Column(children: loading(),):   Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: AppColors.secondaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.MARGIN_16,
                        vertical: Sizes.MARGIN_16,
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Categories",
                            style: textTheme.title.copyWith(
                              fontSize: Sizes.TEXT_SIZE_16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.indigoShade1,
                            ),
                          ),
                        ],
                      ),
                    ),

                SingleChildScrollView(
                  child: Column(
                      children: List.generate(
                    categories.length,
                    (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.5,color: AppColors.grey.withOpacity(0.5)))
                        ),
                        // color: Colors.red,
                        child: CheckboxListTile(
                          tileColor: AppColors.white,
                         
                          title: Row(
                            children: [
                              //  Image.network(categories[index]['image'],height: 60,width: 60,fit: BoxFit.cover,),
                              ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          categories[index]['image'],
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Container(
                                // height: ,
                                width: 40,
                                height: 37,
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
                          height: 37,
                          width: 40,
                        )),
                               SizedBox(width: 10,),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(categories[index]['name'],
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 17,
                                        fontWeight: FontWeight.normal)),
                              ),
                            ],
                          ),
                          value: categories[index]['check'],
                    
                          activeColor: AppColors.secondaryElement,
                          //  selectedTileColor: Colors.red,
                          contentPadding: EdgeInsets.all(0),
                          checkColor: AppColors.white,
                          onChanged: (newValue) {
                            setState(() {
                              categories[index]['check'] = newValue;
                            });
                          },
                    
                          // controlAffinity:
                          //     ListTileControlAffinity.leading, //  <-- leading Checkbox
                        )),
                  )),
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
}