import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class AniruddhaProfile extends StatelessWidget {
  const AniruddhaProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Aniruddha Ashok Pednekar',
          style: TextStyle(fontFamily: 'Outfit', color: Colors.black),
          textAlign: TextAlign.center,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            // Profile Picture with subtle shadow effect
            ZoomIn(
              duration: const Duration(milliseconds: 1000),
              child: const CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('assets/profile/Aniruddha.jpg'),
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 20),

            // Name and Title with gradient effect
            FadeInDown(
              duration: const Duration(milliseconds: 1000),
              child: Text(
                'Aniruddha Ashok Pednekar',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            FadeInDown(
              duration: const Duration(milliseconds: 1000),
              child: const Text(
                'UI/UX Designer',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Bio Section with a card-like effect
            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'Aniruddha is passionate about software development and innovation. He has extensive experience in building mobile and web applications, focusing on creating user-friendly interfaces and scalable solutions. Currently pursuing a degree in Computer Science, he is actively expanding his skills in programming, algorithms, and data structures. Aniruddha is also involved in various coding communities and open-source projects where he collaborates with developers to tackle real-world challenges.',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Education Section
            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: _buildEducationTile(
                'Finolex Academy of Management and Technology',
                'Bachelor of Science in Computer Science (AI & ML)',
                '2019 - Present',
              ),
            ),
            const SizedBox(height: 20),

            // Skills Section
            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: _buildSkillTile(
                'Programming Languages',
                'Dart, Java, Python',
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: _buildSkillTile(
                'Tools',
                'Android Studio, Visual Studio Code',
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Enhanced Education Tile with Card Layout
  Widget _buildEducationTile(String institution, String degree, String period) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            const Icon(Icons.school, color: Colors.blueAccent, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    institution,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    degree,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    period,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced Skill Tile with minimalistic icons
  Widget _buildSkillTile(String title, String skills) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            const Icon(Icons.code, color: Colors.greenAccent, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    skills,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
