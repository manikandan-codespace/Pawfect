import 'package:flutter/material.dart';
import 'package:pawfect_bites/categoryscreen.dart';
import 'package:pawfect_bites/sqldb.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Define the peach color theme
  static const Color primaryPeach = Color.fromRGBO(255, 212, 197, 1);
  static const Color darkPeach = Color.fromRGBO(230, 180, 160, 1);
  static const Color lightPeach = Color.fromRGBO(255, 230, 220, 1);
  static const Color accentPeach = Color.fromRGBO(255, 190, 170, 1);

  String selectedPet = "Cats";
  final Map<String, String> petImages = {
    "Cats": 'assets/images/cat.jpg',
    "Dogs": 'assets/images/dog.jpg',
    "Birds": 'assets/images/bird.jpg',
    "Cows": 'assets/images/cow.jpg',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPeach,
      body: Container(
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                Row(
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
                  ],
                ),

                const SizedBox(height: 15),

                Text(
                  "Discover",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.brown[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Choose the type of Pet you want to Know about",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.brown[600],
                    height: 1.3,
                  ),
                ),

                // Pet Selection Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildPetButton("Cats"),
                        _buildPetButton("Dogs"),
                        _buildPetButton("Birds"),
                        _buildPetButton("Cows"),
                      ],
                    ),
                  ),
                ),

                // Pet Image Display
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    child: GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity! < 0) {
                          setState(() {
                            selectedPet = petImages.keys.elementAt(
                                (petImages.keys.toList().indexOf(selectedPet) +
                                        1) %
                                    petImages.length);
                          });
                        } else if (details.primaryVelocity! > 0) {
                          setState(() {
                            selectedPet = petImages.keys.elementAt(
                                (petImages.keys.toList().indexOf(selectedPet) -
                                        1 +
                                        petImages.length) %
                                    petImages.length);
                          });
                        }
                      },
                      child: Stack(
                        children: _buildPetImageStack(),
                      ),
                    ),
                  ),
                ),

                // Explore Button
                const SizedBox(height: 20),
                Hero(
                  tag: 'exploreButton',
                  transitionOnUserGestures: true,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 32,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [darkPeach, accentPeach],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: darkPeach.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AnimatedLoadingDialog(
                              message: 'Loading $selectedPet data...',
                            ),
                          );
                          String petID = "";
                          // Preload the data
                          final dbHelper = DatabaseHelper.instance;
                          try {
                            if (selectedPet == "Cats") {
                              petID = "Cat";
                            } else if (selectedPet == "Dogs") {
                              petID = "Dog";
                            } else if (selectedPet == "Birds") {
                              petID = "Poultry";
                            } else if (selectedPet == "Cows") {
                              petID = "Cow";
                            }
                            final animalData =
                                await dbHelper.getDBDataByPet(petID);

                            // Close loading dialog
                            Navigator.pop(context);

                            // Navigate with preloaded data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryScreen(
                                  animalCategory: selectedPet,
                                  preloadedData: animalData,
                                ),
                              ),
                            );
                          } catch (e) {
                            // Handle errors
                            print('Error preloading data: $e');
                            Navigator.pop(context); // Close loading dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error loading data: $e'),
                                backgroundColor: Colors.brown[600],
                              ),
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Explore",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[800],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.pets_rounded,
                              color: Colors.brown[800],
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build pet selection buttons
  Widget _buildPetButton(String petName) {
    bool isSelected = selectedPet == petName;

    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPet = petName;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: isSelected
                ? const LinearGradient(
                    colors: [darkPeach, accentPeach],
                  )
                : null,
            color: isSelected ? null : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.transparent : primaryPeach,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? darkPeach.withOpacity(0.3)
                    : primaryPeach.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          height: 50,
          width: isSelected ? 100 : 90,
          child: Center(
            child: Text(
              petName,
              style: TextStyle(
                color: isSelected ? Colors.brown[800] : Colors.brown[600],
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build the pet image stack
  List<Widget> _buildPetImageStack() {
    List<String> petNames = ["Cats", "Dogs", "Birds", "Cows"];
    List<Widget> stackItems = [];

    // First add background images (not selected)
    for (var pet in petNames) {
      if (pet != selectedPet && petImages.containsKey(pet)) {
        stackItems.add(
          Positioned(
            left: pet == "Dogs" || pet == "Cats" ? null : 0,
            right: pet == "Dogs" || pet == "Cats" ? 0 : null,
            top: 30,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: primaryPeach.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryPeach.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  petImages[pet]!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      }
    }

    // Then add the selected pet image on top
    if (petImages.containsKey(selectedPet)) {
      stackItems.add(
        Positioned(
          left: 40,
          top: 0,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: darkPeach,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: darkPeach.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.asset(
                petImages[selectedPet]!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }

    // Add pet name overlay
    stackItems.add(
      Positioned(
        bottom: 20,
        left: 60,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: primaryPeach,
              width: 1,
            ),
          ),
          child: Text(
            selectedPet,
            style: TextStyle(
              color: Colors.brown[800],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

    return stackItems;
  }
}

class AnimatedLoadingDialog extends StatefulWidget {
  final String message;

  const AnimatedLoadingDialog({
    super.key,
    this.message = 'Loading data...',
  });

  @override
  State<AnimatedLoadingDialog> createState() => _AnimatedLoadingDialogState();
}

class _AnimatedLoadingDialogState extends State<AnimatedLoadingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  // Define the peach color theme
  static const Color primaryPeach = Color.fromRGBO(255, 212, 197, 1);
  static const Color darkPeach = Color.fromRGBO(230, 180, 160, 1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primaryPeach,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: darkPeach.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(darkPeach),
                    strokeWidth: 4,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.message,
                  style: TextStyle(
                    color: Colors.brown[800],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
