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

  bool _isEditingEnabled = false;
  Map<String, dynamic>? currentUser;
  bool isLoading = true;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

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
                      "Admin Profile",
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
                                    // Admin Icon
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
                                        Icons.admin_panel_settings,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 24),

                                    Text(
                                      "Admin Settings",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2d3748),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Manage your admin account",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 32),

                                    // Name (Disabled)
                                    TextFormField(
                                      controller: _nameController,
                                      enabled: false,
                                      decoration: InputDecoration(
                                        labelText: "Name",
                                        labelStyle: TextStyle(color: Colors.grey[700]),
                                        prefixIcon: Icon(Icons.person_outline, color: Colors.grey[400]),
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

                                    // Enable Editing Checkbox
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.grey[200]!),
                                      ),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: _isEditingEnabled,
                                            activeColor: Color(0xFF667eea),
                                            onChanged: (val) {
                                              setState(() {
                                                _isEditingEnabled = val ?? false;
                                              });
                                            },
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Enable editing (Email / Password)",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16),

                                    // Email (Editable if checkbox checked)
                                    TextFormField(
                                      controller: _emailController,
                                      enabled: _isEditingEnabled,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) return "Email required";
                                        if (!value.contains("@")) return "Invalid email";
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Email",
                                        labelStyle: TextStyle(color: Colors.grey[700]),
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: _isEditingEnabled ? Color(0xFF667eea) : Colors.grey[400],
                                        ),
                                        fillColor: _isEditingEnabled ? Colors.grey[50] : Colors.grey[100],
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
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
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

                                    // New Password
                                    TextFormField(
                                      controller: _newPassController,
                                      enabled: _isEditingEnabled,
                                      obscureText: _obscureNewPassword,
                                      validator: (value) {
                                        if (!_isEditingEnabled) return null;
                                        if (value == null || value.isEmpty) return null;
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "New Password",
                                        labelStyle: TextStyle(color: Colors.grey[700]),
                                        prefixIcon: Icon(
                                          Icons.vpn_key_outlined,
                                          color: _isEditingEnabled ? Color(0xFF667eea) : Colors.grey[400],
                                        ),
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
                                        fillColor: _isEditingEnabled ? Colors.grey[50] : Colors.grey[100],
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
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),

                                    // Confirm Password
                                    TextFormField(
                                      controller: _confirmPassController,
                                      enabled: _isEditingEnabled,
                                      obscureText: _obscureConfirmPassword,
                                      validator: (value) {
                                        if (!_isEditingEnabled) return null;
                                        if (_newPassController.text.isNotEmpty && value != _newPassController.text) {
                                          return "Passwords do not match";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Confirm Password",
                                        labelStyle: TextStyle(color: Colors.grey[700]),
                                        prefixIcon: Icon(
                                          Icons.check_circle_outline,
                                          color: _isEditingEnabled ? Color(0xFF667eea) : Colors.grey[400],
                                        ),
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
                                        fillColor: _isEditingEnabled ? Colors.grey[50] : Colors.grey[100],
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
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
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
                                                if (newEmail != null) currentUser!['email'] = newEmail;
                                                if (newPass != null) currentUser!['pass'] = newPass;
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
                                              setState(() {
                                                _isEditingEnabled = false;
                                              });
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

                                    // Manage Users Button
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => Info_user())
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        side: BorderSide(color: Color(0xFF667eea), width: 2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        "Manage Users",
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
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF667eea),
        unselectedItemColor: Colors.grey[400],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
          }
          if (index == 2) {
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
