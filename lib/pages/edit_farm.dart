import 'package:flutter/material.dart';
import '../services/farm_selection_service.dart';
import '../models/farm_selection_models.dart';


class EditFarmPage extends StatefulWidget {
  final FarmSelection farm;
  final int farmIndex;
  final Function(FarmSelection, int) onFarmUpdated;

  const EditFarmPage({
    super.key,
    required this.farm,
    required this.farmIndex,
    required this.onFarmUpdated,
  });

  @override
  State<EditFarmPage> createState() => _EditFarmPageState();
}

class _EditFarmPageState extends State<EditFarmPage> {
  // Form controllers - pre-filled with existing farm data
  late TextEditingController _farmNameController;
  late TextEditingController _villageController;
  late TextEditingController _postcodeController;
  late TextEditingController _farmAreaController;
  late TextEditingController _treeStandsController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  // Dropdown values - pre-filled
  late String? _selectedState;
  late String? _selectedDistrict;

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

  List<String> _availableDistricts = [];

  @override
  void initState() {
    super.initState();

    // Pre-fill controllers with FarmSelection data
    _farmNameController = TextEditingController(text: widget.farm.farmName);
    _villageController = TextEditingController(text: widget.farm.village);
    _postcodeController = TextEditingController(text: widget.farm.postcode);
    _farmAreaController = TextEditingController(text: widget.farm.areaHectares.toString());
    _treeStandsController = TextEditingController(text: widget.farm.treeCount.toString());
    _latitudeController = TextEditingController(text: widget.farm.latitude?.toString() ?? '');
    _longitudeController = TextEditingController(text: widget.farm.longitude?.toString() ?? '');

    // Pre-fill dropdowns
    _selectedState = widget.farm.state;
    _selectedDistrict = widget.farm.district;

    // Set available districts based on selected state
    if (_selectedState != null) {
      _availableDistricts = _stateDistricts[_selectedState] ?? [];
    }
  }

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
          'Edit Farm',
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
                      // Farm Location Box
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

                            // Village
                            _buildTextField(
                              controller: _villageController,
                              hintText: 'Village',
                              icon: Icons.location_city_rounded,
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

                            // Postcode
                            _buildTextField(
                              controller: _postcodeController,
                              hintText: 'Postcode',
                              icon: Icons.location_on_rounded,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Farm Details Box
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

                      // Location Coordinates Box
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

                            // Google Maps Preview
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

              // Save Changes Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
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
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.save_rounded, size: 20),
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
      onChanged: (_) => setState(() {}),
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

  void _saveChanges() async {
    // Basic validation
    if (_farmNameController.text.isEmpty) {
      _showError('Please enter farm name');
      return;
    }

    if (_villageController.text.isEmpty) {
      _showError('Please enter village');
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

    if (_postcodeController.text.isEmpty) {
      _showError('Please enter postcode');
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

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Create updated FarmSelection using copyWith (which exists on FarmSelection)
      final updatedFarm = widget.farm.copyWith(
        farmName: _farmNameController.text.trim(),
        village: _villageController.text.trim(),
        state: _selectedState!,
        district: _selectedDistrict!,
        postcode: _postcodeController.text.trim(),
        areaHectares: double.tryParse(_farmAreaController.text) ?? 0.0,
        treeCount: int.tryParse(_treeStandsController.text) ?? 0,
        updatedAt: DateTime.now(),
        latitude: _latitudeController.text.isNotEmpty
            ? double.tryParse(_latitudeController.text)
            : null,
        longitude: _longitudeController.text.isNotEmpty
            ? double.tryParse(_longitudeController.text)
            : null,
      );

      // Update in database using FarmSelectionService
      final farmService = FarmSelectionService();
      final savedFarm = await farmService.updateFarm(updatedFarm);

      Navigator.pop(context); // Close loading dialog

      if (savedFarm != null) {
        // Call the callback to update the farm in home page
        widget.onFarmUpdated(savedFarm, widget.farmIndex);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Farm updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back
        Navigator.pop(context);
      } else {
        _showError('Failed to update farm');
      }

    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showError('Failed to update farm: $e');
    }
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
    _villageController.dispose();
    _postcodeController.dispose();
    _farmAreaController.dispose();
    _treeStandsController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }
}