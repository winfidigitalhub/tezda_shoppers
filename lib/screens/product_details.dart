import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/product_model.dart';
import '../services/cart_service.dart';
import '../services/favorites_service.dart';
import '../widgets/custom_top_snackbar.dart';
import '../widgets/product_detail_screen_widget/custom_bottom_navigation.dart';
import '../widgets/product_detail_screen_widget/product_color_selection.dart';
import '../widgets/product_detail_screen_widget/product_description_widget.dart';
import '../widgets/product_detail_screen_widget/product_size_selector.dart';
import '../widgets/product_detail_screen_widget/ratings_widget.dart';
import '../widgets/product_detail_screen_widget/star_widget_builder.dart';
import 'homescreen/cart_page.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  final double highestRating;

  const ProductDetail({Key? key, required this.product, required this.highestRating}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetail> with SingleTickerProviderStateMixin {
  String? selectedColor;
  String? selectedSize;
  late CartService cartService;
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isAnimating = false;
  bool isFavorited = false;
  FavoritesService favoritesService = FavoritesService();


  @override
  void initState() {
    super.initState();
    cartService = CartService();
    _checkIfFavorited();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkIfFavorited() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;
      DocumentSnapshot favoriteSnapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .doc(userId)
          .get();

      if (favoriteSnapshot.exists) {
        Map<String, dynamic> favoritesData = favoriteSnapshot.data() as Map<String, dynamic>;
        if (favoritesData.containsKey('products')) {
          List<dynamic> productsData = favoritesData['products'];
          for (var productData in productsData) {
            Product product = Product.fromJson(productData);
            if (product.id == widget.product.id) {
              setState(() {
                isFavorited = true;
              });
              break;
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepOrangeAccent),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [

          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
              icon: Image.asset(
                'assets/images/cart.png',
                color: Colors.deepOrangeAccent,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.product.image,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: double.infinity,
                      height: 350,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: widget.product.availableColors.map((colorName) {
                              return Container(
                                width: 15,
                                height: 15,
                                margin: const EdgeInsets.only(right: 4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        ColorSelectionWidget(
                          availableColors: widget.product.availableColors,
                          onColorSelected: (selectedColor) {
                            setState(() {
                              this.selectedColor = selectedColor;
                              print(selectedColor);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.product.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepOrangeAccent,
                ),
              ),
              const SizedBox(height: 10),
              RatingWidget(
                rating: widget.highestRating,
                numberOfReviews: widget.product.rating.count,
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 8),
                    child: Text(
                      'Size',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizeSelector(
                    availableSizes: widget.product.availableSizes!,
                    onSizeSelected: (selectedSize) {
                      setState(() {
                        this.selectedSize = selectedSize;
                        print(this.selectedSize);
                      });
                    },
                  ),
                ],
              ),
              ShoeDescriptionWidget(description: widget.product.description),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: widget.product.reviews.take(3).map((review) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ReviewItem(review: review),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Builder(
        builder: (context) => CustomBottomNavigationBar(
          price: widget.product.price,
          onAddToCartPressed: () async {
            await cartService.addProductToCart(widget.product);
            CustomTopSnackBar.show(context, '${widget.product.title} added to cart successfully.');
          },
        ),
      ),
    );
  }
}

class ReviewItem extends StatefulWidget {
  final RatingReview review;

  const ReviewItem({Key? key, required this.review}) : super(key: key);

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 2,
            leading: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset('assets/images/user.png').image,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.review.reviewerName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StarRatingWidget(rating: widget.review.rating),
                const SizedBox(height: 10),
                Text(
                  widget.review.reviewText,
                  style: const TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.visible,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


