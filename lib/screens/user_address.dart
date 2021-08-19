import 'package:flutter/material.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/circularIndicator.dart';

class UserAddresses extends StatefulWidget {
  const UserAddresses({Key key}) : super(key: key);

  @override
  _UserAddressesState createState() => _UserAddressesState();
}

class _UserAddressesState extends State<UserAddresses> {
  List<dynamic> myaddress = [];
  bool loader = true;
  @override
  void initState() {
    getUserAddresses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Addresses'),
        ),
        body: loader
            ? CircularIndicator()
            : myaddress.length == 0
                ? Center( 
                    child: Text(
                      'No addresses available.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(children: addresscard())));
  }

  List<Widget> addresscard() {
    return List.generate(
        myaddress.length,
        (index) => InkWell(
              onTap: () {
                // setState(() {
                //   selectedaddress = index;
                // });
              },
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: AppColors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
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
                                color: AppColors.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                myaddress[index]['address_type'],
                                style: TextStyle(
                                    color: AppColors.black,
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

  getUserAddresses() async {
    var respo = await AppService().getaddress();
    print(respo);
    myaddress = respo['data'];
    loader = false;
    setState(() {});
  }
}
