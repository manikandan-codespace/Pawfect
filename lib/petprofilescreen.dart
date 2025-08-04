import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:pawfect_bites/sqldb.dart';

class PetProfileScreen extends StatefulWidget {
  final int? petId;

  const PetProfileScreen({super.key, this.petId});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  static const Color primaryPeach = Color.fromRGBO(255, 212, 197, 1);
  static const Color darkPeach = Color.fromRGBO(230, 180, 160, 1);
  static const Color lightPeach = Color.fromRGBO(255, 230, 220, 1);

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();

  bool _isEditing = false;
  bool _isLoading = true;
  PetProfile? _currentPet;
  File? _selectedImage;

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _ownerController = TextEditingController();
  final TextEditingController _adoptionDateController = TextEditingController();
  final TextEditingController _medicalNotesController = TextEditingController();

  String _selectedGender = 'Male';
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  // Vaccination tracking
  final Map<String, VaccinationRecord> _vaccinations = {
    'Rabies': VaccinationRecord(name: 'Rabies', isAdministered: false),
    'DHPP': VaccinationRecord(
        name: 'DHPP (Distemper, Hepatitis, Parvovirus, Parainfluenza)',
        isAdministered: false),
    'Bordetella': VaccinationRecord(
        name: 'Bordetella (Kennel Cough)', isAdministered: false),
    'Lyme Disease':
        VaccinationRecord(name: 'Lyme Disease', isAdministered: false),
    'Feline Leukemia': VaccinationRecord(
        name: 'Feline Leukemia (FeLV)', isAdministered: false),
    'FVRCP': VaccinationRecord(
        name:
            'FVRCP (Feline Viral Rhinotracheitis, Calicivirus, Panleukopenia)',
        isAdministered: false),
  };

  @override
  void initState() {
    super.initState();
    _loadPetProfile();
  }

  Future<void> _loadPetProfile() async {
    setState(() => _isLoading = true);

    try {
      PetProfile? pet;
      if (widget.petId != null) {
        pet = await _databaseHelper.getPetProfile(widget.petId!);
      } else {
        pet = await _databaseHelper.getFirstPetProfile();
      }

      if (pet != null) {
        _currentPet = pet;
        _populateControllers(pet);
        _parseVaccinationHistory(pet.vaccinationHistory);
      } else {
        _isEditing = true;
        _setDefaultValues();
      }
    } catch (e) {
      print('Error loading pet profile: $e');
      _isEditing = true;
      _setDefaultValues();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _populateControllers(PetProfile pet) {
    _nameController.text = pet.name;
    _speciesController.text = pet.species;
    _breedController.text = pet.breed;
    _ageController.text = pet.age;
    _weightController.text = pet.weight;
    _colorController.text = pet.color;
    _ownerController.text = pet.owner;
    _adoptionDateController.text = pet.adoptionDate;
    _medicalNotesController.text = pet.medicalNotes;
    _selectedGender = pet.gender;
  }

  void _setDefaultValues() {
    _nameController.text = '';
    _speciesController.text = 'Cat';
    _breedController.text = '';
    _ageController.text = '';
    _weightController.text = '';
    _colorController.text = '';
    _ownerController.text = '';
    _adoptionDateController.text = '';
    _medicalNotesController.text = '';
    _selectedGender = 'Male';
  }

  void _parseVaccinationHistory(String history) {
    if (history.isEmpty) return;

    final lines = history.split('\n');
    for (String line in lines) {
      for (String vaccineKey in _vaccinations.keys) {
        if (line.toLowerCase().contains(vaccineKey.toLowerCase())) {
          if (line.toLowerCase().contains('administered') &&
              !line.toLowerCase().contains('not administered')) {
            // Extract date if present
            final dateMatch = RegExp(r'\d{4}-\d{2}-\d{2}').firstMatch(line);
            _vaccinations[vaccineKey] = _vaccinations[vaccineKey]!.copyWith(
              isAdministered: true,
              dateAdministered: dateMatch?.group(0),
            );
          }
          break;
        }
      }
    }
  }

  String _generateVaccinationHistory() {
    List<String> history = [];
    _vaccinations.forEach((key, vaccine) {
      if (vaccine.isAdministered) {
        String entry = '${vaccine.name}: Administered';
        if (vaccine.dateAdministered != null &&
            vaccine.dateAdministered!.isNotEmpty) {
          entry += ' on ${vaccine.dateAdministered}';
        }
        if (vaccine.notes != null && vaccine.notes!.isNotEmpty) {
          entry += ' - ${vaccine.notes}';
        }
        history.add(entry);
      } else {
        history.add('${vaccine.name}: Not administered');
      }
    });
    return history.join('\n');
  }

  Future<void> _selectAdoptionDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: darkPeach,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.brown.shade800,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('MMM dd, yyyy').format(pickedDate);
      setState(() {
        _adoptionDateController.text = formattedDate;
      });
    }
  }

  Future<void> _selectVaccinationDate(String vaccineKey) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: darkPeach,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.brown.shade800,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _vaccinations[vaccineKey] = _vaccinations[vaccineKey]!.copyWith(
          dateAdministered: formattedDate,
        );
      });
    }
  }

  Future<void> _savePetProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final now = DateTime.now();
      final petProfile = PetProfile(
        id: _currentPet?.id,
        name: _nameController.text.trim(),
        species: _speciesController.text.trim(),
        breed: _breedController.text.trim(),
        gender: _selectedGender,
        age: _ageController.text.trim(),
        weight: _weightController.text.trim(),
        color: _colorController.text.trim(),
        owner: _ownerController.text.trim(),
        adoptionDate: _adoptionDateController.text.trim(),
        imageUrl: _selectedImage?.path ??
            _currentPet?.imageUrl ??
            'assets/images/cat.jpg',
        medicalNotes: _medicalNotesController.text.trim(),
        vaccinationHistory: _generateVaccinationHistory(),
        createdAt: _currentPet?.createdAt ?? now,
        updatedAt: now,
      );

      if (_currentPet == null) {
        final id = await _databaseHelper.insertPetProfile(petProfile);
        _currentPet = petProfile.copyWith(id: id);
      } else {
        await _databaseHelper.updatePetProfile(petProfile);
        _currentPet = petProfile;
      }

      setState(() => _isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pet profile saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving pet profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: lightPeach,
        body: Center(
          child: CircularProgressIndicator(color: darkPeach),
        ),
      );
    }

    return Scaffold(
      backgroundColor: lightPeach,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildPetInfoCard(),
                const SizedBox(height: 20),
                _buildDetailsCard(),
                const SizedBox(height: 20),
                _buildVaccinationCard(),
                const SizedBox(height: 20),
                if (_isEditing) _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: !_isEditing
          ? FloatingActionButton(
              onPressed: () => setState(() => _isEditing = true),
              backgroundColor: primaryPeach,
              child: Icon(Icons.edit, color: Colors.brown[800]),
            )
          : null,
    );
  }

  // Keep your existing _buildHeader() and _buildPetInfoCard() methods unchanged

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryPeach, width: 1),
            boxShadow: [
              BoxShadow(
                color: darkPeach.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.brown[800]),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            _currentPet == null ? 'Add Pet Profile' : 'Pet Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPetInfoCard() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Pet Avatar
              GestureDetector(
                onTap: _isEditing ? _pickImage : null,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: primaryPeach,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : _currentPet?.imageUrl != null
                              ? AssetImage(_currentPet!.imageUrl)
                              : const AssetImage('assets/images/cat.jpg')
                                  as ImageProvider,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: darkPeach, width: 3),
                        ),
                      ),
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryPeach,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(Icons.camera_alt,
                              color: Colors.brown[800], size: 20),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Pet Name
              _isEditing
                  ? TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Pet Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: lightPeach.withOpacity(0.3),
                      ),
                      validator: (value) => value?.isEmpty == true
                          ? 'Please enter pet name'
                          : null,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      _nameController.text.isEmpty
                          ? 'Pet Name'
                          : _nameController.text,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
              const SizedBox(height: 8),

              // Species/Breed
              _isEditing
                  ? Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _speciesController,
                            decoration: InputDecoration(
                              labelText: 'Species',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: lightPeach.withOpacity(0.3),
                            ),
                            validator: (value) => value?.isEmpty == true
                                ? 'Please enter species'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _breedController,
                            decoration: InputDecoration(
                              labelText: 'Breed',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: lightPeach.withOpacity(0.3),
                            ),
                            validator: (value) => value?.isEmpty == true
                                ? 'Please enter breed'
                                : null,
                          ),
                        ),
                      ],
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryPeach,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_speciesController.text} - ${_breedController.text}',
                        style: TextStyle(
                          color: Colors.brown[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pet Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 16),
            if (_isEditing) ...[
              _buildEditableInfoRow('Age', _ageController, 'Enter age'),
              _buildGenderDropdown(),
              _buildEditableInfoRow(
                  'Weight', _weightController, 'Enter weight'),
              _buildEditableInfoRow('Color', _colorController, 'Enter color'),
              _buildEditableInfoRow(
                  'Owner', _ownerController, 'Enter owner name'),
              _buildAdoptionDateField(),
              _buildEditableInfoRow('Medical Notes', _medicalNotesController,
                  'Enter medical notes',
                  maxLines: 3),
            ] else ...[
              _buildInfoRow(
                  Icons.cake,
                  'Age',
                  _ageController.text.isEmpty
                      ? 'Not specified'
                      : _ageController.text),
              _buildInfoRow(Icons.male, 'Gender', _selectedGender),
              _buildInfoRow(
                  Icons.monitor_weight,
                  'Weight',
                  _weightController.text.isEmpty
                      ? 'Not specified'
                      : _weightController.text),
              _buildInfoRow(
                  Icons.palette,
                  'Color',
                  _colorController.text.isEmpty
                      ? 'Not specified'
                      : _colorController.text),
              _buildInfoRow(
                  Icons.person,
                  'Owner',
                  _ownerController.text.isEmpty
                      ? 'Not specified'
                      : _ownerController.text),
              _buildInfoRow(
                  Icons.calendar_today,
                  'Adoption Date',
                  _adoptionDateController.text.isEmpty
                      ? 'Not specified'
                      : _adoptionDateController.text),
              if (_medicalNotesController.text.isNotEmpty)
                _buildInfoRow(Icons.medical_services, 'Medical Notes',
                    _medicalNotesController.text),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAdoptionDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _adoptionDateController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Adoption Date',
          hintText: 'Select adoption date',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: lightPeach.withOpacity(0.3),
          prefixIcon: const Icon(Icons.calendar_today, color: darkPeach),
          suffixIcon: IconButton(
            icon: const Icon(Icons.date_range, color: darkPeach),
            onPressed: _selectAdoptionDate,
          ),
        ),
        onTap: _selectAdoptionDate,
      ),
    );
  }

  Widget _buildVaccinationCard() {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medical_services, color: darkPeach, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Vaccination History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isEditing)
              _buildVaccinationEditor()
            else
              _buildVaccinationDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccinationEditor() {
    return Column(
      children: _vaccinations.entries.map((entry) {
        final vaccineKey = entry.key;
        final vaccine = entry.value;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          color: lightPeach.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        vaccine.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.brown[800],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Switch(
                      value: vaccine.isAdministered,
                      onChanged: (value) {
                        setState(() {
                          _vaccinations[vaccineKey] = vaccine.copyWith(
                            isAdministered: value,
                            dateAdministered:
                                value ? vaccine.dateAdministered : null,
                          );
                        });
                      },
                      activeColor: darkPeach,
                    ),
                  ],
                ),
                if (vaccine.isAdministered) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vaccine.dateAdministered?.isNotEmpty == true
                              ? 'Date: ${vaccine.dateAdministered}'
                              : 'Date not set',
                          style: TextStyle(
                            color: Colors.brown[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _selectVaccinationDate(vaccineKey),
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: const Text('Set Date'),
                        style: TextButton.styleFrom(
                          foregroundColor: darkPeach,
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    initialValue: vaccine.notes ?? '',
                    decoration: InputDecoration(
                      hintText: 'Add notes (optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    style: const TextStyle(fontSize: 12),
                    onChanged: (value) {
                      _vaccinations[vaccineKey] =
                          vaccine.copyWith(notes: value);
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVaccinationDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightPeach.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _vaccinations.entries.map((entry) {
          final vaccine = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  vaccine.isAdministered ? Icons.check_circle : Icons.cancel,
                  color: vaccine.isAdministered ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vaccine.name,
                        style: TextStyle(
                          color: Colors.brown[700],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (vaccine.isAdministered &&
                          vaccine.dateAdministered != null)
                        Text(
                          'Date: ${vaccine.dateAdministered}',
                          style: TextStyle(
                            color: Colors.brown[600],
                            fontSize: 12,
                          ),
                        ),
                      if (vaccine.notes?.isNotEmpty == true)
                        Text(
                          'Notes: ${vaccine.notes}',
                          style: TextStyle(
                            color: Colors.brown[600],
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Keep your existing helper methods unchanged
  Widget _buildEditableInfoRow(
      String label, TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: lightPeach.withOpacity(0.3),
          prefixIcon: Icon(_getIconForLabel(label), color: darkPeach),
        ),
        validator: (value) {
          if (['Age', 'Weight', 'Color', 'Owner'].contains(label) &&
              (value?.isEmpty == true)) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: InputDecoration(
          labelText: 'Gender',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: lightPeach.withOpacity(0.3),
          prefixIcon: const Icon(Icons.male, color: darkPeach),
        ),
        items: _genderOptions.map((gender) {
          return DropdownMenuItem(value: gender, child: Text(gender));
        }).toList(),
        onChanged: (value) => setState(() => _selectedGender = value!),
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Age':
        return Icons.cake;
      case 'Weight':
        return Icons.monitor_weight;
      case 'Color':
        return Icons.palette;
      case 'Owner':
        return Icons.person;
      case 'Adoption Date':
        return Icons.calendar_today;
      case 'Medical Notes':
        return Icons.medical_services;
      default:
        return Icons.info;
    }
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() => _isEditing = false);
              if (_currentPet != null) {
                _populateControllers(_currentPet!);
                _parseVaccinationHistory(_currentPet!.vaccinationHistory);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.brown[800],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [primaryPeach, darkPeach]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: _savePetProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.brown[800],
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Pet Profile'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: darkPeach, size: 20),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.brown[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.brown[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _colorController.dispose();
    _ownerController.dispose();
    _adoptionDateController.dispose();
    _medicalNotesController.dispose();
    super.dispose();
  }
}

// Add this class to your sqldb.dart file
class VaccinationRecord {
  final String name;
  final bool isAdministered;
  final String? dateAdministered;
  final String? notes;

  VaccinationRecord({
    required this.name,
    required this.isAdministered,
    this.dateAdministered,
    this.notes,
  });

  VaccinationRecord copyWith({
    String? name,
    bool? isAdministered,
    String? dateAdministered,
    String? notes,
  }) {
    return VaccinationRecord(
      name: name ?? this.name,
      isAdministered: isAdministered ?? this.isAdministered,
      dateAdministered: dateAdministered ?? this.dateAdministered,
      notes: notes ?? this.notes,
    );
  }
}
