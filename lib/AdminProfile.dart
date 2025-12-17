import 'package:flutter/material.dart';
import 'package:flutter_project/Info_user.dart';
import 'package:flutter_project/HomePage.dart';
import 'package:flutter_project/DB.dart';
import 'package:flutter_project/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _isEditingEnabled = false; // Checkbox state
  Map<String, dynamic>? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdminProfile();
  }

  Future<void> _loadAdminProfile() async {
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

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                width: 350,
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
                        Text("Admin Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),

                        // Name (Always Disabled for Part 2 req, or disabled by default)
                        // Part 2 says "Champ name (disabled)"
                        TextFormField(
                          controller: _nameController,
                          enabled: false, 
                          decoration: InputDecoration(labelText: "Name", prefixIcon: Icon(Icons.person)),
                        ),
                        SizedBox(height: 10),

                        // Checkbox to enable editing
                        Row(
                          children: [
                            Checkbox(
                              value: _isEditingEnabled,
                              onChanged: (val) {
                                setState(() {
                                  _isEditingEnabled = val ?? false;
                                  if (!_isEditingEnabled) {
                                      // Reset fields if unchecked? Or keep them? 
                                      // Logic: just disables the inputs.
                                  }
                                });
                              },
                            ),
                            Text("Enable Editing (Email / Password)"),
                          ],
                        ),

                        // Email (Editable only if checkbox is checked)
                        TextFormField(
                          controller: _emailController,
                          enabled: _isEditingEnabled,
                          validator: (value) {
                             if(value == null || value.isEmpty) return "Email required";
                             if(!value.contains("@")) return "Invalid email";
                             return null;
                          },
                          decoration: InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)),
                        ),
                        SizedBox(height: 20),

                        Text("Security", style: TextStyle(fontWeight: FontWeight.bold)),
                        
                        // Current Password (Always enabled for validation)
                        TextFormField(
                          controller: _currentPassController,
                          obscureText: true,
                          validator: (value) {
                             if (value == null || value.isEmpty) return "Current password required";
                             if (value != currentUser!['pass']) return "Incorrect current password";
                             return null;
                          },
                          decoration: InputDecoration(labelText: "Current Password", prefixIcon: Icon(Icons.lock)),
                        ),

                        // New Password (Enabled if checkbox checked)
                        TextFormField(
                          controller: _newPassController,
                          enabled: _isEditingEnabled,
                          obscureText: true,
                          validator: (value) {
                            if (!_isEditingEnabled) return null; // Skip if disabled
                            if (value == null || value.isEmpty) return null; // Optional if empty
                            return null;
                          },
                          decoration: InputDecoration(labelText: "New Password", prefixIcon: Icon(Icons.vpn_key)),
                        ),

                        // Confirm Password (Enabled if checkbox checked)
                        TextFormField(
                          controller: _confirmPassController,
                          enabled: _isEditingEnabled,
                          obscureText: true,
                          validator: (value) {
                             if (!_isEditingEnabled) return null;
                             if (_newPassController.text.isNotEmpty && value != _newPassController.text) {
                               return "Passwords do not match";
                             }
                             return null;
                          },
                          decoration: InputDecoration(labelText: "Confirm Password", prefixIcon: Icon(Icons.check)),
                        ),

                        SizedBox(height: 20),

                        // Update Button
                        MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                String? newEmail = _isEditingEnabled ? _emailController.text : null;
                                String? newPass = (_isEditingEnabled && _newPassController.text.isNotEmpty) 
                                                  ? _newPassController.text 
                                                  : null;
                                
                                int uid = currentUser!['uid'];

                                await updateUser(
                                  uid, 
                                  email: newEmail,
                                  password: newPass
                                );
                                
                                setState(() {
                                  // Update local state
                                  if (newEmail != null) currentUser!['email'] = newEmail;
                                  if (newPass != null) currentUser!['pass'] = newPass;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Profile updated successfully"))
                                );
                                
                                _currentPassController.clear();
                                _newPassController.clear();
                                _confirmPassController.clear();
                                setState(() {
                                    _isEditingEnabled = false;
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: $e"))
                                );
                              }
                            }
                          },
                          color: Colors.black,
                          textColor: Colors.white,
                          child: Text("Update Profile"),
                        ),
                         SizedBox(height: 20),
                        Divider(),
                         // Link to Manage Users (Interface 05 for Admin)
                        MaterialButton(
                            onPressed: () {
                                Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (_) => Info_user())
                                );
                            },
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text("Consulter la liste user"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Admin Profile is index 0
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) { // Pizza List (Optional/Standard)
             Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
          }
          if (index == 2) { // Manage Users
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
