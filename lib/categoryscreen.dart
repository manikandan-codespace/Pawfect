import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pawfect_bites/ml/mlscreen.dart';
import 'package:pawfect_bites/searchintocategory.dart';
import 'package:pawfect_bites/sqldb.dart';

class CategoryScreen extends StatefulWidget {
  final String animalCategory;
  final List<DBanimals>? preloadedData;
  const CategoryScreen(
      {super.key, required this.animalCategory, this.preloadedData});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<DBanimals> _dbData = [];
  bool _isLoading = true;
  String petID = "";

  @override
  void initState() {
    super.initState();
    if (widget.preloadedData != null) {
      // Use preloaded data if available
      setState(() {
        _dbData = widget.preloadedData!;
        _isLoading = false;
      });
    } else {
      // Otherwise load data normally
      _loadAnimalData();
    }
  }

  void filterResults(DBanimals selectedAnimal) {
    setState(() {
      _dbData = [selectedAnimal]; // Show only the selected animal
    });
  }

// Optional: Add a method to reset the filter
  void resetFilter() {
    _loadAnimalData(); // Reload all animals for the current pet type
  }

  Future<void> _loadAnimalData() async {
    try {
      if (widget.animalCategory == "Cats") {
        petID = "Cat";
      } else if (widget.animalCategory == "Dogs") {
        petID = "Dog";
      } else if (widget.animalCategory == "Birds") {
        petID = "Poultry";
      } else if (widget.animalCategory == "Cows") {
        petID = "Cow";
      }
      final dbData = await _databaseHelper.getDBDataByPet(petID);
      setState(() {
        _dbData = dbData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading dbData: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> petImages = {
      "Cats": 'assets/images/cat.jpg',
      "Dogs": 'assets/images/dog.jpg',
      "Birds": 'assets/images/bird.jpg',
      "Cows": 'assets/images/cow.jpg',
    };

    final controller = ScrollController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 212, 197, 1),
        //title: Text(widget.animalCategory),
        actions: [
          if (_dbData.length == 1)
            IconButton(
              icon: const Icon(Icons.clear_all),
              tooltip: 'Show all foods',
              onPressed: resetFilter,
            ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final selectedAnimal = await showSearch<DBanimals>(
                context: context,
                delegate: FoodSearchDelegate(_dbData),
              );

              if (selectedAnimal != null) {
                // Filter the results to show only the selected animal
                filterResults(selectedAnimal);
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 50,
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.black, Color(0xFF303030)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DiseaseDetectionScreen(),
                  ));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Go to Disease Search",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_dbData.length == 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.filter_list),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Filtered: ${_dbData.first.foodName}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  TextButton(
                    onPressed: resetFilter,
                    child: const Text('CLEAR'),
                  ),
                ],
              ),
            ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_dbData.isEmpty)
            const Center(child: Text('No data available'))
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: controller,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _dbData
                    .map((dbField) => DescriptionCard(
                          foodName: dbField.foodName,
                          petType: widget.animalCategory,
                          symptoms: dbField.symptoms,
                          tileImage: petImages[widget.animalCategory]!,
                          toxicityLevel: dbField.toxicityLevel,
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class DescriptionCard extends StatelessWidget {
  final String tileImage;
  final String foodName;
  final String petType;
  final String toxicityLevel;
  final String symptoms;
  const DescriptionCard(
      {super.key,
      required this.tileImage,
      required this.foodName,
      required this.petType,
      required this.toxicityLevel,
      required this.symptoms});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        //height: MediaQuery.of(context).size.height - 135,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      tileImage,
                      fit: BoxFit.cover,
                      height: 300,
                      width: MediaQuery.of(context).size.width - 30,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      petType,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Styled information section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Food item with icon and styled text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.no_drinks,
                                  color: Colors.red),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Food',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  foodName.length > 20
                                      ? '${foodName.substring(0, 17)}...'
                                      : foodName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.pets, color: Colors.blue),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pet Type',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  petType,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Toxicity Level',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                toxicityLevel,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: toxicityLevel == 'Severe'
                                      ? Colors.red
                                      : (toxicityLevel == 'Mild'
                                          ? Colors.orange
                                          : (toxicityLevel == 'Moderate'
                                              ? Colors.orange
                                              : Colors.green)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Visual indicator of severity
                              Row(
                                children: List.generate(
                                  toxicityLevel == 'Severe'
                                      ? 3
                                      : (toxicityLevel == 'Mild'
                                          ? 2
                                          : (toxicityLevel == "Moderate"
                                              ? 2
                                              : 0)),
                                  (index) => Container(
                                    width: 20,
                                    height: 8,
                                    margin: const EdgeInsets.only(right: 4),
                                    decoration: BoxDecoration(
                                      color: toxicityLevel == 'Severe'
                                          ? Colors.red
                                          : (toxicityLevel == 'Mild'
                                              ? Colors.orange
                                              : (toxicityLevel == 'Moderate'
                                                  ? Colors.orange
                                                  : Colors.green)),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'Symptoms',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          ...symptoms.split(', ').map((symptom) {
                            return _buildSymptomItem(
                                symptom,
                                toxicityLevel == 'Severe'
                                    ? Icons.warning
                                    : (toxicityLevel == 'Mild'
                                        ? Icons.info
                                        : Icons.check_circle),
                                toxicityLevel);
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Call-to-action button with gradient
              Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 50,
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.black, Color(0xFF303030)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      // Handle button tap
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Know More",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build symptom items
  Widget _buildSymptomItem(
      String symptom, IconData icon, String toxicityLevel) {
    return Row(
      children: [
        Icon(icon,
            color: toxicityLevel == 'Severe'
                ? Colors.red
                : (toxicityLevel == 'Mild'
                    ? Colors.orange
                    : (toxicityLevel == 'Moderate'
                        ? Colors.orange
                        : Colors.green)),
            size: 20),
        const SizedBox(width: 8),
        Text(
          overflow: TextOverflow.clip,
          symptom,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset('assets/images/cat.jpg'),
          ),
        ),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                width: MediaQuery.of(context).size.width - 30,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  //color: Colors.white.withOpacity(0.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Food: Alcohol',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Pet: Cat',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Toxicity Level: Severe',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Symptoms: Liver Damage, Coma',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.only(top: 20),
                          child: const Center(
                            child: Text(
                              "Know More",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GradientCard extends StatelessWidget {
  const GradientCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/cat.jpg',
              fit: BoxFit.cover,
              //height: 400,
              //width: MediaQuery.of(context).size.width - 30,
            ),
          ),
          // Add a subtle gradient overlay on the image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
          ),
          // Title on the image
          Positioned(
            bottom: 120,
            left: 20,
            child: Text(
              "Cat",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: 3.0,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
