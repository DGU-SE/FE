import 'package:flutter/material.dart';
import 'package:how_much_market/screens/product_list/search_result_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();

  List<String> recentSearches = [];
  String selectedStatus = 'unsold'; // 초기값

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  Future<void> _addSearchQuery(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!recentSearches.contains(query)) {
      recentSearches.insert(0, query);
      await prefs.setStringList('recentSearches', recentSearches);
    }
    _navigateToSearchResult(query);
  }

  Future<void> _clearRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('recentSearches');
    setState(() {
      recentSearches.clear();
    });
  }

  void _navigateToSearchResult(String query) {
    // 필터 데이터를 전달
    String minPrice =
        minPriceController.text.isEmpty ? '0' : minPriceController.text;
    String maxPrice =
        maxPriceController.text.isEmpty ? '10000000' : maxPriceController.text;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultScreen(
          searchQuery: query,
          filterStatus: selectedStatus,
          filterMinPrice: minPrice,
          filterMaxPrice: maxPrice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('검색하기'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),
            // 검색 텍스트 필드
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.015,
                ),
              ),
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  _addSearchQuery(query);
                  searchController.clear();
                }
              },
            ),
            SizedBox(height: screenHeight * 0.03),
            // 필터링 UI
            _buildFilters(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.02),
            // 최근 검색어 제목
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '최근 검색어',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: _clearRecentSearches,
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            // 최근 검색어 리스트
            Expanded(
              child: ListView.builder(
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _navigateToSearchResult(recentSearches[index]),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: Colors.grey, size: 20),
                          SizedBox(width: screenWidth * 0.02),
                          Expanded(
                            child: Text(
                              recentSearches[index],
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          IconButton(
                            icon:
                                Icon(Icons.clear, color: Colors.grey.shade600),
                            onPressed: () async {
                              recentSearches.removeAt(index);
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setStringList(
                                  'recentSearches', recentSearches);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '필터링',
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Row(
          children: [
            // 상품 상태 필터
            DropdownButton<String>(
              value: selectedStatus,
              items: ['unsold', 'sold']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
              borderRadius: BorderRadius.circular(10),
            ),
            SizedBox(width: screenWidth * 0.05),
            // 최소/최대 가격 필터
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: minPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: '최소 가격',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Flexible(
                    child: TextField(
                      controller: maxPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: '최대 가격',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
