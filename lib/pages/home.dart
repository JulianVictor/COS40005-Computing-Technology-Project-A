import 'package:flutter/material.dart';
import 'add_farm.dart';
import 'edit_farm.dart';
import 'home_dashboard.dart';
import 'profile.dart';
import '/widgets/side_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Sample farm data - in complete app, this would come from database
  final List<Farm> _farms = [
    Farm(
      name: 'Happy Farm Kuching',
      state: 'Sarawak',
      treeStands: 8888,
      latestEggCount: 15,
      needsTreatment: true,
      latitude: 1.5535,
      longitude: 110.3593,
    ),
    Farm(
      name: 'Green Valley Farm',
      state: 'Sabah',
      treeStands: 6500,
      latestEggCount: 8,
      needsTreatment: false,
      latitude: 5.9804,
      longitude: 116.0735,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SideTab(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder( // WRAP WITH BUILDER
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
          // Profile button
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
                      'Welcome Back!',
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
                child: _farms.isEmpty
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeDashboard(
              farmName: farm.name,
              latitude: farm.latitude,
              longitude: farm.longitude,
              treeStands: farm.treeStands,
              latestEggCount: farm.latestEggCount,
              needsTreatment: farm.needsTreatment,
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
                      farm.name,
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
              _buildFarmDetail('Tree Stands', '${farm.treeStands}'),
              _buildFarmDetail('Latest CPB Egg Count', '${farm.latestEggCount}'),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _handleFarmAction(farm);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: farm.needsTreatment ? Colors.red : const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        farm.needsTreatment ? 'TREAT' : 'Continue Sampling',
                        style: const TextStyle(
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
            width: 140, // Reduced width for better alignment
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
    ).then((newFarm) {
      if (newFarm != null) {
        setState(() {
          _farms.add(newFarm);
        });
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
          onFarmUpdated: (updatedFarm, index) {
            setState(() {
              _farms[index] = updatedFarm;
            });

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${updatedFarm.name} updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleFarmAction(Farm farm) {
    if (farm.needsTreatment) {
      // Navigate to treatment page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigate to treatment page for ${farm.name}'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Navigate to sampling page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Continue sampling for ${farm.name}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showMapPreview(Farm farm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location: ${farm.name}'),
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
                    '${farm.latitude.toStringAsFixed(4)}, ${farm.longitude.toStringAsFixed(4)}',
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
}

// Farm model class
class Farm {
  final String name;
  final String state;
  final int treeStands;
  final int latestEggCount;
  final bool needsTreatment;
  final double latitude;
  final double longitude;

  Farm({
    required this.name,
    required this.state,
    required this.treeStands,
    required this.latestEggCount,
    required this.needsTreatment,
    required this.latitude,
    required this.longitude,
  });
}