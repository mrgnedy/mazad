import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:tawasool/router.gr.dart';

class MapScreen extends StatefulWidget {
  final Function setLocation;
  MapScreen(this.setLocation);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  checkPermission() async {
    geolocator.checkGeolocationPermissionStatus().then((geoStatus) {
      if (geoStatus == GeolocationStatus.denied)
      
        Permission.location.request().then((_)=>getCurrentLocation());// requestPermissions([PermissionGroup.location]).then((_)=>getCurrentLocation());
      else
        getCurrentLocation();
    });
  }

  @override
  void initState() {
    // checkPermission();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Container(  
      child: Scaffold(
        
        appBar: AppBar(
          title: Text('حدد مكان المناسبة', style: TextStyle(fontFamily: 'Cairo'),),
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: ()=>ExtendedNavigator.rootNavigator.pop(currentPos)),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.my_location),
                onPressed: () => checkPermission())
          ],
        ),
        body: GoogleMap(
          
          onTap: (s) {
            currentPos = Position(longitude: s.longitude, latitude: s.latitude);
            marker = Set.from([
              Marker(
                  markerId: MarkerId('0'),
                  draggable: true,
                  onDragEnd: (s) {
                    currentPos =
                        Position(longitude: s.longitude, latitude: s.latitude);
                  },
                  position: LatLng(currentPos.latitude, currentPos.longitude))
            ]);
            print(currentPos.longitude);
            widget.setLocation(currentPos);
            setState(() {});
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(0, 0),
          ),
          markers: marker,

          // myLocationEnabled: true,
          // myLocationButtonEnabled: true,
          onMapCreated: onMapCreated,
        ),
      ),
    );
  }

  Completer<GoogleMapController> completer = Completer();
  GoogleMapController _mapController;
  Geolocator geolocator = Geolocator();
  Position currentPos;
  Set<Marker> marker = Set.of([]);
  onMapCreated(GoogleMapController controller) async {
    completer.complete(controller);
    _mapController = controller;

    // getCurrentLocation();
  }

  getCurrentLocation() async {
    if (true) {
      currentPos = await geolocator.getCurrentPosition();
      if (currentPos == null)
        AppSettings.openLocationSettings();
      else if (true)
        _mapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(currentPos.latitude, currentPos.longitude))))
            .then((s) {
          marker = Set.from([
            Marker(
              draggable: true,
              onDragEnd: (s) {
                currentPos =
                    Position(longitude: s.longitude, latitude: s.latitude);
              },
              markerId: MarkerId('0'),
              position: LatLng(currentPos.latitude, currentPos.longitude),
            )
          ]);
          setState(() {});
        });
    }
    // else
    // widget.setLocation(currentPos);
  }
}
