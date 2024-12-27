import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/product_model.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> favoriteProduct(Product product) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is currently logged in");
      }
      String userId = currentUser.uid;

      Map<String, dynamic> productMap = product.toMap();

      DocumentReference favoriteRef = _firestore.collection('favorites').doc(userId);
      DocumentSnapshot favoritesSnapshot = await favoriteRef.get();

      if (favoritesSnapshot.exists) {
        await favoriteRef.update({
          'products': FieldValue.arrayUnion([productMap])
        });
      } else {
        await favoriteRef.set({
          'products': [productMap]
        });
      }

      print('Product added to favorites successfully');
    } catch (e) {
      print('Error adding product to favorites: $e');
    }
  }

  Future<List<Product>> fetchFavoritesProducts() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("No user is currently logged in");
    }
    String userId = currentUser.uid;

    DocumentReference favoriteRef = _firestore.collection('favorites').doc(userId);
    DocumentSnapshot favoriteSnapshot = await favoriteRef.get();

    if (!favoriteSnapshot.exists) {
      return [];
    }

    Map<String, dynamic> favoritesData = favoriteSnapshot.data() as Map<String, dynamic>;
    if (!favoritesData.containsKey('products')) {
      return [];
    }

    List<dynamic> productsData = favoritesData['products'];
    return productsData.map((data) => Product.fromJson(data)).toList();
  }

  Future<void> removeProductFromFavorites(Product product) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is currently logged in");
      }
      String userId = currentUser.uid;

      Map<String, dynamic> productMap = product.toMap();

      DocumentReference favoriteRef = _firestore.collection('favorites').doc(userId);
      await favoriteRef.update({
        'products': FieldValue.arrayRemove([productMap])
      });

      print('Product removed from cart successfully');
    } catch (e) {
      print('Error removing product from cart: $e');
    }
  }
}