import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class TestConnectionPage extends StatelessWidget {
  const TestConnectionPage({super.key});

  Future<void> _testConnection(BuildContext context) async {
    try {
      final supabase = SupabaseService().client;

      // Test 1: Basic connection
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Testing Supabase connection...')),
      );

      // Test 2: Try to access users table
      final users = await supabase.from('users').select().limit(5);

      // Test 3: Try to access farms table
      final farms = await supabase.from('farms').select().limit(5);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('✅ Connection Successful!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Users count: ${users.length}'),
              Text('Farms count: ${farms.length}'),
              SizedBox(height: 10),
              Text('Supabase is properly connected!',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );

    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('❌ Connection Failed'),
          content: Text('Error: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supabase Connection Test'),
        backgroundColor: Color(0xFF2D108E),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_sync, size: 64, color: Color(0xFF2D108E)),
            SizedBox(height: 20),
            Text(
              'Test Supabase Connection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _testConnection(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2D108E),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                'Test Connection',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'This will test if your app can connect to Supabase\ndatabase and read from users and farms tables.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}