import 'package:UniSched/pages/home/create_time_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';



class Instructor extends StatefulWidget {
  const Instructor({Key? key}) : super(key: key);

  @override
  _InstructorState createState() => _InstructorState();
}

class _InstructorState extends State<Instructor> {
  String selectedSemester = "Odd Semester";
  String? selectedInstructor;
  Map<String, Map<String, List<String>>> timetables = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedInstructor = INSTRUCTORS.keys.first;
  }

  void generateTimetables() {
    setState(() => isLoading = true);
    Map<String, Map<String, List<String>>> generated =
    TimetableGenerator.generateTimetables(selectedSemester);
    setState(() {
      timetables = generated;
      isLoading = false;
    });
  }

  Future<void> generatePdf() async {
    if (timetables.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No timetable to download!")),
      );
      return;
    }

    // Check for storage permission
    PermissionStatus permissionStatus = await Permission.storage.status;

    // For Android 11+, try manageExternalStorage if standard storage isn't granted
    if (!permissionStatus.isGranted) {
      permissionStatus = await Permission.storage.request();
      if (!permissionStatus.isGranted) {
        // Try to request manage external storage permission (Android 11+)
        permissionStatus = await Permission.manageExternalStorage.request();
      }
    }

    // Only proceed if permission is granted
    if (!permissionStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Storage permission denied! Please enable it from settings.")),
      );
      return;
    }

    // Build the PDF
    final pdf = pw.Document();

    timetables.forEach((section, timetable) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Timetable - $section",
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                cellAlignment: pw.Alignment.center,
                headerStyle: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                headers: ["Time Slot", ...DAYS],
                data: List.generate(TIME_SLOTS.length, (index) {
                  return [
                    TIME_SLOTS[index],
                    ...DAYS.map((day) => timetable[day]?[index] ?? "-"),
                  ];
                }),
              ),
              pw.SizedBox(height: 20),
            ],
          ),
        ),
      );
    });

    try {
      // Save PDF to Downloads folder
      final directory = Directory('/storage/emulated/0/Download');
      final file = File("${directory.path}/Timetable.pdf");
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF saved in Downloads folder!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save PDF: $e")),
      );
    }
  }

  Future<void> saveTimetableToFirestore() async {
    if (timetables.isEmpty) return;

    String semesterCollection = selectedSemester == "Odd Semester" ? "OddSem" : "EvenSem";
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    for (var entry in timetables.entries) {
      String section = entry.key; // SE, TE, BE
      Map<String, List<String>> timetable = entry.value;

      String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

      await firestore
          .collection("Timetables")
          .doc(semesterCollection)
          .collection(section)
          .doc(uniqueId) // Unique document ID
          .set({
        "schedule": timetable,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Timetable saved successfully!")),
    );
  }



  Widget _buildTimetableHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.deepPurple,
        ),
      ),
    );
  }


  Map<String, List<String>> buildInstructorTimetable(String instructor) {
    Map<String, List<String>> instructorTimetable = TimetableGenerator.createEmptyTimetable();

    timetables.forEach((section, timetable) {
      for (var day in DAYS) {
        for (int i = 0; i < TIME_SLOTS.length; i++) {
          String cell = timetable[day]![i];
          if (cell.isNotEmpty && cell != "Break") {
            List<String> parts = cell.split(" (");
            if (parts.length > 1) {
              String cellInstructor = parts[1].replaceAll(")", "");
              if (cellInstructor == instructor) {
                instructorTimetable[day]![i] = cell;
              }
            }
          }
        }
      }
    });

    return instructorTimetable;
  }

  Widget buildTimetableTable(Map<String, List<String>> timetable) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 4, spreadRadius: 1),
          ],
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.purple.shade300),
              dataRowColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                return states.contains(WidgetState.selected) ? Colors.purple.shade100 : null;
              }),
              border: TableBorder.symmetric(
                inside: BorderSide(width: 1, color: Colors.grey.shade300),
              ),
              columns: [
                const DataColumn(
                  label: Text(
                    "Time Slot",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                  ),
                ),
                ...DAYS.map(
                      (day) => DataColumn(
                    label: Text(
                      day,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                    ),
                  ),
                ).toList(),
              ],
              rows: List.generate(TIME_SLOTS.length, (index) {
                return DataRow(
                  color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                    return index % 2 == 0 ? Colors.grey.shade100 : Colors.white;
                  }),
                  cells: [
                    DataCell(
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          TIME_SLOTS[index],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ),
                    ...DAYS.map((day) {
                      String cellContent = timetable[day]?[index] ?? "-";

                      return DataCell(
                        Center(
                          child: Text(
                            cellContent,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
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

  @override
  Widget build(BuildContext context) {
    List<String> instructors = INSTRUCTORS.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Timetable Generator",
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 26, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Semester Selection
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSemesterRadio("Odd Semester"),
                  _buildSemesterRadio("Even Semester"),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Instructor Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.deepPurpleAccent, width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedInstructor,
                  hint: const Text("Select Instructor"),
                  isExpanded: true,
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                  dropdownColor: Colors.white,
                  onChanged: (String? newValue) => setState(() => selectedInstructor = newValue),
                  items: instructors.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            // Buttons with Horizontal Scroll
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton("Generate Timetable", generateTimetables, isLoading, Colors.deepPurpleAccent),
                  const SizedBox(width: 10),
                  _buildButton("Save Timetable", saveTimetableToFirestore, false, Colors.green),
                  const SizedBox(width: 10),
                  _buildButton("Download PDF", generatePdf, false, Colors.blue),
                ],
              ),
            ),
            Expanded(
              child: timetables.isEmpty
                  ? Center(
                child: Text(
                  "No timetable generated yet.",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
                  : ListView(
                children: [
                  ...timetables.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTimetableHeader("${entry.key} Timetable"),
                        buildTimetableTable(entry.value),
                      ],
                    );
                  }).toList(),
                  if (selectedInstructor != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTimetableHeader("Timetable for $selectedInstructor"),
                        buildTimetableTable(buildInstructorTimetable(selectedInstructor!)),
                      ],
                    ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildSemesterRadio(String value) {
    return Row(
      children: [
        Radio<String>(
          activeColor: Colors.deepPurpleAccent,
          value: value,
          groupValue: selectedSemester,
          onChanged: (val) => setState(() => selectedSemester = val!),
        ),
        Text(value, style: GoogleFonts.poppins(fontSize: 14)),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, bool isLoading, Color color) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: isLoading
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
          : Text(
        text,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}
