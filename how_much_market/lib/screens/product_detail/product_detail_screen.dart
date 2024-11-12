import 'package:flutter/material.dart';
import 'package:how_much_market/screens/product_detail/comment_registration_screen.dart';
import 'package:how_much_market/screens/product_detail/product_confirmation_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    bool isAuction = widget.product['saleType'] == 'auction';

    // 화면 크기 가져오기
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 상단 이미지
          SliverAppBar(
            expandedHeight: screenHeight * 0.4,
            flexibleSpace: Stack(
              children: [
                FlexibleSpaceBar(
                  background: Image.asset(
                    widget.product['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: const Color.fromARGB(230, 255, 128, 128),
                      size: 28,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorited = !isFavorited;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 사용자 정보
                  Row(
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.07,
                        backgroundImage: const AssetImage(
                            'assets/images/user_profile.png'), // 프로필 이미지
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product['userName'] ?? '사용자 이름',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            widget.product['userLocation'] ?? '위치 정보 없음',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  // 상품 제목
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAuction ? '경매중 ' : '판매중 ',
                        style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          widget.product['title'],
                          style: TextStyle(
                            fontSize: screenWidth * 0.055,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2, // 최대 줄 수를 2줄로 제한
                          overflow:
                              TextOverflow.ellipsis, // 글자가 너무 길면 "..."로 생략
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "10분 전", // 상품이 올라온 시간
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // 상품 가격 (숫자 강조)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isAuction) ...[
                            Text(
                              '경매 시작가',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            Text(
                              '현재 최고가',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.black87,
                              ),
                            ),
                          ] else ...[
                            Text(
                              '가격',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (isAuction) ...[
                            Text(
                              widget.product['auctionStartPrice'], // 경매 시작가 값
                              style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            Text(
                              widget.product['highestBid'], // 현재 최고가 값
                              style: TextStyle(
                                fontSize: screenWidth * 0.07,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ] else ...[
                            Text(
                              widget.product['price'], // 가격 값
                              style: TextStyle(
                                fontSize: screenWidth * 0.07,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // 상품 설명
                  Text(
                    widget.product['description'] ?? '상품 설명이 없습니다.',
                    style: TextStyle(fontSize: screenWidth * 0.045),
                  ),
                  SizedBox(height: screenHeight * 0.06),

                  // 거래 희망 장소
                  Text(
                    '거래 희망 장소:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Container(
                    height: screenHeight * 0.3,
                    color: Theme.of(context).cardColor,
                    child: Center(
                      child: Text(
                        '지도 위치 (곧 업데이트 예정)',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),

                  // 댓글 목록 및 댓글 등록 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '댓글',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentRegistrationScreen(
                                      productTitle:
                                          "${widget.product['title']}",
                                    )),
                          );
                        },
                        child: Text(
                          '댓글 등록하기',
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildComment(
                      'assets/images/user_profile.png', '사용자1', '좋은 상품이네요!'),
                  SizedBox(height: screenHeight * 0.015),
                  _buildComment(
                      'assets/images/user_profile.png', '사용자2', '가격이 마음에 들어요!'),

                  SizedBox(height: screenHeight * 0.1),

                  // 응찰하기 or 구매하기 버튼
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // isAuction에 따라 다른 화면으로 이동
                        if (isAuction) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductBidConfirmationScreen(
                                      product: widget.product),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductPurchaseConfirmationScreen(
                                      product: widget.product),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.25,
                          vertical: screenHeight * 0.015,
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isAuction ? '응찰하기' : '구매하기',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 댓글 위젯
  Widget _buildComment(String imageUrl, String username, String comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(imageUrl),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              comment,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ],
    );
  }
}
