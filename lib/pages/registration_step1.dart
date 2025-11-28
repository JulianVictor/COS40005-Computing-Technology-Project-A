import '../services/supabase_service.dart';
import 'registration_step2.dart';
import 'package:flutter/material.dart';

class RegistrationStep1 extends StatefulWidget {
  const RegistrationStep1({super.key});

  @override
  State<RegistrationStep1> createState() => _RegistrationStep1State();
}

class _RegistrationStep1State extends State<RegistrationStep1> {
  // Form controllers
  final TextEditingController _farmNameController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _farmAreaController = TextEditingController();
  final TextEditingController _treeStandsController = TextEditingController();

  // Dropdown values
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedCountry;

  // Text editing controllers for autocomplete
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

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
  void initState() {
    super.initState();
    // Set initial values for controllers based on selected values
    _stateController.text = _selectedState ?? '';
    _districtController.text = _selectedDistrict ?? '';
    _countryController.text = _selectedCountry ?? '';
  }

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
                Color(0xFFF8F6FF),
                Colors.white,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Back button and progress indicator
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
                      'Step 1 of 3',
                      style: TextStyle(
                        color: Color(0xFF2D108E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Main title
                const Column(
                  children: [
                    Text(
                      'Step 1',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Enter Farm Location Details',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D108E),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

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
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
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

                              // Country Autocomplete
                              _buildAutocompleteField(
                                controller: _countryController,
                                hintText: 'Country',
                                icon: Icons.flag_rounded,
                                options: _countries,
                                onSelected: (String selection) {
                                  setState(() {
                                    _selectedCountry = selection;
                                    _countryController.text = selection;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // State Autocomplete
                              _buildAutocompleteField(
                                controller: _stateController,
                                hintText: 'State',
                                icon: Icons.map_rounded,
                                options: _stateDistricts.keys.toList(),
                                onSelected: (String selection) {
                                  setState(() {
                                    _selectedState = selection;
                                    _stateController.text = selection;
                                    _selectedDistrict = null;
                                    _districtController.text = '';
                                    _availableDistricts = _stateDistricts[selection] ?? [];
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // District Autocomplete (only shows when state is selected)
                              if (_selectedState != null)
                                _buildAutocompleteField(
                                  controller: _districtController,
                                  hintText: 'District',
                                  icon: Icons.location_city_rounded,
                                  options: _availableDistricts,
                                  onSelected: (String selection) {
                                    setState(() {
                                      _selectedDistrict = selection;
                                      _districtController.text = selection;
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
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
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

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),

                // Next Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Save farm details first, then go to next step
                      await _saveFarmDetails();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationStep2()),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D108E),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: const Color(0xFF2D108E).withOpacity(0.3),
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Login section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
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
                            color: const Color(0xFF2D108E).withOpacity(0.1),
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

  // Backend
  Future<void> _saveFarmDetails() async {
    try {
      // Create instance first, then use client
      final supabase = SupabaseService();
      final user = supabase.client.auth.currentUser;

      if (user != null) {
        await supabase.client.from('farms').insert({
          'ownerid': user.id,
          'farmname': _farmNameController.text,
          'state': _selectedState,
          'district': _selectedDistrict,
          'postcode': _postcodeController.text,
          'areahectares': double.tryParse(_farmAreaController.text) ?? 0.0,
          'treecount': int.tryParse(_treeStandsController.text) ?? 0,
        });
        print('Farm details saved successfully!');
      } else {
        print('No user logged in - cannot save farm');
      }
    } catch (e) {
      print('Error saving farm details: $e');
    }
  }


  // Helper method to create consistent text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color(0xFF2D108E)),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2D108E)),
        ),
      ),
    );
  }

  // Helper method to create autocomplete fields
  Widget _buildAutocompleteField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    return Autocomplete<String>(
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: const Color(0xFF2D108E)),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2D108E)),
            ),
          ),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return options;
        }
        return options.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: onSelected,
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    onTap: () {
                      onSelected(option);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}