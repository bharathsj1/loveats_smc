import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/ServiceProvider.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/cartservice.dart';
import 'package:potbelly/services/paymentservice.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/custom_text_form_field.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:place_picker/place_picker.dart';
import 'package:potbelly/widgets/spaces.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class CheckOutScreen1 extends StatefulWidget {
  var checkoutdata;
  CheckOutScreen1({@required this.checkoutdata});

  @override
  _CheckOutScreen1State createState() => _CheckOutScreen1State();
}

class _CheckOutScreen1State extends State<CheckOutScreen1> {
  int page = 1;
  var selectedaddress = 0;
  final nameController = TextEditingController();
  final phoneNoController = TextEditingController();
  String selected_address = '';
  String selected_city = '';
  String selected_country = '';
  String selected_lat = '';
  String selected_long = '';
  bool loader = true;
  bool loader2 = true;
  bool loader3 = false;
  bool isError = false;
  bool marketing = false;
  var selectedcard;
  var _paymentSheetData;
  final _formKey = GlobalKey<FormState>();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  LatLng _initialcameraposition;
  // GoogleMapController _controller;
  final Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller;

  @override
  void initState() {
    _controller = Completer();
    getaddress();
    print(widget.checkoutdata['total']);
    getsavedcards();
    super.initState();
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    // _controller = _cntlr;


    _controller.complete(_cntlr);
    // _location.onLocationChanged.listen((l) {
    //   _controller.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
    //       ),
    //   );
    // });
  }

  createmaps(lat, long) {
    _initialcameraposition = LatLng(lat, long);
    setState(() {});

    setState(() {
      // add marker on the position
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(123.toString()),
        position: _initialcameraposition,
        infoWindow: InfoWindow(
            // title is the address
            // title: 'Customer Address',
            // snippet are the coordinates of the position
            // snippet:
            //     widget.desdirection['address'],
            ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      loader = false;
    });
  }

  getaddress() async {
    var respo = await AppService().getaddress();
    print(respo);
    myaddress = respo['data'];
    if (respo['data'].length > 0) {
      createmaps(double.parse(myaddress[0]['user_latitude']),
          double.parse(myaddress[0]['user_longitude']));
    } else {
      loader = false;
    }
    setState(() {});
  }

  getsavedcards() async {
    var respo = await AppService().getallmethod();
    print(respo);

    mycards = respo['data']['data'];
    if (mycards.length > 0) {
      // selectedcard = mycards[0]['id'];
      selectedcard = 0;
    }
    loader2 = false;
    setState(() {});
  }

  getuser() {}

  nameValidator(String value) {
    if (value.isEmpty)
      return 'Name field is required';
    else if (value.length < 3) return 'Please enter valid name';
  }

  phoneValidator(String value) {
    if (value.isEmpty)
      return 'Phone number is required';
    else if (value.length < 10) return 'Invalid Phone Number';
  }

  List mycards = [];
  List myaddress = [];

  void updatePinOnMap(lat, long) async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: 15,
      target: LatLng(lat, long),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    if (mounted) {
      setState(() {
        // updated position
        var pinPosition = LatLng(lat, long);

        // the trick is to remove the marker (by id)
        // and add it again at the updated location
        // _markers.removeWhere((m) => m.markerId.value == 123.toString());
        _markers.clear();
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(lat.toString()),
          position: pinPosition,
          infoWindow: InfoWindow(
              // title is the address
              // title: 'Customer Address',
              // snippet are the coordinates of the position
              // snippet:
              //     widget.desdirection['address'],
              ),
          icon: BitmapDescriptor.defaultMarker,
        ));
        setState(() {});
      });
    }
  }

  showPlacePicker(context,pop) async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              "AIzaSyCkoLh9yZhcAtP9R-KsP90JaqFiooRuEmg",
              displayLocation: LatLng(53.4083714, -2.991572600000012),
            )));

    // Handle the result in your way
    if (result != null) {
      print(result.latLng);
      selected_address = result.formattedAddress;
      selected_city = result.city.name;
      selected_country = result.country.name;
      selected_lat = result.latLng.latitude.toString();
      selected_long = result.latLng.longitude.toString();
      if(pop){
      Navigator.pop(context);
      }
      bottomSheetForLocation(context);
    }
  }

  bottomSheetForLocation(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        // backgroundColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
          return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Add New Address',
                                style: Styles.customNormalTextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () {
                                  if (_formKey.currentState.validate()) {
                                    FocusScope.of(context).unfocus();
                  
                                    // loader = true;
                                    setState(() {});
                                    var data = {
                                      'name': nameController.text,
                                      'phone_no': phoneNoController.text,
                                      'latitude': selected_lat.toString(),
                                      'longitude': selected_long.toString(),
                                      'address': selected_address,
                                      'city': selected_city,
                                      'country': selected_country,
                                      'address_type': 'Other',
                                    };
                                    AppService().setaddress(data).then((value) {
                                      print(value);
                                      myaddress.add(value['data']);
                                      if(_controller.isCompleted){
                                          updatePinOnMap(
            double.parse(myaddress[selectedaddress]['user_latitude']),
            double.parse(myaddress[selectedaddress]['user_longitude']));
                                      }else{
                                        print('here');
                                        createmaps(double.parse(myaddress[myaddress.length-1]['user_latitude']),
                                        double.parse(myaddress[myaddress.length-1]['user_longitude']));
                                        // selectedaddress=myaddress.length-1;
                                        // print(selectedaddress);
                                      }
                                      loader = false;
                                      setState(() {});
                                         Navigator.of(context).pop();
                                    this.nameController.text = '';
                                    this.phoneNoController.text = '';
                                    });
                                 
                                    // Toast.show('New Address added', context,
                                    //     duration: 3);
                  
                                  }
                                },
                                child: Container(
                                  height: 30,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: AppColors.secondaryElement,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: Text(
                                      'Add',
                                      style: Styles.customNormalTextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: CustomTextFormField(
                            hasPrefixIcon: true,
                            textEditingController: nameController,
                            prefixIcon: Icons.person_outline,
                            hintText: StringConst.HINT_TEXT_NAME,
                            borderColor: AppColors.green,
                            borderWidth: 2,
                            enabledBorderColor: AppColors.grey,
                            hintTextStyle: TextStyle(color: AppColors.grey),
                            focusedBorderColor: AppColors.grey,
                            prefixIconColor: AppColors.secondaryElement,
                            // fillColor: AppColors.grey.withOpacity(0.4),
                            borderStyle: BorderStyle.solid,
                            textFormFieldStyle: TextStyle(color: AppColors.grey),
                            function: nameValidator,
                          ),
                        ),
                        SpaceH16(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: CustomTextFormField(
                            hasPrefixIcon: true,
                            textEditingController: phoneNoController,
                            
                            // prefixIconImagePath: ImagePath.personIcon,
                            prefixIcon: Icons.phone_outlined,
                            hintText: StringConst.HINT_TEXT_PHONE_NO,
                            borderColor: AppColors.green,
                            borderWidth: 2,
                            enabledBorderColor: AppColors.grey,
                            hintTextStyle: TextStyle(color: AppColors.grey),
                            focusedBorderColor: AppColors.grey,
                            prefixIconColor: AppColors.secondaryElement,
                            textFormFieldStyle: TextStyle(color: AppColors.grey),
                            // fillColor: AppColors.grey.withOpacity(0.4),
                            borderStyle: BorderStyle.solid,
                            keyboardtype: TextInputType.phone,
                            function: phoneValidator,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // InkWell(
                        //   onTap: () =>
                        //       AppRouter.navigator.pushNamed(AppRouter.googleMap),
                        //   child: Row(
                        //     children: [
                        //       Icon(Icons.location_searching, size: 12.0),
                        //       SizedBox(
                        //         width: 5.0,
                        //       ),
                        //       Text('Use current location',
                        //           style: Styles.customNormalTextStyle(
                        //               color: Colors.indigo)),
                        //     ],
                        //   ),
                        // ),
                        Divider(),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'Selected Address',
                          style: Styles.customNormalTextStyle(color: Colors.black),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.place_outlined,
                            color: AppColors.secondaryElement,
                          ),
                          title: Text('Other'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          subtitle: Text(selected_address +
                              ' ' +
                              selected_city +
                              ' ' +
                              selected_country),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget createrow(color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              Icon(
                Icons.radio_button_checked_rounded,
                color: color,
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 100,
                // color: Colors.red,
                child: Row(
                  children: List.generate(
                      200 ~/ 10,
                      (index) => Expanded(
                            child: Container(
                              color: index % 2 == 0
                                  ? Colors.transparent
                                  : Colors.grey,
                              height: 2,
                            ),
                          )),
                ),
              ),
            ],
          ),
        ),
        // SizedBox(
        //   height: 5,
        // ),
        // Text(
        //   'Delivery address',
        //   style: TextStyle(color: AppColors.secondaryElement, fontSize: 12),
        // ),
      ],
    );
  }

  List<Widget> addresscard() {
    return List.generate(
        myaddress.length,
        (index) => InkWell(
              onTap: () {
                setState(() {
                  selectedaddress = index;
                });
              },
              child: Container(
                // elevation: 0,
                // shape: RoundedRectangleBorder(
                //   side: BorderSide(
                //       color: selectedaddress == index
                //           ? AppColors.secondaryElement
                //           : AppColors.grey,
                //       width: selectedaddress == index ? 1 : 0),
                //   borderRadius: BorderRadius.circular(10),
                // ),
                color: selectedaddress == index
                    ? AppColors.secondaryElement.withOpacity(0.2)
                    : null,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                myaddress[index]['address_type'] == 'Work'
                                    ? Icons.work_outline_outlined
                                    : Icons.place_outlined,
                                color: selectedaddress == index
                                    ? AppColors.secondaryElement
                                    : AppColors.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                myaddress[index]['address_type'],
                                style: TextStyle(
                                    color: selectedaddress == index
                                        ? AppColors.secondaryElement
                                        : AppColors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'roboto'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              index == 0
                                  ? Container(
                                      height: 20,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColors.secondaryElement,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Default',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.white,
                                            fontFamily: 'roboto'),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                          selectedaddress == index
                              ? Icon(
                                  Icons.check_circle_outline,
                                  color: AppColors.secondaryElement,
                                )
                              : Container()
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        myaddress[index]['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppColors.black,
                            fontFamily: 'roboto'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        myaddress[index]['phone_no'],
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppColors.black,
                            fontFamily: 'roboto'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        myaddress[index]['address'] +
                            ' ' +
                            myaddress[index]['city'] +
                            ', ' +
                            myaddress[index]['country'],
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black54,
                            fontFamily: 'roboto'),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  changelocation(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        // backgroundColor: Colors.black54,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mysetState) {
            return SingleChildScrollView(
                child: Column(
              children: [
                Column(
                    children: List.generate(
                        myaddress.length,
                        (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            padding: EdgeInsets.zero,
                            // decoration: BoxDecoration(
                            //     border: Border(
                            //         bottom: BorderSide(
                            //             width: 0.5,
                            //             color: AppColors.grey.withOpacity(0.5)))),
                            // color: Colors.red,
                            child: RadioListTile(
                              tileColor: AppColors.white,

                              title: Row(
                                children: [
                                  Icon(
                                    Icons.place_outlined,
                                    color: AppColors.grey,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(myaddress[index]['address'],
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal)),
                                  ),
                                ],
                              ),
                              value: index,
                              activeColor: AppColors.secondaryElement,
                              //  selectedTileColor: Colors.red,
                              contentPadding: EdgeInsets.all(0),
                              // checkColor: AppColors.white,
                              onChanged: (newValue) {
                                mysetState(() {
                                  selectedaddress = newValue;
                                });
                                setState(() {});
                              },
                              groupValue: selectedaddress,

                              controlAffinity: ListTileControlAffinity
                                  .trailing, //  <-- leading Checkbox
                            )))),
                Center(
                  child: InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                      showPlacePicker(context,true);

                    },
                    child: Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          // border: Border.all(color: Colors.grey, width: 0),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.place_outlined,
                            color: AppColors.secondaryElement,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Add a new address',
                            style: TextStyle(
                                color: AppColors.secondaryElement,
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                                fontFamily: 'roboto'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ));
          });
        }).whenComplete(() {
      setState(() {
        print(selectedaddress);
        updatePinOnMap(
            double.parse(myaddress[selectedaddress]['user_latitude']),
            double.parse(myaddress[selectedaddress]['user_longitude']));
      });
    });
  }

  buyrecipe() async {
    setState(() {
      loader3 = true;
    });
    var orderId = '';
    if (widget.checkoutdata['usersub']) {
      var packdata = {
        'total_amount': widget.checkoutdata['total_amount'],
        'payment_method': widget.checkoutdata['payment_method'],
        'is_receipe': widget.checkoutdata['is_receipe'],
        'method_id': widget.checkoutdata['method_id'],
        'user_id': int.parse(widget.checkoutdata['user_id']),
        'customer_id': int.parse(widget.checkoutdata['user_id']),
        'payment_id': widget.checkoutdata['payment_id'],
        'customer_addressId': myaddress[selectedaddress]['id'],
        'is_subscribed_user': widget.checkoutdata['is_subscribed_user'],
        'receipe_id': widget.checkoutdata['receipe_id'],
        'sub_total': widget.checkoutdata['sub_total'],
        'delivery_free': widget.checkoutdata['shipping'],
        'service_fee': widget.checkoutdata['charges'],
        'quantity': '1',
        'person_quantity': widget.checkoutdata['person'] == 1
            ? '4'
            : widget.checkoutdata['person'] == 2
                ? '6'
                : '2',
        // 'receipe_id': widget
        //     .checkoutdata['packlist'][i]['id']
      };
      print(packdata);
      AppService().addeorder(packdata).then((value) {
        orderId = value['data']['id'].toString();
        print(value);
        var data = {
          'title': 'Order Placed',
          'body': 'You can track you order in order history section',
          // 'data': value.toString(),
          'user_id': int.parse(widget.checkoutdata['user_id'])
        };
        AppService().sendnotispecificuser(data);
        loader3 = false;
          Provider.of<ServiceProvider>(context, listen: false).getsubdata(context);
        Navigator.pushNamed(context, AppRouter.CheckOut3,
            arguments: {'type': 'recipe', 'orderId': orderId});
      });
      setState(() {});
    } else {
      var data2 = {
        'amount': (double.parse(widget.checkoutdata['total_amount']).floor())
                .toString() +
            '00',
        'currency': 'usd',
        'customer': mycards[selectedcard]['customer']
        // 'receipt_email': 'miansaadhafeez@gmail.com'
      };
      await PaymentService().getIntent(data2).then((value) async {
        print(value);
        _paymentSheetData = value;
        print(_paymentSheetData['client_secret']);
        print(mycards[selectedcard]['customer']);
        setState(() {});
        var resp = await Stripe.instance.confirmPayment(
            _paymentSheetData['client_secret'],
            PaymentMethodParams.cardFromMethodId(
                paymentMethodId: mycards[selectedcard]['id'].toString(),
                cvc: '123'));

        if (resp.status == PaymentIntentsStatus.Succeeded) {
          var packdata = {
            'total_amount': widget.checkoutdata['total_amount'],
            'payment_method': 'card',
            'is_receipe': widget.checkoutdata['is_receipe'],
            'method_id': mycards[selectedcard]['id'].toString(),
            'payment_id': _paymentSheetData['id'],
            'user_id': int.parse(widget.checkoutdata['user_id']),
            'customer_addressId': myaddress[selectedaddress]['id'],
            'is_subscribed_user': widget.checkoutdata['is_subscribed_user'],
            'receipe_id': widget.checkoutdata['receipe_id'],
            'sub_total': widget.checkoutdata['sub_total'],
            'delivery_free': widget.checkoutdata['shipping'],
            'service_fee': widget.checkoutdata['charges'],
            'quantity': '1',
            'person_quantity': widget.checkoutdata['person'] == 1
                ? '4'
                : widget.checkoutdata['person'] == 2
                    ? '6'
                    : '2',
            // 'person_quantity': person ==1? '4':person==2?'6':'2',
            // 'receipe_id': widget
            //     .checkoutdata['packlist'][i]['id']
          };
          print(packdata);
          AppService().addeorder(packdata).then((value) {
            orderId = value['data']['id'].toString();
            print(value);
            var data = {
              'title': 'Order Placed',
              'body': 'You can track you order in order history section',
              // 'data': value.toString(),
              'user_id': int.parse(widget.checkoutdata['user_id'])
            };
            AppService().sendnotispecificuser(data);
            loader3 = false;
              Provider.of<ServiceProvider>(context, listen: false).getsubdata(context);
            Navigator.pushNamed(context, AppRouter.CheckOut3,
                arguments: {'type': 'recipe', 'orderId': orderId});
          });
          setState(() {});
        } else {
          Toast.show('Payment Failed', context, duration: 3);
        }
      });
    }
  }

  buycartitem(payment_id, method_id) {
    setState(() {
      loader3 = true;
    });
    print('here');
    var orderId = '';
    if (widget.checkoutdata['mixmatch'] == true) {
      // var packdata = {
      //   'total_amount': widget.checkoutdata['total_amount'],
      //   'payment_method': widget.checkoutdata['payment_method'],
      //   'is_receipe': widget.checkoutdata['is_receipe'],
      //   'method_id': widget.checkoutdata['method_id'],
      //   'user_id': int.parse(widget.checkoutdata['user_id']),
      //   'customer_id': int.parse(widget.checkoutdata['user_id']),
      //   'payment_id': widget.checkoutdata['payment_id'],
      //   'customer_addressId': myaddress[selectedaddress]['id'],
      //   'is_subscribed_user': widget.checkoutdata['is_subscribed_user'],
      //   'receipe_id': widget.checkoutdata['receipe_id'],
      //   'quantity':'1',
      //   'person_quantity': widget.checkoutdata['person'] ==1? '4':widget.checkoutdata['person']==2?'6':'2',
      //   // 'receipe_id': widget
      //   //     .checkoutdata['packlist'][i]['id']
      // };
      var data = {
        'total_amount': widget.checkoutdata['total'],
        'payment_method': 'card',
        'is_receipe': 0,
        'method_id': method_id,
        'payment_id': payment_id,
        'user_id': int.parse(widget.checkoutdata['user_id']),
        'customer_id': int.parse(widget.checkoutdata['user_id']),
        'customer_addressId': myaddress[selectedaddress]['id'],
        'is_subscribed_user': widget.checkoutdata['usersub'] ? 1 : 0,
        'sub_total': widget.checkoutdata['sub_total'],
        'delivery_free': widget.checkoutdata['shipping'],
        'service_fee': widget.checkoutdata['charges'],
        'tip_more': widget.checkoutdata['tip_more'],
        'rider_tip': widget.checkoutdata['rider_tip'],
        'restaurent_tip': widget.checkoutdata['restaurent_tip'],
        'cutlery': widget.checkoutdata['cutlery'],
        // 'receipe_id': null,
        // 'quantity':'0',
        // 'person_quantity': '0',
      };
      AppService().addeorder(data).then((value) {
        orderId = value['data']['id'];
        print(value);
        for (var i = 0; i < widget.checkoutdata['cartlist'].length; i++) {
          for (var j = 0; j < widget.checkoutdata['cartlist'][i].length; j++) {
            print(widget.checkoutdata['cartlist'][i][j]);
            var data2 = {
              'quantity': widget.checkoutdata['cartlist'][i][j]['qty'],
              'total_price': widget.checkoutdata['cartlist'][i][j]
                  ['payableAmount'],
              'order_id': value['data']['id'],
              'rest_menuId': widget.checkoutdata['cartlist'][i][j]['id'],
              'rest_Id': widget.checkoutdata['cartlist'][i][j]['restaurantId'],
            };
            AppService().addorderdetails(data2).then((value) {
              print(value);
              if (i == widget.checkoutdata['cartlist'].length - 1 &&
                  j == widget.checkoutdata['cartlist'][i].length - 1) {
                var data = {
                  'title': 'New Order',
                  'body': 'User has been placed a new order',
                  'data': value.toString(),
                  //  ''
                };
                var notidata = {
                  'title': 'Order Placed',
                  'body': 'You can track you order in order history section',
                  // 'data': value.toString(),
                  'user_id': int.parse(widget.checkoutdata['user_id'])
                };
                AppService().sendnotispecificuser(notidata);
                AppService().sendnotisuperadmin(data);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                this.loader3 = false;

                setState(() {});
                  Provider.of<ServiceProvider>(context, listen: false).getsubdata(context);
                Navigator.pushNamed(context, AppRouter.CheckOut3, arguments: {
                  'type': widget.checkoutdata['type'],
                  'orderId': orderId
                });
              }
            });
          }
        }
        //    AppRouter.navigator.pushNamed(AppRouter.CheckOut3, arguments: {
        //   'type': widget.checkoutdata['type'],
        //   'orderId': orderId
        // });
      });
    } else {
      for (var i = 0; i < widget.checkoutdata['cartlist'].length; i++) {
        var data = {
          'total_amount': widget.checkoutdata['total'],
          'payment_method': 'card',
          'is_receipe': 0,
          'method_id': method_id,
          'payment_id': payment_id,
          'user_id': int.parse(widget.checkoutdata['user_id']),
          'customer_id': int.parse(widget.checkoutdata['user_id']),
          'customer_addressId': myaddress[selectedaddress]['id'],
          'is_subscribed_user': widget.checkoutdata['usersub'] ? 1 : 0,
          'sub_total': widget.checkoutdata['sub_total'],
          'delivery_free': widget.checkoutdata['shipping'],
          'service_fee': widget.checkoutdata['charges'],
          'tip_more': widget.checkoutdata['tip_more'],
          'rider_tip': widget.checkoutdata['rider_tip'],
          'restaurent_tip': widget.checkoutdata['restaurent_tip'],
          'cutlery': widget.checkoutdata['cutlery'],
          // 'receipe_id': null,
          // 'quantity':'0',
          // 'person_quantity': '0',
        };
        AppService().addeorder(data).then((value) {
          orderId = value['data']['id'].toString();
          print(orderId);
          for (var j = 0; j < widget.checkoutdata['cartlist'][i].length; j++) {
            print(widget.checkoutdata['cartlist'][i][j]);
            var data2 = {
              'quantity': widget.checkoutdata['cartlist'][i][j]['qty'],
              'total_price': widget.checkoutdata['cartlist'][i][j]
                  ['payableAmount'],
              'order_id': value['data']['id'],
              'rest_menuId': widget.checkoutdata['cartlist'][i][j]['id'],
              'rest_Id': widget.checkoutdata['cartlist'][i][j]['restaurantId'],
            };
            AppService().addorderdetails(data2).then((value) async {
              print(value);
              if (i == widget.checkoutdata['cartlist'].length - 1 &&
                  j == widget.checkoutdata['cartlist'][i].length - 1) {
                // this.loader3 = false;
                var data = {
                  'title': 'New Order',
                  'body': 'User has been placed a new order',
                  'data': value.toString(),
                };
                var notidata = {
                  'title': 'Order Placed',
                  'body': 'You can track you order in order history section',
                  // 'data': value.toString(),
                  'user_id': int.parse(widget.checkoutdata['user_id'])
                };
                AppService().sendnotispecificuser(notidata);
                AppService().sendnotisuperadmin(data);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                this.loader3 = false;
                await CartProvider().clearcart();
                Provider.of<CartProvider>(context, listen: false).getcartslist();
                setState(() {});
                Navigator.pushNamed(context, AppRouter.CheckOut3, arguments: {
                  'type': widget.checkoutdata['type'],
                  'orderId': orderId
                });
              }
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            ImagePath.arrowBackIcon,
            color: AppColors.black,
          ),
        ),
        // centerTitle: true,
        title: Text(
          'Checkout',
          style: Styles.customTitleTextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: Sizes.TEXT_SIZE_16,
          ),
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 5,
        child: Container(
          color: AppColors.white,
          margin: EdgeInsets.only(top: 5),
          height: 90,
          child: Column(
            children: [
              SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text(
                        widget.checkoutdata['recipe'] == true
                            ? '${StringConst.currency}' +
                                widget.checkoutdata['total_amount']
                            : '${StringConst.currency}' +
                                widget.checkoutdata['total'].toStringAsFixed(2),
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loader3
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.secondaryElement),
                            ),
                          ),
                        )
                      : PotbellyButton(
                          'Proceed to payment',
                          onTap: () async {
                            if (widget.checkoutdata['recipe']) {
                              if (myaddress.length != 0) {
                                print('if');
                                buyrecipe();
                              } else {
                                Toast.show('Add address to continue', context,
                                    duration: 3);
                              }
                            } else {
                              if (myaddress.length != 0 &&
                                  selectedcard != null) {
                                loader3 = true;
                                setState(() {});

                                // var data = {
                                //   'cartlist': widget.checkoutdata['cartlist'],
                                //   'charges': widget.checkoutdata['charges'],
                                //   'shipping': widget.checkoutdata['shipping'],
                                //   'total': widget.checkoutdata['total'],
                                //   'type': widget.checkoutdata['type'],
                                //   'mixmatch': widget.checkoutdata['mixmatch'],
                                //   'customer_addressId': myaddress[selectedaddress]
                                //       ['id'],
                                //   'addressId': selectedaddress
                                // };
                                if (widget.checkoutdata['total'] <= 0) {
                                  buycartitem('Free Subscription Meal','Free Subscription Meal');
                                } else {
                                  var data2 = {
                                    'amount':
                                        (widget.checkoutdata['total'].floor())
                                                .toString() +
                                            '00',
                                    'currency': 'usd',
                                    'customer': mycards[selectedcard]
                                        ['customer']
                                    // 'receipt_email': 'miansaadhafeez@gmail.com'
                                  };
                                  await PaymentService()
                                      .getIntent(data2)
                                      .then((value) async {
                                    print(value);
                                    _paymentSheetData = value;
                                    print(_paymentSheetData['client_secret']);
                                    print(mycards[selectedcard]['customer']);
                                    setState(() {});
                                    var resp = await Stripe.instance
                                        .confirmPayment(
                                            _paymentSheetData['client_secret'],
                                            PaymentMethodParams
                                                .cardFromMethodId(
                                                    paymentMethodId:
                                                        mycards[selectedcard]
                                                                ['id']
                                                            .toString(),
                                                    cvc: '123'));

                                    if (resp.status ==
                                        PaymentIntentsStatus.Succeeded) {
                                      print('else');
                                      buycartitem(
                                          _paymentSheetData['client_secret'],
                                          mycards[selectedcard]['id']
                                              .toString());
                                    }
                                  });
                                }

                                
                                
                                // var respo = await Stripe.instance.presentPaymentSheet(
                                //     parameters: PresentPaymentSheetParameters(
                                //       confirmPayment: true,
                                //         clientSecret:
                                //             _paymentSheetData['client_secret']));
                                //             print(respo);
                                // Navigator.pushNamed(context, AppRouter.CheckOut2,
                                //     arguments: data);

                              } else {
                                if(myaddress.length == 0){

                                Toast.show('Add address to continue', context,
                                    duration: 3);
                                }
                                else{
                                   Toast.show('Add payment method to continue', context,
                                    duration: 3);
                                }
                              }
                            }
                          },
                          buttonHeight: 45,
                          buttonWidth: MediaQuery.of(context).size.width * 0.89,
                          buttonTextStyle: TextStyle(
                              fontSize: 18,
                              fontFamily: 'roboto',
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: myaddress.length != 0
                                  ? AppColors.secondaryElement
                                  : AppColors.grey),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Material(
            //   elevation: 0.5,
            //   child: Container(
            //     height: 60,
            //     color: AppColors.white,
            //     // padding: EdgeInsets.only(top: 12),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         createrow(AppColors.secondaryElement),
            //         Container(
            //             margin: EdgeInsets.only(left: 5),
            //             child: createrow(Colors.grey)),
            //         SizedBox(
            //           width: 8,
            //         ),
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.only(left: 5.0),
            //               child: Row(
            //                 children: [
            //                   Icon(
            //                     Icons.radio_button_checked_rounded,
            //                     color: Colors.grey,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             // SizedBox(
            //             //   height: 5,
            //             // ),
            //             // Text(
            //             //   'Delivery address',
            //             //   style: TextStyle(
            //             //       color: AppColors.secondaryElement, fontSize: 12),
            //             // ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            Container(
              color: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/driver.gif",
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Delivery in 15 - 30 min',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'roboto',
                            color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     // showrating = !showrating;
                  //     setState(() {});
                  //   },
                  //   child: Container(
                  //     child: Text(
                  //       'Change',
                  //       style: TextStyle(
                  //           fontSize: 16,
                  //           fontFamily: 'roboto',
                  //           fontWeight: FontWeight.bold,
                  //           color: AppColors.secondaryElement),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                child: CheckboxListTile(
                  tileColor: AppColors.white,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 3.0, left: 20),
                    child: Text(
                        "Tick this box if you would not like to receive Deliveroo marketing offers and promotions via email. You can opt out at any time, and we promise never to sell your details to other businesses",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.grey,
                        )),
                  ),
                  value: marketing,

                  activeColor: AppColors.secondaryElement,
                  //  selectedTileColor: Colors.red,
                  contentPadding: EdgeInsets.all(0),
                  checkColor: AppColors.white,
                  onChanged: (newValue) {
                    setState(() {
                      marketing = newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.trailing, //  <-- leading Checkbox
                )),
            SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Deliver to',
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'roboto'),
              ),
            ),
            !loader
                ?  myaddress.length>0? Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                     Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            GoogleMap(
                                myLocationEnabled: false,
                                scrollGesturesEnabled: false,
                                buildingsEnabled: false,
                                zoomControlsEnabled: false,
                                initialCameraPosition: CameraPosition(
                                    target: _initialcameraposition, zoom: 16),
                                mapType: MapType.normal,
                                onMapCreated: _onMapCreated,
                                markers: _markers
                                // myLocationEnabled: true,
                                ),
                          ],
                        ),
                      ),
                      Container(
                        color: AppColors.white,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.place_outlined,
                                color: AppColors.grey,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(myaddress[selectedaddress]['address'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                        )),
                                    Text(
                                        myaddress[selectedaddress]['city'] +
                                            ', ' +
                                            myaddress[selectedaddress]
                                                ['country'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                        )),
                                    Text(myaddress[selectedaddress]['phone_no'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                        )),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // showrating = !showrating;
                                  changelocation(context);
                                  setState(() {});
                                },
                                child: Container(
                                  child: Text(
                                    'Change',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'roboto',
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondaryElement),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Container():Container(),
            SizedBox(
              height: myaddress.length == 0 ? 20 : 0,
            ),
            myaddress.length == 0
                ? Center(
                    child: InkWell(
                      onTap: () {
                        showPlacePicker(context,false);
                      },
                      child: Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            // border: Border.all(color: Colors.grey, width: 0),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.place_outlined,
                              color: AppColors.secondaryElement,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Add a new address',
                              style: TextStyle(
                                  color: AppColors.secondaryElement,
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                  fontFamily: 'roboto'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 5,
            ),
            // loader
            //     ? Padding(
            //         padding: const EdgeInsets.only(top: 40.0),
            //         child: Center(
            //           child: CircularProgressIndicator(
            //             valueColor: AlwaysStoppedAnimation<Color>(
            //                 AppColors.secondaryElement),
            //           ),
            //         ),
            //       )
            //     : myaddress.length == 0
            //         ? Center(
            //             child: Container(
            //               padding: const EdgeInsets.only(top: 40.0),
            //               child: Text(
            //                   'No address available, Add new address to continue'),
            //             ),
            //           )
            //         : Column(children: addresscard()),
            SizedBox(
              height: 20,
            ),
            widget.checkoutdata['usersub'] ||(widget.checkoutdata['total']!=null && widget.checkoutdata['total'] <= 0)
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Payment',
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'roboto'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      !loader
                          ? SingleChildScrollView(
                              child: Column(
                                  children: List.generate(
                                      mycards.length,
                                      (index) => Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 15),
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
                                              padding: const EdgeInsets.only(
                                                  top: 2.0),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Image.asset(
                                                    mycards[index]['card']
                                                                ['brand'] ==
                                                            'visa'
                                                        ? 'assets/images/visa2.png'
                                                        : 'assets/images/master.png',
                                                    height: 20,
                                                    width: 30,
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          mycards[index]['card']
                                                                  ['brand']
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          '**** **** **** ' +
                                                              mycards[index]
                                                                      ['card']
                                                                  ['last4'],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            value: index,
                                            activeColor:
                                                AppColors.secondaryElement,
                                            //  selectedTileColor: Colors.red,
                                            contentPadding: EdgeInsets.all(0),
                                            // checkColor: AppColors.white,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedcard = newValue;
                                              });
                                            },
                                            groupValue: selectedcard,

                                            controlAffinity: ListTileControlAffinity
                                                .trailing, //  <-- leading Checkbox
                                          )))))
                          : Container(),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () async {
                            // Navigator.pushNamed(context, AppRouter.Add_new_Payment);
                            Navigator.pushNamed(context, AppRouter.testing,
                                    arguments: {
                                      'subscribe':false
                                    })
                                .then((value) {
                              getsavedcards();
                            });
                            // final paymentMethod =
                            // await Stripe.instance.createPaymentMethod(PaymentMethodParams.card(

                            // ));
                            // print(paymentMethod);
                            //  await Stripe.instance.createPaymentMethod({
                            //    'card':''
                            //  });
                          },
                          child: Container(
                            height: 55,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                // border: Border.all(color: Colors.grey, width: 0),
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.credit_card_outlined,
                                  color: AppColors.secondaryElement,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  child: Text(
                                    'Add a Payment method',
                                    style: TextStyle(
                                        color: AppColors.secondaryElement,
                                        fontSize: 16,
                                        // fontWeight: FontWeight.bold,
                                        fontFamily: 'roboto'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            // SizedBox(
            //   height: 5,
            // ),
            // Center(
            //   child: InkWell(
            //     onTap: () {
            //       showPlacePicker(context);
            //     },
            //     child: Container(
            //       height: 55,
            //       width: MediaQuery.of(context).size.width,
            //       decoration: BoxDecoration(
            //           color: AppColors.white,
            //           // border: Border.all(color: Colors.grey, width: 0),
            //           borderRadius: BorderRadius.circular(8)),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: [
            //           SizedBox(
            //             width: 20,
            //           ),
            //           Icon(
            //             Icons.credit_card_outlined,
            //             color: Colors.grey.shade600,
            //           ),
            //           SizedBox(
            //             width: 10,
            //           ),
            //           Text(
            //             'Debit/Credit Card',
            //             style: TextStyle(
            //                 color: Colors.grey.shade600,
            //                 fontSize: 16,
            //                 // fontWeight: FontWeight.bold,
            //                 fontFamily: 'roboto'),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
