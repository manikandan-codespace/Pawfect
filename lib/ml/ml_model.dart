import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

enum AnimalType { dog, cat, chicken }

class AnimalDiseaseDetector {
  static const Map<AnimalType, String> modelPaths = {
    AnimalType.dog: 'assets/models/dog_disease_model.tflite',
    AnimalType.cat: 'assets/models/cat_disease_model.tflite',
    AnimalType.chicken: 'assets/models/poultry_disease_model.tflite',
  };

  static const Map<AnimalType, List<String>> labels = {
    AnimalType.chicken: [
      'healthy',
      'salmonella',
      'newcastle_disease',
      'coccidiosis'
    ],
    AnimalType.cat: [
      'scabies',
      'fungus',
      'ringworm',
      'flea_allergy',
      'dermatitis',
      'demodicosis',
    ],
    AnimalType.dog: [
      'healthy',
      'hypersensitivity dermatitis',
      'fungal infection',
      'bacterial dermatitis'
    ],
  };

  Interpreter? _interpreter;
  AnimalType? _currentAnimalType;

  Future<void> loadModel(AnimalType animalType) async {
    try {
      // Close previous model if exists
      if (_interpreter != null) {
        _interpreter!.close();
        _interpreter = null;
      }

      final modelPath = modelPaths[animalType]!;
      _interpreter = await Interpreter.fromAsset(modelPath);
      _currentAnimalType = animalType;
      print('${animalType.name} model loaded successfully');
    } catch (e) {
      print('Error loading ${animalType.name} model: $e');
      throw Exception('Failed to load ${animalType.name} model');
    }
  }

  Future<Map<String, double>> predictDisease(File imageFile) async {
    if (_interpreter == null || _currentAnimalType == null) {
      throw Exception('Model not loaded. Please select an animal type first.');
    }

    // Preprocess image
    final preprocessedImage = await _preprocessImage(imageFile);

    // Get current labels
    final currentLabels = labels[_currentAnimalType]!;

    // Prepare input and output tensors
    final input = [preprocessedImage];
    final output = List.filled(1 * currentLabels.length, 0.0)
        .reshape([1, currentLabels.length]);

    // Run inference
    _interpreter!.run(input, output);

    // Process results
    final predictions = <String, double>{};
    for (int i = 0; i < currentLabels.length; i++) {
      predictions[currentLabels[i]] = output[0][i];
    }

    return predictions;
  }

  Future<List<List<List<double>>>> _preprocessImage(File imageFile) async {
    // Read and decode image
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) throw Exception('Unable to decode image');

    // Resize to 128x128 (adjust based on your model requirements)
    image = img.copyResize(image, width: 128, height: 128);

    // Convert to normalized float values
    final imageMatrix = List.generate(
      128,
      (y) => List.generate(
        128,
        (x) => List.generate(3, (c) {
          final pixel = image!.getPixel(x, y);
          switch (c) {
            case 0:
              return pixel.r / 255.0; // Red channel
            case 1:
              return pixel.g / 255.0; // Green channel
            case 2:
              return pixel.b / 255.0; // Blue channel
            default:
              return 0.0;
          }
        }),
      ),
    );

    return imageMatrix;
  }

  String get currentAnimalName => _currentAnimalType?.name ?? 'None';

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _currentAnimalType = null;
  }
}
