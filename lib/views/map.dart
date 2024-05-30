import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';


class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};

  // List of addresses to be highlighted on the map
  final List<String> _addresses = [
    '1600 Amphitheatre Parkway, Mountain View, CA',
    '1 Infinite Loop, Cupertino, CA',
    '350 Fifth Avenue, New York, NY',
  ];

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() async {
    for (var address in _addresses) {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final marker = Marker(
          markerId: MarkerId(address),
          position: LatLng(locations.first.latitude, locations.first.longitude),
          infoWindow: InfoWindow(
            title: address,
          ),
        );
        setState(() {
          _markers.add(marker);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Map Demo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                _controller = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(37.7749, -122.4194), // Centered around San Francisco
                zoom: 10,
              ),
              markers: _markers,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                // Add a new marker by address
                String newAddress = '1600 Pennsylvania Avenue NW, Washington, DC';
                List<Location> locations = await locationFromAddress(newAddress);
                if (locations.isNotEmpty) {
                  final marker = Marker(
                    markerId: MarkerId(newAddress),
                    position: LatLng(locations.first.latitude, locations.first.longitude),
                    infoWindow: InfoWindow(
                      title: newAddress,
                    ),
                  );
                  setState(() {
                    _markers.add(marker);
                  });
                  _controller?.animateCamera(
                    CameraUpdate.newLatLng(
                      LatLng(locations.first.latitude, locations.first.longitude),
                    ),
                  );
                }
              },
              child: Text('Add Washington, DC Marker'),
            ),
          ),
        ],
      ),
    );
  }
}