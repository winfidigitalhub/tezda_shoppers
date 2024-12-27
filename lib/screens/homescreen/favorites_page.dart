import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../model/product_model.dart';
import '../../services/favorites_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesService _favoritesService = FavoritesService();
  Future<List<Product>>? _favoritesProducts;

  @override
  void initState() {
    super.initState();
    _favoritesProducts = _favoritesService.fetchFavoritesProducts();
  }

  void _removeProduct(Product product) async {
    await _favoritesService.removeProductFromFavorites(product);
    setState(() {
      _favoritesProducts = _favoritesService.fetchFavoritesProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: Colors.orange.withOpacity(0.1),
      ),
      body: FutureBuilder<List<Product>>(
        future: _favoritesProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Your favorites list is empty'));
          } else {
            List<Product> favoriteProducts = snapshot.data!;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: favoriteProducts.length,
                    itemBuilder: (context, index) {
                      Product product = favoriteProducts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: product.image,
                            placeholder: (context, url) => const CircularProgressIndicator(
                              color: Colors.deepOrangeAccent,
                              strokeWidth: 3,
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                          title: Text(
                            product.title,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('\$${product.price.toStringAsFixed(2)}', style:
                          const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.deepOrangeAccent,
                            ),
                            onPressed: () => _removeProduct(product),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
