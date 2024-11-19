import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationSettingScreen extends StatefulWidget {
  const LocationSettingScreen({super.key});

  @override
  State<LocationSettingScreen> createState() => _LocationSettingScreenState();
}

class _LocationSettingScreenState extends State<LocationSettingScreen> {
  LatLng? _currentPosition; // 현재 위치
  late GoogleMapController _mapController; // 지도 컨트롤러
  final TextEditingController cityController = TextEditingController(); // 시 입력란
  final TextEditingController districtController =
      TextEditingController(); // 구 입력란
  final TextEditingController neighborhoodController =
      TextEditingController(); // 동 입력란
  final TextEditingController detailAddressController =
      TextEditingController(); // 상세 주소 입력란

  // 현재 위치 가져오기
  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('위치 권한을 허용해주세요.')),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      // 지도 카메라를 현재 위치로 이동
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 15),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('현재 위치를 가져올 수 없습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('거주지 설정'),
        centerTitle: true,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '현재 위치',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                height: 200, // 정사각형 지도
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _currentPosition == null
                    ? const Center(child: Text('위치를 가져오는 중...'))
                    : GoogleMap(
                        onMapCreated: (controller) =>
                            _mapController = controller,
                        initialCameraPosition: CameraPosition(
                          target: _currentPosition!,
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('current_location'),
                            position: _currentPosition!,
                            infoWindow: const InfoWindow(title: '현재 위치'),
                          ),
                        },
                      ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _getCurrentLocation,
                icon: const Icon(Icons.my_location),
                label: const Text('현재 위치 가져오기'),
              ),
              const SizedBox(height: 16),

              // 위도/경도 표시
              if (_currentPosition != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '위도: ${_currentPosition!.latitude.toStringAsFixed(6)}'),
                    Text(
                        '경도: ${_currentPosition!.longitude.toStringAsFixed(6)}'),
                  ],
                ),
              const SizedBox(height: 16),

              const Text(
                '주소 입력',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              // 시 입력란
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: '시',
                  filled: true,
                  fillColor: Color.fromRGBO(238, 238, 238, 1),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              // 구 입력란
              TextFormField(
                controller: districtController,
                decoration: const InputDecoration(
                  labelText: '구',
                  filled: true,
                  fillColor: Color.fromRGBO(238, 238, 238, 1),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              // 동 입력란
              TextFormField(
                controller: neighborhoodController,
                decoration: const InputDecoration(
                  labelText: '동',
                  filled: true,
                  fillColor: Color.fromRGBO(238, 238, 238, 1),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              // 상세 주소 입력란
              TextFormField(
                controller: detailAddressController,
                decoration: const InputDecoration(
                  labelText: '상세 주소',
                  filled: true,
                  fillColor: Color.fromRGBO(238, 238, 238, 1),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 저장 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // API 호출 또는 데이터 저장 로직
                  },
                  child: const Text('주소 저장'),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
