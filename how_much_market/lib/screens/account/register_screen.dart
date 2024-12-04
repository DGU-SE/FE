import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:how_much_market/screens/account/login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressDetailController =
      TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  Position? _currentPosition;
  GoogleMapController? _mapController;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    // Check for permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Get the current location
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      if (_mapController != null && _currentPosition != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          ),
        );
      }
    });
  }

  Future<void> _signUp() async {
    if (_idController.text.isEmpty ||
        _pwController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _zipcodeController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _addressDetailController.text.isEmpty ||
        _accountNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('모든 필드를 채워주세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_currentPosition == null) {
      await _getCurrentLocation();
    }

    final url = Uri.parse('http://13.125.107.235/api/user/join');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "id": _idController.text,
      "pw": _pwController.text,
      "name": _nameController.text,
      "location": {
        "longitude": _currentPosition?.longitude,
        "latitude": _currentPosition?.latitude,
        "zipcode": _zipcodeController.text,
        "address": _addressController.text,
        "addressDetail": _addressDetailController.text
      },
      "accountNumber": _accountNumberController.text,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        // Handle the response data if needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('회원가입 성공: ${responseData['name']}'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        final errorMessage = response.body.isNotEmpty
            ? jsonDecode(utf8.decode(response.bodyBytes))['message'] ??
                '알 수 없는 오류'
            : '알 수 없는 오류';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('회원가입 실패: $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('오류 발생: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('회원가입', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildTextField(_idController, '아이디', Icons.person_outline),
              _buildTextField(_pwController, '비밀번호', Icons.lock_outline,
                  obscureText: true),
              _buildTextField(_nameController, '이름', Icons.account_circle),
              _buildTextField(_zipcodeController, '우편번호', Icons.location_on),
              _buildTextField(_addressController, '주소 (예시:서울시 중구)', Icons.home),
              _buildTextField(_addressDetailController,
                  '상세주소 (예시:동국대학교 신공학관 5143)', Icons.details),
              _buildTextField(
                  _accountNumberController, '계좌번호', Icons.account_balance,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _getCurrentLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3297DF),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '현 위치 불러오기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: _currentPosition == null
                      ? const Center(child: CircularProgressIndicator())
                      : GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                            zoom: 15,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                          },
                          markers: _currentPosition != null
                              ? {
                                  Marker(
                                    markerId: const MarkerId('currentLocation'),
                                    position: LatLng(
                                      _currentPosition!.latitude,
                                      _currentPosition!.longitude,
                                    ),
                                  ),
                                }
                              : {},
                        ),
                ),
              ),
              const SizedBox(height: 10),
              if (_currentPosition != null)
                Text(
                  '현 위치 좌표: ${_currentPosition!.latitude.toStringAsFixed(3)} , ${_currentPosition!.longitude.toStringAsFixed(3)} (거리 계산용)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3297DF),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '회원가입 완료',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: const Color(0xff3297DF)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff3297DF), width: 2.0),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }
}
