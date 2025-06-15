import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class AssignTeacherPage extends StatefulWidget {
  @override
  _AssignTeacherPageState createState() => _AssignTeacherPageState();
}

class _AssignTeacherPageState extends State<AssignTeacherPage> {
  String selectedSemesterType = 'Odd Sem';
  List<Map<String, dynamic>> professors = [];
  Map<String, List<String>> subjects = {};
  Map<String, List<String>> labs = {};
  Map<String, List<String>> assignedSubjects = {};
  Map<String, List<String>> assignedLabs = {};

  @override
  void initState() {
    super.initState();
    fetchProfessors();
  }

  Future<void> fetchProfessors() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('Professor').get();
      List<Map<String, dynamic>> fetchedProfessors = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['Name'],
        };
      }).toList();

      setState(() {
        professors = fetchedProfessors;
        fetchSubjectsAndLabs(selectedSemesterType);
      });
    } catch (e) {
      print("Error fetching professors: $e");
    }
  }

  Future<void> fetchSubjectsAndLabs(String semesterType) async {
    try {
      List<int> semesterNumbers =
      semesterType == 'Odd Sem' ? [3, 5, 7] : [4, 6, 8];
      Map<String, List<String>> fetchedSubjects = {};
      Map<String, List<String>> fetchedLabs = {};

      for (int semester in semesterNumbers) {
        QuerySnapshot subjectsSnapshot = await FirebaseFirestore.instance
            .collection('/Departments/CSE/$semesterType/$semester/Subject')
            .get();
        List<String> subjectList =
        subjectsSnapshot.docs.map((doc) => doc.id).toList();

        QuerySnapshot labsSnapshot = await FirebaseFirestore.instance
            .collection('/Departments/CSE/$semesterType/$semester/Lab')
            .get();
        List<String> labList = labsSnapshot.docs.map((doc) => doc.id).toList();

        fetchedSubjects[semester.toString()] = subjectList;
        fetchedLabs[semester.toString()] = labList;
      }

      setState(() {
        subjects = {
          for (var professor in professors)
            professor['id']: fetchedSubjects.values.expand((x) => x).toList()
        };
        labs = {
          for (var professor in professors)
            professor['id']: fetchedLabs.values.expand((x) => x).toList()
        };
        assignedSubjects = {
          for (var professor in professors) professor['id']: []
        };
        assignedLabs = {
          for (var professor in professors) professor['id']: []
        };
      });
    } catch (e) {
      print("Error fetching subjects and labs: $e");
    }
  }

  Future<void> storeAssignments() async {
    try {
      for (var professor in professors) {
        String professorId = professor['id'];
        String docName = "${professorId}_$selectedSemesterType";

        await FirebaseFirestore.instance.collection('Assigned').doc(docName).set({
          'ProfessorID': professorId,
          'ProfessorName': professor['name'],
          'SemesterType': selectedSemesterType,
          'AssignedSubjects': assignedSubjects[professorId] ?? [],
          'AssignedLabs': assignedLabs[professorId] ?? [],
          'Timestamp': FieldValue.serverTimestamp(),
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Assignments stored successfully!')),
      );
    } catch (e) {
      print("Error storing assignments: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error storing assignments!')),
      );
    }
  }

  void removeSubject(String professorId, String subject) {
    setState(() {
      assignedSubjects[professorId]?.remove(subject);
    });
  }

  void removeLab(String professorId, String lab) {
    setState(() {
      assignedLabs[professorId]?.remove(lab);
    });
  }

  Widget _buildDropdown(String hint, List<String> items, String professorId, Map<String, List<String>> assignedMap, Function removeFunction) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onChanged: (String? newValue) {
        if (newValue != null && !assignedMap[professorId]!.contains(newValue)) {
          setState(() {
            assignedMap[professorId]!.add(newValue);
          });
        }
      },
      items: items.map((String item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
    );
  }

  Widget _buildChipList(List<String> items, String professorId, Function removeFunction) {
    return Wrap(
      spacing: 8,
      children: items.map((item) => Chip(
        label: Text(item),
        deleteIcon: Icon(Icons.close),
        onDeleted: () => removeFunction(professorId, item),
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Assign Teacher",
          style: GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 25),
        ),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedSemesterType,
              decoration: InputDecoration(
                labelText: "Select Semester Type",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedSemesterType = newValue;
                  });
                  fetchSubjectsAndLabs(newValue);
                }
              },
              items: ['Odd Sem', 'Even Sem'].map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: professors.length,
                itemBuilder: (context, index) {
                  String professorId = professors[index]['id'];
                  return Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            professors[index]['name'],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                          ),
                          SizedBox(height: 10),
                          _buildDropdown("Select Subject", subjects[professorId] ?? [], professorId, assignedSubjects, removeSubject),
                          _buildChipList(assignedSubjects[professorId] ?? [], professorId, removeSubject),
                          _buildDropdown("Select Lab", labs[professorId] ?? [], professorId, assignedLabs, removeLab),
                          _buildChipList(assignedLabs[professorId] ?? [], professorId, removeLab),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}