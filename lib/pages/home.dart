import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_farm.dart';
import 'edit_farm.dart';
import 'home_dashboard.dart';
import 'profile.dart';
import '/widgets/side_tab.dart';
import '/services/database_service.dart';
import '/models/database_models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _dbService = DatabaseService();
  List<Farm> _farms = [];
  bool _isLoading = true;
  Farm? _selectedFarm; // Track the currently selected farm

  @override
  void initState() {
    super.initState();
    _loadFarms();
  }

  Future<void> _loadFarms() async {
    final String? currentUserId = await _getCurrentUserId();
    if (currentUserId != null) {
      final farms = await _dbService.getUserFarms(currentUserId);
      setState(() {
        _farms = farms;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _getCurrentUserId() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      return user?.id;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SideTab(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Color(0xFF2D108E)),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          'My Farms',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D108E),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_rounded, color: Color(0xFF2D108E)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Welcome message
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D108E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back! Select a farm to start managing.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Managing ${_farms.length} farm${_farms.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Farms list
              Expanded(
                child: _isLoading
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : _farms.isEmpty
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.agriculture_rounded,
                        size: 64,
                        color: Color(0xFF2D108E),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No farms added yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap the + button to add your first farm',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: _farms.length,
                  itemBuilder: (context, index) {
                    return _buildFarmCard(_farms[index], index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // Add Farm Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewFarm();
        },
        backgroundColor: const Color(0xFF2D108E),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildFarmCard(Farm farm, int index) {
    return GestureDetector(
      onTap: () {
        // Set the selected farm and navigate to dashboard
        setState(() {
          _selectedFarm = farm;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeDashboard(
              farm: farm, // Pass the entire farm object
              onFarmSelected: (selectedFarm) {
                // Callback to update selected farm if needed
                setState(() {
                  _selectedFarm = selectedFarm;
                });
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(128, 128, 128, 0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: const Color.fromRGBO(128, 128, 128, 0.2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      farm.farmName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D108E),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _editFarm(index),
                    icon: const Icon(Icons.edit_rounded, size: 20),
                    color: const Color(0xFF2D108E),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              _buildFarmDetail('State', farm.state),
              _buildFarmDetail('District', farm.district),
              _buildFarmDetail('Tree Stands', '${farm.treeCount}'),
              _buildFarmDetail('Area', '${farm.areaHectares} hectares'),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _handleFarmAction(farm);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: farm.isActive ? const Color(0xFF4CAF50) : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Manage Farm',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      _showMapPreview(farm);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D108E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFF2D108E),
                        size: 20,
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

  Widget _buildFarmDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _addNewFarm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddFarmPage()),
    ).then((result) {
      if (result != null && result is Farm) {
        // Farm was added successfully, reload the list
        _loadFarms();

        // Optional: Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result.farmName} added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (result == true) {
        // Fallback for boolean return (backward compatibility)
        _loadFarms();
      }
    });
  }
  void _editFarm(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFarmPage(
          farm: _farms[index],
          farmIndex: index,
          onFarmUpdated: (Farm updatedFarm, int index) { // Add types here
            // Reload farms to get updated data
            _loadFarms();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${updatedFarm.farmName} updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }


  void _handleFarmAction(Farm farm) {
    // Set as selected farm and navigate to dashboard
    setState(() {
      _selectedFarm = farm;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeDashboard(
          farm: farm,
          onFarmSelected: (selectedFarm) {
            setState(() {
              _selectedFarm = selectedFarm;
            });
          },
        ),
      ),
    );
  }

  void _showMapPreview(Farm farm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location: ${farm.farmName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE8EAF6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2D108E).withOpacity(0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.map_rounded,
                    size: 48,
                    color: Color(0xFF2D108E),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Google Maps Preview',
                    style: TextStyle(
                      color: Color(0xFF2D108E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${farm.state}, ${farm.district}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Getter for selected farm (can be used by other pages)
  Farm? get selectedFarm => _selectedFarm;
}