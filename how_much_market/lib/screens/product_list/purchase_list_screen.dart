import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class PurchasedTransactionsScreen extends StatefulWidget {
  const PurchasedTransactionsScreen({super.key});

  @override
  _PurchasedTransactionsScreenState createState() =>
      _PurchasedTransactionsScreenState();
}

class _PurchasedTransactionsScreenState
    extends State<PurchasedTransactionsScreen> {
  List<dynamic> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPurchasedTransactions();
  }

  Future<void> _fetchPurchasedTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('http://13.125.107.235/api/transaction/purchased'),
        headers: {
          'Authorization': 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _transactions = json.decode(utf8.decode(response.bodyBytes));
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 구매 내역'),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                final product = transaction['product'];
                final sellerId = transaction['sellerId'];

                final String imageUrl = product['productPictures'] != null &&
                        product['productPictures'].isNotEmpty
                    ? product['productPictures'][0]['blobUrl']
                    : '';
                final String fullImageUrl =
                    'http://13.125.107.235/api/product/image/$imageUrl';

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading: imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              fullImageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Icon(Icons.image,
                                size: 40, color: Colors.grey),
                          ),
                    title: Text(
                      product['name'] ?? 'Unknown Product',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '최종가 : ${transaction['finalPrice']}원',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          '판매자 ID: $sellerId',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14.0,
                          ),
                        ),
                        transaction['status'] == 'completed'
                            ? Container(
                                margin: const EdgeInsets.only(top: 4.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Text(
                                  '거래완료',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                ),
                              )
                            : Text(
                                'Status: ${transaction['status']}',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14.0,
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
