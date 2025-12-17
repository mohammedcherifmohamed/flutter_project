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

  final formState = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
          appBar: AppBar(title: Text('Register Page'),),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:[
                      // user Name Field
                      TextFormField(
                        controller: _usernameController,
                        validator:(value){
                          if(value!.isEmpty){
                            return "UserName cannot be empty";
                          }
                          if(value.length < 3 ){
                            return "username cant be less than 3 chars";
                          }

                        },
                        decoration:InputDecoration(
                            fillColor: Colors.white,
                            filled:true,
                            labelText:"UserName",
                            prefixIcon:Icon(Icons.person),
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
                      // Email Input
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
                    // password Section
                      // Password Input
                      TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          print("Validating password: '$value'");
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
                       Column(
                         children:[

                           // validations messages
                           Container(
                             width: double.infinity,
                             margin: EdgeInsets.only(top:10),
                             child:Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children:[
                                 Column(
                                   children:[
                                     Text("1 upperCase",
                                       style: TextStyle(
                                         fontSize: 15,
                                         fontWeight: FontWeight.bold,
                                         color: has_upper? Colors.green : Colors.black,
                                       ),),
                                     Text("1 lowerCase",
                                       style: TextStyle(
                                         fontSize: 15,
                                         fontWeight: FontWeight.bold,
                                         color: has_lower? Colors.green : Colors.black,

                                       ),),
                                     Text("1 number",
                                       style: TextStyle(
                                         fontSize: 15,
                                         fontWeight: FontWeight.bold,
                                         color: has_number? Colors.green : Colors.black,

                                       ),),
                                   ],
                                 ),
                                 Column(
                                     children:[
                                       Text("1 special Character",
                                         style: TextStyle(
                                           fontSize: 15,
                                           fontWeight: FontWeight.bold,
                                           color: has_special? Colors.green : Colors.black,

                                         ),),
                                       Text("8 minimum chars",
                                         style: TextStyle(
                                           fontSize: 15,
                                           fontWeight: FontWeight.bold,
                                           color: valid_length? Colors.green : Colors.black,

                                         ),),

                                     ]
                                 ),

                               ],
                             ),
                           ),
                          ],
                       ),

                      // Register Button
                      MaterialButton(
                        onPressed:() async  {

                          print("clicked");
                          if(formState.currentState!.validate()){
                             String email = _emailController.text.trim();
                             var existingUser = await getUserByEmail(email);
                             if(existingUser != null){
                               ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(content: Text("Email déjà utilisé"))
                               );
                             } else {
                               // Start of requested change: Delete all users before adding new one
                               // await deleteAllUsers();
                               // End of requested change
                               await insertUser(
                                 _usernameController.text.trim(),
                                 email,
                                 _passwordController.text.trim(),
                                 "user",
                                 true,
                               );
                               List <Map<String,dynamic>>  res = await getUsers();
                               print("results : $res");
                               ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(content: Text("Inscription réussie"))
                               );
                             }
                          }else{
                            print("invalid");
                          }
                        },
                        child:Text("Register"),
                        color:Colors.black,
                        textColor:Colors.white,
                        padding:EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),

                      ),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? "),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => LoginPage()),
                              );
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          )
                        ],
                      )
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

                if (index == 0) {
                   print("Navigating to Login Page via BottomNav");
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                }

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
