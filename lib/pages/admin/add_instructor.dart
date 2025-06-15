import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart'; // For animations

class AddInstructorPage extends StatefulWidget {
  const AddInstructorPage({Key? key}) : super(key: key);

  @override
  _AddInstructorPageState createState() => _AddInstructorPageState();
}

class _AddInstructorPageState extends State<AddInstructorPage> {
  final TextEditingController _nameController = TextEditingController();

  // Function to add instructor to Firestore
  Future<void> _addInstructor() async {
    String name = _nameController.text.trim();
    if (name.isNotEmpty) {
      try {
        // Use the instructor's name as the document ID
        await FirebaseFirestore.instance.collection('Professor').doc(name).set({
          'Name': name, // Store the name inside the document
        });
        // Clear the text field after adding
        _nameController.clear();
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Instructor added successfully!')),
        );
      } catch (e) {
        // Show an error message if there's an issue
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5), // Light lavender background
      appBar: AppBar(
        title: Text(
          "Add Instructor",
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Heading
              FadeInDown(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 900),
                child: Center(
                  child: Text(
                    'Enter Instructor Details',
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // 🔹 Instructor Name Input Field
              FadeInLeft(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 900),
                child: _buildTextField("Instructor Name", _nameController, Icons.person),
              ),

              const SizedBox(height: 25),

              // 🔹 Add Instructor Button
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 900),
                child: _buildActionButton("Add Instructor", _addInstructor),
              ),

              const SizedBox(height: 30),

              // 🔹 Decorative Icon
              FadeInUp(
                delay: const Duration(milliseconds: 900),
                duration: const Duration(milliseconds: 900),
                child: Center(
                  child: Icon(
                    Icons.school_rounded,
                    color: Colors.deepPurpleAccent,
                    size: 100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// 🔹 Custom TextField Builder
  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter $label",
            hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.deepPurpleAccent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.deepPurpleAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

// 🔹 Custom Action Button
  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          shadowColor: Colors.black45,
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }

}
