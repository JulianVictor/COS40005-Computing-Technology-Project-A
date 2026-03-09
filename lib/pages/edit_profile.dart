import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, String> userData;

  const EditProfilePage({super.key, required this.userData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _selectedCountryCode = '+60';
  bool _isLoading = false;
  final SupabaseService _supabaseService = SupabaseService();

  final List<Map<String, String>> _countryCodes = [
    {'code': '+60', 'flag': '🇲🇾', 'country': 'Malaysia'},
    {'code': '+62', 'flag': '🇮🇩', 'country': 'Indonesia'},
    {'code': '+65', 'flag': '🇸🇬', 'country': 'Singapore'},
    {'code': '+66', 'flag': '🇹🇭', 'country': 'Thailand'},
    {'code': '+84', 'flag': '🇻🇳', 'country': 'Vietnam'},
    {'code': '+63', 'flag': '🇵🇭', 'country': 'Philippines'},
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill controllers with existing user data
    _firstNameController.text = widget.userData['firstName']!;
    _lastNameController.text = widget.userData['lastName']!;
    _licenseController.text = widget.userData['licenseNumber'] ?? '';

    // Extract country code and phone number
    final phone = widget.userData['phone']!;
    if (phone.startsWith('+')) {
      // Find where the country code ends (usually after 2-4 digits)
      String? extractedCode;
      for (var country in _countryCodes) {
        if (phone.startsWith(country['code']!)) {
          extractedCode = country['code'];
          _phoneController.text = phone.substring(country['code']!.length);
          break;
        }
      }
      _selectedCountryCode = extractedCode ?? '+60';
    } else {
      _phoneController.text = phone;
    }

    _emailController.text = widget.userData['email']!;
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
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D108E),
          ),
        ),
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
              // Form content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Details Box
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(128, 128, 128, 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: const Color.fromRGBO(128, 128, 128, 0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            // First Name & Last Name in one row
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _firstNameController,
                                    hintText: 'First Name',
                                    icon: Icons.person_rounded,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _lastNameController,
                                    hintText: 'Last Name',
                                    icon: Icons.person_outline_rounded,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // License Number
                            _buildTextField(
                              controller: _licenseController,
                              hintText: 'License Number',
                              icon: Icons.badge_rounded,
                            ),
                            const SizedBox(height: 16),

                            // Phone Number with Country Code
                            Row(
                              children: [
                                // Country Code Dropdown
                                Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(128, 128, 128, 0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color.fromRGBO(128, 128, 128, 0.3),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedCountryCode,
                                      isExpanded: true,
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      items: _countryCodes.map((country) {
                                        return DropdownMenuItem<String>(
                                          value: country['code'],
                                          child: Text(
                                            '${country['flag']} ${country['code']}',
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedCountryCode = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _phoneController,
                                    hintText: 'Phone Number',
                                    icon: Icons.phone_rounded,
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Email
                            _buildTextField(
                              controller: _emailController,
                              hintText: 'Email',
                              icon: Icons.email_rounded,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Info box
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D108E).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF2D108E).withOpacity(0.3),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: Color(0xFF2D108E),
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Some information like license number may not be editable for security reasons.',
                                style: TextStyle(
                                  color: Color(0xFF2D108E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
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

              // Save Changes Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D108E),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: const Color.fromRGBO(45, 16, 142, 0.3),
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.save_rounded, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color(0xFF2D108E)),
        filled: true,
        fillColor: const Color.fromRGBO(128, 128, 128, 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(128, 128, 128, 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromRGBO(128, 128, 128, 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2D108E)),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    // Basic validation
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final User? currentUser = _supabaseService.client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Update user data in Supabase - FIXED: Removed .execute()
      await _supabaseService.client
          .from('users')
          .update({
        'firstname': _firstNameController.text,
        'lastname': _lastNameController.text,
        'phonenumber': '$_selectedCountryCode${_phoneController.text}',
        'email': _emailController.text,
        if (_licenseController.text.isNotEmpty)
          'licensenumber': _licenseController.text,
      })
          .eq('userid', currentUser.id);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _licenseController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}