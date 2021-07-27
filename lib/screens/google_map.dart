import 'dart:collection';

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
  Set<Marker> _markers = HashSet<Marker>();
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
                onCameraIdle: () {
                  _markers.add(Marker(
                    draggable: true,
                    markerId: MarkerId("1"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: LatLng(latitude, longitude),
                  ));
                },
                onCameraMove: (position) {
                  latitude = position.target.latitude;
                  longitude = position.target.longitude;
                  _markers.add(Marker(
                    draggable: true,
                    markerId: MarkerId("1"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: LatLng(latitude, longitude),
                  ));
                  setState(() {});
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude), zoom: 10),
                markers: _markers,
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

      _markers.add(Marker(
        draggable: true,
        markerId: MarkerId("1"),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(position.latitude, position.longitude),
      ));
      setState(() {});
    }).timeout(
      Duration(seconds: 30),
      onTimeout: () {
        showToaster('Could not fetch live location');
        return;
      },
    );
  }
}
