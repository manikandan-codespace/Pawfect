import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyDoctorsScreen extends StatefulWidget {
  const NearbyDoctorsScreen({super.key});

  @override
  State<NearbyDoctorsScreen> createState() => _NearbyDoctorsScreenState();
}

class _NearbyDoctorsScreenState extends State<NearbyDoctorsScreen> {
  // Define the peach color theme
  static const Color primaryPeach = Color.fromRGBO(255, 212, 197, 1);
  static const Color darkPeach = Color.fromRGBO(230, 180, 160, 1);
  static const Color lightPeach = Color.fromRGBO(255, 230, 220, 1);
  static const Color accentPeach = Color.fromRGBO(255, 190, 170, 1);

  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Nearby', 'Highly Rated', 'Emergency'];

  final List<Map<String, dynamic>> doctors = [
    // Thanjavur Veterinary Doctors
    {
      'name': 'Happy Paws - Dr. M. K. Devi',
      'specialty': 'Veterinary Medicine',
      'rating': 4.8,
      'reviews': 124,
      'distance': '1.2 km',
      'clinic': 'Happy Paws',
      'address':
          'No.1, Shanmuga Complex, Madhavarao Nagar 1st Street, Anna Nagar 11th Street, Nanjikottai Road, Thanjavur, Tamil Nadu 613006',
      'phone': '+91-7845115760',
      'isEmergency': true,
      'isOpen': true,
      'nextAvailable': 'Today 2:30 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'JS Pet Clinic',
      'specialty': 'Veterinary Medicine',
      'rating': 4.6,
      'reviews': 89,
      'distance': '2.1 km',
      'clinic': 'JS Pet Clinic',
      'address':
          '7th Street, Abiramapuram, Opposite to Eliza Nagar Water Tank, Near New Bus Stand, Thanjavur, Tamil Nadu 613007',
      'phone': '+91-9445662796',
      'isEmergency': false,
      'isOpen': true,
      'nextAvailable': 'Today 4:00 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Kanagadevi',
      'specialty': 'Veterinary Medicine',
      'rating': 4.5,
      'reviews': 67,
      'distance': '1.8 km',
      'clinic': 'Private Practice',
      'address': 'Nanjikottai Road, Thanjavur, Tamil Nadu 613007',
      'phone': '+91-7845115760',
      'isEmergency': false,
      'isOpen': true,
      'nextAvailable': 'Tomorrow 10:00 AM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. M. Saravanan',
      'specialty': 'Veterinary Medicine',
      'rating': 4.7,
      'reviews': 156,
      'distance': '3.2 km',
      'clinic': 'Saravanan Veterinary Clinic',
      'address': 'Nagai Road, Thanjavur, Tamil Nadu',
      'phone': '+91-9943333033',
      'isEmergency': true,
      'isOpen': false,
      'nextAvailable': 'Tomorrow 9:00 AM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Government Veterinary Hospital',
      'specialty': 'Veterinary Medicine',
      'rating': 4.3,
      'reviews': 203,
      'distance': '2.5 km',
      'clinic': 'Government Veterinary Hospital',
      'address': 'Periya Koil, Thanjavur, Tamil Nadu',
      'phone': '+91-4362-272731',
      'isEmergency': true,
      'isOpen': true,
      'nextAvailable': 'Today 3:15 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Veterinary Clinical Complex, TANUVAS',
      'specialty': 'Veterinary Medicine',
      'rating': 4.9,
      'reviews': 312,
      'distance': '15.3 km',
      'clinic': 'TANUVAS',
      'address':
          'Veterinary College and Research Institute, Orathanadu, Thanjavur, Tamil Nadu 614625',
      'phone': '+91-4372-234014',
      'isEmergency': true,
      'isOpen': true,
      'nextAvailable': 'Today 1:45 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. B. Saravanan',
      'specialty': 'Veterinary Medicine',
      'rating': 4.4,
      'reviews': 78,
      'distance': '8.7 km',
      'clinic': 'Veterinary Dispensary',
      'address':
          'Veterinary Dispensary, Vallam, Thanjavur District, Tamil Nadu 613403',
      'phone': '+91-9786252862',
      'isEmergency': false,
      'isOpen': true,
      'nextAvailable': 'Today 5:30 PM',
      'image': 'assets/images/doctor.png',
    },
    // Trichy Veterinary Doctors
    {
      'name': 'SKS Veterinary Hospital',
      'specialty': 'Veterinary Medicine',
      'rating': 4.6,
      'reviews': 187,
      'distance': '3.7 km',
      'clinic': 'SKS Veterinary Hospital',
      'address':
          'C50, Near Nilgiris Super Market, North East Extension 3rd Cross Street, Thillai Nagar, Trichy, Tamil Nadu 620018',
      'phone': '+91-8680070008',
      'isEmergency': true,
      'isOpen': true,
      'nextAvailable': 'Today 2:00 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Anandagiri Pet Speciality',
      'specialty': 'Veterinary Medicine',
      'rating': 4.8,
      'reviews': 143,
      'distance': '4.2 km',
      'clinic': 'Anandagiri Pet Speciality',
      'address':
          'No. 2/4, George Complex, Kallukudi, Near Citi Finance, Pudukottai Main Road, Khajanagar, Trichy, Tamil Nadu 620020',
      'phone': '+91-9842425200',
      'isEmergency': false,
      'isOpen': true,
      'nextAvailable': 'Today 6:00 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. P. Srinivasan',
      'specialty': 'Veterinary Medicine',
      'rating': 4.5,
      'reviews': 92,
      'distance': '2.8 km',
      'clinic': 'Srinivasan Veterinary Care',
      'address':
          'S-3, Bharath Empire, Devi Thottam, South Devi Street, Srirangam, Trichy, Tamil Nadu 620006',
      'phone': '+91-9443647635',
      'isEmergency': false,
      'isOpen': false,
      'nextAvailable': 'Tomorrow 11:30 AM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. V. Varadharajan',
      'specialty': 'Veterinary Medicine',
      'rating': 4.7,
      'reviews': 165,
      'distance': '3.1 km',
      'clinic': 'Varadharajan Pet Clinic',
      'address':
          'No. 4/22, Arun Nagar, 2nd Street, Srirangam, Trichy, Tamil Nadu 620006',
      'phone': '+91-9443143487',
      'isEmergency': true,
      'isOpen': true,
      'nextAvailable': 'Today 4:15 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Akbar Ali',
      'specialty': 'Veterinary Medicine',
      'rating': 4.4,
      'reviews': 108,
      'distance': '5.3 km',
      'clinic': 'Ali Animal Hospital',
      'address':
          'No. 1/10 A, David Colony, K.K. Nagar Metre Factory Road, Trichy, Tamil Nadu 620021',
      'phone': '+91-9842459689',
      'isEmergency': false,
      'isOpen': true,
      'nextAvailable': 'Today 7:00 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Sukumar',
      'specialty': 'Veterinary Medicine',
      'rating': 4.6,
      'reviews': 134,
      'distance': '2.9 km',
      'clinic': 'Sukumar Pet Care',
      'address':
          'D-15, North East Extension, 1st Cross, Thillai Nagar, Trichy, Tamil Nadu 620018',
      'phone': '+91-9842404647',
      'isEmergency': false,
      'isOpen': true,
      'nextAvailable': 'Today 3:45 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Selvaraj',
      'specialty': 'Veterinary Medicine',
      'rating': 4.3,
      'reviews': 76,
      'distance': '1.9 km',
      'clinic': 'Selvaraj Animal Clinic',
      'address':
          'No. 31, Ponn Nagar, 3rd Main Road, Tiruchirappalli HO, Trichy, Tamil Nadu 620001',
      'phone': '+91-9442707402',
      'isEmergency': false,
      'isOpen': false,
      'nextAvailable': 'Tomorrow 8:30 AM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'IAR Dog Clinic & Pet Hostel',
      'specialty': 'Veterinary Medicine',
      'rating': 4.7,
      'reviews': 198,
      'distance': '6.1 km',
      'clinic': 'IAR Dog Clinic & Pet Hostel',
      'address': '440, Echikamalapatty, K.K. Nagar, Trichy, Tamil Nadu 620021',
      'phone': '+91-431-2914184',
      'isEmergency': true,
      'isOpen': true,
      'nextAvailable': 'Today 1:30 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Suresh Christopher',
      'specialty': 'Veterinary Medicine',
      'rating': 4.8,
      'reviews': 221,
      'distance': '4.5 km',
      'clinic': 'Christopher Pet Hospital',
      'address':
          'G-3, Sriranga Block, Thathachariyar Garden, Mambalasalai, Srinivasa Nagar, Trichy, Tamil Nadu 620005',
      'phone': '+91-9443191716',
      'isEmergency': true,
      'isOpen': true,
      'nextAvailable': 'Today 2:45 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Velayutham',
      'specialty': 'Veterinary Medicine',
      'rating': 4.2,
      'reviews': 85,
      'distance': '12.8 km',
      'clinic': 'Velayutham Animal Care',
      'address':
          'No. 717, Thiruvalluvar Avenue, Bikshandarkoil, Trichy, Tamil Nadu 621216',
      'phone': '+91-9443922245',
      'isEmergency': false,
      'isOpen': true,
      'nextAvailable': 'Tomorrow 10:15 AM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Mani',
      'specialty': 'Veterinary Medicine',
      'rating': 4.5,
      'reviews': 112,
      'distance': '3.4 km',
      'clinic': 'Mani Veterinary Clinic',
      'address':
          'B-19, North East Extension, Thillai Nagar, Trichy, Tamil Nadu 620018',
      'phone': '+91-9842478419',
      'isEmergency': false,
      'isOpen': true,
      'nextAvailable': 'Today 5:15 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Raja',
      'specialty': 'Veterinary Medicine',
      'rating': 4.4,
      'reviews': 97,
      'distance': '7.2 km',
      'clinic': 'Raja Pet Care Center',
      'address':
          'No. 8, Ayanavaram Colony, 3rd Street, Manachanallur, Trichy, Tamil Nadu 621005',
      'phone': '+91-9842435374',
      'isEmergency': false,
      'isOpen': false,
      'nextAvailable': 'Tomorrow 9:45 AM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Ibrahim',
      'specialty': 'Veterinary Medicine',
      'rating': 4.6,
      'reviews': 128,
      'distance': '4.8 km',
      'clinic': 'Ibrahim Animal Hospital',
      'address':
          'No. 79, E.B. Colony, Kajamalai, Khaja Nagar, Trichy, Tamil Nadu 620023',
      'phone': '+91-9842652330',
      'isEmergency': true,
      'isOpen': true,
      'nextAvailable': 'Today 3:00 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Rajasekaran',
      'specialty': 'Veterinary Medicine',
      'rating': 4.3,
      'reviews': 73,
      'distance': '9.1 km',
      'clinic': 'Rajasekaran Vet Clinic',
      'address':
          'No. 333, Shanmuga Nagar, 3rd Cross, Somarasampettai, Trichy, Tamil Nadu 620102',
      'phone': '+91-9842904162',
      'isEmergency': false,
      'isOpen': true,
      'nextAvailable': 'Today 6:30 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Ganapathy',
      'specialty': 'Veterinary Medicine',
      'rating': 4.7,
      'reviews': 145,
      'distance': '8.6 km',
      'clinic': 'Ganapathy Pet Hospital',
      'address':
          'No. 4, U.T. Malai Post, Kodappu Road, Somarasampettai, Trichy, Tamil Nadu 620102',
      'phone': '+91-9443765446',
      'isEmergency': false,
      'isOpen': true,
      'nextAvailable': 'Tomorrow 11:00 AM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Rajagopal',
      'specialty': 'Veterinary Medicine',
      'rating': 4.5,
      'reviews': 119,
      'distance': '5.7 km',
      'clinic': 'Rajagopal Animal Care',
      'address':
          'C-98, Harini Nivas, Bell Nagar, Tiruchirappalli Fort, Trichy, Tamil Nadu 620015',
      'phone': '+91-9443192821',
      'isEmergency': false,
      'isOpen': false,
      'nextAvailable': 'Tomorrow 8:00 AM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Nathappan',
      'specialty': 'Veterinary Medicine',
      'rating': 4.4,
      'reviews': 88,
      'distance': '11.3 km',
      'clinic': 'Nathappan Vet Center',
      'address':
          'No. 16 A, Swaminathan Nagar, Opposite to Govt Hospital, Thuraiyur, Trichy, Tamil Nadu 621010',
      'phone': '+91-9443367718',
      'isEmergency': false,
      'isOpen': true,
      'nextAvailable': 'Today 4:45 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Rajapandian',
      'specialty': 'Veterinary Medicine',
      'rating': 4.6,
      'reviews': 156,
      'distance': '6.4 km',
      'clinic': 'Rajapandian Pet Clinic',
      'address':
          'No. 56, Rajaram Salai, K.K. Nagar Metre Factory Road, Trichy, Tamil Nadu 620021',
      'phone': '+91-9842423445',
      'isEmergency': true,
      'isOpen': true,
      'nextAvailable': 'Today 2:15 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Rajamanickam',
      'specialty': 'Veterinary Medicine',
      'rating': 4.3,
      'reviews': 94,
      'distance': '7.8 km',
      'clinic': 'Rajamanickam Animal Hospital',
      'address':
          'Nagappa Nagar, Konarchathiram, K.K. Nagar Metre Factory Road, Trichy, Tamil Nadu 620021',
      'phone': '+91-9443888413',
      'isEmergency': false,
      'isOpen': true,
      'nextAvailable': 'Today 7:30 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Ganapathy Prasad',
      'specialty': 'Veterinary Medicine',
      'rating': 4.7,
      'reviews': 178,
      'distance': '5.9 km',
      'clinic': 'Prasad Veterinary Care',
      'address':
          'No. 188, Lincoln Street, K.K. Nagar Metre Factory Road, Trichy, Tamil Nadu 620021',
      'phone': '+91-9443151194',
      'isEmergency': false,
      'isOpen': false,
      'nextAvailable': 'Tomorrow 10:30 AM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Murugavel',
      'specialty': 'Veterinary Medicine',
      'rating': 4.5,
      'reviews': 103,
      'distance': '4.1 km',
      'clinic': 'Murugavel Pet Hospital',
      'address': 'Tennur, Trichy, Tamil Nadu 620017',
      'phone': '+91-9842476577',
      'isEmergency': false,
      'isOpen': true,
      'nextAvailable': 'Today 5:45 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Dr. Parivel',
      'specialty': 'Veterinary Medicine',
      'rating': 4.2,
      'reviews': 67,
      'distance': '13.7 km',
      'clinic': 'Parivel Animal Clinic',
      'address':
          'No. 237, Arasalur, Musiri Taluk, Main Road, Trichy, Tamil Nadu',
      'phone': '+91-9443354210',
      'isEmergency': false,
      'isOpen': true,
      'nextAvailable': 'Tomorrow 9:15 AM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Government Veterinary Hospital',
      'specialty': 'Veterinary Medicine',
      'rating': 4.1,
      'reviews': 234,
      'distance': '6.8 km',
      'clinic': 'Government Veterinary Hospital',
      'address':
          'Malligaipuram Thottam, Palakarai, Sangillyandapuram, Tiruchirappalli, Tamil Nadu 620008',
      'phone': '+91-431-2711919',
      'isEmergency': true,
      'isOpen': true,
      'nextAvailable': 'Today 1:00 PM',
      'image': 'assets/images/doctor.png',
    },
    {
      'name': 'Rathna\'s Pet Clinic - Dr. Dinesh Kumar',
      'specialty': 'Veterinary Medicine',
      'rating': 4.8,
      'reviews': 167,
      'distance': '3.6 km',
      'clinic': 'Rathna\'s Pet Clinic',
      'address':
          'No. 27A, Opposite to ABC Hospital, Annamalai Nagar, Trichy, Tamil Nadu',
      'phone': '+91-8610977746',
      'isEmergency': false,
      'isOpen': true,
      'nextAvailable': 'Today 4:30 PM',
      'image': 'assets/images/doctor.png',
    },
  ];

  // Function to make phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch phone dialer'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      padding: const EdgeInsets.only(right: 50),
                      child: Text(
                        'Find the best care for your pet',
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
              // Filter Section
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: filters.map((filter) {
                          final isSelected = selectedFilter == filter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: FilterChip(
                              label: Text(filter),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  selectedFilter = filter;
                                });
                              },
                              backgroundColor: Colors.white,
                              selectedColor: primaryPeach,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.brown[800]
                                    : Colors.brown[600],
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected
                                      ? darkPeach
                                      : Colors.grey.withOpacity(0.3),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Doctors List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return _buildDoctorCard(doctor);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [darkPeach, accentPeach],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            // Implement emergency call functionality
            _showEmergencyDialog();
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: Icon(
            Icons.emergency_rounded,
            color: Colors.brown[800],
          ),
          label: Text(
            'Emergency',
            style: TextStyle(
              color: Colors.brown[800],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
              primaryPeach.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Header
              Row(
                children: [
                  // Doctor Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryPeach,
                    backgroundImage:
                        Image.asset('assets/images/doctor.png').image,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: darkPeach,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Doctor Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                doctor['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown[800],
                                ),
                              ),
                            ),
                            if (doctor['isEmergency'])
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '24/7',
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctor['specialty'],
                          style: TextStyle(
                            color: Colors.brown[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber[600],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${doctor['rating']} (${doctor['reviews']} reviews)',
                              style: TextStyle(
                                color: Colors.brown[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.location_on_rounded,
                              color: Colors.brown[600],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              doctor['distance'],
                              style: TextStyle(
                                color: Colors.brown[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Status Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: doctor['isOpen']
                          ? Colors.green[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      doctor['isOpen'] ? 'Open' : 'Closed',
                      style: TextStyle(
                        color: doctor['isOpen']
                            ? Colors.green[700]
                            : Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Clinic Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryPeach.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor['clinic'] ?? 'Private Practice',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.brown[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor['address'],
                      style: TextStyle(
                        color: Colors.brown[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Next available: ${doctor['nextAvailable']}',
                      style: TextStyle(
                        color: Colors.brown[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [accentPeach, primaryPeach],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _makePhoneCall(doctor['phone']);
                        },
                        icon: const Icon(Icons.phone_rounded),
                        label: const Text('Call'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.brown[800],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [darkPeach, accentPeach],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _makePhoneCall(doctor['phone']);
                        },
                        icon: const Icon(Icons.calendar_today_rounded),
                        label: const Text('Book'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.brown[800],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.emergency_rounded,
              color: Colors.red[600],
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Emergency Services',
              style: TextStyle(
                color: Colors.brown[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need immediate veterinary care?',
              style: TextStyle(
                color: Colors.brown[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '• Emergency hotline: +91-911-PETS\n• Happy Paws - Dr. M. K. Devi - Available 24/7\n• SKS Veterinary Hospital - Critical Care',
              style: TextStyle(
                color: Colors.brown[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.brown[600]),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red[400]!, Colors.red[600]!],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _makePhoneCall('+91-7845115760'); // Emergency number
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Call Now'),
            ),
          ),
        ],
      ),
    );
  }
}
