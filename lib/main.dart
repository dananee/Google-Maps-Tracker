import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/direction_data.dart';
import 'package:map_app/directions_models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GoogleMapController _mapController;

  // orgin location
  Marker? _origin;
  // destination location
  Marker? _destination;
  // Directions
  Directions? _infos;

  // first location when app apears
  static const _initcamerapos = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            onPressed: () {
              _mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: _origin!.position, tilt: 0.0, zoom: 14.4746),
                ),
              );
            },
            child: const Text('Origin',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            onPressed: () {
              _mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: _destination!.position, tilt: 0.0, zoom: 14.4746),
                ),
              );
            },
            child: const Text('Destination',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: GoogleMap(
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (controller) => _mapController = controller,
          markers: {
            if (_origin != null) _origin!,
            if (_destination != null) _destination!,
          },
          polylines: {
            if (_infos != null)
              Polyline(
                points: _infos!.polylinePoints
                    .map((e) => LatLng(e.latitude, e.longitude))
                    .toList(),
                color: Colors.blue,
                width: 4,
                polylineId: const PolylineId("overview_polyline"),
              ),
          },
          onLongPress: _addMarker,
          initialCameraPosition: _initcamerapos),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mapController.animateCamera(_infos != null
            ? CameraUpdate.newLatLngBounds(_infos!.bounds, 100.0)
            : CameraUpdate.newCameraPosition(_initcamerapos)),
        tooltip: 'Add Marker',
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.center_focus_strong,
          color: Colors.black,
        ),
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
          markerId: MarkerId('origin'),
          position: pos,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        );
        _destination = null;
        _infos = null;
      });
    } else {
      setState(() {
        _destination = Marker(
          markerId: MarkerId('destination'),
          position: pos,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
      });

      final directions = await DirectionData().directionData(
        origin: _origin!.position,
        destination: pos,
      );
      setState(() => _infos = directions);
    }
  }
}
