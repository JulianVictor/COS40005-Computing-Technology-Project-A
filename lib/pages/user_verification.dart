import 'package:flutter/material.dart';
import 'login.dart';

class UserVerification extends StatefulWidget {
  final bool isFirstTimeVerification;

  const UserVerification({
    super.key,
    this.isFirstTimeVerification = true,
  });

  @override
  State<UserVerification> createState() => _UserVerificationState();
}

class _UserVerificationState extends State<UserVerification> {
  final List<TextEditingController> _codeControllers = List.generate(
      6,
          (index) => TextEditingController()
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    // Set up focus node listeners for auto-moving between fields
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (!_focusNodes[i].hasFocus && i < _focusNodes.length - 1) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }

    // Check if user is already verified (in real app, this would be from shared preferences/backend)
    _checkVerificationStatus();
  }

  void _checkVerificationStatus() {
    // TODO: Replace with actual check from shared preferences or backend
    // For demo, we'll assume we check some local storage
    bool isVerified = false; // This would come from your storage

    if (isVerified && !widget.isFirstTimeVerification) {
      // If already verified and this is not first-time verification, skip to login
      _navigateToLogin();
    }
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If already verified and this is a returning user, show loading while navigating
    if (_isVerified && !widget.isFirstTimeVerification) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D108E)),
          ),
        ),
      );
    }

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
                // Back button - only show if it's first time verification
                if (widget.isFirstTimeVerification) ...[
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
                  const SizedBox(height: 20),
                ] else ...[
                  const SizedBox(height: 60),
                ],

                // Main title and description
                Column(
                  children: [
                    Text(
                      widget.isFirstTimeVerification
                          ? 'Account Verification'
                          : 'Welcome Back!',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D108E),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.isFirstTimeVerification
                          ? 'Enter the 6-digit verification code sent to your WhatsApp'
                          : 'Enter your verification code to continue',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Verification code input
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
                      // Verification code boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 45,
                            child: TextField(
                              controller: _codeControllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              decoration: InputDecoration(
                                counterText: '',
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
                                  borderSide: const BorderSide(
                                      color: Color(0xFF2D108E)),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.length == 1 && index < 5) {
                                  _focusNodes[index + 1].requestFocus();
                                } else if (value.isEmpty && index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }

                                // Auto-submit when all fields are filled
                                if (_isAllFieldsFilled()) {
                                  _verifyCode();
                                }
                              },
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      // Resend code section - only show for first time verification
                      if (widget.isFirstTimeVerification)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Didn't receive the code?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                _resendCode();
                              },
                              child: const Text(
                                'Resend',
                                style: TextStyle(
                                  color: Color(0xFF2D108E),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Info box about admin approval - only for first time
                if (widget.isFirstTimeVerification)
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
                            'Your account needs admin approval before you can log in. '
                                'You will receive a WhatsApp message once your account is approved.',
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

                const Spacer(),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _verifyCode();
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.isFirstTimeVerification ? 'Verify Code' : 'Continue',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          widget.isFirstTimeVerification
                              ? Icons.verified_rounded
                              : Icons.arrow_forward_rounded,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isAllFieldsFilled() {
    for (var controller in _codeControllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  String _getVerificationCode() {
    return _codeControllers.map((controller) => controller.text).join();
  }

  void _verifyCode() {
    final verificationCode = _getVerificationCode();

    // Basic validation - check if all fields are filled
    if (verificationCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 6-digit code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _simulateVerification(verificationCode);
  }

  void _simulateVerification(String code) {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D108E)),
        ),
      ),
    );

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Remove loading dialog

      // TODO: Replace this with actual verification logic
      if (code == "123456") {
        // Mark as verified (in real app, save to shared preferences/backend)
        _markAsVerified();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification successful!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to login page after successful verification
        Future.delayed(const Duration(milliseconds: 500), () {
          _navigateToLogin();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid verification code. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  void _markAsVerified() {
    // TODO: Replace with actual storage mechanism (SharedPreferences, Hive, etc.)
    setState(() {
      _isVerified = true;
    });
    // In real app: await SharedPreferences.getInstance().setBool('isVerified', true);
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()), // REPLACE: LoginPage() with your actual login page
    );
  }

  void _resendCode() {
    // TODO: Replace with actual resend code logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification code resent to your WhatsApp'),
        backgroundColor: Colors.green,
      ),
    );

    // Clear all fields when resending
    for (var controller in _codeControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }
}