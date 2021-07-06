import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:potbelly/values/values.dart';

class Open_map extends StatefulWidget {
   var desdirection;
  Open_map({@required this.desdirection});

  @override
  _Open_mapState createState() => _Open_mapState();
}

class _Open_mapState extends State<Open_map> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  LatLng _initialcameraposition ;
  GoogleMapController _controller;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    //  _controller= Completer();
   _initialcameraposition= LatLng(widget.desdirection['lat'], widget.desdirection['long']);
    setState(() {
      
    });

    setState(() {
      // add marker on the position
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(123.toString()),
        position: _initialcameraposition,
        infoWindow: InfoWindow(
          // title is the address
          title: 'Customer Address',
          // snippet are the coordinates of the position
          snippet:
              widget.desdirection['address'],
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
    super.initState();
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    // _location.onLocationChanged.listen((l) {
    //   _controller.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
    //       ),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        // centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.secondaryElement),
        // title: Text(
        //   'Customer location',
        //   style: Styles.customTitleTextStyle(
        //     color: AppColors.secondaryElement,
        //     fontWeight: FontWeight.w600,
        //     fontSize: Sizes.TEXT_SIZE_22,
        //   ),
        // ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _initialcameraposition, zoom: 15),
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                markers: _markers
                // myLocationEnabled: true,
                ),
          ],
        ),
      ),
    );
  }
}
