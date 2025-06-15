import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Dropdown state
  String _selectedRole = 'Faculty'; // Default value
  List<String> _roles = ['HOD', 'Faculty'];

  @override
  void initState() {
    super.initState();
    _checkHODExists();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _checkHODExists() async {
    QuerySnapshot hodQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'HOD')
        .limit(1)
        .get();

    if (hodQuery.docs.isNotEmpty) {
      setState(() {
        _roles = ['Faculty']; // Remove 'HOD' if already exists
        _selectedRole = 'Faculty';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orangeAccent, Colors.deepOrangeAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.h, bottom: 4.h),
                  child: FadeInDown(
                    duration: const Duration(milliseconds: 1000),
                    child: Column(
                      children: [
                        Icon(Icons.person_add, size: 50.sp, color: Colors.white),
                        SizedBox(height: 2.h),
                        Text(
                          'Register Account',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lilitaOne(
                            fontSize: 23.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SlideInUp(
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 0),
                            _buildTextField(_firstNameController, 'First Name', 'Enter your first name'),
                            _buildTextField(_middleNameController, 'Middle Name', 'Enter your middle name'),
                            _buildTextField(_lastNameController, 'Last Name', 'Enter your last name'),
                            _buildTextField(_idController, 'ID', 'Enter a unique ID'),
                            _buildTextField(_emailController, 'Email', 'Enter your email', keyboardType: TextInputType.emailAddress),
                            _buildPasswordField(_passwordController, 'Password', 'Enter your password', obscureText: _obscurePassword, onVisibilityToggle: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            }),
                            _buildPasswordField(_confirmPasswordController, 'Confirm Password', 'Confirm your password', obscureText: _obscureConfirmPassword, onVisibilityToggle: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            }),

                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              child: DropdownButtonFormField<String>(
                                value: _selectedRole,
                                decoration: InputDecoration(
                                  labelText: 'Role',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                ),
                                items: _roles.map((role) {
                                  return DropdownMenuItem(
                                    value: role,
                                    child: Text(role),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRole = value!;
                                  });
                                },
                              ),
                            ),

                            SizedBox(height: 3.h),
                            Center(
                              child: ElevatedButton(
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 12.w),
                                  backgroundColor: Colors.deepOrangeAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 5,
                                ),
                                child: Text(
                                  'Register',
                                  style: GoogleFonts.rubik(fontSize: 14.sp, fontWeight: FontWeight.w600,color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
        validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, String hint, {required bool obscureText, required VoidCallback onVisibilityToggle}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: onVisibilityToggle,
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String userEnteredID = _idController.text.trim(); // ✅ Get user-entered ID

      // Store user data in Firestore using the user-entered ID
      await FirebaseFirestore.instance.collection('users').doc(userEnteredID).set({
        'first_name': _firstNameController.text.trim(),
        'middle_name': _middleNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'id': userEnteredID, // Save user-entered ID as document ID
        'email': _emailController.text.trim(),
        'role': _selectedRole, // Save role
        'auth_uid': userCredential.user!.uid, // Save Firebase Authentication UID for reference
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration Successful!')));
      Navigator.pop(context);

    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

}
