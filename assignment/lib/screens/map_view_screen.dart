import 'package:flutter/material.dart';
import 'package:assignment/models/restaurant.dart';
import 'package:assignment/widgets/buttomNavigationBar.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapViewPage extends StatefulWidget {
  final List<Restaurant> restaurants;

  const MapViewPage({Key? key, required this.restaurants}) : super(key: key);

  @override
  State<MapViewPage> createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  late List<Marker> _markers;
  late MapController _mapController;
  final PopupController _popupController = PopupController();
  LatLng initialCenter = LatLng(37.0902, 31.5370);
  List<LatLng> _routePoints = [];
  bool _isLoading = true;
  LatLng _currentLocation = LatLng(56.1304, 106.3468);

  @override
  void initState() {
    super.initState();
    _mapController = MapController(); // Initialize MapController here
    _markers = _buildMarkers();
    _getLocationPermission();
    _getCurrentLocation();
  }

  List<Marker> _buildMarkers() {
    return widget.restaurants.map((restaurant) {
      return Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(restaurant.latitude, restaurant.longitude),
          child: IconButton(
  icon: Icon(Icons.location_pin),
  color: Colors.red,
  onPressed: () async {
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double currentLat = currentPosition.latitude;
    double currentLon = currentPosition.longitude;
    print(currentLat);
    print(currentLon);

    double distance = await _calculateDistance(
        currentLat, currentLon, restaurant.latitude, restaurant.longitude);

    await _fetchRoute(LatLng(restaurant.latitude, restaurant.longitude));


    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(restaurant.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(restaurant.address),
            Text('Distance: $distance km'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
  },
),
        
      );
    }).toList();
  }

  Future<void> _getLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Handle the case where the user denied permission
        print('Location permission denied');
      }
    }
  }

  Future<double> _calculateDistance(double lat1, double lon1, double lat2, double lon2) async {
  // Get the current location
  Position currentPosition = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  // Extract latitude and longitude from the current position
  double lat1 = currentPosition.latitude;
  double lon1 = currentPosition.longitude;

  const double earthRadius = 6371.0; // Radius of the Earth in kilometers
  double dLat = _degreesToRadians(lat2 - lat1);
  double dLon = _degreesToRadians(lon2 - lon1);

  double a = pow(sin(dLat / 2), 2) +
      cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) * pow(sin(dLon / 2), 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c; // Distance in kilometers
}

double _degreesToRadians(double degrees) {
  return degrees * (pi / 180.0);
}

Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });
  }

  Future<void> _fetchRoute(LatLng destination) async {
  final String baseUrl = 'http://router.project-osrm.org/route/v1';
  final String coordinates = '${_currentLocation.longitude},${_currentLocation.latitude};${destination.longitude},${destination.latitude}';
  final String url = '$baseUrl/driving/$coordinates?steps=true';
  final response = await http.get(Uri.parse(url));
  print(response.statusCode);
  print(response.body);

  if (response.statusCode == 200) {
    final decodedData = json.decode(response.body);
    final routes = decodedData['routes'];

    if (routes.isNotEmpty) {
      final route = routes[0]['geometry'];
      final polylinePoints = PolylinePoints();
      final List<PointLatLng> polylineCoordinates =
          polylinePoints.decodePolyline(route);

      setState(() {
        _routePoints = polylineCoordinates.map((point) {
          return LatLng(point.latitude, point.longitude);
        }).toList();
      });
    } else {
      throw Exception('No routes found');
    }
  } else {
    throw Exception('Failed to fetch route');
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyNavigationBar(),
      appBar: AppBar(
        title: Text(
          'Map View',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body:_isLoading
          ? Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                center: _currentLocation ?? initialCenter,
                zoom: 3.0,
              ),
        children: [
          openStreetMapTileLayer,
    MarkerLayer(markers: _markers),
    PolylineLayer(
      polylines: [
        Polyline(
          points: _routePoints,
          strokeWidth: 4.0,
          color: Colors.blue,
        ),
      ],
    ),
    Positioned(
      bottom: 16.0,
      left: 16.0,
      child: Column(
        children: [
          IconButton(
            onPressed: () => _mapController.move(initialCenter, _mapController.zoom + 1.0),
            icon: Icon(Icons.add),
          ),
          SizedBox(height: 8.0),
          IconButton(
            onPressed: () => _mapController.move(_mapController.center, _mapController.zoom - 1.0),
            icon: Icon(Icons.remove),
          ),
          SizedBox(height: 8.0),
          IconButton(
            onPressed: () => _mapController.move(LatLng(37.0902, -95.7129), 4.0),
            icon: Icon(Icons.gps_fixed),
          ),
        ],
      ),
    ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    //_popupController.hidePopup();
    _popupController.dispose();
    super.dispose();
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  subdomains: ['a', 'b', 'c'],
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);


