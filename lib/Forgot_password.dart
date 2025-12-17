import 'package:flutter/material.dart';
import 'package:flutter_project/HomePage.dart';
import 'package:flutter_project/DB.dart';
import 'package:flutter_project/LoginPage.dart';
import 'package:flutter_project/RegisterPage.dart';
import 'package:flutter_project/Info_user.dart';
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

  // State flags for editing
  bool _editEmail = false;
  bool _editPassword = false;

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
      appBar: AppBar(title: Text("forgot password")),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name (Disabled)
                        Center(child: Text("Display Info", style: TextStyle(fontWeight: FontWeight.bold))),
                        TextFormField(
                          controller: _nameController,
                          enabled: false,
                          decoration: InputDecoration(labelText: "Name", prefixIcon: Icon(Icons.person)),
                        ),
                        SizedBox(height: 10),

                        // Selection Checkboxes
                        Divider(),
                        Text("Select to Edit:", style: TextStyle(fontWeight: FontWeight.bold)),
                        CheckboxListTile(
                          title: Text("Edit Email"),
                          value: _editEmail, 
                          onChanged: (val) {
                            setState(() {
                              _editEmail = val!;
                              // Reset email to current if unchecked
                              if (!_editEmail && currentUser != null) {
                                _emailController.text = currentUser!['email'];
                              }
                            });
                          }
                        ),
                        CheckboxListTile(
                          title: Text("Edit Password"),
                          value: _editPassword, 
                          onChanged: (val) {
                            setState(() {
                              _editPassword = val!;
                              if (!_editPassword) {
                                _newPassController.clear();
                                _confirmPassController.clear();
                              }
                            });
                          }
                        ),
                        Divider(),
                        
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          enabled: _editEmail,
                          validator: (value) {
                             if (_editEmail) {
                               if (value == null || value.isEmpty) return "Email required";
                               if (!value.contains("@")) return "Invalid email";
                             }
                             return null;
                          },
                          decoration: InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)),
                        ),
                        SizedBox(height: 20),

                        if (_editPassword) ...[
                          Text("New Password Info", style: TextStyle(fontWeight: FontWeight.bold)),
                          TextFormField(
                            controller: _newPassController,
                            obscureText: true,
                            validator: (value) {
                              if (_editPassword) {
                                if (value == null || value.isEmpty) return "Required";
                                if (value.length < 6) return "Min 6 chars";
                                if (_currentPassController.text.isNotEmpty && _currentPassController.text == value) return "Must be different";
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: "New Password", prefixIcon: Icon(Icons.vpn_key)),
                          ),
                          TextFormField(
                            controller: _confirmPassController,
                            obscureText: true,
                            validator: (value) {
                               if (_editPassword) {
                                 if (value != _newPassController.text) return "Passwords do not match";
                               }
                               return null;
                            },
                            decoration: InputDecoration(labelText: "Confirm Password", prefixIcon: Icon(Icons.check)),
                          ),
                          SizedBox(height: 20),
                        ],

                        // Current Password (Always Required for changes)
                        Text("Security Verification", style: TextStyle(fontWeight: FontWeight.bold)),
                        TextFormField(
                          controller: _currentPassController,
                          obscureText: true,
                          validator: (value) {
                            // Only validate if we are actually editing something
                            if (_editEmail || _editPassword) {
                               if (value == null || value.isEmpty) return "Current password required";
                               if (value != currentUser!['pass']) return "Incorrect current password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: "Current Password", prefixIcon: Icon(Icons.lock)),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Confirm Change Button
                        Center(
                          child: MaterialButton(
                            onPressed: () async {
                              if (!_editEmail && !_editPassword) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("No changes selected"))
                                );
                                return;
                              }

                              if (_formKey.currentState!.validate()) {
                                try {
                                  print("Valid form. Updating Admin...");
                                  
                                  int uid = currentUser!['uid'];
                                  String? newEmail = _editEmail ? _emailController.text : null;
                                  String? newPass = _editPassword ? _newPassController.text : null;

                                  await updateUser(
                                    uid, 
                                    email: newEmail,
                                    password: newPass
                                  );
                                  
                                  print("Admin updated.");

                                  // Update local state
                                  setState(() {
                                    currentUser = {
                                      ...currentUser!,
                                      if (newEmail != null) 'email': newEmail,
                                      if (newPass != null) 'pass': newPass
                                    };
                                    
                                    // Make sure shared prefs are updated if email changed!
                                    if (newEmail != null) {
                                      SharedPreferences.getInstance().then((prefs) {
                                        prefs.setString('email', newEmail);
                                      });
                                    }
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Profile updated successfully"))
                                  );
                                  
                                  // Clear password fields and checkboxes
                                  _currentPassController.clear();
                                  _newPassController.clear();
                                  _confirmPassController.clear();
                                  setState(() {
                                    _editPassword = false;
                                    _editEmail = false;
                                  });
                                  
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
                        ),

                        SizedBox(height: 10),

                        // Consult List Button (Redirect to Interface 05 - Info_user)
                        Center(
                          child: MaterialButton(
                            onPressed: () {
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => Info_user()), 
                                );
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text("Consulter la liste user"),
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Profile is index 0
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) { // Pizza List
            Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
          }
          if (index == 2) { // Admin Dashboard
             Navigator.push(context, MaterialPageRoute(builder: (_) => Info_user()));
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Me"),
          BottomNavigationBarItem(icon: Icon(Icons.local_pizza), label: "Pizzas"),
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: "Manage Users"),
        ],
      ),
    );
  }
}