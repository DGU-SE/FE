import 'package:flutter/material.dart';
import 'package:how_much_market/models/comment.dart';
import 'package:how_much_market/models/product.dart';
import 'package:how_much_market/screens/product_detail/comment_registration_screen.dart';
import 'package:how_much_market/screens/product_detail/product_confirmation_screen.dart';
import 'package:how_much_market/screens/product_detail/reportScreen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final List<Comment> comments; // 댓글 리스트 추가

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.comments, // 댓글 데이터 받기
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavorited = false;
  String baseUrl = 'http://13.125.107.235/api/product/image/';

  @override
  Widget build(BuildContext context) {
    bool isAuction = widget.product.onAuction;

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
                    background: Image.network(
                  widget.product.productPictures.isNotEmpty &&
                          widget.product.productPictures[0]['blobUrl'] != null
                      ? baseUrl + widget.product.productPictures[0]['blobUrl']
                      : 'assets/no_image.jpg',
                  fit: BoxFit.cover,
                )),
                Positioned(
                  right: 16,
                  top: 16,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.report_gmailerrorred_outlined,
                          color: Colors.redAccent,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportScreen(
                                    postTitle: widget.product.name,
                                    userName: widget.product.locationName)),
                          );
                        },
                      ),
                      IconButton(
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
                    ],
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
                            widget.product.locationName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '거리: ${widget.product.distanceKiloMeter} km',
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
                          widget.product.name,
                          style: TextStyle(
                            fontSize: screenWidth * 0.055,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.product.regTime,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // 상품 가격
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isAuction ? '경매 시작가' : '가격',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${widget.product.price} 원',
                        style: TextStyle(
                          fontSize: screenWidth * 0.07,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // 상품 설명
                  Text(
                    widget.product.productDetail,
                    style: TextStyle(fontSize: screenWidth * 0.045),
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
                                productTitle: widget.product.name,
                                productId: widget.product.id,
                              ),
                            ),
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

                  // 댓글 위젯 생성
                  ...widget.comments.isNotEmpty
                      ? widget.comments.map((comment) {
                          return _buildComment(
                            'assets/images/user_profile.png',
                            comment.userId,
                            comment.secret ? '비밀 댓글입니다.' : comment.content,
                          );
                        }).toList()
                      : [const Text('댓글이 없습니다.')],

                  SizedBox(height: screenHeight * 0.1),

                  // 응찰하기 or 구매하기 버튼
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
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
        Expanded(
          // 텍스트를 Expanded로 감싸기
          child: Column(
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
        ),
      ],
    );
  }
}
