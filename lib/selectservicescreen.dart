import 'package:flutter/material.dart';
import 'package:pawfect_bites/consultingscreen.dart';
import 'package:pawfect_bites/crewscreen.dart';
import 'package:pawfect_bites/firstaidscreen.dart';
import 'package:pawfect_bites/homescreen.dart';
import 'package:pawfect_bites/ml/mlscreen.dart';
import 'package:pawfect_bites/petprofilescreen.dart';
import 'package:pawfect_bites/sqldb.dart';

class SelectServiceScreen extends StatelessWidget {
  const SelectServiceScreen({super.key});

  // Define the peach color theme
  static const Color primaryPeach = Color.fromRGBO(255, 212, 197, 1);
  static const Color darkPeach = Color.fromRGBO(230, 180, 160, 1);
  static const Color lightPeach = Color.fromRGBO(255, 230, 220, 1);
  static const Color accentPeach = Color.fromRGBO(255, 190, 170, 1);

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
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Welcome Header
                  Text(
                    'Welcome to PawFect Bites',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'For every Paw from A to Z',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.brown[600],
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  _buildServiceCard(
                    context,
                    icon: Icons.pets_rounded,
                    title: 'Pet Profile',
                    subtitle: 'Manage your pet\'s information and records',
                    color: const Color.fromRGBO(240, 190, 170, 1),
                    onTap: () async {
                      // Check if there's an existing pet profile
                      final existingPet =
                          await DatabaseHelper.instance.getFirstPetProfile();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetProfileScreen(
                            petId: existingPet
                                ?.id, // Will be null for new pet, or existing pet ID
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  // Service Cards
                  _buildServiceCard(
                    context,
                    icon: Icons.medical_services_rounded,
                    title: 'Animal Disease Detection',
                    subtitle: 'AI-powered health analysis for your pets',
                    color: darkPeach,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DiseaseDetectionScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  _buildServiceCard(
                    context,
                    icon: Icons.restaurant_rounded,
                    title: 'Food Safety Detection',
                    subtitle: 'Ensure your pet\'s food is safe and healthy',
                    color: accentPeach,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Nearby Doctors Tile
                  _buildServiceCard(
                    context,
                    icon: Icons.local_hospital_rounded,
                    title: 'Nearby Pet Doctors',
                    subtitle: 'Find veterinarians and clinics near you',
                    color: const Color.fromRGBO(255, 180, 150, 1),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NearbyDoctorsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildServiceCard(
                    context,
                    icon: Icons.pets_rounded,
                    title: 'First Aid',
                    subtitle: 'Know essential first aid measures for pets',
                    color: const Color.fromRGBO(240, 190, 170, 1),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PetFirstAidScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // Footer
                  Material(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MeetTheCrewScreen(),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.brown[600],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Caring for your furry friends',
                              style: TextStyle(
                                color: Colors.brown[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
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
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Card(
          elevation: 8,
          shadowColor: color.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  color.withOpacity(0.1),
                ],
              ),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: Colors.brown[800],
                  ),
                ),

                const SizedBox(width: 20),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[800],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.brown[600],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.brown[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
