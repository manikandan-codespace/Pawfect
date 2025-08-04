import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawfect_bites/ml/ml_model.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  _DiseaseDetectionScreenState createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  final ImagePicker _picker = ImagePicker();
  final AnimalDiseaseDetector _detector = AnimalDiseaseDetector();

  File? _selectedImage;
  Map<String, double>? _predictions;
  bool _isLoading = false;
  AnimalType? _selectedAnimalType;

  // Define the peach color theme
  static const Color primaryPeach = Color.fromRGBO(255, 212, 197, 1);
  static const Color darkPeach = Color.fromRGBO(230, 180, 160, 1);
  static const Color lightPeach = Color.fromRGBO(255, 230, 220, 1);
  static const Color accentPeach = Color.fromRGBO(255, 190, 170, 1);

  @override
  void dispose() {
    _detector.dispose();
    super.dispose();
  }

  Future<void> _selectAnimalType(AnimalType animalType) async {
    setState(() {
      _isLoading = true;
      _selectedImage = null;
      _predictions = null;
    });

    try {
      await _detector.loadModel(animalType);
      setState(() {
        _selectedAnimalType = animalType;
      });
    } catch (e) {
      _showErrorDialog('Error loading ${animalType.name} model: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_selectedAnimalType == null) {
      _showErrorDialog('Please select an animal type first');
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _predictions = null;
        });
      }
    } catch (e) {
      _showErrorDialog('Error picking image: $e');
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null || _selectedAnimalType == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final predictions = await _detector.predictDisease(_selectedImage!);
      setState(() {
        _predictions = predictions;
      });
    } catch (e) {
      _showErrorDialog('Error analyzing image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Error',
          style: TextStyle(
            color: Colors.brown[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.brown[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: primaryPeach,
              foregroundColor: Colors.brown[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalSelector() {
    return Card(
      elevation: 6,
      color: Colors.white,
      shadowColor: primaryPeach.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              primaryPeach.withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.pets_rounded,
                    color: Colors.brown[800],
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Select Animal Type',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: AnimalType.values.map((animalType) {
                  final isSelected = _selectedAnimalType == animalType;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [darkPeach, accentPeach],
                                )
                              : null,
                          border: Border.all(
                            color: isSelected
                                ? darkPeach
                                : Colors.grey.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () => _selectAnimalType(animalType),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isSelected ? Colors.transparent : Colors.white,
                            foregroundColor: isSelected
                                ? Colors.brown[800]
                                : Colors.brown[600],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            animalType.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerButtons() {
    return Card(
      elevation: 6,
      color: Colors.white,
      shadowColor: primaryPeach.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.add_a_photo_rounded,
                  color: Colors.brown[800],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Add Image',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [darkPeach, accentPeach],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt_rounded),
                      label: const Text('Take Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.brown[800],
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [accentPeach, primaryPeach],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_rounded),
                      label: const Text('From Gallery'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.brown[800],
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageDisplay() {
    return Card(
      elevation: 6,
      color: Colors.white,
      shadowColor: primaryPeach.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.image_rounded,
                  color: Colors.brown[800],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Selected Image',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(
                  color: primaryPeach,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryPeach.withOpacity(0.1),
                    Colors.white,
                  ],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [darkPeach, accentPeach],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _analyzeImage,
                icon: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.brown[800],
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.analytics_rounded),
                label: Text(_isLoading ? 'Analyzing...' : 'Analyze Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.brown[800],
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    final sortedPredictions = _predictions!.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      elevation: 6,
      color: Colors.white,
      shadowColor: primaryPeach.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              primaryPeach.withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.analytics_rounded,
                    color: Colors.brown[800],
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedAnimalType!.name.toUpperCase()} Detection Results',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...sortedPredictions.map((entry) {
                final confidence = (entry.value * 100).toStringAsFixed(1);
                final isHighConfidence = entry.value > 0.5;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isHighConfidence
                        ? accentPeach.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isHighConfidence
                          ? accentPeach.withOpacity(0.5)
                          : Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isHighConfidence ? darkPeach : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.key.replaceAll('_', ' ').toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.brown[800],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isHighConfidence ? darkPeach : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$confidence%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isHighConfidence
                                ? Colors.brown[800]
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPeach,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                lightPeach,
                primaryPeach.withOpacity(0.3),
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: primaryPeach,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: darkPeach.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.brown[800],
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Text(
                          'Disease Detection',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Animal type selector
                _buildAnimalSelector(),

                const SizedBox(height: 20),

                // Image selection buttons
                if (_selectedAnimalType != null) ...[
                  _buildImagePickerButtons(),
                  const SizedBox(height: 20),

                  // Selected image display
                  if (_selectedImage != null) ...[
                    _buildImageDisplay(),
                    const SizedBox(height: 20),
                  ],

                  // Results display
                  if (_predictions != null) ...[
                    _buildResults(),
                  ],
                ] else ...[
                  Card(
                    elevation: 6,
                    color: Colors.white,
                    shadowColor: primaryPeach.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.pets_rounded,
                            size: 64,
                            color: Colors.brown[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Please select an animal type to continue',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.brown[600],
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
