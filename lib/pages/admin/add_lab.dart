import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';


class AddLabPage extends StatefulWidget {
  const AddLabPage({Key? key}) : super(key: key);

  @override
  _AddLabPageState createState() => _AddLabPageState();
}

class _AddLabPageState extends State<AddLabPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedDepartment = 'CSE';
  String? selectedSemesterType;
  String? selectedSemester;
  TextEditingController labController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  List<String> semesterTypes = ["Odd Sem", "Even Sem"];
  List<String> semesters = [];

  Future<void> checkAndCreatePath() async {
    if (selectedSemesterType == null || selectedSemester == null) {
      return;
    }
    try {
      setState(() => isLoading = true);
      DocumentReference semesterRef = _firestore
          .collection('Departments')
          .doc(selectedDepartment)
          .collection(selectedSemesterType!)
          .doc(selectedSemester);

      DocumentSnapshot semSnapshot = await semesterRef.get();
      if (!semSnapshot.exists) {
        await semesterRef.set({});
      }
    } catch (e) {
      setState(() => errorMessage = "Error initializing Firestore path: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> addLab() async {
    if (selectedSemesterType == null || selectedSemester == null || labController.text.isEmpty) {
      setState(() => errorMessage = "Please fill all fields");
      return;
    }
    try {
      setState(() => isLoading = true);
      String labName = labController.text.trim();
      DocumentReference labRef = _firestore
          .collection('Departments')
          .doc(selectedDepartment)
          .collection(selectedSemesterType!)
          .doc(selectedSemester)
          .collection('Lab')
          .doc(labName);

      DocumentSnapshot docSnapshot = await labRef.get();
      if (docSnapshot.exists) {
        setState(() => errorMessage = "Lab '$labName' already exists.");
        return;
      }
      await labRef.set({'lab': labName});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lab '$labName' added successfully")));
      labController.clear();
    } catch (e) {
      setState(() => errorMessage = "Error adding lab: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Lab",
          style: GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 25),
        ),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: 'CSE',
              items: [DropdownMenuItem(value: 'CSE', child: Text('CSE'))],
              onChanged: (_) {},
              decoration: inputDecoration,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedSemesterType,
              hint: Text("Select Semester Type"),
              items: semesterTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSemesterType = value;
                  selectedSemester = null;
                  semesters = value == "Odd Sem" ? ["3", "5", "7"] : ["4", "6", "8"];
                  errorMessage = null;
                });
              },
              decoration: inputDecoration,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedSemester,
              hint: Text("Select Semester"),
              items: semesters.map((sem) => DropdownMenuItem(value: sem, child: Text(sem))).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSemester = value;
                  errorMessage = null;
                });
                checkAndCreatePath();
              },
              decoration: inputDecoration,
            ),
            SizedBox(height: 20),
            TextField(
              controller: labController,
              decoration: inputDecoration.copyWith(labelText: 'Lab Name'),
            ),
            SizedBox(height: 20),
            if (errorMessage != null) Text(errorMessage!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addLab,
                child: Text('Add Lab', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black)),
  );
}
