import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potbelly/values/values.dart';

class FilterSort extends StatefulWidget {
  bool sort;
  FilterSort({@required this.sort});

  @override
  _FilterSortState createState() => _FilterSortState();
}

class _FilterSortState extends State<FilterSort> {
  List mainfilters = [
    {'icon': OMIcons.sort, 'name': 'Distance', 'check': false},
    {'icon': OMIcons.fastfood, 'name': 'Hygiene ratings', 'check': false},
    {'icon': OMIcons.localOffer, 'name': 'Recommended', 'check': false},
    {'icon': OMIcons.healing, 'name': 'Time', 'check': false},
    {'icon': OMIcons.healing, 'name': 'Top rated', 'check': false},
  ];

  List mainfilters2 = [
    // {'icon':OMIcons.sort,'name': 'Hygiene rating', 'check': false},
    {'icon': OMIcons.fastfood, 'name': 'Hygiene rating: 5', 'check': false},
    {'icon': OMIcons.localOffer, 'name': 'Hygiene rating: 4', 'check': false},
    {'icon': OMIcons.healing, 'name': 'Hygiene rating: 3', 'check': false},
    {'icon': OMIcons.healing, 'name': 'Hygiene rating: 2', 'check': false},
  ];

  var selected = 'Recommended';

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
                                        value: mainfilters[index]['name'],
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
