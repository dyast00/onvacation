import 'dart:math' show sin, cos, sqrt, atan2;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class mapscreen extends StatefulWidget {
  const mapscreen({Key? key}) : super(key: key);

  @override
  State<mapscreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<mapscreen> {
  String currentAddress = '';
  String destinationAddress = '';
  LatLng currentPosition = LatLng(0, 0);
  LatLng destinationPosition = LatLng(-8.164972, 113.717556);

  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getDestinationAddress();
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final addresses = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (addresses.isNotEmpty) {
      final address = addresses.first;
      final formattedAddress =
          '${address.street}, ${address.locality}, ${address.country}';
      setState(() {
        currentAddress = formattedAddress;
      });
    }

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.https(
        "www.google.com", "maps/place/Pantai+payangan/@-8.4364088,113.581299");
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not launch url";
    }
  }

  Future<void> _getDestinationAddress() async {
    final addresses = await placemarkFromCoordinates(
      destinationPosition.latitude,
      destinationPosition.longitude,
    );

    if (addresses.isNotEmpty) {
      final address = addresses.first;
      final formattedAddress =
          '${address.street}, ${address.locality}, ${address.country}';
      setState(() {
        destinationAddress = formattedAddress;
      });
    }
  }

  double calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {
    const int earthRadius = 6371; // Radius of the earth in kilometers

    double latDiff = degreesToRadians(endLat - startLat);
    double lngDiff = degreesToRadians(endLng - startLng);

    double a = sin(latDiff / 2) * sin(latDiff / 2) +
        cos(degreesToRadians(startLat)) *
            cos(degreesToRadians(endLat)) *
            sin(lngDiff / 2) *
            sin(lngDiff / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c; // Distance in kilometers
    return distance;
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    double distance = calculateDistance(
      currentPosition.latitude,
      currentPosition.longitude,
      destinationPosition.latitude,
      destinationPosition.longitude,
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(102, 218, 255, 1.0),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Container(
              width: 350,
              height: 210,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/onvocation-81249.appspot.com/o/Group%201737.png?alt=media&token=3a3e7814-71b9-4621-b64a-4ce4c811eb1b&_gl=1*1dx894e*_ga*NTYyMDIyOTE4LjE2ODQxNzY3MzU.*_ga_CW55HF8NVT*MTY4NTYxNTIzMC4yMy4xLjE2ODU2MTg4ODUuMC4wLjA."),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/onvocation-81249.appspot.com/o/PANTAI-PAYANGAN-1248x703.jpg?alt=media&token=bcf6f515-49d5-42ff-b0c2-2dfea1b5d27d&_gl=1*9s8hoz*_ga*NTYyMDIyOTE4LjE2ODQxNzY3MzU.*_ga_CW55HF8NVT*MTY4NjMwMTU2OC4zMC4xLjE2ODYzMDUzMDAuMC4wLjA."),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pantai Payangan',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Pantai',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 20,
                          ),
                          Container(
                            width: 150,
                            child: Text(
                              'Jl. Sidomulyo, Sido Mulyo, Sumberrejo, Kec. Ambulu, Kabupaten Jember, Jawa Timur 68172',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.money,
                            color: Colors.white,
                            size: 20,
                          ),
                          Container(
                            width: 150,
                            child: Text(
                              'Harga Mulai Rp 7.500',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          Icon(
                            Icons.star_half,
                            color: Colors.amber,
                          ),
                          Icon(
                            Icons.star_border,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            height: 25,
                            width: 90,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'Upload Foto',
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 25,
                            child: ElevatedButton(
                              onPressed: () {
                                _launchURL(
                                    "https://www.google.com/maps/search/?api=1&query=-8.164972,113.717556");
                              },
                              child: Text(
                                'Menuju Lokasi',
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: destinationPosition,
                zoom: 13.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: destinationPosition,
                      builder: (ctx) => Container(
                        child: Icon(
                          Icons.flag,
                          color: Colors.blue,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Keterangan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jarak:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${distance.toStringAsFixed(2)} km',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lokasi Tujuan:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${destinationPosition.latitude.toStringAsFixed(6)},${destinationPosition.longitude.toStringAsFixed(6)}',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Alamat: $destinationAddress',
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lokasimu Saat Ini:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${currentPosition.latitude.toStringAsFixed(6)},${currentPosition.longitude.toStringAsFixed(6)}',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Alamat: $currentAddress',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            iconSize: 20.0,
            selectedIconTheme: IconThemeData(size: 28.0),
            selectedItemColor: Color.fromARGB(255, 46, 90, 172),
            unselectedItemColor: Colors.black,
            selectedFontSize: 16.0,
            unselectedFontSize: 12,
            currentIndex: 1,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: GestureDetector(
                  child: Icon(Icons.home),
                  onTap: () {},
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.navigation),
                label: "map",
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  child: Icon(Icons.person),
                  onTap: () {},
                ),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
