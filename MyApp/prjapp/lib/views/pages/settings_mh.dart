import 'package:flutter/material.dart';
import 'package:prjapp/views/pages/fac_home_page.dart';
//import 'stu_home_page.dart'; // import your existing login page here

class SettingsMh extends StatelessWidget {
const SettingsMh({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Settings",style: TextStyle(color:Colors.white),),centerTitle: true,backgroundColor: Colors.deepPurple[200],),
body: Padding(
padding: const EdgeInsets.all(12.0),
child: Column(
children: [
// Change Password tile
Row(
children: [
Expanded(
child: GestureDetector(
onTap: () {
Navigator.push(
context,
MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
);
},
child: Card(
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
child: Padding(
padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
child: Row(
children: const [
Icon(Icons.lock_outline, size: 28),
SizedBox(width: 8),
Text("Change Password", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
],
),
),
),
),
),
],
),
const SizedBox(height: 16),



        // Logout tile  
        Row(  
          children: [  
            Expanded(  
              child: GestureDetector(  
                onTap: () {  
                  // Navigate to your existing login page  
                  Navigator.pushAndRemoveUntil(  
                    context,  
                    MaterialPageRoute(builder: (_) => const FacHomePage(role: '',)), // replace with your login page  
                    (route) => false,  
                  );  
                },  
                child: Card(  
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),  
                  child: Padding(  
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),  
                    child: Row(  
                      children: const [  
                        Icon(Icons.logout, size: 28),  
                        SizedBox(width: 8),  
                        Text("Logout", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),  
                      ],  
                    ),  
                  ),  
                ),  
              ),  
            ),  
          ],  
        ),  
      ],  
    ),  
  ),  
);

}
}

// ChangePasswordPage remains the same
class ChangePasswordPage extends StatefulWidget {
const ChangePasswordPage({super.key});

@override
State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
final _presentPasswordController = TextEditingController();
final _newPasswordController = TextEditingController();
final _reEnterPasswordController = TextEditingController();

@override
void dispose() {
_presentPasswordController.dispose();
_newPasswordController.dispose();
_reEnterPasswordController.dispose();
super.dispose();
}

void _savePassword() {
final newPass = _newPasswordController.text;
final reEnter = _reEnterPasswordController.text;

if (newPass != reEnter) {  
  ScaffoldMessenger.of(context).showSnackBar(  
    const SnackBar(content: Text("New passwords do not match")),  
  );  
  return;  
}  

ScaffoldMessenger.of(context).showSnackBar(  
  const SnackBar(content: Text("Password changed successfully")),  
);  

Navigator.pop(context);

}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Change Password")),
body: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
children: [
TextField(
controller: _presentPasswordController,
obscureText: true,
decoration: const InputDecoration(
labelText: "Present Password",
border: OutlineInputBorder(),
),
),
const SizedBox(height: 12),
TextField(
controller: _newPasswordController,
obscureText: true,
decoration: const InputDecoration(
labelText: "New Password",
border: OutlineInputBorder(),
),
),
const SizedBox(height: 12),
TextField(
controller: _reEnterPasswordController,
obscureText: true,
decoration: const InputDecoration(
labelText: "Re-enter New Password",
border: OutlineInputBorder(),
),
),
const SizedBox(height: 20),
ElevatedButton(
onPressed: _savePassword,
child: const Text("Save"),
),
],
),
),
);
}
}
/*import 'package:flutter/material.dart';
import 'login_page.dart'; // import your existing login page here
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class SettingsMh extends StatelessWidget {
const SettingsMh({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Settings",style: TextStyle(color:Colors.white),),centerTitle: true,backgroundColor: Colors.deepPurple[200],),
body: Padding(
padding: const EdgeInsets.all(12.0),
child: Column(
children: [
// Change Password tile
Row(
children: [
Expanded(
child: GestureDetector(
onTap: () {
Navigator.push(
context,
MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
);
},
child: Card(
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
child: Padding(
padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
child: Row(
children: const [
Icon(Icons.lock_outline, size: 28),
SizedBox(width: 8),
Text("Change Password", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
],
),
),
),
),
),
],
),
const SizedBox(height: 16),


        const SizedBox(height: 16),  

        // Logout tile  
        Row(  
          children: [  
            Expanded(  
              child: GestureDetector(  
                onTap: () {  
                  // Navigate to your existing login page  
                  Navigator.pushAndRemoveUntil(  
                    context,  
                    MaterialPageRoute(builder: (_) => const LoginPage()), // replace with your login page  
                    (route) => false,  
                  );  
                },  
                child: Card(  
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),  
                  child: Padding(  
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),  
                    child: Row(  
                      children: const [  
                        Icon(Icons.logout, size: 28),  
                        SizedBox(width: 8),  
                        Text("Logout", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),  
                      ],  
                    ),  
                  ),  
                ),  
              ),  
            ),  
          ],  
        ),  
      ],  
    ),  
  ),  
);

}
}
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final  presentPasswordController = TextEditingController();
  final  newPasswordController = TextEditingController();
  final reEnterPasswordController = TextEditingController();

  // ✅ STEP 2: Create the API call function here
  Future<void> changePassword() async {
    print("Change password button clicked");
    final prefs = await SharedPreferences.getInstance();
        final token= prefs.getString('token'); // token stored after login
        print("Token:$token");

    final url = Uri.parse("http://192.168.0.183:5000/api/auth/change-password");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // ✅ Send JWT
      },
      body: jsonEncode({
        "presentPassword": presentPasswordController.text,
        "newPassword": newPasswordController.text,
        "reEnterPassword": reEnterPasswordController.text,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully!")),
      );
      Navigator.pop(context); // go back to settings
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"] ?? "Error changing password")),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple[200],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: presentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Present Password"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: reEnterPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Re-enter New Password"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[200],
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: changePassword, // ✅ CALL API HERE
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
*/
