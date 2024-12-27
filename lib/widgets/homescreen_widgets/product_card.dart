import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/product_model.dart';
import '../../screens/product_details.dart';
import '../../services/favorites_service.dart';
import '../page_transition_builder.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorited = false;
  FavoritesService favoritesService = FavoritesService();

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
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

  Future<void> _toggleFavorite() async {
    if (isFavorited) {
      await favoritesService.removeProductFromFavorites(widget.product);
    } else {
      await favoritesService.favoriteProduct(widget.product);
    }
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.withOpacity(0.1),
      elevation: 0,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageTransition.createPageRoute(
              ProductDetail(
                product: widget.product.toDetails(),
                highestRating: widget.product.rating.rate,
              ),
            ),
          );
        },
        child: Wrap(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10.0),
                    bottom: Radius.circular(10.0),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.product.image,
                    placeholder: (context, url) => const Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 30.0,
                        width: 30.0,
                        child: CircularProgressIndicator(
                          color: Colors.deepOrangeAccent,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: Colors.orange,
                      size: 30,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        '${widget.product.rating.rate}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        '(${widget.product.rating.count} Reviews)',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    '\$${widget.product.price.toString()}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}