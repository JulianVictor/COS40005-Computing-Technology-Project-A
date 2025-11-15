import 'package:flutter/material.dart';

import 'home.dart';

class AddFarmPage extends StatefulWidget {
  const AddFarmPage({super.key});

  @override
  State<AddFarmPage> createState() => _AddFarmPageState();
}

class _AddFarmPageState extends State<AddFarmPage> {
  // Form controllers
  final TextEditingController _farmNameController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _farmAreaController = TextEditingController();
  final TextEditingController _treeStandsController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  // Dropdown values
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedCountry;

  // Sample data
  final Map<String, List<String>> _stateDistricts = {
    'Johor': ['Batu Pahat', 'Johor Bahru', 'Kluang', 'Kota Tinggi', 'Kulai', 'Mersing', 'Muar', 'Pontian', 'Segamat', 'Tangkak', 'Others'],
    'Kedah': ['Baling', 'Bandar Baharu', 'Kota Setar', 'Kuala Muda', 'Kubang Pasu', 'Kulim', 'Langkawi', 'Padang Terap', 'Pendang', 'Pokok Sena', 'Sik', 'Yan', 'Others'],
    'Kelantan': ['Bachok', 'Gua Musang', 'Jeli', 'Kota Bharu', 'Kuala Krai', 'Machang', 'Pasir Mas', 'Pasir Puteh', 'Tanah Merah', 'Tumpat', 'Others'],
    'Melaka': ['Alor Gajah', 'Jasin', 'Melaka Tengah', 'Others'],
    'Negeri Sembilan': ['Jelebu', 'Jempol', 'Kuala Pilah', 'Port Dickson', 'Rembau', 'Seremban', 'Tampin', 'Others'],
    'Pahang': ['Bentong', 'Bera', 'Cameron Highlands', 'Jerantut', 'Kuantan', 'Lipis', 'Maran', 'Pekan', 'Raub', 'Rompin', 'Temerloh', 'Others'],
    'Penang': ['Central Seberang Perai', 'North Seberang Perai', 'Northeast Penang Island', 'South Seberang Perai', 'Southwest Penang Island', 'Others'],
    'Perak': ['Bagan Datuk', 'Batang Padang', 'Hilir Perak', 'Hulu Perak', 'Kampar', 'Kerian', 'Kinta', 'Kuala Kangsar', 'Larut, Matang & Selama', 'Manjung', 'Muallim', 'Perak Tengah', 'Others'],
    'Perlis': ['Kangar', 'Arau', 'Others'],
    'Sabah': ['Beaufort', 'Keningau', 'Kuala Penyu', 'Membakut', 'Nabawan', 'Sipitang', 'Sook', 'Tambunan', 'Tenom', 'Kota Marudu', 'Kudat', 'Pitas', 'Beluran', 'Kinabatangan','Paitan', 'Sandakan', 'Telupid', 'Tongod', 'Kalabakan', 'Kunak', 'Lahad datu', 'Semporna', 'Tawau', 'Kota Belud', 'Kota Kinabalu', 'Papar', 'Penampang', 'Putatan','Ranau', 'Tuaran', 'Others'],
    'Sarawak': ['Kuching',],
    'Selangor': ['Gombak', 'Hulu Langat', 'Hulu Selangor', 'Klang', 'Kuala Langat', 'Kuala Selangor', 'Petaling', 'Sabak Bernam', 'Sepang', 'Others'],
    'Terengganu': ['Besut', 'Dungun', 'Hulu Terengganu', 'Kemaman', 'Kuala Nerus', 'Kuala Terengganu', 'Marang', 'Setiu', 'Others'],
    'Kuala Lumpur': ['Kuala Lumpur'],
    'Labuan': ['Labuan'],
    'Putrajaya': ['Putrajaya'],
  };

  // Country list
  final List<String> _countries = [
    'Malaysia',
    'Indonesia',
    'Thailand',
    'Vietnam',
    'Philippines',
    'Singapore',
    'Brunei',
    'Cambodia',
    'Laos',
    'Myanmar',
    'Others'
  ];

  List<String> _availableDistricts = [];

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
          'Add New Farm',
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
                      // First Box - Farm Location
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Farm Location',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D108E),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Farm Name
                            _buildTextField(
                              controller: _farmNameController,
                              hintText: 'Farm Name',
                              icon: Icons.agriculture_rounded,
                            ),

                            const SizedBox(height: 16),

                            // State Dropdown
                            _buildDropdownField(
                              value: _selectedState,
                              hintText: 'State',
                              icon: Icons.map_rounded,
                              items: _stateDistricts.keys.toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedState = newValue;
                                  _selectedDistrict = null;
                                  _availableDistricts = _stateDistricts[newValue] ?? [];
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            // District Dropdown (only shows when state is selected)
                            if (_selectedState != null)
                              _buildDropdownField(
                                value: _selectedDistrict,
                                hintText: 'District',
                                icon: Icons.location_city_rounded,
                                items: _availableDistricts,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedDistrict = newValue;
                                  });
                                },
                              ),
                            if (_selectedState != null) const SizedBox(height: 16),

                            // Postcode (Optional)
                            _buildTextField(
                              controller: _postcodeController,
                              hintText: 'Postcode (Optional)',
                              icon: Icons.location_on_rounded,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Second Box - Farm Details
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Farm Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D108E),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Farm Area
                            _buildTextField(
                              controller: _farmAreaController,
                              hintText: 'Farm Area (Hectare)',
                              icon: Icons.square_foot_rounded,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),

                            // Number of cocoa tree stands
                            _buildTextField(
                              controller: _treeStandsController,
                              hintText: 'Number of cocoa tree stands',
                              icon: Icons.park_rounded,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Third Box - Location Coordinates (Optional)
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.map_rounded, color: Color(0xFF2D108E), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Location Coordinates (Optional)',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D108E),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Add GPS coordinates for better farm management',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Latitude & Longitude
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _latitudeController,
                                    hintText: 'Latitude',
                                    icon: Icons.my_location_rounded,
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _longitudeController,
                                    hintText: 'Longitude',
                                    icon: Icons.explore_rounded,
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Google Maps Preview Box
                            Container(
                              height: 150,
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
                                    _latitudeController.text.isNotEmpty && _longitudeController.text.isNotEmpty
                                        ? '${_latitudeController.text}, ${_longitudeController.text}'
                                        : 'Coordinates will appear here',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: _getCurrentLocation,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2D108E).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.gps_fixed_rounded, size: 16, color: Color(0xFF2D108E)),
                                    SizedBox(width: 8),
                                    Text(
                                      'Use Current Location',
                                      style: TextStyle(
                                        color: Color(0xFF2D108E),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Add Farm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addFarm,
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
                        'Add Farm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.add_circle_rounded, size: 20),
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
      onChanged: (_) => setState(() {}), // Update UI when coordinates change
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

  Widget _buildDropdownField({
    required String? value,
    required String hintText,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(128, 128, 128, 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromRGBO(128, 128, 128, 0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF2D108E)),
                const SizedBox(width: 12),
                Text(
                  hintText,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(item),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  void _getCurrentLocation() {
    // TODO: Implement actual location service
    // For now, set demo coordinates
    setState(() {
      _latitudeController.text = '1.5535';
      _longitudeController.text = '110.3593';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location set to demo coordinates'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _addFarm() {
    // Basic validation
    if (_farmNameController.text.isEmpty) {
      _showError('Please enter farm name');
      return;
    }

    if (_selectedCountry == null) {
      _showError('Please select country');
      return;
    }

    if (_selectedState == null) {
      _showError('Please select state');
      return;
    }

    if (_selectedDistrict == null) {
      _showError('Please select district');
      return;
    }

    if (_farmAreaController.text.isEmpty) {
      _showError('Please enter farm area');
      return;
    }

    if (_treeStandsController.text.isEmpty) {
      _showError('Please enter number of tree stands');
      return;
    }

    // Create new farm
    final newFarm = Farm(
      name: _farmNameController.text.trim(),
      state: _selectedState!,
      treeStands: int.tryParse(_treeStandsController.text) ?? 0,
      latestEggCount: 0, // Will be set after first sampling
      needsTreatment: false, // Will be determined after sampling
      latitude: double.tryParse(_latitudeController.text) ?? 0.0,
      longitude: double.tryParse(_longitudeController.text) ?? 0.0,
    );

    // Return the new farm to home page
    Navigator.pop(context, newFarm);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _farmNameController.dispose();
    _postcodeController.dispose();
    _farmAreaController.dispose();
    _treeStandsController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }
}