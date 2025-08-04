import 'package:flutter/material.dart';

class PetFirstAidScreen extends StatelessWidget {
  const PetFirstAidScreen({super.key});

  // Peach color theme
  static const Color primaryPeach = Color.fromRGBO(255, 212, 197, 1);
  static const Color darkPeach = Color.fromRGBO(230, 180, 160, 1);
  static const Color lightPeach = Color.fromRGBO(255, 230, 220, 1);
  static const Color accentPeach = Color.fromRGBO(255, 190, 170, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPeach,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [lightPeach, primaryPeach.withOpacity(0.3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Back button
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

                  // Title
                  Text(
                    "Pet First Aid Measures",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.brown[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Essential steps to help your pet in emergencies. Always consult a vet as soon as possible.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.brown[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // First Aid Cards
                  _buildAidCard(
                    icon: Icons.healing_rounded,
                    color: accentPeach,
                    title: "Bleeding",
                    description:
                        "Apply gentle pressure with a clean cloth or bandage. Keep the pet calm and elevate the wounded area if possible. Seek veterinary help immediately if bleeding is severe.",
                  ),
                  const SizedBox(height: 16),
                  _buildAidCard(
                    icon: Icons.local_fire_department_rounded,
                    color: darkPeach,
                    title: "Burns",
                    description:
                        "Cool the burn with cool (not cold) water for several minutes. Do not apply creams or ice. Cover with a clean, damp cloth and contact your vet.",
                  ),
                  const SizedBox(height: 16),
                  _buildAidCard(
                    icon: Icons.warning_amber_rounded,
                    color: const Color.fromRGBO(255, 180, 150, 1),
                    title: "Poisoning",
                    description:
                        "Do NOT induce vomiting unless instructed by a vet. Remove the source of poison and call your vet or a poison control hotline immediately.",
                  ),
                  const SizedBox(height: 16),
                  _buildAidCard(
                    icon: Icons.air_rounded,
                    color: const Color.fromRGBO(255, 200, 180, 1),
                    title: "Choking",
                    description:
                        "If safe, try to remove the object from the mouth with tweezers. If the pet is not breathing, perform gentle chest compressions and seek emergency care.",
                  ),
                  const SizedBox(height: 16),
                  _buildAidCard(
                    icon: Icons.thermostat_rounded,
                    color: const Color.fromRGBO(240, 190, 170, 1),
                    title: "Heatstroke",
                    description:
                        "Move your pet to a cool area. Offer small amounts of water. Wet their fur with cool (not cold) water and use a fan if available. Contact your vet immediately.",
                  ),
                  const SizedBox(height: 16),
                  _buildAidCard(
                    icon: Icons.pets_rounded,
                    color: accentPeach,
                    title: "Seizures",
                    description:
                        "Keep your pet away from objects that could hurt them. Do not restrain or put anything in their mouth. Time the seizure and call your vet as soon as possible.",
                  ),
                  const SizedBox(height: 30),

                  // Footer
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Colors.brown[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Always keep your vet’s emergency number handy!',
                            style: TextStyle(
                              color: Colors.brown[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildAidCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 6,
      color: Colors.white,
      shadowColor: color.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              color.withOpacity(0.08),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: Colors.brown[800],
                  size: 28,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.brown[700],
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
