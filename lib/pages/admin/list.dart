import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedDepartment = 'CSE';
  String? selectedSemesterType;
  String? selectedSemester;
  List<String> semesterTypes = ["Odd Sem", "Even Sem"];
  List<String> semesters = [];

  Stream<QuerySnapshot>? _subjectsStream;
  Stream<QuerySnapshot>? _labsStream;

  void updateStreams() {
    if (selectedSemesterType != null && selectedSemester != null) {
      setState(() {
        _subjectsStream = _firestore
            .collection('Departments')
            .doc(selectedDepartment)
            .collection(selectedSemesterType!)
            .doc(selectedSemester)
            .collection('Subject')
            .snapshots();

        _labsStream = _firestore
            .collection('Departments')
            .doc(selectedDepartment)
            .collection(selectedSemesterType!)
            .doc(selectedSemester)
            .collection('Lab')
            .snapshots();
      });
    }
  }

  void _deleteSubject(String subjectId) {
    _firestore
        .collection('Departments')
        .doc(selectedDepartment)
        .collection(selectedSemesterType!)
        .doc(selectedSemester)
        .collection('Subject')
        .doc(subjectId)
        .delete();
  }

  void _deleteLab(String labId) {
    _firestore
        .collection('Departments')
        .doc(selectedDepartment)
        .collection(selectedSemesterType!)
        .doc(selectedSemester)
        .collection('Lab')
        .doc(labId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subjects & Labs",
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown("Select Semester Type", selectedSemesterType, semesterTypes, (value) {
              setState(() {
                selectedSemesterType = value;
                selectedSemester = null;
                semesters = value == "Odd Sem" ? ["3", "5", "7"] : ["4", "6", "8"];
              });
            }),
            SizedBox(height: 15),
            _buildDropdown("Select Semester", selectedSemester, semesters, (value) {
              setState(() {
                selectedSemester = value;
                updateStreams();
              });
            }),
            SizedBox(height: 20),
            Expanded(child: _buildList("Subjects", _subjectsStream, _deleteSubject)),
            SizedBox(height: 20),
            Expanded(child: _buildList("Labs", _labsStream, _deleteLab)),
          ],
        ),
      ),
    );
  }

// 📌 **Dropdown Builder (Minimal Styling)**
  Widget _buildDropdown(String label, String? value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
      value: value,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

// 📌 **List Builder (Minimal but Clean UI)**
  Widget _buildList(String title, Stream<QuerySnapshot>? stream, Function(String) deleteFunction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.deepPurple)),
        SizedBox(height: 10),
        Expanded(
          child: stream == null
              ? _emptyState("Please select Semester Type & Semester") // Professional Empty State
              : StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              var items = snapshot.data!.docs;
              if (items.isEmpty) return _emptyState("No data available");
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];
                  return _buildListItem(item.id, () => _showDeleteDialog(context, item.id, deleteFunction));
                },
              );
            },
          ),
        ),
      ],
    );
  }

// 📌 **List Item with Delete Button**
  Widget _buildListItem(String title, VoidCallback onDelete) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }

// 📌 **Delete Confirmation Dialog**
  void _showDeleteDialog(BuildContext context, String id, Function(String) deleteFunction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Item", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text("Are you sure you want to delete $id?"),
          actions: [
            TextButton(child: Text("Cancel"), onPressed: () => Navigator.pop(context)),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                deleteFunction(id);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

// 📌 **Empty State UI**
  Widget _emptyState(String message) {
    return Center(
      child: Text(message, style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600])),
    );
  }

}
