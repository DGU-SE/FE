import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:how_much_market/screens/account/update_location_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyCurLocScreen extends StatefulWidget {
  const MyCurLocScreen({super.key});

  @override
  _MyCurLocScreenState createState() => _MyCurLocScreenState();
}

class _MyCurLocScreenState extends State<MyCurLocScreen> {
  double? longitude;
  double? latitude;
  String? zipcode;
  String? address;
  String? addressDetail;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      final response = await http.get(
          Uri.parse('http://13.125.107.235/api/user/$userId'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          longitude = data['location']['longitude'];
          latitude = data['location']['latitude'];
          zipcode = data['location']['zipcode'];
          address = data['location']['address'];
          addressDetail = data['location']['addressDetail'];
        });
      } else {
        // Handle server error
        print('Failed to load location data');
      }
    } else {
      // Handle missing userId
      print('User ID not found in SharedPreferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('거주지 변경'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: longitude != null && latitude != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '현재 거주지 정보를 확인하세요',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitude!, longitude!),
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('currentLocation'),
                          position: LatLng(latitude!, longitude!),
                        ),
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('우편번호: $zipcode',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black87)),
                        const SizedBox(height: 8),
                        Text('주소: $address',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black87)),
                        const SizedBox(height: 8),
                        Text('상세 주소: $addressDetail',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black87)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UpdateLocationScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3297DF),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      '거주지 정보 변경하기',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
