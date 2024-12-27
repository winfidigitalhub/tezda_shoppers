import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/profile_service.dart';
import '../../widgets/custom_top_snackbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _profileImageUrl;
  File? _profileImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> userProfile = await _profileService.getUserProfile();
    setState(() {
      _nameController.text = userProfile['username'] ?? '';
      _emailController.text = userProfile['email'] ?? '';
      _profileImageUrl = userProfile['profileImageUrl'];
      _isLoading = false;
    });
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });
    await _profileService.updateProfile(
      _nameController.text,
      _emailController.text,
      _profileImage,
    );
    setState(() {
      _isLoading = false;
    });
    // Show success Snackbar
    CustomTopSnackBar.show(context, 'Profile updated successfully');
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      }
    });
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, Icon icon,
      {bool readOnly = false}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade800),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.orange.withOpacity(0.1),
        filled: true,
        prefixIcon: icon,
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 70,
          backgroundColor: Colors.orange.withOpacity(0.2),
          child: _profileImage != null
              ? ClipOval(
            child: Image.file(
              _profileImage!,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          )
              : _profileImageUrl != null && _profileImageUrl!.isNotEmpty
              ? ClipOval(
            child: Image.network(
              _profileImageUrl!,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 140,
                );
              },
            ),
          )
              : ClipOval(
            child: Image.asset(
              'assets/images/user.png',
              width: 140,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.orange.withOpacity(0.1),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent,))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              children: [
                _buildProfileImage(),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        size: 25,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildTextField(
              _nameController,
              'Name',
              const Icon(Icons.person, color: Colors.deepOrangeAccent),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              _emailController,
              'Email',
              const Icon(Icons.email, color: Colors.deepOrangeAccent),
              readOnly: true,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _updateProfile,
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                    horizontal: 70, vertical: 10),
                backgroundColor: Colors.deepOrangeAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Update Profile',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}
