444444444444444444444444444444444444444444444444444444444444import 'package:flutter/material.dart';
import 'package:flutter_project/HomePage.dart';
import 'package:flutter_project/DB.dart';
import 'package:flutter_project/LoginPage.dart';
import 'package:flutter_project/RegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Info_user extends StatefulWidget {
  const Info_user({super.key});
  State<Info_user> createState() => Info_user_state();
}

class Info_user_state extends State<Info_user> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  Map<String, dynamic>? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    if (email != null) {
      var user = await getUserByEmail(email);
      if (user != null) {
        setState(() {
          currentUser = user;
          _nameController.text = user['name'];
          _emailController.text = user['email'];
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Profile")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                width: 300,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white60, Colors.black12],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text("Change Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        
                        // Email (Disabled)
                        TextFormField(
                          controller: _emailController,
                          enabled: false,
                          decoration: InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)),
                        ),
                        SizedBox(height: 10),

                        // Name (Editable)
                        TextFormField(
                          controller: _nameController,
                          validator: (value) {
                             if(value == null || value.isEmpty) return "Name required";
                             return null;
                          },
                          decoration: InputDecoration(labelText: "Name", prefixIcon: Icon(Icons.person)),
                        ),
                        SizedBox(height: 20),

                        Text("Security", style: TextStyle(fontWeight: FontWeight.bold)),
                        
                        // Current Password
                        TextFormField(
                          controller: _currentPassController,
                          obscureText: true,
                          validator: (value) {
                             // Always required to confirm identity before ANY change
                             if (value == null || value.isEmpty) return "Current password required";
                             if (value != currentUser!['pass']) return "Incorrect current password";
                             return null;
                          },
                          decoration: InputDecoration(labelText: "Current Password", prefixIcon: Icon(Icons.lock)),
                        ),

                        // New Password (Optional)
                        TextFormField(
                          controller: _newPassController,
                          obscureText: true,
                          validator: (value) {
                            // If empty, user only wants to change name -> VALID
                            if (value == null || value.isEmpty) return null;
                            
                            // If not empty, enforce rules
                            if (value.length < 6) return "Min 6 chars";
                            if (!value.contains(RegExp(r'[A-Z]'))) return "Missing uppercase";
                            if (!value.contains(RegExp(r'[a-z]'))) return "Missing lowercase";
                            if (!value.contains(RegExp(r'[0-9]'))) return "Missing digit";
                            
                            if (value == _currentPassController.text) return "New password must be different";
                            
                            return null;
                          },
                          decoration: InputDecoration(labelText: "New Password (Optional)", prefixIcon: Icon(Icons.vpn_key)),
                        ),

                        // Confirm Password
                        TextFormField(
                          controller: _confirmPassController,
                          obscureText: true,
                          validator: (value) {
                             // If new pass is empty, this must be empty/ignored
                             if (_newPassController.text.isEmpty) return null;
                             
                             if (value != _newPassController.text) return "Passwords do not match";
                             return null;
                          },
                          decoration: InputDecoration(labelText: "Confirm Password", prefixIcon: Icon(Icons.check)),
                        ),

                        SizedBox(height: 20),

                        // Confirm Change Button
                        MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                print("Valid form. Updating user...");
                                String newPass = _newPassController.text;
                                String? passToUpdate = newPass.isNotEmpty ? newPass : null;
                                
                                int uid = currentUser!['uid'];
                                print("Updating UID: $uid, Name: ${_nameController.text}, Pass: $passToUpdate");

                                await updateUser(
                                  uid, 
                                  _nameController.text, 
                                  passToUpdate
                                );
                                
                                setState(() {
                                  String finalPass = passToUpdate ?? currentUser!['pass']; 
                                  currentUser = {
                                    ...currentUser!,
                                    'name': _nameController.text,
                                    'pass': finalPass
                                  };
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Profile updated successfully"))
                                );
                                
                                _currentPassController.clear();
                                _newPassController.clear();
                                _confirmPassController.clear();
                              } catch (e) {
                                print("Error updating profile: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: $e"))
                                );
                              }
                            } else {
                              print("Form invalid");
                            }
                          },
                          color: Colors.black,
                          textColor: Colors.white,
                          child: Text("Confirm Change"),
                        ),

                        SizedBox(height: 10),

                        // Consult List Button (Redirect to Interface 02)
                        MaterialButton(
                          onPressed: () {
                             Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => HomePage()), 
                              );
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Text("Consulter la liste"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Highlight "Login" / Profile
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
          }
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
          }
          if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person_2), label: "Login"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Sign-Up"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        ],
      ),
    );
  }
}