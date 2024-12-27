import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tezda_app/screens/app_theme/app_bar_theme.dart';
import 'package:tezda_app/screens/auth_screens/login.dart';
import 'package:tezda_app/screens/auth_screens/signup.dart';
import 'package:tezda_app/screens/homescreen/product_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        '/home': (context) => ProductScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => SignupPage(),
      },
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      home: const AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user == null) {
            // User is not signed in, navigate to login
            return const LoginPage();
          } else {
            // User is signed in, navigate to home
            return const ProductScreen();
          }
        }

        // Show loading indicator while checking authentication state
        return const SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            color: Colors.deepOrangeAccent,
          ),
        );
      },
    );
  }
}
