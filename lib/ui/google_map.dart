import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {

  GoogleMapController _controller;
  // Position position;
  LocationData position;
  Widget _child;
  var location = Location();

  Future<void> getLocation() async{
    var serviceEnabled = await location.serviceEnabled();
    if(!serviceEnabled)
      {
        serviceEnabled = await location.requestService();
        if(!serviceEnabled)
          {
            return;
          }
      }

    var _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied)
      {
        _permissionGranted = await location.requestPermission();
        if(_permissionGranted == PermissionStatus.granted)
        {
          _getCurrentLocation();
        }
      }
    if(_permissionGranted == PermissionStatus.granted)
    {
      _getCurrentLocation();
    }
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }
  Set<Marker> _createMarker(){
    return <Marker>[
      Marker(
        markerId: MarkerId('home'),
        position: LatLng(position.latitude,position.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: 'Current Location')
      )
    ].toSet();
  }

  void showToast(message){
      print(message);
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }
  void _getCurrentLocation() async{
    // Position res = await Geolocator().getCurrentPosition();
    var res = await Location().getLocation();
    setState(() {
      position = res;
      print(res);
      _child = _mapWidget();
    });
  }


  Widget _mapWidget(){
    return GoogleMap(
      mapType: MapType.normal,
      markers: _createMarker(),
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude,position.longitude),
        zoom: 16,
      ),
      onMapCreated: (GoogleMapController controller){
        _controller = controller;
        _setStyle(controller);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map',textAlign: TextAlign.center,style: TextStyle(color: CupertinoColors.white),),
      ),
      body:_child
    );
  }
}
