import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetTheCrewScreen extends StatelessWidget {
  const MeetTheCrewScreen({super.key});

  // Peach color theme
  static const Color primaryPeach = Color.fromRGBO(255, 212, 197, 1);
  static const Color darkPeach = Color.fromRGBO(230, 180, 160, 1);
  static const Color lightPeach = Color.fromRGBO(255, 230, 220, 1);
  static const Color accentPeach = Color.fromRGBO(255, 190, 170, 1);

  // Example crew data
  final List<Map<String, String>> crew = const [
    {
      "name": "Manikandan",
      "designation": "Data Engineer",
      "image": "assets/images/mani.jpg",
      "linkedin": "https://www.linkedin.com/in/manikandanmyd"
    },
    {
      "name": "Somesh Karthi",
      "designation": "Product Manager",
      "image": "assets/images/somesh.jpg",
      "linkedin": "https://www.linkedin.com/in/someshkarthi-k-3a5163261"
    },
    {
      "name": "Allan Joshua",
      "designation": "Application Engineer",
      "image": "assets/images/allan.jpg",
      "linkedin": "https://linkedin.com/in/allan-joshua-472686292"
    },
  ];
  Future<void> openLinkedIn(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

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

                  // Title
                  Text(
                    "Meet the Crew",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.brown[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "The passionate team behind PawFect Bites",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.brown[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Crew Cards
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: crew.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 18),
                    itemBuilder: (context, index) {
                      final member = crew[index];
                      return _buildCrewCard(
                        image: member["image"]!,
                        name: member["name"]!,
                        designation: member["designation"]!,
                        color: index.isEven ? accentPeach : darkPeach,
                        linkedin: member["linkedin"].toString(),
                      );
                    },
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
                          Icons.favorite_rounded,
                          color: Colors.brown[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Built with love by the PawFect Bites Team!',
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

  Widget _buildCrewCard({
    required String image,
    required String name,
    required String designation,
    required Color color,
    required String linkedin,
  }) {
    return GestureDetector(
      onTap: () => openLinkedIn(linkedin),
      child: Card(
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
                color.withOpacity(0.07),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: color.withOpacity(0.3),
                  backgroundImage: AssetImage(image),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[800],
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        designation,
                        style: TextStyle(
                          color: Colors.brown[600],
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
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
}
