import 'package:flutter/material.dart';
import 'reset_password.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/login.png',
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

                // Email Field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Phone Number (e.g.: 0128888888)',
                    prefixIcon: const Icon(Icons.person_rounded, color: Color(0xFF2D108E)),
                    filled: true,
                    fillColor: const Color.fromRGBO(128, 128, 128, 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color.fromRGBO(128, 128, 128, 0.3)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Field
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock_rounded, color: Color(0xFF2D108E)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility_off_rounded, color: Color(0xFF2D108E)),
                      onPressed: () {},
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(128, 128, 128, 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color.fromRGBO(128, 128, 128, 0.3)),
                    ),
                  ),
                ),

                // Forgot Password - ADD THIS SECTION
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
                    onPressed: () {
                      // TODO: Add login logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D108E),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
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
        ),
      ),
    );
  }
}