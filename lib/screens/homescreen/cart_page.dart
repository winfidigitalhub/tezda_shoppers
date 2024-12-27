import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../model/product_model.dart';
import '../../services/cart_service.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  Future<List<Product>>? _cartProducts;

  @override
  void initState() {
    super.initState();
    _cartProducts = _cartService.fetchCartProducts();
  }

  void _removeProduct(Product product) async {
    await _cartService.removeProductFromCart(product);
    setState(() {
      _cartProducts = _cartService.fetchCartProducts();
    });
  }

  double _calculateTotal(List<Product> products) {
    return products.fold(0.0, (total, product) => total + product.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.withOpacity(0.1),
        title: const Text('My Cart'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _cartProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(
              color: Colors.deepOrangeAccent,
              strokeWidth: 3,
            ),);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          } else {
            List<Product> cartProducts = snapshot.data!;
            double total = _calculateTotal(cartProducts);

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProducts.length,
                    itemBuilder: (context, index) {
                      Product product = cartProducts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: product.image,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(
                                  color: Colors.deepOrangeAccent,
                                  strokeWidth: 3,
                                ),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                          title: Text(
                            product.title,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
                          ),
                          subtitle: Text('\$${product.price.toStringAsFixed(2)}', style:
                            TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.remove_shopping_cart,
                              color: Colors.red,
                            ),
                            onPressed: () => _removeProduct(product),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Total Payment: \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent),
                        onPressed: () {
                          // Handle checkout action here
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                          child: Text('Proceed to Checkout', style: TextStyle(color: Colors.white, fontSize: 16),),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
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
