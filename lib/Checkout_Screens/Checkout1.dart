import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/custom_text_form_field.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:place_picker/place_picker.dart';
import 'package:potbelly/widgets/spaces.dart';
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
  final _formKey = GlobalKey<FormState>();
  
    @override
  void initState() {
    getaddress();
    super.initState();
  }

  getaddress() async {
    var respo= await AppService().getaddress();
    print(respo);
    myaddress=respo['data'];
    loader = false;
    setState(() { });
  }

  getuser(){

  }

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

  List myaddress = [
    // {
    //   'id': '1',
    //   'type': 'Work',
    //   'name': 'Mian Saad Hafeez',
    //   'phone': '+922234829393',
    //   'address':
    //       '1188  Bird Spring Lane, Cleveland, Texas 1188  Bird Spring Lane',
    //   'city': 'Cleveland',
    //   'country': 'Texas',
    // },
    // {
    //   'id': '2',
    //   'type': 'Home',
    //   'name': 'Mian Saad',
    //   'phone': '+928334738939',
    //   'address':
    //       '1188  Bird Spring Lane, Cleveland, Texas 1188  Bird Spring Lane',
    //   'city': 'Cleveland',
    //   'country': 'Texas',
    // }
  ];

   showPlacePicker(context) async {
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
      bottomSheetForLocation(context);
    }
  }

  bottomSheetForLocation(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        // backgroundColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
          return Container(
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
                                
                                loader=true;
                                setState(() {
                                  
                                });
                                var data= {
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
                                  loader=false;
                                  setState(() {
                                    
                                  });
                                });
                                this.nameController.text='';
                                this.phoneNoController.text='';
                                Navigator.of(context).pop();
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
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: selectedaddress == index
                          ? AppColors.secondaryElement
                          : AppColors.grey,
                      width: selectedaddress == index ? 1 : 0),
                  borderRadius: BorderRadius.circular(10),
                ),
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
                                myaddress[index]['address_type'] == 'Work'? Icons.work_outline_outlined: Icons.place_outlined,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () => AppRouter.navigator.pop(),
          child: Image.asset(
            ImagePath.arrowBackIcon,
            color: AppColors.headingText,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Checkout (1/3)',
          style: Styles.customTitleTextStyle(
            color: AppColors.headingText,
            fontWeight: FontWeight.w500,
            fontSize: Sizes.TEXT_SIZE_20,
          ),
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 5,
        child: Container(
          color: AppColors.white,
          margin: EdgeInsets.only(top: 5),
          height: 65,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PotbellyButton(
                'Proceed to payment',
                onTap: () {
                  if(myaddress.length!=0){
                  var data = {
                    'cartlist': widget.checkoutdata['cartlist'],
                    'charges': widget.checkoutdata['charges'],
                    'shipping': widget.checkoutdata['shipping'],
                    'total': widget.checkoutdata['total'],
                    'type': widget.checkoutdata['type'],
                    'mixmatch': widget.checkoutdata['mixmatch'],
                    'customer_addressId': myaddress[selectedaddress]['id'],
                    'addressId': selectedaddress
                  };
                  AppRouter.navigator
                      .pushNamed(AppRouter.CheckOut2, arguments: data);
                }
                else{
                   Toast.show('Add address to continue', context, duration: 3);
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
                    borderRadius: BorderRadius.circular(8),
                    color: myaddress.length!=0? AppColors.secondaryElement: AppColors.grey),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 0.5,
              child: Container(
                height: 60,
                color: AppColors.white,
                // padding: EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    createrow(AppColors.secondaryElement),
                    Container(
                        margin: EdgeInsets.only(left: 5),
                        child: createrow(Colors.grey)),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.radio_button_checked_rounded,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        // Text(
                        //   'Delivery address',
                        //   style: TextStyle(
                        //       color: AppColors.secondaryElement, fontSize: 12),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Select delivery address',
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
            Center(
              child: InkWell(
                onTap: () {
                  showPlacePicker(context);
                },
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: AppColors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Add New Address',
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                            fontFamily: 'roboto'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
         loader
        ? Padding(
          padding: const EdgeInsets.only(top:40.0),
          child: Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.secondaryElement),
              ),
            ),
        )
        :myaddress.length == 0
            ? Center(
                child: Container(
                  padding: const EdgeInsets.only(top:40.0),
                  child: Text('No address available, Add new address to continue'),
                ),
              )
            :   Column(children: addresscard())
          ],
        ),
      ),
    );
  }
}
