import 'package:flutter/material.dart';
import 'package:how_much_market/models/comment.dart';
import 'package:how_much_market/models/product.dart';
import 'package:how_much_market/screens/product_detail/comment_registration_screen.dart';
import 'package:how_much_market/screens/product_detail/product_confirmation_screen.dart';
import 'package:how_much_market/screens/product_detail/reportScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:how_much_market/services/CommnetService.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final List<Comment> comments;

  const ProductDetailScreen({
    super.key,
    required this.comments,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavorited = false;
  List<Comment> comments = [];
  bool isLoadingComments = true;
  String baseUrl = 'http://13.125.107.235/api/product/image/';

  @override
  void initState() {
    super.initState();
    _fetchComments(); // Fetch comments when entering the screen
  }

  Future<void> _fetchComments() async {
    try {
      final String? token = await _fetchToken();
      final fetchedComments = await CommentService.fetchComments(
        widget.product.id,
        token ?? '', // Provide a default empty string if token is null
      );
      setState(() {
        comments = fetchedComments;
        isLoadingComments = false;
      });
    } catch (e) {
      print('Error fetching comments: $e');
      setState(() {
        isLoadingComments = false;
      });
    }
  }

  Future<String?> _fetchToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  @override
  Widget build(BuildContext context) {
    bool isAuction = widget.product.onAuction;

    // 화면 크기 가져오기
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    print('widget product info');
    print(widget.product.distanceKiloMeter);

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
                    widget.product.productPictures.isNotEmpty
                        ? baseUrl + widget.product.productPictures[0]['blobUrl']
                        : 'assets/images/no_image.jpg', // 기본 이미지
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // 이미지 로딩 실패 시 기본 이미지 표시
                      return Image.asset('assets/images/no_image.jpg',
                          fit: BoxFit.cover);
                    },
                  ),
                ),
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
                                      productId: widget.product.id,
                                    )),
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
                            widget.product.userName,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          Text(
                            widget.product.locationName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '거리: ${widget.product.distanceKiloMeter.toStringAsFixed(3)} km',
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
                        () {
                          if (isAuction) {
                            // 경매인 경우
                            switch (widget.product.productStatus) {
                              case 'unsold':
                                return '경매중 ';
                              case 'no_bids':
                                return '경매 유찰 ';
                              case 'auction_ended':
                                return '경매 종료 (인도 대기) ';
                              case 'sold':
                                return '경매 완료 ';
                              default:
                                return '';
                            }
                          } else {
                            // 일반 판매인 경우
                            switch (widget.product.productStatus) {
                              case 'unsold':
                                return '판매중 ';
                              case 'sold':
                                return '판매 완료 ';
                              default:
                                return '';
                            }
                          }
                        }(),
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
                    DateFormat('yyyy년 MM월 d일 HH시 mm분 ss초')
                        .format(DateTime.parse(widget.product.regTime)),
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
                  if (widget.product.onAuction)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '현재가',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${widget.product.currentPrice} 원',
                          style: TextStyle(
                            fontSize: screenWidth * 0.07,
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  if (widget.product.onAuction)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2), // 필요한 경우 상하 패딩 조정
                          child: Text(
                            '경매 마감 일자',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color: Colors.grey,
                              height: 1, // 라인 높이를 1로 설정
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2), // 필요한 경우 상하 패딩 조정
                          child: Text(
                            DateFormat('yyyy년 MM월 d일 HH시 mm분 ss초').format(
                                DateTime.parse(widget.product.auctionEndTime)),
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
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
                                onCommentRegistered: () {
                                  _fetchComments(); // 댓글이 등록되면 댓글 목록을 다시 불러옴
                                },
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

// 댓글 리스트뷰 생성
                  comments.isNotEmpty
                      ? ListView.separated(
                          // ListView.builder 대신 ListView.separated 사용
                          itemCount: comments.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16), // 댓글 사이 여백
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return _buildComment(
                              'assets/images/user_profile.png',
                              comment.userName,
                              comment.content,
                            );
                          },
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        )
                      : const Text('댓글이 없습니다.'),

                  SizedBox(height: screenHeight * 0.1),
                  // 응찰하기 or 구매하기 버튼
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // 경매 완료됐고 입찰자가 있을 경우
                        if (isAuction &&
                            widget.product.productStatus == "auction_ended") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductPurchaseConfirmationScreen(
                                      product: widget.product),
                            ),
                          );
                        } else if (isAuction &&
                            widget.product.productStatus == "no_bids") {
                          // 경매가 유찰되었을 때
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('유찰된 상품입니다.')),
                          );
                        } else if (isAuction) {
                          // 경매 진행중인 경우
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductBidConfirmationScreen(
                                      product: widget.product),
                            ),
                          );
                        } else {
                          // 상품 구매할 때
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
                        isAuction &&
                                widget.product.productStatus == "auction_ended"
                            ? "경매종료"
                            : (isAuction &&
                                    widget.product.productStatus == "no_bids"
                                ? "유찰된 상품"
                                : (isAuction ? '응찰하기' : '구매하기')),
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
