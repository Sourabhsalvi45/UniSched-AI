import 'package:UniSched/pages/landing/welcome.dart';
import 'package:flutter/material.dart';
import 'package:UniSched/pages/admin/add_instructor.dart';
import 'package:UniSched/pages/admin/add_lab.dart';
import 'package:UniSched/pages/admin/add_sub.dart';
import 'package:UniSched/pages/admin/assign_teacher.dart';
import 'package:UniSched/pages/home/instructor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sizer/sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:UniSched/pages/admin/list.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String adminName = "Admin";
  String adminEmail = "admin@unisched.com"; // Default email if not found

  @override
  void initState() {
    super.initState();
    fetchAdminData();
  }

  void fetchAdminData() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'HOD')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data();
        setState(() {
          adminName = "${userData['first_name']} ${userData['last_name']}";
          adminEmail = userData['email'] ?? adminEmail; // Fetch email
        });
      }
    } catch (e) {
      print("Error fetching admin data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 25),
        ),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAdminProfileCard(),
              SizedBox(height: 3.h),
              _buildSectionTitle("Quick Actions"),
              SizedBox(height: 2.h),
              _buildGridMenu(),
            ],
          ),
        ),
      ),
    );
  }

// 📌 **Admin Profile Card**
  Widget _buildAdminProfileCard() {
    return FadeInDown(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.purpleAccent]),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(2, 4))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.deepPurple, size: 35),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome, $adminName!",
                    style: GoogleFonts.lilitaOne(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w200),
                  ),
                  SizedBox(height: 5),
                  Text("HOD | Admin", style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// 📌 **Section Title**
  Widget _buildSectionTitle(String title) {
    return FadeInLeft(
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.deepPurple),
      ),
    );
  }

// 📌 **Grid Menu for Quick Actions**
  Widget _buildGridMenu() {
    List<Map<String, dynamic>> menuItems = [
      {"title": "Add Subject", "icon": Icons.book, "page": AddSubPage()},
      {"title": "Add Lab", "icon": Icons.science, "page": AddLabPage()},
      {"title": "Add Instructor", "icon": Icons.person, "page": AddInstructorPage()},
      {"title": "Assign Teacher", "icon": Icons.assignment_ind, "page": AssignTeacherPage()},
      {"title": "Generate Timetable", "icon": Icons.schedule, "page": Instructor()},
      {"title": "List of Subjects and Labs", "icon": Icons.list, "page": ListScreen()},
    ];

    return Column(
      children: [
      GridView.builder(
      shrinkWrap: true, // ✅ Fixes scrolling issue
      physics: NeverScrollableScrollPhysics(), // ✅ Prevents GridView from scrolling separately
      itemCount: menuItems.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
        itemBuilder: (context, index) {
          return FadeInUp(
            child: _buildGridItem(
              menuItems[index]["title"],
              menuItems[index]["icon"],
              menuItems[index]["page"],
            ),
          );
        },
      ),
    ]
    );
  }

  Widget _buildGridItem(String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            SizedBox(height: 8),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }


  // 📌 **Navigation Drawer**
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.deepPurple.shade50], // Light background
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // ✅ Stylish Drawer Header
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade500, Colors.purpleAccent.shade200],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text(
                adminName,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                adminEmail,
                style: TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Icon(Icons.person, size: 40, color: Colors.deepPurpleAccent),
              ),
            ),

            // ✅ Drawer Menu Items
            _buildDrawerItem(Icons.book, 'Add Subject', AddSubPage()),
            _buildDrawerItem(Icons.science, 'Add Lab', AddLabPage()),
            _buildDrawerItem(Icons.person, 'Add Instructor', AddInstructorPage()),
            _buildDrawerItem(Icons.assignment_ind, 'Assign Teacher', AssignTeacherPage()),
            _buildDrawerItem(Icons.list, 'List of Subjects and Labs', ListScreen()),

            Divider(thickness: 1, color: Colors.grey.shade300, indent: 20, endIndent: 20), // ✅ Adds separation

            Spacer(), // Pushes Logout to the bottom

            // ✅ Stylish Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // Logout color
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomePage()));
                },
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

// 📌 **Enhanced Drawer Item with Hover Effect**
  Widget _buildDrawerItem(IconData icon, String title, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.deepPurple, // ✅ Hover effect
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16)),
      ),
    );
  }

}
