import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

// ignore: use_key_in_widget_constructors
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late GoogleMapController mapController;
  Location locationTracker = Location();
  static const initialCameraPosition = CameraPosition(
    target: LatLng(-19.919359685613145, -43.939165581247096),
    zoom: 20.0,
  );
  List<Marker> markers = [
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(-19.976523364712037, -44.02588694432856),
      infoWindow: InfoWindow(
        title: 'PUC Minas - Barreiro',
      ),
    ),
    const Marker(
      markerId: MarkerId('2'),
      position: LatLng(-19.9550716, -44.1984331),
      infoWindow: InfoWindow(
        title: 'PUC Minas - Betim',
      ),
    ),
    const Marker(
      markerId: MarkerId('3'),
      position: LatLng(-19.94146, -44.07642),
      infoWindow: InfoWindow(
        title: 'PUC Minas - Contagem',
      ),
    ),
    const Marker(
      markerId: MarkerId('4'),
      position: LatLng(-19.92257975766356, -43.99257354444666),
      infoWindow: InfoWindow(
        title: 'PUC Minas - Coração Eucarístico',
      ),
    ),
    const Marker(
      markerId: MarkerId('5'),
      position: LatLng(-21.7992564, -46.6007147),
      infoWindow: InfoWindow(
        title: 'PUC Minas - Poços de Caldas',
      ),
    ),
    const Marker(
      markerId: MarkerId('6'),
      position: LatLng(-19.933722065812983, -43.93633613095481),
      infoWindow: InfoWindow(
        title: 'PUC Minas - Praça da Liberdade',
      ),
    ),
    const Marker(
      markerId: MarkerId('7'),
      position: LatLng(-19.859143126099053, -43.91881268492343),
      infoWindow: InfoWindow(
        title: 'PUC Minas - São Gabriel',
      ),
    ),
    const Marker(
      markerId: MarkerId('8'),
      position: LatLng(-18.92406, -48.29534),
      infoWindow: InfoWindow(
        title: 'PUC Minas - Uberlândia',
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void fetchClosestPuc(double lat, double lon) async {
    final response = await http.get(Uri.parse('https://southamerica-east1-closest-puc.cloudfunctions.net/closestPuc/?lat=$lat&lon=$lon'));

    debugPrint(response.body.toString());

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Bem vindo à ${response.body}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void getCurrentLocation() async {
    try {
      locationTracker.onLocationChanged.listen((newLocaData) {
        mapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(newLocaData.latitude!, newLocaData.longitude!), zoom: 17)));
        fetchClosestPuc(newLocaData.latitude!, newLocaData.longitude!);
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION DENIED') {
        debugPrint('Permission denied');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Closest PUC'),
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: true,
        ),
        body: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          myLocationEnabled: true,
          markers: markers.toSet(),
          initialCameraPosition: initialCameraPosition,
        ),
      ),
    );
  }
}
