import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/product_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProductToCart(Product product) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is currently logged in");
      }
      String userId = currentUser.uid;

      Map<String, dynamic> productMap = product.toMap();

      DocumentReference cartRef = _firestore.collection('carts').doc(userId);
      DocumentSnapshot cartSnapshot = await cartRef.get();

      if (cartSnapshot.exists) {
        await cartRef.update({
          'products': FieldValue.arrayUnion([productMap])
        });
      } else {
        await cartRef.set({
          'products': [productMap]
        });
      }

      print('Product added to cart successfully');
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  Future<List<Product>> fetchCartProducts() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("No user is currently logged in");
    }
    String userId = currentUser.uid;

    DocumentReference cartRef = _firestore.collection('carts').doc(userId);
    DocumentSnapshot cartSnapshot = await cartRef.get();

    if (!cartSnapshot.exists) {
      return [];
    }

    Map<String, dynamic> cartData = cartSnapshot.data() as Map<String, dynamic>;
    if (!cartData.containsKey('products')) {
      return [];
    }

    List<dynamic> productsData = cartData['products'];
    return productsData.map((data) => Product.fromJson(data)).toList();
  }

  Future<void> removeProductFromCart(Product product) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is currently logged in");
      }
      String userId = currentUser.uid;

      Map<String, dynamic> productMap = product.toMap();

      DocumentReference cartRef = _firestore.collection('carts').doc(userId);
      await cartRef.update({
        'products': FieldValue.arrayRemove([productMap])
      });

      print('Product removed from cart successfully');
    } catch (e) {
      print('Error removing product from cart: $e');
    }
  }
}