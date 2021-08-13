import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class StepsScreen extends StatefulWidget {
  var data;
  StepsScreen({@required this.data});

  @override
  _StepsScreenState createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen>
    with SingleTickerProviderStateMixin {
  AutoScrollController _autoScrollController;
  bool lastStatus = true;
  bool isExpaned = true;

  @override
  void initState() {
    //  _tabcontroller.index=2;

    _autoScrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    )..addListener(_scrollListener2);
    super.initState();
  }

  @override
  void dispose() {
    if (_autoScrollController != null) {
      _autoScrollController.dispose();
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

  _buildSliverAppbar(context, heightOfStack, data) {
    return SliverAppBar(
      brightness: Brightness.light,
      pinned: true,
      floating: false,
      expandedHeight: 225,
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Step ' +
            (widget.data['stepno']+1).toString() +
            ' of ' +
            widget.data['steps'].length.toString(),
        style: TextStyle(color: _isShrink ? AppColors.black : AppColors.white),
      ),
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
                        imageUrl: data['image'],
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

  untensil() {
    print(widget.data);
      var untensils = widget.data['steps'][widget.data['stepno']]['utensils'];
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
          Text(toBeginningOfSentenceCase(untensils[i]['name']),
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


  ingredients() {
    var ingridient = widget.data['steps'][widget.data['stepno']]['ingridients'];
    var personselect= widget.data['person'];
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

  @override
  Widget build(BuildContext context) {
    var data = widget.data['steps'][widget.data['stepno']];
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
                widget.data['stepno']+1 == widget.data['steps'].length?'Finish' : 'Next Step',
                  buttonHeight: 45,
                  buttonWidth: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                      color: AppColors.secondaryElement,
                      borderRadius: BorderRadius.circular(10)),
                  buttonTextStyle:
                      TextStyle(color: AppColors.white, fontSize: 15),
                  onTap: () {
                  if(widget.data['stepno']+1 == widget.data['steps'].length){
                     print('last');
                     Navigator.pushNamed(context, AppRouter.Enjoy_Meal,arguments: {'recipe':widget.data['recipe']});
                   }
                   else{
                     Navigator.pushNamed(context, AppRouter.Steps_Screen,
                        arguments: {
                          'steps': widget.data['steps'],
                          'stepno': widget.data['stepno']+1
                        });
                   }
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
          _buildSliverAppbar(context, heightOfStack, data),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(data['description'],
                      textAlign: TextAlign.left,
                      style: Styles.customTitleTextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      )),
                  SizedBox(
                    height: 5,
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    thickness: 0.3,
                    color: Colors.black54,
                  ),
                  SizedBox(
                    height: 0,
                  ),

                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded:true,
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
                          child:  Column(
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
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: false,
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
                      children: <Widget>[Wrap(children: ingredients())],
                    ),
                  ),

                  // Divider(
                  //   thickness: 0.3,
                  //   color: Colors.black54,
                  // ),
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
