import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SupabaseService _supabaseService = SupabaseService();
  Map<String, String> _userData = {
    'firstName': '',
    'lastName': '',
    'phone': '',
    'email': '',
  };
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final User? currentUser = _supabaseService.client.auth.currentUser;

      if (currentUser == null) {
        setState(() {
          _errorMessage = 'User not authenticated';
          _isLoading = false;
        });
        return;
      }

      // Fetch user data from 'users' table - FIXED: Removed .execute()
      final response = await _supabaseService.client
          .from('users')
          .select()
          .eq('userid', currentUser.id)
          .single();

      if (response == null) {
        throw Exception('User data not found');
      }

      final userData = response as Map<String, dynamic>;

      setState(() {
        _userData = {
          'firstName': userData['firstname']?.toString() ?? '',
          'lastName': userData['lastname']?.toString() ?? '',
          'phone': userData['phonenumber']?.toString() ?? '',
          'email': userData['email']?.toString() ?? '',
          'licenseNumber': userData['licensenumber']?.toString() ?? '', // Add if exists
          'userId': currentUser.id,
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile: $e';
        _isLoading = false;
      });
      print('Profile load error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2D108E)),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D108E),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: Color(0xFF2D108E)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(userData: _userData),
                ),
              ).then((_) {
                // Refresh profile after editing
                _loadUserProfile();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2D108E)),
            onPressed: _loadUserProfile,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(248, 246, 255, 1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              if (_isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF2D108E),
                    ),
                  ),
                )
              else if (_errorMessage != null)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadUserProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2D108E),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Profile Header
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color:
                                const Color.fromRGBO(128, 128, 128, 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            border: Border.all(
                              color:
                              const Color.fromRGBO(128, 128, 128, 0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Profile Picture
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color:
                                  const Color(0xFF2D108E).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 40,
                                  color: Color(0xFF2D108E),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '${_userData['firstName']} ${_userData['lastName']}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D108E),
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (_userData['email']!.isNotEmpty)
                                Text(
                                  _userData['email']!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Profile Details
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color:
                                const Color.fromRGBO(128, 128, 128, 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            border: Border.all(
                              color:
                              const Color.fromRGBO(128, 128, 128, 0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Personal Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D108E),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Personal Details
                              if (_userData['firstName']!.isNotEmpty)
                                _buildProfileDetail(
                                    'First Name', _userData['firstName']!),
                              if (_userData['lastName']!.isNotEmpty)
                                _buildProfileDetail(
                                    'Last Name', _userData['lastName']!),
                              if (_userData['phone']!.isNotEmpty)
                                _buildProfileDetail(
                                    'Phone Number', _userData['phone']!),
                              if (_userData['email']!.isNotEmpty)
                                _buildProfileDetail(
                                    'Email', _userData['email']!),
                              if (_userData.containsKey('licenseNumber') &&
                                  _userData['licenseNumber']!.isNotEmpty)
                                _buildProfileDetail('License Number',
                                    _userData['licenseNumber']!),
                              const SizedBox(height: 30),
                              // Logout Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showLogoutConfirmation(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    elevation: 4,
                                    minimumSize: const Size.fromHeight(56),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.logout_rounded, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Logout',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color.fromRGBO(128, 128, 128, 0.2)),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _supabaseService.client.auth.signOut();
              Navigator.pushReplacementNamed(context, '/welcome');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}