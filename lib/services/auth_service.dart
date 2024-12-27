import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/auth_screens/login.dart';
import '../widgets/page_transition_builder.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }


  Future<User?> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _storeUserData(
        userID: userCredential.user!.uid,
        username: username,
        email: email,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle registration errors
      print('Registration error: ${e.message}');
      return null;
    }
  }

  Future<void> _storeUserData({
    required String userID,
    required String username,
    required String email,
  }) async {
    try {
      await _firestore.collection('users').doc(userID).set({
        'userID': userID,
        'username': username,
        'email': email,
        'profilePicture': '',
        'shippingAddress': '',
        'location': '',
        'privilege': 'customer', // You can modify this based on your needs
      });
    } catch (e) {
      print('Error storing user data: $e');
    }
  }


  // Sign out
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushReplacement(PageTransition.createPageRoute(LoginPage()));
    } catch (e) {
      print('Error during sign out: $e');
      // Display a snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign Out Failed. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
