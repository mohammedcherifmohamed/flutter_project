
import 'package:flutter/material.dart';
import 'package:project/HomePage.dart';
import 'package:project/RegisterPage.dart';
import 'package:project/LoginPage.dart';
class HomePageState extends State<HomePage>  {
  int currentindx = 2 ;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(20),
            child: GridView.count(
              childAspectRatio: 0.8,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 15,
              children: List.generate(2, (index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(0.2),
                        spreadRadius: 2.5,
                        blurRadius: 3,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding:  EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120 ,
                          width: double.infinity,
                          child: Image.asset(
                            "salta3burger.png",
                            fit: BoxFit.cover,
                          ),
                        ),

                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top : 10,right:5,bottom:10),
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                "Non-Veg",
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top : 10,right:5,bottom:10),

                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                "Bland",
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        ),

                        Text(
                          "The Beast",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "This is description This is description This is description",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                          softWrap: true,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'DA 10.8',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "DA 15",
                                  style: TextStyle(
                                    fontSize: 13,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
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

            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
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
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  State<HomePage> createState() => HomePageState();
}