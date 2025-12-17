import 'package:flutter/material.dart';
import 'package:flutter_project/RegisterPage.dart';
import 'package:flutter_project/HomePage.dart';
import 'package:flutter_project/DB.dart';
import 'package:flutter_project/Forgot_password.dart';
import 'package:flutter_project/Info_user.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

  final formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
            appBar: AppBar(title: Text('Login Page'),),
            body:Center(
              child:Container(
                width:300,
                padding: EdgeInsets.all(20),

                decoration:BoxDecoration(
                  gradient:LinearGradient(
                    colors:[Colors.white60,Colors.black12],
                  ),
                  borderRadius: BorderRadius.circular(10),

                ),
                child:Form(
                    key:formState,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        // Email Input
                      Container(
                        margin: EdgeInsets.only(top:70),
                        child:
                        TextFormField(
                          controller: _emailController,
                          validator:(value){
                            if(value!.isEmpty){
                              return "Email cannot be empty";
                            }
                            if(!value.contains("@")){
                              return "Email is not valid";
                            }
                          },
                          decoration:InputDecoration(
                              fillColor: Colors.white,
                              filled:true,
                              labelText:"Email",
                              prefixIcon:Icon(Icons.email),
                              border:InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              )

                          ),
                        ),


                      ),
                        // password Section
                        Container(
                          margin: EdgeInsets.only(top:20, bottom:30),

                          child:Column(
                            children:[
                              // Password Input
                              TextFormField(
                                controller: _passwordController,
                                onChanged: (value){
                                  setState(() {
                                    has_upper = value.contains(RegExp(r'[A-Z]'));
                                    has_lower = value.contains(RegExp(r'[a-z]'));
                                    has_number = value.contains(RegExp(r'[0-9]'));
                                    has_special = value.contains(
                                        RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
                                    valid_length = value.length >= 8;
                                  });

                                },

                                decoration:InputDecoration(
                                    fillColor: Colors.white,
                                    filled:true,
                                    labelText:"Password",
                                    prefixIcon:Icon(Icons.lock),
                                    border:InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10),
                                    )

                                ),
                              ),
                            ],
                          ),
                        ),

                        // Register Button
                        MaterialButton(
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
                                  SnackBar(content: Text("Email n'existe pas")),
                                );
                              } else if (user['pass'] != password) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Mot de passe erroné")),
                                );
                              } else if (user['active'] == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Compte désactivé")),
                                );
                              } else {
                                // Success
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                await prefs.setString('email', user['email']);
                                await prefs.setString('type', user['type']);

                                if (user['type'] == 'admin') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => Forgot_password()), // Interface 04
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => Info_user()), // Interface for regular users
                                  );
                                }
                              }
                            } else {
                              print("invalid");
                            }
                          },
                          child: Text("Login"),
                          color: Colors.black,
                          textColor: Colors.white,
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],

                    )
                ),

              ),
            ),
            bottomNavigationBar:BottomNavigationBar(
              currentIndex: currentindx,
              onTap: (index){
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
                BottomNavigationBarItem(icon:Icon(Icons.person_2),label:"Login"),
                BottomNavigationBarItem(icon:Icon(Icons.add),label:"Sign-Up"),
                BottomNavigationBarItem(icon:Icon(Icons.home),label:"Home"),


              ],

            )

    );
  }


}

