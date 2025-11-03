import 'package:flutter/material.dart';

class RegistrationStep3 extends StatefulWidget {
  const RegistrationStep3({super.key});

  @override
  State<RegistrationStep3> createState() => _RegistrationStep3State();
}

class _RegistrationStep3State extends State<RegistrationStep3> {
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
                // Back button (optional - you can remove if not needed)
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
                      'Step 3 of 3',
                      style: TextStyle(
                        color: Color(0xFF2D108E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Success Icon/Logo
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(45, 16, 142, 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    //Icons.check_circle_rounded,
                    //size: 80,
                    //color: Color(0xFF2D108E),

                      Icons.access_time_rounded,
                      size: 80,
                      color: Color(0xFF2D108E),
                  ),
                ),

                const SizedBox(height: 40),

                // WhatsApp Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(37, 211, 102, 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.phone_android_rounded, // You can use Icons.whatsapp if you have the icon
                    size: 50,
                    color: Color(0xFF25D366), // WhatsApp green color
                  ),
                ),

                const SizedBox(height: 40),

                // Success Message
                const Column(
                  children: [
                    Text(
                      'Account Registration Complete!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D108E),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 17),
                    Text(
                      "Please await admin's approval and look out for a WhatsApp text from them to be able to login. "
                      "Your account isn't available for use right away.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const Spacer(),

                // Okay/Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate back to welcome page or login page
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/welcome',
                        (route) => false
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D108E),
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shadowColor: const Color.fromRGBO(45, 16, 142, 0.3),
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Login section (optional - you can remove if not needed)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    //borderRadius: BorderRadius.circular(12),
                   //border: Border.all(
                      //color: const Color.fromRGBO(128, 128, 128, 0.2),
                    ),
                  //),
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
}