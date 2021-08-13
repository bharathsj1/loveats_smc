import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class RecipeDetails extends StatefulWidget {
  var data;
  RecipeDetails({@required this.data});

  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails>
    with SingleTickerProviderStateMixin {
  AutoScrollController _autoScrollController;
  TabController _tabcontroller;
  var recipedetails;
  bool lastStatus = true;
  bool isExpaned = true;
  bool loader = true;
  bool usersub = false;
  int personselect = 0;
  double delivery=5.0;
  List sublist=[];
  List persons = [
    {'name': '2', 'select': true},
    {'name': '4', 'select': false},
    {'name': '6', 'select': false},
  ];
  TabController _controller;

  @override
  void initState() {
    if(widget.data['usersub']){
    usersub=widget.data['usersub'];
    personselect= persons
        .indexWhere((p) => p['name']
            .contains(widget.data['subdata']['person_quantity']));
    print(personselect);
    persons[personselect]['select']=true;
    }
    setState(() {
      
    });
    getrecipes();
    getsub();
    _controller = new TabController(length: 2, vsync: this);
    //  _tabcontroller.index=2;

    _autoScrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    )..addListener(_scrollListener2);
    super.initState();
  }

  getrecipes() async {
    var response =
        await AppService().getrecipedetails(widget.data['recipe']['id'].toString());
    recipedetails = response['data'];
    print(response);
    loader = false;
    setState(() {});
  }
  getsub() async {
    var response =
        await AppService().getsublist();
    sublist = response['data'];
    print(sublist);
    for (var item in sublist) {
      if(item['product']['id']== 'prod_JzuaHXKP0rkKNJ'){
        print('avail');
        delivery=0.0;
        break;
      }
    }
    // loader = false;
    setState(() {});
  }

  @override
  void dispose() {
    if (_tabcontroller != null) {
      _tabcontroller.dispose();
    }
    super.dispose();
  }

  void _scrollListener2() {
    _isAppBarExpanded
        ? isExpaned != false
            ? setState(
                () {
                  isExpaned = false;
                  print('setState is called');
                },
              )
            : {}
        : isExpaned != true
            ? setState(() {
                print('setState is called');
                isExpaned = true;
              })
            : {};
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isAppBarExpanded {
    return _autoScrollController.hasClients &&
        _autoScrollController.offset > (160 - kToolbarHeight);
  }

  bool get _isShrink {
    return _autoScrollController.hasClients &&
        _autoScrollController.offset > (250 - kToolbarHeight);
  }

  _buildSliverAppbar(context, heightOfStack) {
    return SliverAppBar(
      brightness: Brightness.light,
      pinned: true,
      floating: false,
      expandedHeight: 225,
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: _isShrink ? Text('Recipe Details') : null,
      leading: InkWell(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: const EdgeInsets.only(
            left: Sizes.MARGIN_16,
            right: Sizes.MARGIN_16,
          ),
          child: Image.asset(
            ImagePath.arrowBackIcon,
            color: _isShrink ? AppColors.black : AppColors.white,
          ),
        ),
      ),
      //  pinned: true,
      actions: [
        // InkWell(
        //   child: Icon(
        //     FeatherIcons.share2,
        //     size: 20,
        //     color: _isShrink ? AppColors.black : Colors.white,
        //   ),
        // ),
        //  Spacer(flex: 1),
        SizedBox(
          width: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: InkWell(
            onTap: () {},
            child: Icon(Icons.favorite_border_outlined,
                color: _isShrink ? AppColors.black : Colors.white),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        titlePadding: EdgeInsets.zero,
        background: Column(
          // shrinkWrap: true,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 250,
                    child: Hero(
                      tag: 'recipe',
                      child: CachedNetworkImage(
                        imageUrl:
                           widget.data['recipe']['image'],
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 150,
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  personlist() {
    return List.generate(
        persons.length,
        (i) => InkWell(
              onTap:usersub?null: () {
                for (var item in persons) {
                  item['select'] = false;
                }
                persons[i]['select'] = true;
                personselect = i;

                setState(() {});
              },
              child: Opacity(
                opacity: usersub && i!=personselect? 0.3:1,
                child: Container(
                  decoration: BoxDecoration(
                      color: persons[i]['select']
                          ? AppColors.secondaryElement
                          : usersub?Colors.grey.shade400: null,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 0.2, color: Colors.black54)),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  child: Row(
                    children: [
                      Text(persons[i]['name'],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            textStyle: Styles.customNormalTextStyle(
                              color: persons[i]['select']
                                  ? AppColors.white
                                  : Colors.black54,
                              fontSize: Sizes.TEXT_SIZE_20,
                            ),
                          )),
                      persons[i]['select']
                          ? Text(' Person',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                textStyle: Styles.customNormalTextStyle(
                                  color: persons[i]['select']
                                      ? AppColors.white
                                      : Colors.black54,
                                  fontSize: Sizes.TEXT_SIZE_16,
                                ),
                              ))
                          : Container(),
                    ],
                  ),
                ),
              ),
            ));
  }

  List ingridient = [
    {
      'name': 'Fresh Mozzarella',
      'quantity': '1 balls',
      'image':
          'https://cdn.shopify.com/s/files/1/0431/8104/7971/products/Untitleddesign_7_e9e122ed-a160-44a0-8433-88a75278ecbf_600x.png?v=1612381148',
    },
    {
      'name': 'Fresh Mozzarella',
      'quantity': '1 balls',
      'image':
          'https://cdn.shopify.com/s/files/1/0431/8104/7971/products/Untitleddesign_7_e9e122ed-a160-44a0-8433-88a75278ecbf_600x.png?v=1612381148',
    },
    {
      'name': 'Fresh Mozzarella',
      'quantity': '1 balls',
      'image':
          'https://cdn.shopify.com/s/files/1/0431/8104/7971/products/Untitleddesign_7_e9e122ed-a160-44a0-8433-88a75278ecbf_600x.png?v=1612381148',
    },
    {
      'name': 'Fresh Mozzarella',
      'quantity': '1 balls',
      'image':
          'https://cdn.shopify.com/s/files/1/0431/8104/7971/products/Untitleddesign_7_e9e122ed-a160-44a0-8433-88a75278ecbf_600x.png?v=1612381148',
    },
  ];

  List steps = [
    {
      'image':
          'https://socarratnyc.com/wp-content/uploads/2020/01/jamon-serrano-iberico.jpg',
      'details':
          'a) Drain and tinly slice mozzarella. b) Roughly tear the serrano ham',
      'untensils': ['Knife', 'Cutting board'],
      'ingredients': [
        {
          'name': 'Fresh Mozzarella',
          'quantity': '1 balls',
          'image':
              'https://cdn.shopify.com/s/files/1/0431/8104/7971/products/Untitleddesign_7_e9e122ed-a160-44a0-8433-88a75278ecbf_600x.png?v=1612381148',
        },
        {
          'name': 'Serrano ham',
          'quantity': '3 Slice',
          'image':
              'https://cdn.shopify.com/s/files/1/0431/8104/7971/products/Untitleddesign_7_e9e122ed-a160-44a0-8433-88a75278ecbf_600x.png?v=1612381148',
        }
      ]
    },
    {
      'image':
          'https://www.greenqueen.com.hk/wp-content/uploads/2020/12/rollito-vegano1.jpg',
      'details':
          'a) Drain and tinly slice mozzarella. b) Roughly tear the serrano ham',
      'untensils': ['Knife', 'Cutting board'],
      'ingredients': [
        {
          'name': 'Fresh Mozzarella',
          'quantity': '1 balls',
          'image':
              'https://cdn.shopify.com/s/files/1/0431/8104/7971/products/Untitleddesign_7_e9e122ed-a160-44a0-8433-88a75278ecbf_600x.png?v=1612381148',
        },
        {
          'name': 'Serrano ham',
          'quantity': '3 Slice',
          'image':
              'https://cdn.shopify.com/s/files/1/0431/8104/7971/products/Untitleddesign_7_e9e122ed-a160-44a0-8433-88a75278ecbf_600x.png?v=1612381148',
        }
      ]
    },
    {
      'image':
          'https://image.shutterstock.com/image-photo/traditional-spanish-jamon-serrano-ham-260nw-1111050764.jpg',
      'details':
          'a) Drain and tinly slice mozzarella. b) Roughly tear the serrano ham',
      'untensils': ['Knife', 'Cutting board'],
      'ingredients': [
        {
          'name': 'Fresh Mozzarella',
          'quantity': '1 balls',
          'image':
              'https://cdn.shopify.com/s/files/1/0431/8104/7971/products/Untitleddesign_7_e9e122ed-a160-44a0-8433-88a75278ecbf_600x.png?v=1612381148',
        },
        {
          'name': 'Serrano ham',
          'quantity': '3 Slice',
          'image':
              'https://cdn.shopify.com/s/files/1/0431/8104/7971/products/Untitleddesign_7_e9e122ed-a160-44a0-8433-88a75278ecbf_600x.png?v=1612381148',
        }
      ]
    }
  ];

  ingredients() {
    var ingridient = recipedetails['data'];
    var twoper = persons[personselect]['name'] == '2' ? true : false;
    var fourper = persons[personselect]['name'] == '4' ? true : false;
    var sizper = persons[personselect]['name'] == '6' ? true : false;
    return List.generate(
        ingridient.length,
        (i) => Container(
              width: MediaQuery.of(context).size.width / 2.2,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: AppColors.secondaryElement, width: 1.5)),
                        padding: EdgeInsets.all(4),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: ingridient[i]['ingridient']['image'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              // height: 150,

                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.secondaryElement),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                      (personselect == 1
                              ? ingridient[i]['three_person_quantity']
                              : personselect == 2
                                  ? ingridient[i]['four_person_quantity']
                                  : ingridient[i]['two_person_quantity']) +
                          ' ' +
                          ingridient[i]['ingridient']['unit'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        textStyle: Styles.customNormalTextStyle(
                          color: Colors.black54,
                          fontSize: Sizes.TEXT_SIZE_14,
                        ),
                      )),
                  Text(ingridient[i]['ingridient']['name'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        textStyle: Styles.customNormalTextStyle(
                          color: Colors.black,
                          fontSize: Sizes.TEXT_SIZE_14,
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ));
  }

  nutrationperserve() {
    var nutration = recipedetails['nutrition'][0]['perServing'];
    return List.generate(
        nutration.length,
        (i) => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(toBeginningOfSentenceCase(nutration[i]['title']),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: Styles.customNormalTextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: Sizes.TEXT_SIZE_14,
                          ),
                        )),
                    Text(nutration[i]['value'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: Styles.customNormalTextStyle(
                            color: Colors.black54,
                            fontSize: Sizes.TEXT_SIZE_14,
                          ),
                        )),
                  ],
                ),
              nutration.length == i+1?  Container(): Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                Divider(
                  thickness: 0.3,
                  color: Colors.black54,
                ),
                SizedBox(
                  height: 5,
                ),
                  ],
                ),
              ],
            ));
  }

  nutrationnotperserve() {
    var nutration = recipedetails['nutrition'][0]['notPerServing'];
   return List.generate(
        nutration.length,
        (i) => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(toBeginningOfSentenceCase(nutration[i]['title']),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: Styles.customNormalTextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: Sizes.TEXT_SIZE_14,
                          ),
                        )),
                    Text(nutration[i]['value'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: Styles.customNormalTextStyle(
                            color: Colors.black54,
                            fontSize: Sizes.TEXT_SIZE_14,
                          ),
                        )),
                  ],
                ),
              nutration.length == i+1?  Container(): Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                Divider(
                  thickness: 0.3,
                  color: Colors.black54,
                ),
                SizedBox(
                  height: 5,
                ),
                  ],
                ),
              ],
            ));
  }

  untensil() {
      var untensils = recipedetails['utensils'];
   return List.generate(
        untensils.length,
        (i) =>  Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(
              Icons.circle,
              size: 5,
              color: AppColors.secondaryElement,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Text(toBeginningOfSentenceCase(untensils[i]),
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                textStyle: Styles.customNormalTextStyle(
                  color: Colors.black,
                  fontSize: Sizes.TEXT_SIZE_14,
                ),
              )),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var heightOfStack = MediaQuery.of(context).size.height / 2.8;
    return Scaffold(
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
                  'Buy Ingredients (' +
                      persons[personselect]['name'] +
                      ')'.toUpperCase(),
                  buttonHeight: 45,
                  buttonWidth: MediaQuery.of(context).size.width / 2.2,
                  decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(10)),
                  buttonTextStyle:
                      TextStyle(color: AppColors.white, fontSize: 14),
                  onTap: () {

                    Navigator.pushNamed(context, AppRouter.Buy_Ingredients,arguments: {'usersub':usersub,'recipe':widget.data['recipe'],'ingredients':recipedetails['data'],'person':personselect,'delivery':delivery});
                  },
                ),
              ),
              Center(
                child: PotbellyButton(
                  'Start Cooking'.toUpperCase(),
                  buttonHeight: 45,
                  buttonWidth: MediaQuery.of(context).size.width / 2.2,
                  decoration: BoxDecoration(
                      color: AppColors.secondaryElement,
                      borderRadius: BorderRadius.circular(10)),
                  buttonTextStyle:
                      TextStyle(color: AppColors.white, fontSize: 14),
                  onTap: () {
                      var steps = recipedetails['steps'];
                    Navigator.pushNamed(context, AppRouter.Steps_Screen,
                        arguments: {'recipe':widget.data['recipe'],'steps': steps, 'stepno': 0,'person':personselect});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _autoScrollController,
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          _buildSliverAppbar(context, heightOfStack),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(toBeginningOfSentenceCase(widget.data['recipe']['title']),
                      textAlign: TextAlign.left,
                      style: Styles.customTitleTextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Text(widget.data['recipe']['short_description'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        textStyle: Styles.customNormalTextStyle(
                          color: Colors.black54,
                          fontSize: Sizes.TEXT_SIZE_14,
                        ),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(widget.data['recipe']['total_time'] + ' prep',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.openSans(
                                  textStyle: Styles.customNormalTextStyle(
                                    color: Colors.black54,
                                    fontSize: Sizes.TEXT_SIZE_14,
                                  ),
                                )),

                        SizedBox(
                          width: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: VerticalDivider(
                            thickness: 1,
                            width: 10,
                            color: Colors.black54,
                          ),
                        ),
                        Text('Serves ' + persons[personselect]['name'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                              textStyle: Styles.customNormalTextStyle(
                                color: Colors.black54,
                                fontSize: Sizes.TEXT_SIZE_14,
                              ),
                            )),
                        SizedBox(
                          width: 2,
                        ),
                                                  ],
                        ),
                     usersub?   Center(
                child: PotbellyButton(
                  'View as non-subscriber',
                  buttonHeight: 30,
                  buttonWidth: 120,
                  decoration: BoxDecoration(
                      color: AppColors.secondaryElement,
                      borderRadius: BorderRadius.circular(4)),
                  buttonTextStyle:
                      TextStyle(color: AppColors.white, fontSize: 12),
                  onTap: () {
                   usersub=false;
                   setState(() {
                     
                   });
                  },
                ),
              ):Container(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    thickness: 0.3,
                    color: Colors.black54,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(widget.data['recipe']['total_time'],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                textStyle: Styles.customNormalTextStyle(
                                  color: Colors.black54,
                                  fontSize: Sizes.TEXT_SIZE_14,
                                ),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Total',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                textStyle: Styles.customNormalTextStyle(
                                  color: Colors.black,
                                  fontSize: Sizes.TEXT_SIZE_14,
                                ),
                              )),
                        ],
                      ),
                      Column(
                        children: [
                          Text(widget.data['recipe']['calories'],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                textStyle: Styles.customNormalTextStyle(
                                  color: Colors.black54,
                                  fontSize: Sizes.TEXT_SIZE_14,
                                ),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Calories (KCal)',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                textStyle: Styles.customNormalTextStyle(
                                  color: Colors.black,
                                  fontSize: Sizes.TEXT_SIZE_14,
                                ),
                              )),
                        ],
                      ),
                      Column(
                        children: [
                          Text(widget.data['recipe']['difficulty'],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                textStyle: Styles.customNormalTextStyle(
                                  color: Colors.black54,
                                  fontSize: Sizes.TEXT_SIZE_14,
                                ),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Difficulty',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                textStyle: Styles.customNormalTextStyle(
                                  color: Colors.black,
                                  fontSize: Sizes.TEXT_SIZE_14,
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  loader
                      ? Container()
                      : Divider(
                          thickness: 0.3,
                          color: Colors.black54,
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  loader
                      ? Container()
                      : Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            tilePadding: EdgeInsets.symmetric(horizontal: 10),
                            title: Text(
                              'Ingredients',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black),
                            ),
                            iconColor: AppColors.black,
                            collapsedIconColor: AppColors.black,
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: personlist()),
                              SizedBox(
                                height: 20,
                              ),
                              Wrap(children: ingredients())
                            ],
                          ),
                        ),
                  loader
                      ? Container()
                      : Divider(
                          thickness: 0.3,
                          color: Colors.black54,
                        ),
                  loader
                      ? Container()
                      : Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            initiallyExpanded: false,
                            tilePadding: EdgeInsets.symmetric(horizontal: 10),
                            title: Text(
                              'Nutrition Values',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black),
                            ),
                            iconColor: AppColors.black,
                            collapsedIconColor: AppColors.black,
                            children: <Widget>[
                              new Container(
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                    color: Theme.of(context).primaryColor),
                                child: new TabBar(
                                  controller: _controller,
                                  isScrollable: true,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  labelPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  labelStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFc9c9c9),
                                      fontWeight: FontWeight.w600),
                                  indicator: UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                        color: AppColors.secondaryElement,
                                        width: 2.0),
                                    // insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0),
                                  ),
                                  unselectedLabelColor: Color(0xFFc9c9c9),
                                  unselectedLabelStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFFc9c9c9),
                                      fontWeight: FontWeight.normal),
                                  tabs: [
                                    new Tab(
                                      // icon: const Icon(Icons.home),
                                      text: 'Per Serving',
                                    ),
                                    new Tab(
                                      // icon: const Icon(Icons.my_location),
                                      text: 'per 100g',
                                    ),
                                  ],
                                ),
                              ),
                              new Container(
                                height: 43.0 *
                                    recipedetails['nutrition'][0]['perServing']
                                        .length,
                                child: new TabBarView(
                                  controller: _controller,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Column(
                                          children: nutrationperserve(),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15.0),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: nutrationnotperserve(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                  loader
                      ? Container()
                      : Divider(
                          thickness: 0.3,
                          color: Colors.black54,
                        ),
                 loader
                      ?  Container():  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: false,
                      tilePadding: EdgeInsets.symmetric(horizontal: 10),
                      title: Text(
                        'Untensils',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black),
                      ),
                      iconColor: AppColors.black,
                      collapsedIconColor: AppColors.black,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: untensil(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.3,
                    color: Colors.black54,
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ])),
        ],
      ),
    );
  }
}
