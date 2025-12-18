import 'package:flutter/material.dart';
import 'package:flutter_project/HomePage.dart';
import 'package:flutter_project/DB.dart';
import 'package:flutter_project/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});
  State<UserProfile> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  Map<String, dynamic>? currentUser;
  bool isLoading = true;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

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
      backgroundColor: Colors.grey[100],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "My Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.white),
                      onPressed: _handleLogout,
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator(color: Colors.white))
                    : SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 500),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Profile Icon
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 24),

                                    Text(
                                      "Update Profile",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2d3748),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Manage your account information",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 32),

                                    // Email (Disabled)
                                    TextFormField(
                                      controller: _emailController,
                                      enabled: false,
                                      decoration: InputDecoration(
                                        labelText: "Email",
                                        labelStyle: TextStyle(color: Colors.grey[700]),
                                        prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[400]),
                                        fillColor: Colors.grey[100],
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),

                                    // Name (Editable)
                                    TextFormField(
                                      controller: _nameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) return "Name required";
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Name",
                                        labelStyle: TextStyle(color: Colors.grey[700]),
                                        prefixIcon: Icon(Icons.person_outline, color: Color(0xFF667eea)),
                                        fillColor: Colors.grey[50],
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF667eea), width: 2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 24),

                                    // Security Section
                                    Text(
                                      "Security",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2d3748),
                                      ),
                                    ),
                                    SizedBox(height: 16),

                                    // Current Password
                                    TextFormField(
                                      controller: _currentPassController,
                                      obscureText: _obscureCurrentPassword,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) return "Current password required";
                                        if (value != currentUser!['pass']) return "Incorrect current password";
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Current Password",
                                        labelStyle: TextStyle(color: Colors.grey[700]),
                                        prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF667eea)),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureCurrentPassword ? Icons.visibility_off : Icons.visibility,
                                            color: Colors.grey[600],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureCurrentPassword = !_obscureCurrentPassword;
                                            });
                                          },
                                        ),
                                        fillColor: Colors.grey[50],
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF667eea), width: 2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),

                                    // New Password (Optional)
                                    TextFormField(
                                      controller: _newPassController,
                                      obscureText: _obscureNewPassword,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) return null;
                                        if (value.length < 6) return "Min 6 chars";
                                        if (!value.contains(RegExp(r'[A-Z]'))) return "Need 1 Upper";
                                        if (!value.contains(RegExp(r'[a-z]'))) return "Need 1 Lower";
                                        if (!value.contains(RegExp(r'[0-9]'))) return "Need 1 Number";
                                        if (value == _currentPassController.text) return "Must be different";
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "New Password (Optional)",
                                        labelStyle: TextStyle(color: Colors.grey[700]),
                                        prefixIcon: Icon(Icons.vpn_key_outlined, color: Color(0xFF667eea)),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                                            color: Colors.grey[600],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureNewPassword = !_obscureNewPassword;
                                            });
                                          },
                                        ),
                                        fillColor: Colors.grey[50],
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF667eea), width: 2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),

                                    // Confirm Password
                                    TextFormField(
                                      controller: _confirmPassController,
                                      obscureText: _obscureConfirmPassword,
                                      validator: (value) {
                                        if (_newPassController.text.isEmpty) return null;
                                        if (value != _newPassController.text) return "Passwords do not match";
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Confirm Password",
                                        labelStyle: TextStyle(color: Colors.grey[700]),
                                        prefixIcon: Icon(Icons.check_circle_outline, color: Color(0xFF667eea)),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                            color: Colors.grey[600],
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureConfirmPassword = !_obscureConfirmPassword;
                                            });
                                          },
                                        ),
                                        fillColor: Colors.grey[50],
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF667eea), width: 2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 32),

                                    // Update Button
                                    Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFF667eea).withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: MaterialButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            try {
                                              String newPass = _newPassController.text;
                                              String? passToUpdate = newPass.isNotEmpty ? newPass : null;

                                              int uid = currentUser!['uid'];

                                              await updateUser(
                                                uid,
                                                name: _nameController.text,
                                                password: passToUpdate
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
                                                SnackBar(
                                                  content: Text("Profile updated successfully"),
                                                  backgroundColor: Colors.green[400],
                                                )
                                              );

                                              _currentPassController.clear();
                                              _newPassController.clear();
                                              _confirmPassController.clear();
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("Error: $e"),
                                                  backgroundColor: Colors.red[400],
                                                )
                                              );
                                            }
                                          }
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          "Update Profile",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),

                                    // View Pizzas Button
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
                                      },
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        side: BorderSide(color: Color(0xFF667eea), width: 2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        "View Pizza Menu",
                                        style: TextStyle(
                                          color: Color(0xFF667eea),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Color(0xFF667eea),
        unselectedItemColor: Colors.grey[400],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.local_pizza), label: "Pizza List"),
        ],
      ),
    );
  }
}

