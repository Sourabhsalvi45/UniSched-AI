import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String apiUrl = 'https://timetable45.onrender.com/generate_timetable';
  // final String apiUrl = 'http://127.0.0.1:5000/generate_timetable';

  Future<Map<String, dynamic>> generateTimetable({required String semester}) async {
    try {
      // Ensure the semester type is correctly formatted
      String formattedSemester = (semester.toLowerCase().contains("odd")) ? "Odd Semester" : "Even Semester";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'semester_type': formattedSemester}),
      ).timeout(Duration(seconds: 60));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load timetable: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error generating timetable: $e');
      throw Exception('Error generating timetable: $e');
    }
  }
}
