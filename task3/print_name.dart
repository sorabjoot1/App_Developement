import 'package:flutter/material.dart';

class PrintNamePage extends StatefulWidget {
  @override
  _PrintNamePageState createState() => _PrintNamePageState();
}

class _PrintNamePageState extends State<PrintNamePage> {
  TextEditingController nameController = TextEditingController();
  String displayName = "";
  String message = "";

  void printName() {
    setState(() {
      displayName = nameController.text;
      if (displayName.isNotEmpty) {
        message = "Print Successful!";
      } else {
        message = "Please enter a name!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Print Name")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Enter Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: printName,
              child: Text("Print"),
            ),
            SizedBox(height: 20),
            Text(displayName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
            SizedBox(height: 10),
            Text(message, style: TextStyle(fontSize: 18, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
