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
  List<String> recentSearches = [];

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultScreen(searchQuery: query),
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
            // 최근 검색어 제목과 삭제 버튼
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
}
