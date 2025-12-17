
import 'package:flutter/material.dart';
import 'package:flutter_project/HomePage.dart';
import 'package:flutter_project/RegisterPage.dart';
import 'package:flutter_project/LoginPage.dart';
import 'package:flutter_project/UserProfile.dart';
import 'package:flutter_project/AdminProfile.dart';
import 'package:flutter_project/Info_user.dart';
import 'package:flutter_project/PizzaFormPage.dart';
import 'package:flutter_project/ProductDetails.dart';
import 'package:flutter_project/DB.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomePageState extends State<HomePage>  {
  int currentindx = 2 ;


  String? userType;

  List<Map<String, dynamic>> pizzas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUserType();
    _loadPizzas();
  }

  Future<void> _checkUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userType = prefs.getString('type');
    });
  }

  Future<void> _loadPizzas() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Map<String, dynamic>> data = await getPizzas();
      setState(() {
        pizzas = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading pizzas: $e");
      setState(() {
        isLoading = false; 
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error fetching pizzas: $e")));
    }
  }

  Future<void> _handleDeletePizza(int pid) async {
    await archivePizza(pid);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pizza archived")));
    _loadPizzas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (userType == 'admin')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (_) => PizzaFormPage()));
                      },
                      icon: Icon(Icons.add),
                      label: Text("Ajouter Pizza"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                Expanded(
                  child: isLoading 
                  ? Center(child: CircularProgressIndicator()) 
                  : GridView.count(
                    childAspectRatio: 0.75, // Adjusted for height
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 15,
                    children: List.generate(pizzas.length, (index) {
                      final pizza = pizzas[index];
                      bool hasDiscount = pizza['old_price'] != null && (pizza['old_price'] is num) && pizza['old_price'] > 0;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProductDetails(pizza: pizza)),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding:  EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 100,
                                  width: double.infinity,
                                  child: Image.asset(
                                    pizza['img'] ?? "assets/salta3burger.png",
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) => Icon(Icons.broken_image, size: 50),
                                  ),
                                ),
                                // Admin Controls on Card
                                if (userType == 'admin')
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, size: 20, color: Colors.blue),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        onPressed: () {
                                           Navigator.push(context, MaterialPageRoute(builder: (_) => PizzaFormPage(pizzaData: pizza)));
                                        },
                                      ),
                                      SizedBox(width: 8),
                                      IconButton(
                                        icon: Icon(Icons.delete, size: 20, color: Colors.red),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        onPressed: () => _handleDeletePizza(pizza['pid']),
                                      ),
                                    ],
                                  ),

                                SizedBox(height: 5),
                                Text(
                                  pizza['title'] ?? "Pizza",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  pizza['desc'] ?? "Description",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'DA ${pizza['price']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        if (hasDiscount) ...[
                                          SizedBox(width: 5),
                                          Text(
                                            "DA ${pizza['old_price']}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              decoration: TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                                    // Add to Cart Icon (only for users)
                                    if (userType != 'admin')
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                        ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        bottomNavigationBar: userType == 'admin' 
        ? BottomNavigationBar(
            currentIndex: 1, // Pizza List is index 1 for Admin
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              if (index == 0) { // Admin Profile
                 Navigator.push(context, MaterialPageRoute(builder: (_) => AdminProfile()));
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
          )
        : BottomNavigationBar(
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
             if (index == 3) { // Profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UserProfile()),
              );
            }
          },

          items: [
            BottomNavigationBarItem(icon:Icon(Icons.person_2),label:"Login"),
            BottomNavigationBarItem(icon:Icon(Icons.add),label:"Sign-Up"),
            BottomNavigationBarItem(icon:Icon(Icons.home),label:"Home"),
            BottomNavigationBarItem(icon:Icon(Icons.account_circle),label:"Profile"),
          ],
        )
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  State<HomePage> createState() => HomePageState();
}