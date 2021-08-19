import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';

class FilterSort extends StatefulWidget {
  bool sort;
  FilterSort({@required this.sort});

  @override
  _FilterSortState createState() => _FilterSortState();
}

class _FilterSortState extends State<FilterSort> {
  bool filteractive=true;
  bool loader=false;
  List restaurant=[];
  List mainfilters = [
    {'icon': OMIcons.sort, 'name': 'Distance','value':'distance', 'check': false},
    {'icon': OMIcons.fastfood, 'name': 'Ratings','value':'ratings', 'check': false},
    {'icon': OMIcons.localOffer, 'name': 'Recommended', 'value':'recommended','check': false},
    {'icon': OMIcons.healing, 'name': 'Time', 'value':'open_close','check': false},
    {'icon': OMIcons.healing, 'name': 'Top rated', 'value':'top_rated','check': false},
  ];

  List mainfilters2 = [
    // {'icon':OMIcons.sort,'name': 'Hygiene rating', 'check': false},
    {'icon': OMIcons.fastfood, 'name': 'Rating: 5', 'value':'5', 'check': false},
    {'icon': OMIcons.localOffer, 'name': 'Rating: 4', 'value':'4', 'check': false},
    {'icon': OMIcons.healing, 'name': 'Rating: 3', 'value':'3', 'check': false},
    {'icon': OMIcons.healing, 'name': 'Rating: 2', 'value':'2', 'check': false},
    {'icon': OMIcons.healing, 'name': 'Rating: 1', 'value':'1', 'check': false},
  ];

  var selected = 'recommended';

   filter(){
  setState(() {
    loader=true;
  });
   var data={
     'sort':  selected
   };
    AppService().getfilters(data).then((value) async {
      print(value);
      restaurant=value.data;
      loader=false;
    
      setState(() {
      });
      Navigator.pushNamed(context, AppRouter.Filtered_Restaurant,arguments: restaurant);
    });
 }

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
            widget.sort ? 'Sort' : 'Hygiene rating',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'roboto'),
          ),
        ),
      bottomNavigationBar : filteractive? Material(
              // elevation: 5,
              child: Container(
                color: AppColors.white,
                margin: EdgeInsets.only(top: 5),
                height: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0.0),
                      child:  loader
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.secondaryElement),
                            ),
                          ),
                        ): PotbellyButton(
                        'Filter',
                        onTap: ()  {
                        
                           filter();
                        },
                        buttonHeight: 45,
                        buttonWidth: MediaQuery.of(context).size.width * 0.85,
                        buttonTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColors.secondaryElement),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ): null,
        body: new Container(
            child:  Container(
                // height: MediaQuery.of(context).size.height / 1.2,
                color: Colors.white60,
                child: SingleChildScrollView(
                    child: Column(children: [
                  Container(
                    color: AppColors.secondaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.MARGIN_16,
                      vertical: Sizes.MARGIN_4,
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
                  widget.sort
                      ? SingleChildScrollView(
                          child: Column(
                              children: List.generate(
                                  mainfilters.length,
                                  (index) => Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      padding: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: AppColors.grey
                                                      .withOpacity(0.5)))),
                                      // color: Colors.red,
                                      child: RadioListTile(
                                        tileColor: AppColors.white,

                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Text(
                                              mainfilters[index]['name'],
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 17,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ),
                                        value: mainfilters[index]['value'],
                                        activeColor: AppColors.secondaryElement,
                                        //  selectedTileColor: Colors.red,
                                        contentPadding: EdgeInsets.all(0),
                                        // checkColor: AppColors.white,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selected = newValue;
                                          });
                                        },
                                        groupValue: selected,

                                        controlAffinity: ListTileControlAffinity
                                            .trailing, //  <-- leading Checkbox
                                      )))))
                      : SingleChildScrollView(
                          child: Column(
                              children: List.generate(
                            mainfilters2.length,
                            (index) => Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 0.5,
                                            color: AppColors.grey
                                                .withOpacity(0.5)))),
                                // color: Colors.red,
                                child: CheckboxListTile(
                                  tileColor: AppColors.white,

                                  title: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 2.0),
                                    child: Text(mainfilters2[index]['name'],
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 17,
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  value: mainfilters2[index]['check'],

                                  activeColor: AppColors.secondaryElement,
                                  //  selectedTileColor: Colors.red,
                                  contentPadding: EdgeInsets.all(0),
                                  checkColor: AppColors.white,
                                  onChanged: (newValue) {
                                    setState(() {
                                      mainfilters2[index]['check'] = newValue;
                                    });
                                  },

                                  // controlAffinity:
                                  //     ListTileControlAffinity.leading, //  <-- leading Checkbox
                                )),
                          )),
                        ),
                ])))));
  }
}
