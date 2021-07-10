import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:potbelly/screens/login_screen.dart';
import 'package:potbelly/screens/root_screen.dart';
import 'package:potbelly/screens/root_screen2.dart';
import 'package:potbelly/services/appServices.dart';
import 'package:potbelly/services/locationService.dart';
import 'package:potbelly/services/service.dart';
import 'package:potbelly/values/values.dart';
import 'package:potbelly/widgets/potbelly_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Open_direction extends StatefulWidget {
  var desdirection;
  Open_direction({@required this.desdirection});

  @override
  _Open_directionState createState() => _Open_directionState();
}

class _Open_directionState extends State<Open_direction> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  LatLng _initialcameraposition = LatLng(53.4083714, -2.991572600000012);
  Completer<GoogleMapController> _controller;
  final Set<Marker> _markers = {};
  // Location _location = Location();

  double CAMERA_ZOOM = 16;
  double CAMERA_TILT = 80;
  double CAMERA_BEARING = 30;
  LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
  LatLng DEST_LOCATION = LatLng(31.4064, 73.1069);

// for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  // String googleAPIKey = 'AIzaSyCkoLh9yZhcAtP9R-KsP90JaqFiooRuEmg';
  String googleAPIKey = 'AIzaSyAvkMhRQCjbxq_zQnRCTLRqF7yw6m9jy4A';
// for my custom marker pins
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
// the user's initial location and current location
// as it moves
  LocationData currentLocation;
// a reference to the destination location
  LocationData destinationLocation;
// wrapper around the location API
  Location location;

  // void _onMapCreated(GoogleMapController _cntlr) {
  //   _controller = _cntlr;
  //   // _location.onLocationChanged.listen((l) {
  //   //   _controller.animateCamera(
  //   //     CameraUpdate.newCameraPosition(
  //   //       CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
  //   //       ),
  //   //   );
  //   // });
  // }

    _onAlertButtonsPressed(context, detail) {
    //  StatefulBuilder(
    //       builder: (BuildContext context, StateSetter setState) {
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "Are you sure?",
      desc: detail,
      buttons: [
        DialogButton(
          child: Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.grey,
        ),
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () async {
           var data = {'order_id': widget.desdirection['data']['id'], 'status': 'delivered'};
            AppService().setorderstatus(data).then((value) async {
               if (value['message'].contains('Successfully')) {
                      var data = {
                        'title': 'Out for Delivery',
                        'body':
                            'You can track live location of the order in orders list section',
                        // 'title': 'Order Delivered',
                        // 'body': 'Thanks for ordering, Enjoy you meal',
                        // 'data': value.toString(),
                        'user_id':widget.desdirection['data']['customer_id']
                      };
                      AppService().sendnotispecificuser(data);
                       SharedPreferences pref = await SharedPreferences.getInstance();
                    pref.remove('driving');
                    pref.remove('drivingorder');
                       Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) =>
                      RootScreen2() ),
            (route) => false);
                    }
            });
          },
          color: AppColors.secondaryElement,
        )
      ],
    ).show();
  }


  @override
  void initState() {
    _controller = Completer();
    // currentLocation.latitude= widget.desdirection['clat'];
    // currentLocation.longitude= widget.desdirection['clong'];
     currentLocation = LocationData.fromMap({
      "latitude": widget.desdirection['clat'],
      "longitude": widget.desdirection['clong']
    });
    setState(() {
      
    });
    // setState(() {
    //   // add marker on the position
    //   _markers.add(Marker(
    //     // This marker id can be anything that uniquely identifies each marker.
    //     markerId: MarkerId(123.toString()),
    //     position: _initialcameraposition,
    //     infoWindow: InfoWindow(
    //       // title is the address
    //       title: 'Customer Address',
    //       // snippet are the coordinates of the position
    //       snippet:
    //           'Lat: ${_initialcameraposition.latitude}, Lng: ${_initialcameraposition.longitude}',
    //     ),
    //     icon: BitmapDescriptor.defaultMarker,
    //   ));
    // });
    super.initState();

    // create an instance of Location
    location = new Location();
    polylinePoints = PolylinePoints();

    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      print(cLoc);
      if(widget.desdirection['driving'] == true){
        if(mounted){
           var data = {
          'driver_lat': cLoc.latitude.toString(),
          'driver_lng': cLoc.longitude.toString(),
          'order_id': widget.desdirection['data']['id']
        };
        print(data);
        try{
        LocationService().setdriverloc(data).then((value) {
          print(value);
        });
        }
        catch(error){
          print(error);
        }
        }
      }
      if (mounted) {
        updatePinOnMap();
      }
    });
    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    setInitialLocation();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/driving_pin1.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();

    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      "latitude": widget.desdirection['lat'],
      "longitude": widget.desdirection['long']
    });
  }

   void _onGeoChanged(CameraPosition position) {
    // print("position: " + position.target.toString());
    // print("zoom: " + position.zoom.toString());
    CAMERA_ZOOM= position.zoom;
    CAMERA_TILT= position.tilt;
    CAMERA_BEARING= position.bearing;
    SOURCE_LOCATION= position.target;
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backwardsCompatibility: true,

          elevation: 0.0,
          // centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 30,right:20.0),
              child: InkWell(
                child:PotbellyButton('Delivered',
                                buttonHeight: 40,
                                buttonWidth: 100,
                                buttonTextStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: AppColors.secondaryElement),
                                onTap: () {
                                  _onAlertButtonsPressed(context, 'Food has been delivered to the customer?');
                                })
              ),
            )
          ],
          iconTheme: IconThemeData(color: AppColors.secondaryElement),
          leading: widget.desdirection['driving'] == true? Padding(
            padding: const EdgeInsets.only(top:20),
            child: InkWell(
              onTap: () async {
                 SharedPreferences pref = await SharedPreferences.getInstance();
                 var orderdata=await  pref.get('drivingorder');
                      var order= jsonDecode(orderdata);
                        final shared = await Service().loggedUser();
                        var data = {'order_id': order['id'], 'status': 'ready'};
                        AppService().setorderstatus(data).then((value) {
                          pref.remove('driving');
                        pref.remove('drivingorder');
                        print(value);
                        if (value['message'].contains('Successfully')) {
                         } });
                         Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        shared != null ? shared == '2'? RootScreen():  RootScreen2() : BackgroundVideo()),
                (route) => false);
              },
              child: Icon(
                Icons.close,
                color: AppColors.secondaryElement,
              ),
            ),
          ):null,
          // title: Text(
          //   'Customer location',
          //   style: Styles.customTitleTextStyle(
          //     color: AppColors.secondaryElement,
          //     fontWeight: FontWeight.w600,
          //     fontSize: Sizes.TEXT_SIZE_22,
          //   ),
          // ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
                // initialCameraPosition:
                //     CameraPosition(target: _initialcameraposition, zoom: 15),
                // mapType: MapType.normal,
                // onMapCreated: _onMapCreated,
                // markers: _markers
                // // myLocationEnabled: true,

                myLocationEnabled: true,
                compassEnabled: true,
                tiltGesturesEnabled: false,
                markers: _markers,
                polylines: _polylines,
                mapType: MapType.normal,
                //  onCameraMove: _onGeoChanged,
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  // _controller.complete(controller);
                  // my map has completed being created;
                  // i'm ready to show the pins on the map
                  if (mounted) {
                    showPinsOnMap();
                  }
                })

            // ),
          ],
        ),
      ),
    );
  }

  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object

    //  var pinPosition = LatLng(currentLocation.latitude,
    //  currentLocation.longitude);
    var pinPosition =
        LatLng(widget.desdirection['clat'], widget.desdirection['clong']);

    // get a LatLng out of the LocationData object
    var destPosition =
        LatLng(widget.desdirection['lat'], widget.desdirection['long']);
    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: sourceIcon));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    if (mounted) {
      setPolylines();
      // print( polylinePoints.getRouteBetweenCoordinates(
      //   googleAPIKey,
      //       PointLatLng(widget.desdirection['clat'], widget.desdirection['clong']),
      //       PointLatLng(widget.desdirection['lat'],widget.desdirection['long']),
      //  ));
    }
  }

// _addPolyLine() {
//     PolylineId id = PolylineId("poly");
//     Polyline polyline = Polyline(
//         polylineId: id, color: Colors.red, points: polylineCoordinates);
//     _polylines[id] = polyline;
//     setState(() {});
//   }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(widget.desdirection['clat'], widget.desdirection['clong']),
        PointLatLng(widget.desdirection['lat'], widget.desdirection['long']),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);
     print(result);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
//     if(mounted){
// _addPolyLine();
//     }
//    List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
//    googleAPIKey,
//   //  currentLocation.latitude,
//   //  currentLocation.longitude,
//    widget.desdirection['clat'],widget.desdirection['clong'],
//   //  destinationLocation.latitude,
//   //  destinationLocation.longitude
//  widget.desdirection['lat'],widget.desdirection['long']
//    );

//    if(result.isNotEmpty){
//       result.forEach((PointLatLng point){
//          polylineCoordinates.add(
//             LatLng(point.latitude,point.longitude)
//          );
//       });

    if (mounted) {
      setState(() {
        _polylines.add(Polyline(
            width: 5, // set the width of the polylines
            polylineId: PolylineId('polly'),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates));
      });
    }
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    if (mounted) {
      setState(() {
        // updated position
        var pinPosition =
            LatLng(currentLocation.latitude, currentLocation.longitude);

        // the trick is to remove the marker (by id)
        // and add it again at the updated location
        _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
        _markers.add(Marker(
            markerId: MarkerId('sourcePin'),
            position: pinPosition, // updated position
            icon: sourceIcon));
      });
    }
  }
}
