import 'package:flutter/material.dart';
import 'package:flutter_project/RegisterPage.dart';
import 'package:flutter_project/HomePage.dart';
import 'package:flutter_project/DB.dart';
import 'package:flutter_project/Forgot_password.dart';
import 'package:flutter_project/Info_user.dart';
import 'package:flutter_project/UserProfile.dart';
import 'package:flutter_project/AdminProfile.dart';
import 'package:flutter_project/SessionManager.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  int currentindx = 0 ;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
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
                      constraints: BoxConstraints(maxWidth: 400),
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
                                  Icons.local_pizza,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 24),
                              
                              // Title
                              Text(
                                'Welcome Back',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2d3748),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Sign in to continue',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 32),

                              // email Input
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
                              SizedBox(height: 20),

                              // Password Input
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
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
                              SizedBox(height: 32),

                              //  Button
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
                                      String password = _passwordController.text.trim();

                                      print("Checking DB for email: '$email'");
                                      var user = await getUserByEmail(email);
                                      print("DB Result: $user");

                                      if (user == null) {
                                        print("User is null");
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Email doesn't exist"),
                                            backgroundColor: Colors.red[400],
                                          ),
                                        );
                                      } else if (user['pass'] != password) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Incorrect password"),
                                            backgroundColor: Colors.red[400],
                                          ),
                                        );
                                      } else if (user['active'] == 0) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Account not active"),
                                            backgroundColor: Colors.orange[400],
                                          ),
                                        );
                                      } else {
                                        await SessionManager.saveSession(
                                          user['email'],
                                          user['type'],
                                          user['uid'],
                                        );

                                        if (user['type'] == 'admin') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => AdminProfile()),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => UserProfile()),
                                          );
                                        }
                                      }
                                    } else {
                                      print("invalid");
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "Sign In",
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
                                    "Don't have an account? ",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => RegisterPage()),
                                      );
                                    },
                                    child: Text(
                                      "Sign Up",
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

                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterPage()),
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


}

