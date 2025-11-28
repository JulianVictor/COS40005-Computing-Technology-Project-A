import 'package:flutter/material.dart';
import '../pages/profile.dart';
import '../pages/home.dart';
import '../pages/welcome_page.dart';
import '../services/supabase_service.dart';



class SideTab extends StatelessWidget {
  const SideTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
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
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            Container(
              height: 180,
              decoration: const BoxDecoration(
                color: Color(0xFF2D108E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'CPB AI VISION',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cocoa Farm Management',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person, color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Farmer Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Menu Section
            /*       _buildSectionHeader('MENU'),

            _buildMenuItem(
              icon: Icons.home_rounded, // CHANGED: Home icon
              title: 'My Farms',
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.pushReplacement( // Go to home page
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),

            _buildMenuItem(
              icon: Icons.monitor_heart_rounded,
              title: 'Monitoring CPB Pest',
              onTap: () {
                Navigator.pop(context);
                _showComingSoonDialog(context, 'CPB Pest Monitoring');
              },
            ),

            _buildMenuItem(
              icon: Icons.agriculture_rounded,
              title: 'Cocoa Yield Management',
              onTap: () {
                Navigator.pop(context);
                _showComingSoonDialog(context, 'Cocoa Yield Management');
              },
            ),

            _buildMenuItem(
              icon: Icons.history_rounded,
              title: 'Record History',
              onTap: () {
                Navigator.pop(context);
                _showComingSoonDialog(context, 'Record History');
              },
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Divider(
                color: Color.fromRGBO(128, 128, 128, 0.2),
                height: 1,
              ),
            ),
*/
            // Info Section
            _buildSectionHeader('INFO'),

            _buildMenuItem(
              icon: Icons.info_rounded,
              title: 'Introduction of System',
              onTap: () {
                Navigator.pop(context);
                _showComingSoonDialog(context, 'System Introduction');
              },
            ),

            _buildMenuItem(
              icon: Icons.bug_report_rounded,
              title: 'CPB Pest',
              onTap: () {
                Navigator.pop(context);
                _showComingSoonDialog(context, 'CPB Pest Information');
              },
            ),

            _buildMenuItem(
              icon: Icons.school_rounded,
              title: 'Tutorial',
              onTap: () {
                Navigator.pop(context);
                _showComingSoonDialog(context, 'App Tutorials');
              },
            ),

            _buildMenuItem(
              icon: Icons.contact_support_rounded,
              title: 'Contact Information',
              onTap: () {
                Navigator.pop(context);
                _showComingSoonDialog(context, 'Contact Information');
              },
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Divider(
                color: Color.fromRGBO(128, 128, 128, 0.2),
                height: 1,
              ),
            ),

            // User Section
            _buildMenuItem(
              icon: Icons.person_rounded,
              title: 'User Profile',
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push( // Navigate to profile page
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),

            _buildMenuItem(
              icon: Icons.settings_rounded,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                _showComingSoonDialog(context, 'Settings');
              },
            ),

            const SizedBox(height: 20),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: 22,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog(context);
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D108E),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2D108E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2D108E),
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          visualDensity: const VisualDensity(vertical: -2),
          onTap: onTap,
        ),
      ),
    );
  }

  // NEW: Show coming soon dialog for unimplemented features
  void _showComingSoonDialog(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: Text('$featureName feature is under development.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: const Color(0xFF2D108E).withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF2D108E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context); // Close dialog

                        try {
                          // Add Supabase import at top if not already there
                          // import '../services/supabase_service.dart';
                          final supabase = SupabaseService();
                          await supabase.client.auth.signOut(); // Sign out from Supabase

                          // Navigate to welcome page
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const WelcomePage()),
                                  (route) => false
                          );
                        } catch (e) {
                          print('Logout error: $e');
                          // Still navigate to welcome page even if logout fails
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const WelcomePage()),
                                  (route) => false
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}