import 'package:flutter/material.dart';
import 'package:flutter_project/LoginPage.dart';
import 'package:flutter_project/HomePage.dart';
import 'package:flutter_project/DB.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
 State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  int currentindx = 1 ;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  int i = 0 ;
  bool is_empty=true ,has_upper = false , has_lower = false , has_number = false , has_special = false , valid_length = false;
  bool _obscurePassword = true;

  final formState = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
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
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 450),
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
                        key: formState,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Logo/Icon
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person_add,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 24),
                            
                            // Title
                            Text(
                              'Create Account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2d3748),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Sign up to get started',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 32),

                            // Username Field
                            TextFormField(
                              controller: _usernameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Username cannot be empty";
                                }
                                if (value.length < 3) {
                                  return "Username must be at least 3 characters";
                                }
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.grey[50],
                                filled: true,
                                labelText: "Username",
                                labelStyle: TextStyle(color: Colors.grey[700]),
                                prefixIcon: Icon(Icons.person_outline, color: Color(0xFF667eea)),
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
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red[300]!, width: 1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),

                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Email cannot be empty";
                                }
                                if (!value.contains("@")) {
                                  return "Email is not valid";
                                }
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.grey[50],
                                filled: true,
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.grey[700]),
                                prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF667eea)),
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
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red[300]!, width: 1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),

                            // Password Field
                            TextFormField(
                              obscureText: _obscurePassword,
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                if (!value.contains(RegExp(r'[A-Z]'))) return 'Missing uppercase';
                                if (!value.contains(RegExp(r'[a-z]'))) return 'Missing lowercase';
                                if (!value.contains(RegExp(r'[0-9]'))) return 'Missing digit';
                                if (!value.contains(RegExp(r'[^a-zA-Z0-9]'))) return 'Missing special char';
                                if (value.length < 8) return 'Too short';
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  has_upper = value.contains(RegExp(r'[A-Z]'));
                                  has_lower = value.contains(RegExp(r'[a-z]'));
                                  has_number = value.contains(RegExp(r'[0-9]'));
                                  has_special = value.contains(
                                      RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
                                  valid_length = value.length >= 8;
                                });
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.grey[50],
                                filled: true,
                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.grey[700]),
                                prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF667eea)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
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
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red[300]!, width: 1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),

                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Password Requirements:",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildRequirement("1 uppercase", has_upper),
                                            _buildRequirement("1 lowercase", has_lower),
                                            _buildRequirement("1 number", has_number),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildRequirement("1 special char", has_special),
                                            _buildRequirement("8 min chars", valid_length),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 32),

                            // Register Button
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
                                  print("clicked");
                                  if (formState.currentState!.validate()) {
                                    String email = _emailController.text.trim();
                                    var existingUser = await getUserByEmail(email);
                                    if (existingUser != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Email already in use"),
                                          backgroundColor: Colors.orange[400],
                                        ),
                                      );
                                    } else {
                                      await insertUser(
                                        _usernameController.text.trim(),
                                        email,
                                        _passwordController.text.trim(),
                                        "user",
                                        true,
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Registration successful!"),
                                          backgroundColor: Colors.green[400],
                                        ),
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => LoginPage()),
                                      );
                                    }
                                  } else {
                                    print("invalid");
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => LoginPage()),
                                    );
                                  },
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Color(0xFF667eea),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentindx,
            selectedItemColor: Color(0xFF667eea),
            unselectedItemColor: Colors.grey[400],
            onTap: (index) {
              setState(() {
                currentindx = index;
              });

              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              }

              if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                );
              }
            },

            items: [
              BottomNavigationBarItem(icon: Icon(Icons.person_2), label: "Login"),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: "Sign-Up"),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            ],
          )

        );
  }

  Widget _buildRequirement(String text, bool met) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: met ? Colors.green : Colors.grey[400],
          ),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: met ? Colors.green : Colors.grey[600],
              fontWeight: met ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }


}
