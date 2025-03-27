import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'grade_book.dart';  
import 'package:login/login.dart';
import 'package:login/calculator.dart';
import 'package:login/print_name.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePage({super.key}); // GlobalKey for Drawer

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ✅ University Name & Logo (Left Side)
            Row(
              children: [
               // Image.asset('assets/bgnu.png', height: 40), // Ensure image exists
                SizedBox(width: 10),
                Text(
                  'BABA GURU NANAK UNIVERSITY',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            // ✅ Centered Navigation Links
            Row(
              children: [
                _buildNavItem("Home", () {}),
                _buildNavItem("About", () {}),
                _buildNavItem("Contact", () {}),
                _buildNavItem("Admission", () {}),
              ],
            ),

            // ✅ Logout Button & Three-dot Menu (Right Side)
            Row(
              children: [
                // Logout Button
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () => logout(context),
                ),

                // Three-dot Menu Button
                PopupMenuButton<String>(
                  onSelected: (String value) {
                    switch (value) {
                      case 'Calculator':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CalculatorPage()));
                        break;
                      case 'Grade Book':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => GradeBookPage()));
                        break;
                      case 'Print Name':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PrintNamePage())); 
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(value: 'Calculator', child: Text('Calculator')),
                    PopupMenuItem(value: 'Grade Book', child: Text('Grade Book')),
                    PopupMenuItem(value: 'Print Name', child: Text('Print Name')),
                  ],
                  icon: Icon(Icons.more_vert, color: Colors.white), // Three-dot icon
                ),
              ],
            ),
          ],
        ),
      ),

      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text("Calculator"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CalculatorPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.grade),
              title: Text("Grade Book"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GradeBookPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.print),
              title: Text('Print Name'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrintNamePage()), // Navigate to Print Name Page
                );
              },
            ),
          ],
        ),
      ), // 🛠 **Drawer was missing closing here!** ✅

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'BABA GURU NANAK UNIVERSITY is a reputed educational institution known for its academic excellence and state-of-the-art infrastructure...',
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        child: Icon(Icons.menu),
      ),
    );
  }

  // ✅ Helper function for Navigation Links
  Widget _buildNavItem(String title, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: onTap,
        child: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
