import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

// Import your profile pages
import 'package:UniSched/pages/aboutus/aniruddhaprofile.dart';
import 'package:UniSched/pages/aboutus/aryamanprofile.dart';
import 'package:UniSched/pages/aboutus/sourabhprofile.dart';
import 'package:UniSched/pages/aboutus/vedantprofile.dart';

class AboutTeam extends StatelessWidget {
  const AboutTeam({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0077FF),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
        ),
        title: const Text(
          "About Our Team",
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            const SizedBox(height: 20),
            _buildMemberCard(context, 'Aryaman Martand Sawant', 'Founder & CEO', 'AryamanProfile', 'assets/profile/Aryaman.jpg'),
            _buildMemberCard(context, 'Vedant Rajesh Naik', 'Lead Developer', 'VedantProfile', 'assets/profile/Vedant.jpeg'),
            _buildMemberCard(context, 'Aniruddha Ashok Pednekar', 'UI/UX Designer', 'AniruddhaProfile', 'assets/profile/Aniruddha.jpg'),
            _buildMemberCard(context, 'Sourabh Shridhar Salvi', 'Data Analytics', 'SourabhProfile', 'assets/profile/Sourabh.jpg'),
            const SizedBox(height: 30),
            _buildMissionSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0077FF), Color(0xFF00CFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 1000),
            child: const Text(
              "Our Team",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          FadeInDown(
            duration: const Duration(milliseconds: 1200),
            child: const Text(
              "Meet the visionaries behind UniSched. We're committed to delivering AI-driven solutions!",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, String name, String role, String routeName, String imagePath) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          leading: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey[200],
            backgroundImage: AssetImage(imagePath),
          ),
          title: Text(
            name,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            role,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
          onTap: () {
            switch (routeName) {
              case 'AryamanProfile':
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AryamanProfile()));
                break;
              case 'VedantProfile':
                Navigator.push(context, MaterialPageRoute(builder: (context) => const VedantProfile()));
                break;
              case 'SourabhProfile':
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SourabhProfile()));
                break;
              case 'AniruddhaProfile':
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AniruddhaProfile()));
                break;
              default:
            }
          },
        ),
      ),
    );
  }

  Widget _buildMissionSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orangeAccent, Colors.deepOrange],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 1000),
            child: const Text(
              "Our Mission",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 15),
          FadeInDown(
            duration: const Duration(milliseconds: 1200),
            child: const Text(
              "At UniSched, we aim to revolutionize timetable management with AI, creating an efficient and seamless experience!",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
