import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapsWidget extends StatefulWidget {
  const GoogleMapsWidget({super.key});

  @override
  _GoogleMapsWidgetState createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  late GoogleMapController mapController;
  LatLng? currentLocation;
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: (currentLocation != null)
          ? GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: currentLocation!,
                zoom: 16.0,
              ),
              onTap: _onMapTap,
              markers: Set.of((selectedLocation != null)
                  ? [
                      Marker(
                        markerId: const MarkerId('selected-location'),
                        position: selectedLocation!,
                      ),
                    ]
                  : []),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedLocation != null) {
            print(
                '선택된 위치: 위도 ${selectedLocation!.latitude}, 경도 ${selectedLocation!.longitude}');
            Navigator.pop(context);
          } else {
            print('위치를 먼저 선택해주세요.');
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      selectedLocation = latLng;
    });
  }

  void _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          print('Location permission denied.');
          currentLocation = const LatLng(37.545605, 126.963605);
        });
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting current location: $e');
      setState(() {
        currentLocation = const LatLng(37.545605, 126.963605); // 명신관으로 기본 위치 설정
      });
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: GoogleMapsWidget(),
  ));
}
