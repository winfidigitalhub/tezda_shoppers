import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> updateProfile(String username, String email, File? profileImage) async {
    User? user = _auth.currentUser;

    if (user != null) {
      String? imageUrl;

      if (profileImage != null) {
        String fileName = 'profile_pictures/${user.uid}.jpg';
        UploadTask uploadTask = _storage.ref().child(fileName).putFile(profileImage);
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      await user.updateDisplayName(username);
      await user.updatePhotoURL(imageUrl);

      await _firestore.collection('users').doc(user.uid).update({
        'username': username,
        'profileImageUrl': imageUrl,
      });
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      return userDoc.data() as Map<String, dynamic>;
    }
    return {};
  }
}
