import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tezda_app/screens/auth_screens/signup.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_top_snackbar.dart';
import '../../widgets/page_transition_builder.dart';
import '../homescreen/product_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  final _auth = AuthService();


  bool _passwordVisible = false;
  bool _isLoading = false;
  String? _error;

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
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      body: Container(
        margin: const EdgeInsets.all(24),
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                _header(context),
                _inputField(context),
                _isLoading ? _buildLoadingWidget() : _loginButton(),
                _error != null ? _buildErrorWidget() : Container(),
                _signup(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(context) {
    return const Column(
      children: [
        Text(
          "Welcome back to tezda shoppers.uk",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrangeAccent),
        ),
        SizedBox(height: 20,),
        Text(
          "Enter your credentials to login", style: TextStyle(fontSize: 20, color: Colors.deepOrangeAccent),),
      ],
    );
  }

  Widget _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: "Username",
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person, color: Colors.deepOrangeAccent,),
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
                borderSide: BorderSide.none
            ),
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.lock, color: Colors.deepOrangeAccent,),
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
      ],
    );
  }

  Widget _loginButton() {
    return Container(
      padding: const EdgeInsets.only(top: 3, left: 3),
      child: ElevatedButton(
        onPressed: _performLogin,
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.only(
              right: 70, left: 70, top: 10, bottom: 10),
          backgroundColor: Colors.deepOrangeAccent,
          foregroundColor: Colors.white,
        ),
        child: const Text(
          "Login",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account yet? "),
        const SizedBox(width: 10,),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).push(
                PageTransition.createPageRoute(SignupPage()));
          },
          child: const Text(
            "Sign Up", style: TextStyle(color: Colors.deepOrangeAccent),),
        )
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
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  void _performLogin() async {
    setState(() {
      _isLoading = true;
      // Clear previous error
      _error = null;
    });

    try {
      // Validate the input fields
      if (_usernameController.text.isEmpty ||
          _passwordController.text.isEmpty) {
        // Display an error message
        _setError("Please enter both username and password.");
        return;
      }

      // Perform login
      User? user = await _auth.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      ).onError((error, stackTrace) {
        print(error);
      });

      if (user != null) {
        // Navigate to the HomeScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ProductScreen()),
        );

        // Show success Snackbar
        CustomTopSnackBar.show(context, 'Login successful!  Welcome back.');
      } else {
        // Handle unsuccessful login
        _setError("Login failed. Please check your credentials.");
      }
    } catch (e) {
      // Handle exceptions during login
      _setError(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  void _setError(String error) {
    setState(() {
      _error = error;
    });
  }
}
