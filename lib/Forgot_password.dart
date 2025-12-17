import 'package:flutter/material.dart';
import 'package:flutter_project/HomePage.dart';
import 'package:flutter_project/DB.dart';
import 'package:flutter_project/LoginPage.dart';
import 'package:flutter_project/RegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Forgot_password extends StatefulWidget {
  const Forgot_password({super.key});
  State<Forgot_password> createState() => Forgot_password_state();
}

class Forgot_password_state extends State<Forgot_password> {
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
      appBar: AppBar(title: Text("Admin Profile")),
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
                        // Name (Disabled)
                        TextFormField(
                          controller: _nameController,
                          enabled: false,
                          decoration: InputDecoration(labelText: "Name", prefixIcon: Icon(Icons.person)),
                        ),
                        SizedBox(height: 10),
                        
                        // Email (Disabled)
                        TextFormField(
                          controller: _emailController,
                          enabled: false,
                          decoration: InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)),
                        ),
                        SizedBox(height: 20),

                        Text("Change Password", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),

                        // Current Password
                        TextFormField(
                          controller: _currentPassController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Required";
                            if (value != currentUser!['pass']) return "Incorrect current password";
                            return null;
                          },
                          decoration: InputDecoration(labelText: "Current Password", prefixIcon: Icon(Icons.lock)),
                        ),
                        
                        // New Password
                        TextFormField(
                          controller: _newPassController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Required";
                            if (value.length < 6) return "Min 6 chars";
                            if (_currentPassController.text == value) return "New password must be different";
                            return null;
                          },
                          decoration: InputDecoration(labelText: "New Password", prefixIcon: Icon(Icons.vpn_key)),
                        ),

                        // Confirm Password
                        TextFormField(
                          controller: _confirmPassController,
                          obscureText: true,
                          validator: (value) {
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
                                print("Valid form. Updating Admin password...");
                                await updateUser(
                                  currentUser!['uid'], 
                                  _nameController.text, 
                                  _newPassController.text
                                );
                                
                                print("Admin password updated.");

                                // Update local state to reflect new password for next time
                                setState(() {
                                  currentUser = {
                                    ...currentUser!,
                                    'pass': _newPassController.text
                                  };
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Password updated successfully"))
                                );
                                
                                // Clear password fields
                                _currentPassController.clear();
                                _newPassController.clear();
                                _confirmPassController.clear();
                              } catch (e) {
                                print("Error updating admin profile: $e");
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
        currentIndex: 0, 
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