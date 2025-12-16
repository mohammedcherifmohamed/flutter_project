import 'package:flutter/material.dart';
import 'package:flutter_project/RegisterPage.dart';
import 'package:flutter_project/HomePage.dart';


class Forgot_password extends StatefulWidget{
  const Forgot_password({super.key});
  State<Forgot_password> createState() => Forgot_password_state() ;
}

class Forgot_password_state extends State<Forgot_password> {
  int currentindx = 0 ;

  int i = 0 ;
  bool is_empty=true ,has_upper = false , has_lower = false , has_number = false , has_special = false , valid_length = false;

  final formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(title:Text("Admin Profile")),
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
                    // Current Password Section
                    Container(
                      margin: EdgeInsets.only(top:20, bottom:30),

                      child:Column(
                        children:[
                          // Password Input
                          TextFormField(
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
                                labelText:"Current Password",
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
                    // New password Section
                    Container(
                      margin: EdgeInsets.only(top:20, bottom:30),

                      child:Column(
                        children:[
                          // Password Input
                          TextFormField(
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
                                labelText:"New Password",
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
                    // Confirm password Section
                    Container(
                      margin: EdgeInsets.only(top:20, bottom:30),

                      child:Column(
                        children:[
                          // Password Input
                          TextFormField(
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
                                labelText:"Confirm Password",
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
                      onPressed:()   {
                        print("clicked");
                        if(formState.currentState!.validate()){
                          print("valid");
                        }else{
                          print("invalid");
                        }
                      },
                      child:Text("Confirm Change"),
                      color:Colors.black,
                      textColor:Colors.white,
                      padding:EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),

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
            BottomNavigationBarItem(icon:Icon(Icons.home),label:"consulter la liste"),


          ],

        )

    );

  }
}