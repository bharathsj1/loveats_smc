import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:potbelly/widgets/toaster.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({Key key}) : super(key: key);

  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  double latitude = 24.90;
  double longitude = 73.33;
  GoogleMapController _controller;
  final markers = Set<Marker>();
  MarkerId markerId = MarkerId("1");
  String address = 'Select your Location';
  var coordinates;
  int addressType = 0;
  String country, city;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.60,
              child: GoogleMap(
                myLocationButtonEnabled: false,
                buildingsEnabled: true,
                mapToolbarEnabled: true,
                onCameraIdle: () async {
                  address = await getAddress(coordinates);
                },
                onCameraMove: (position) {
                  coordinates = Coordinates(
                      position.target.latitude, position.target.longitude);
                  setState(() {
                    markers.add(
                      Marker(
                        markerId: markerId,
                        position: position.target,
                        infoWindow: InfoWindow(
                          title: address,
                        ),
                      ),
                    );
                  });

                  latitude = position.target.latitude;
                  longitude = position.target.longitude;
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude), zoom: 5),
                markers: markers,
                onMapCreated: (controller) {
                  setState(() {
                    _controller = controller;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0, top: 30),
              child: Align(
                alignment: Alignment.topRight,
                child: FloatingActionButton(
                  onPressed: () => getCurrentValue(),
                  child: Icon(Icons.location_on),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Select Location',
                      style: Styles.customNormalTextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Divider(),
                    Text(
                      address,
                      style: Styles.customNormalTextStyle(
                        fontSize: 11.0,
                        color: Colors.black,
                      ),
                    ),
                    Divider(),
                    Text(
                      'Tag this location for later',
                      style: Styles.customNormalTextStyle(
                        color: AppColors.accentElement,
                        fontSize: 11.0,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              addressType = 0;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 5.0,
                            ),
                            margin: EdgeInsets.only(bottom: 15.0, top: 5.0),
                            decoration: BoxDecoration(
                              color:
                                  addressType == 0 ? Colors.red : Colors.white,
                              border: Border.all(
                                color: Colors.red[500],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Home',
                              style: Styles.customNormalTextStyle(
                                fontSize: 11.0,
                                color: addressType == 0
                                    ? Colors.white
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              addressType = 1;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 5.0,
                            ),
                            margin: EdgeInsets.only(bottom: 15.0, top: 5.0),
                            decoration: BoxDecoration(
                              color:
                                  addressType == 1 ? Colors.red : Colors.white,
                              border: Border.all(
                                color: Colors.red[500],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Work',
                              style: Styles.customNormalTextStyle(
                                fontSize: 11.0,
                                color: 1 == addressType
                                    ? Colors.white
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              addressType = 2;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 5.0,
                            ),
                            margin: EdgeInsets.only(bottom: 15.0, top: 5.0),
                            decoration: BoxDecoration(
                              color:
                                  2 == addressType ? Colors.red : Colors.white,
                              border: Border.all(
                                color: Colors.red[500],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Hostel',
                              style: Styles.customNormalTextStyle(
                                fontSize: 11.0,
                                color: addressType == 2
                                    ? Colors.white
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              addressType = 4;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 5.0,
                            ),
                            margin: EdgeInsets.only(bottom: 15.0, top: 5.0),
                            decoration: BoxDecoration(
                              color:
                                  addressType == 4 ? Colors.red : Colors.white,
                              border: Border.all(
                                color: Colors.red[500],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Other',
                              style: Styles.customNormalTextStyle(
                                fontSize: 11.0,
                                color: addressType == 4
                                    ? Colors.white
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    PotbellyButton(
                      'Confirm Location',
                      buttonWidth: double.infinity,
                      onTap: () => saveLocation(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getCurrentValue() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    await Geolocator.getLastKnownPosition().then((value) {
      _controller.animateCamera(
        CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude), 25.0),
      );
    }).timeout(
      Duration(seconds: 30),
      onTimeout: () {
        showToaster('Could not fetch live location');
        return;
      },
    );
  }

  getAddress(Coordinates coordinates) async {
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    country = addresses.first.countryName;
    city = addresses.first.subAdminArea;
    
    return addresses.first.addressLine;
  }

  saveLocation() async {
    FormData data = FormData.fromMap({
      'address': address,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'address_type': addressType,
    });

    bool isAddressSaved = await Service().saveAddress(data);
    // if (isAddressSaved) showToaster('Location Saved');
    Navigator.pop(context,city ?? country);
  }
}
