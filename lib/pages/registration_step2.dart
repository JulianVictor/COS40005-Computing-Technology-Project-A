import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import 'registration_step3.dart';
import 'package:flutter/material.dart';


class RegistrationStep2 extends StatefulWidget {
  const RegistrationStep2({super.key});

  @override
  State<RegistrationStep2> createState() => _RegistrationStep2State();
}

class _RegistrationStep2State extends State<RegistrationStep2> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  //final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _selectedCountryCode = '+60';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<Map<String, String>> _countryCodes = [
    {'code': '+60', 'flag': '🇲🇾', 'country': 'Malaysia'},
    {'code': '+62', 'flag': '🇮🇩', 'country': 'Indonesia'},
    {'code': '+65', 'flag': '🇸🇬', 'country': 'Singapore'},
    {'code': '+66', 'flag': '🇹🇭', 'country': 'Thailand'},
    {'code': '+84', 'flag': '🇻🇳', 'country': 'Vietnam'},
    {'code': '+63', 'flag': '🇵🇭', 'country': 'Philippines'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
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
                // Back button and progress indicator
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: const Color(0xFF2D108E),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Step 2 of 3',
                      style: TextStyle(
                        color: Color(0xFF2D108E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Main title
                const Column(
                  children: [
                    Text(
                      'Step 2',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Enter User Details',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D108E),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Form content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // User Details Box
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

                              // Phone Number with Country Code
                              Row(
                                children: [
                                  // Country Code Dropdown
                                  Container(
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          128, 128, 128, 0.05),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            128, 128, 128, 0.3),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedCountryCode,
                                        isExpanded: true,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        items: _countryCodes.map((country) {
                                          return DropdownMenuItem<String>(
                                            value: country['code'],
                                            child: Text(
                                              '${country['flag']} ${country['code']}',
                                              style: const TextStyle(
                                                  fontSize: 14),
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

                              // Email (Optional)
                              _buildTextField(
                                controller: _emailController,
                                hintText: 'Email (Optional)',
                                icon: Icons.email_rounded,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),

                              // Password
                              _buildPasswordField(
                                controller: _passwordController,
                                hintText: 'Password',
                                obscureText: _obscurePassword,
                                onToggle: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // Confirm Password
                              _buildPasswordField(
                                controller: _confirmPasswordController,
                                hintText: 'Confirm Password',
                                obscureText: _obscureConfirmPassword,
                                onToggle: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),

                // Create Account Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _createAccount();
                    },
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.check_circle_rounded, size: 20),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Login section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color.fromRGBO(128, 128, 128, 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          // Navigate to LoginPage()
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(45, 16, 142, 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              color: Color(0xFF2D108E),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
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
          borderSide: const BorderSide(
              color: Color.fromRGBO(128, 128, 128, 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Color.fromRGBO(128, 128, 128, 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2D108E)),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.lock_rounded, color: Color(0xFF2D108E)),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off_rounded : Icons
                .visibility_rounded,
            color: const Color(0xFF2D108E),
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color.fromRGBO(128, 128, 128, 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Color.fromRGBO(128, 128, 128, 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Color.fromRGBO(128, 128, 128, 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2D108E)),
        ),
      ),
    );
  }

// _createAccount method
  void _createAccount() async {
    // 1. Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
      const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // 2. Password match validation
      if (_passwordController.text != _confirmPasswordController.text) {
        Navigator.pop(context); // Remove loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // 3. Basic validation
      if (_firstNameController.text.isEmpty ||
          _lastNameController.text.isEmpty ||
          _phoneController.text.isEmpty ||
          _passwordController.text.isEmpty) {
        Navigator.pop(context); // Remove loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all required fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final supabase = SupabaseService();

      final AuthResponse authResponse = await supabase.client.auth.signUp(
        email: _emailController.text.isNotEmpty
            ? _emailController.text
            : '${_phoneController.text}@cocoafarm.com',
        password: _passwordController.text,
      );

      if (authResponse.user != null) {
        await supabase.client.from('users').insert({
          'userid': authResponse.user!.id,
          'firstname': _firstNameController.text,
          'lastname': _lastNameController.text,
          'email': _emailController.text.isNotEmpty
              ? _emailController.text
              : null,
          'phonenumber': '$_selectedCountryCode${_phoneController.text}',
          'role': 'farmer',
          'accountstatus': 'pending_approved',
        });

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegistrationStep3()),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      print('Registration error: $e');
    }
  }
}