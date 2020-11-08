import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swagger/api.dart';
import 'StyleUtils.dart';

class ViewLocationScreen extends StatefulWidget {
  final List<Location> locations;

  ViewLocationScreen({Key key, @required this.locations}) : super(key: key);

  @override
  _ViewLocationScreenState createState() => _ViewLocationScreenState();
}

class _ViewLocationScreenState extends State<ViewLocationScreen> {
  static const LatLng _defaultPosition = LatLng(-34.6021521, -58.4345179);

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set<Marker>();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: _defaultPosition,
    zoom: 12.0,
  );

  Widget _buildMap() {
    widget.locations.forEach((location) {
      double lat = double.parse(location.latitude);
      double lng = double.parse(location.longitude);
      String locationInfo =
          "${location.address} - ${location.occupation}/${location.maxCapacity}";

      Marker marker = Marker(
          //FIXME: El backend esta entregando la id en null, hay que arreglar eso y usarla aca
          markerId: MarkerId(location.id),
          position: LatLng(lat, lng),
          //TODO: Obtener el nombre de la locación y mostrar todos sus datos
          infoWindow:
              InfoWindow(title: location.description, snippet: locationInfo));

      _markers.add(marker);
    });

    return Container(
        width: double.infinity,
        height: 500,
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: _markers,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BackgroundFrame(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Locaciones Registradas', style: subtitleTextStyle),
        SizedBox(height: 30.0),
        _buildMap(),
        backButton(context)
      ],
    )));
  }
}
