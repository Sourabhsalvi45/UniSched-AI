import 'package:UniSched/pages/landing/welcome.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';

class FacultyHomePage extends StatefulWidget {
  const FacultyHomePage({Key? key}) : super(key: key);

  @override
  _FacultyHomePageState createState() => _FacultyHomePageState();
}

class _FacultyHomePageState extends State<FacultyHomePage> {
  String? firstName;
  String? email;
  String? facultyDepartment;
  String? role;
  String selectedSemester = "OddSem";
  String selectedYear = "SE";
  String? selectedInstructor;

  List<String> instructors = [];

  final List<String> timeSlots = [
    "9:15-10:15",
    "10:15-11:15",
    "11:15-11:30 (Break)",
    "11:30-12:30",
    "12:30-1:30",
    "1:30-2:15 (Break)",
    "2:15-3:15",
    "3:15-4:15",
    "4:15-5:15",
  ];

  final List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];

  @override
  void initState() {
    super.initState();
    _getUserData();
    _fetchInstructors();
  }

  Future<void> _getUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('auth_uid', isEqualTo: user.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data();
        setState(() {
          firstName = userData['first_name'] ?? 'Faculty';
          email = userData['email'] ?? '';
          role = userData['role'] ?? '';
          facultyDepartment = userData['department'] ?? 'Unknown';
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> _fetchInstructors() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Professor').get();

      List<String> fetchedInstructors = snapshot.docs.map((doc) => doc.id).toList();

      setState(() {
        instructors = fetchedInstructors;
      });

      print("Fetched Instructors: $instructors");
    } catch (e) {
      print("Error fetching instructors: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Faculty Dashboard",
          style: GoogleFonts.outfit( fontWeight: FontWeight.w500 , fontSize: 25),
        ),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.blue,
      ),
        drawer: _buildDrawer(context, firstName, email),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              FadeInDown(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome, ${firstName ?? ''}!',
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)),
                      SizedBox(height: 1.h),
                      Text('View your weekly schedule.',
                          style: TextStyle(fontSize: 12.sp, color: Colors.greenAccent)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              _semesterSelector(),
              SizedBox(height: 2.h),
              _yearSelector(),
              SizedBox(height: 2.h),
              _instructorSelector(),
              SizedBox(height: 2.h),

              /// 🔹 General Timetable
              Text(
                "Full Weekly Timetable",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              _buildWeeklyTimetable(),

              SizedBox(height: 4.h),

              /// 🔹 Personalized Instructor Timetable
              if (selectedInstructor != null) ...[
                Text(
                  "Personalized Timetable for $selectedInstructor",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                _buildWeeklyTimetable(instructor: selectedInstructor),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, String? firstName, String? email) {
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
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text(
                firstName ?? 'Faculty',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                email ?? '',
                style: TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Text(
                  firstName?.substring(0, 1) ?? 'F',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),

            Divider(thickness: 1, color: Colors.grey.shade300, indent: 20, endIndent: 20),

            Spacer(), // Pushes Logout to the bottom

            // ✅ Stylish Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
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


  Widget _semesterSelector() {
    return DropdownButtonFormField<String>(
      decoration: _dropdownDecoration("Select Semester"),
      value: selectedSemester,
      items: ["OddSem", "EvenSem"]
          .map((sem) => DropdownMenuItem(value: sem, child: Text(sem)))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedSemester = value!;
        });
      },
    );
  }

  Widget _yearSelector() {
    return DropdownButtonFormField<String>(
      decoration: _dropdownDecoration("Select Year"),
      value: selectedYear,
      items: ["SE", "TE", "BE"]
          .map((year) => DropdownMenuItem(value: year, child: Text(year)))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedYear = value!;
        });
      },
    );
  }

  Widget _instructorSelector() {
    return DropdownButtonFormField<String>(
      decoration: _dropdownDecoration("Select Instructor"),
      value: selectedInstructor,
      hint: Text("Select Instructor"),
      items: instructors.isNotEmpty
          ? instructors.map((inst) => DropdownMenuItem(value: inst, child: Text(inst))).toList()
          : [DropdownMenuItem(value: null, child: Text("No Instructors Found"))],
      onChanged: (value) {
        setState(() {
          selectedInstructor = value;
        });
      },
    );
  }

  Widget _buildWeeklyTimetable({String? instructor}) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Timetables')
          .doc(selectedSemester)
          .collection(selectedYear)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        var docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return Center(child: Text("No timetable found for $selectedSemester - $selectedYear"));
        }

        var data = docs.first.data() as Map<String, dynamic>;
        Map<String, dynamic>? schedule = data['schedule'];

        if (schedule == null || schedule.isEmpty) {
          return Center(child: Text("No weekly schedule available"));
        }

        return _buildWeeklyTable(schedule, instructor: instructor);
      },
    );
  }

  Widget _buildWeeklyTable(Map<String, dynamic> schedule, {String? instructor}) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 6, spreadRadius: 2)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.blueAccent),
              dataRowColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                return states.contains(WidgetState.selected) ? Colors.lightBlueAccent : null;
              }),
              border: TableBorder(
                horizontalInside: BorderSide(width: 1, color: Colors.grey.shade400),
                verticalInside: BorderSide(width: 1, color: Colors.grey.shade400),
                top: BorderSide(width: 2, color: Colors.blue),
                bottom: BorderSide(width: 2, color: Colors.blue),
              ),
              columns: [
                DataColumn(
                  label: Text("Time Slot",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                ),
                ...days.map(
                      (day) => DataColumn(
                    label: Text(day,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                  ),
                ).toList(),
              ],
              rows: List.generate(timeSlots.length, (index) {
                return DataRow(
                  color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                    return index % 2 == 0 ? Colors.grey[100] : Colors.white;
                  }),
                  cells: [
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          timeSlots[index],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ),
                    ...days.map((day) {
                      List<dynamic>? daySchedule = schedule[day];
                      String subject = (daySchedule != null && index < daySchedule.length) ? daySchedule[index] : "-";

                      if (instructor != null && !subject.contains(instructor)) {
                        subject = "-";
                      }

                      return DataCell(
                        Center(
                          child: Text(
                            subject,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }



  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}