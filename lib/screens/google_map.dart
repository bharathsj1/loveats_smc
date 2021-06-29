import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
              height: MediaQuery.of(context).size.height * 0.70,
              child: GoogleMap(
                myLocationButtonEnabled: false,
                buildingsEnabled: true,
                mapToolbarEnabled: true,
                onCameraMove: (position) {
                  print(position.target.latitude);
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude), zoom: 10),
                markers: Set<Marker>.of(
                  <Marker>[
                    Marker(
                      draggable: true,
                      markerId: MarkerId("1"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: LatLng(latitude, longitude),
                      onDragEnd: (value) {
                        print(value.latitude);
                        print(value.longitude);
                      },
                    )
                  ],
                ),
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
          ],
        ),
      ),
    );
  }

  void getCurrentValue() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);

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
}
