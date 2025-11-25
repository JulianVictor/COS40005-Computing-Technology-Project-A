import 'package:flutter/material.dart';
import 'reset_password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import 'home.dart';

class LoginPage extends StatefulWidget { // CHANGED to StatefulWidget
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailOrPhoneController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Dummy credentials
  //final String _dummyPhone = '0174865555';
  //final String _dummyPassword = 'dmcocoa';

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
                // BACK BUTTON
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: const Color(0xFF2D108E),
                    ),
                  ],
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                // Logo
                Image.asset(
                  'lib/assets/images/login.png',
                  height: 150,
                ),
                const SizedBox(height: 40),

                // Title
                const Text(
                  'Login to Your Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D108E),
                  ),
                ),
                const SizedBox(height: 40),

                // Phone Number Field
                      TextField(
                        controller: _emailOrPhoneController,
                        keyboardType: TextInputType.text, // Changed from phone
                        decoration: InputDecoration(
                          hintText: 'Email or Phone Number',
                          prefixIcon: const Icon(Icons.email_rounded, color: Color(0xFF2D108E)),
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
                ),
                const SizedBox(height: 16),

                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock_rounded, color: Color(0xFF2D108E)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: const Color(0xFF2D108E),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
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
                ),

                // Forgot Password
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF2D108E),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D108E),
                      foregroundColor: Colors.white,
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
                        : const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
    ));

  }

  void _handleLogin() async {
    final input = _emailOrPhoneController.text.trim();
    final password = _passwordController.text.trim();

    print('=== LOGIN ATTEMPT ===');
    print('Input: $input');
    print('Password: $password');

    if (input.isEmpty || password.isEmpty) {
      _showError('Please enter both email/phone and password');
      return;
    }

    setState(() { _isLoading = true; });

    try {
      final supabase = SupabaseService();
      String? userEmail;

      final isEmail = input.contains('@');
      print('Is email: $isEmail');

      if (isEmail) {
        // Try direct login with email
        userEmail = input;
        print('Using email directly: $userEmail');

        final userData = await supabase.client
            .from('users')
            .select('accountstatus')
            .eq('email', userEmail!)
            .maybeSingle();

        print('Email user data: $userData');

        if (userData != null && userData['accountstatus'] != 'approved') {
          _showError('Account pending admin approval. Please wait for approval.');
          setState(() { _isLoading = false; });
          return;
        }
      } else {
        // Input is phone number - find user by phone
        final phone = input.replaceAll(RegExp(r'[-\s]'), '');

        // Add country code if missing (since registration saves with +60)
        String phoneToSearch = phone;
        if (!phone.startsWith('+')) {
          phoneToSearch = '+60$phone'; // Add Malaysia country code
        }

        print('Searching for phone: $phoneToSearch');

        final userData = await supabase.client
            .from('users')
            .select('email, accountstatus, phonenumber')
            .eq('phonenumber', phoneToSearch)
            .maybeSingle();

        print('Found user data: $userData');

        if (userData != null) {
          userEmail = userData['email'];

          // ✅ UPDATED: Only allow login if status is 'approved'
          if (userData['accountstatus'] != 'approved') {
            _showError('Account pending admin approval. Please wait for approval.');
            setState(() { _isLoading = false; });
            return;
          }
        }else {
          _showError('No account found with this phone number');
          setState(() { _isLoading = false; });
          return;
        }
      }

      // If userEmail is null, it means user registered with phone only
      if (userEmail == null) {
        _showError('Please use your registered email to login, or contact support.');
        setState(() { _isLoading = false; });
        return;
      }

      print('Attempting login with email: $userEmail');

      // Attempt login
      final AuthResponse authResponse = await supabase.client.auth.signInWithPassword(
        email: userEmail,
        password: password,
      );

      if (authResponse.user != null) {
        print('Login successful!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      print('Login error: $e');
      _showError('Invalid email/phone or password. Please try again.');
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}