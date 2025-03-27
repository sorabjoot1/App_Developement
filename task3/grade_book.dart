import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GradeBookPage extends StatefulWidget {
  const GradeBookPage({super.key});

  @override
  _GradeBookPageState createState() => _GradeBookPageState();
}

class _GradeBookPageState extends State<GradeBookPage> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController marksController = TextEditingController();
  final TextEditingController creditHoursController = TextEditingController();

  List<Map<String, dynamic>> grades = [];

  @override
  void initState() {
    super.initState();
    loadGrades();
  }

  void saveGrades() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(grades);
    prefs.setString('grades', encodedData);
  }

  void loadGrades() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('grades');
    if (data != null) {
      setState(() {
        grades = List<Map<String, dynamic>>.from(jsonDecode(data));
      });
    }
  }

  void addGrade() {
    String subject = subjectController.text;
    int? marks = int.tryParse(marksController.text);
    int? creditHours = int.tryParse(creditHoursController.text);

    if (subject.isNotEmpty && marks != null && creditHours != null) {
      String grade;
      double gradePoint;

      if (marks >= 80) {
        grade = 'A';
        gradePoint = 4.0;
      } else if (marks >= 70) {
        grade = 'B';
        gradePoint = 3.0;
      } else if (marks >= 60) {
        grade = 'C';
        gradePoint = 2.0;
      } else if (marks >= 50) {
        grade = 'D';
        gradePoint = 1.0;
      } else {
        grade = 'F';
        gradePoint = 0.0;
      }

      List<Map<String, dynamic>> newBookGrades = [];
      newBookGrades.add({
        'subject': subject,
        'marks': marks,
        'creditHours': creditHours,
        'grade': grade,
        'gradePoint': gradePoint,
      });

      double cgpa = calculateCGPA(newBookGrades); // ✅ Separate CGPA Calculation

      setState(() {
        grades.add({
          'subject': subject,
          'marks': marks,
          'creditHours': creditHours,
          'grade': grade,
          'gradePoint': gradePoint,
          'cgpa': cgpa, // ✅ Each book has its own CGPA
        });
      });

      saveGrades();
      subjectController.clear();
      marksController.clear();
      creditHoursController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields correctly")),
      );
    }
  }

  double calculateCGPA(List<Map<String, dynamic>> bookGrades) {
    if (bookGrades.isEmpty) return 0.0;
    double totalPoints = 0;
    int totalCreditHours = 0;

    for (var grade in bookGrades) {
      totalPoints += grade['gradePoint'] * (grade['creditHours'] as int);
      totalCreditHours += (grade['creditHours'] as int);
    }

    return totalCreditHours == 0 ? 0.0 : totalPoints / totalCreditHours;
  }

  void clearGrades() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('grades');
    setState(() {
      grades.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grade Book", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField(subjectController, "Subject Name"),
            SizedBox(height: 10),
            buildTextField(marksController, "Total Marks", isNumeric: true),
            SizedBox(height: 10),
            buildTextField(creditHoursController, "Credit Hours (CH)", isNumeric: true),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: addGrade,
                  child: Text("Add Grade"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: clearGrades,
                  child: Text("Clear All"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            grades.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: grades.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white,
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: Icon(Icons.school, color: Colors.blueAccent),
                            title: Text("${grades[index]['subject']}", style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              "Marks: ${grades[index]['marks']} | CH: ${grades[index]['creditHours']}\n"
                              "Grade: ${grades[index]['grade']} | Point: ${grades[index]['gradePoint']} | "
                              "CGPA: ${grades[index]['cgpa'].toStringAsFixed(2)}", // ✅ Separate CGPA per book
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(child: Text("No grades added yet.", style: TextStyle(fontSize: 16, color: Colors.grey))),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, {bool isNumeric = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
