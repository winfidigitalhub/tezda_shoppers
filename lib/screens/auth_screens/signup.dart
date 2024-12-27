import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_top_snackbar.dart';
import '../../widgets/page_transition_builder.dart';
import '../homescreen/product_screen.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  late AnimationController _slideAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _error;
  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    _slideAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 5.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 5.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideAnimationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _slideAnimationController.forward();
    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery
              .of(context)
              .size
              .height - 50,
          width: double.infinity,
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _header(),
                  _inputField(),
                  _isLoading ? _buildLoadingWidget() : _signupButton(),
                  if (_error != null) _buildErrorWidget(),
                  _loginLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return const Column(
      children: <Widget>[
        SizedBox(height: 60.0),
        Text(
          "Tezda shoppers.uk",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrangeAccent,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Create your account today",
          style: TextStyle(fontSize: 20, color: Colors.deepOrangeAccent),
        )
      ],
    );
  }

  Widget _signupButton() {
    return Container(
      padding: const EdgeInsets.only(top: 3, left: 3),
      child: ElevatedButton(
        onPressed: () {
          _registerUser();
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.only(
              right: 70, left: 70, top: 10, bottom: 10),
          backgroundColor: Colors.deepOrangeAccent,
          foregroundColor: Colors.white,
        ),
        child: const Text(
          "Sign up",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _inputField() {
    return Column(
      children: <Widget>[
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: "Username",
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person, color: Colors.deepOrangeAccent),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Email",
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.email, color: Colors.deepOrangeAccent),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.lock, color: Colors.deepOrangeAccent),
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.deepOrangeAccent,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
          obscureText: !_passwordVisible,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            hintText: "Confirm Password",
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.lock, color: Colors.deepOrangeAccent),
            suffixIcon: IconButton(
              icon: Icon(
                _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.deepOrangeAccent,
              ),
              onPressed: () {
                setState(() {
                  _confirmPasswordVisible = !_confirmPasswordVisible;
                });
              },
            ),
          ),
          obscureText: !_confirmPasswordVisible,
        ),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return const SizedBox(
      height: 40.0,
      width: 40.0,
      child: CircularProgressIndicator(
        color: Colors.deepOrangeAccent,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        _error!,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _loginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text("Already have an account?"),
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).push(PageTransition.createPageRoute(LoginPage()));
          },
          child: const Text(
              "Login", style: TextStyle(color: Colors.deepOrangeAccent)),
        ),
      ],
    );
  }

  void _registerUser() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final String confirmPassword = _confirmPasswordController.text.trim();
      final String username = _usernameController.text.trim();

      if (password != confirmPassword) {
        setState(() {
          _error = "Passwords do not match";
          _isLoading = false;
        });
        return;
      }

      User? user = await AuthService().registerUser(
        username: username,
        email: email,
        password: password,
      );

      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ProductScreen()),
        );

        // Show success Snackbar
        CustomTopSnackBar.show(context, 'Registration successful! Welcome to Shoesly.');
      } else {
        setState(() {
          _error = "Please add your details to register";
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error during user registration: $e');
      setState(() {
        _error = "An unexpected error occurred";
        _isLoading = false;
      });
    }
  }

  }

