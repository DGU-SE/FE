import 'package:flutter/material.dart';
import 'dart:convert';

class LocationSettingScreen extends StatefulWidget {
  const LocationSettingScreen({super.key});

  @override
  State<LocationSettingScreen> createState() => _LocationSettingScreenState();
}

class _LocationSettingScreenState extends State<LocationSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressDetailController =
      TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();

  // 임시 API 요청을 보내는 함수 (실제 API 호출 없이 성공 메시지만 표시)
  Future<void> mockUpdateLocation() async {
    // 임시로 입력받은 데이터 출력
    final data = {
      'longitude': double.tryParse(_longitudeController.text) ?? 127.11111,
      'latitude': double.tryParse(_latitudeController.text) ?? 37.11111,
      'zipcode': _zipcodeController.text,
      'address': _addressController.text,
      'addressDetail': _addressDetailController.text,
    };

    print('Sending PATCH request to API with data: ${json.encode(data)}');

    // 임시로 2초 딜레이 후 성공 메시지 표시
    await Future.delayed(const Duration(seconds: 2));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('거주지 정보가 성공적으로 업데이트되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('거주지 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('주소', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: '주소를 입력하세요',
                  filled: true,
                  fillColor: Color.fromRGBO(255, 255, 255, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? '주소를 입력해주세요' : null,
              ),
              const SizedBox(height: 16),
              const Text('상세 주소',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              TextFormField(
                controller: _addressDetailController,
                decoration: const InputDecoration(
                  hintText: '상세 주소를 입력하세요',
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('우편번호', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              TextFormField(
                controller: _zipcodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '우편번호를 입력하세요',
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('경도 (Longitude)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              TextFormField(
                controller: _longitudeController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: '경도 값을 입력하세요',
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('위도 (Latitude)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              TextFormField(
                controller: _latitudeController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: '위도 값을 입력하세요',
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    mockUpdateLocation();
                  }
                },
                child: const Text('주소 저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
