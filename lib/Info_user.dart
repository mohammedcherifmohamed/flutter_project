import 'package:flutter/material.dart';
import 'package:flutter_project/HomePage.dart';
import 'package:flutter_project/DB.dart';
import 'package:flutter_project/LoginPage.dart';
import 'package:flutter_project/RegisterPage.dart';
import 'package:flutter_project/RegisterPage.dart';
import 'package:flutter_project/Forgot_password.dart';
import 'package:flutter_project/AdminProfile.dart';

class Info_user extends StatefulWidget {
  const Info_user({super.key});
  State<Info_user> createState() => Info_user_state();
}

class Info_user_state extends State<Info_user> {
  // Sorting options
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  String _sortCriteria = 'Name'; // 'Name' or 'Etat'

  List<Map<String, dynamic>> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      isLoading = true; 
    });
    try {
      print("Loading users...");
      // Create a mutable copy of the list
      List<Map<String, dynamic>> fetchedUsers = List.from(await getRegularUsers());
      print("Users fetched: ${fetchedUsers.length}");
      
      // Sort logic
      fetchedUsers.sort((a, b) {
        int compare;
        if (_sortCriteria == 'Name') {
          compare = a['name'].toString().toLowerCase().compareTo(b['name'].toString().toLowerCase());
        } else { // Etat / Active
          compare = a['active'].compareTo(b['active']);
        }
        return _sortAscending ? compare : -compare;
      });

      setState(() {
        users = fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading users: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading users: $e")),
      );
    }
  }

  Future<void> _handleDelete(int uid) async {
    await deleteUser(uid);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User deleted")));
    _loadUsers();
  }

  Future<void> _handleToggleActive(int uid, int currentStatus) async {
    int newStatus = currentStatus == 1 ? 0 : 1;
    await toggleUserStatus(uid, newStatus);
    String statusMsg = newStatus == 1 ? "User Activated" : "User Deactivated";
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(statusMsg)));
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Users")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Sorting Controls
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sort By:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Name',
                              groupValue: _sortCriteria,
                              onChanged: (val) {
                                setState(() {
                                  _sortCriteria = val!;
                                  _loadUsers();
                                });
                              },
                            ),
                            Text("Name"),
                            SizedBox(width: 20),
                            Radio<String>(
                              value: 'Etat',
                              groupValue: _sortCriteria,
                              onChanged: (val) {
                                setState(() {
                                  _sortCriteria = val!;
                                  _loadUsers();
                                });
                              },
                            ),
                            Text("Etat (Active)"),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Order: "),
                            Switch(
                              value: _sortAscending,
                              onChanged: (val) {
                                setState(() {
                                  _sortAscending = val;
                                  _loadUsers();
                                });
                              },
                            ),
                            Text(_sortAscending ? "Ascending" : "Descending"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),

                  // Data Table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('NAME')),
                        DataColumn(label: Text('EMAIL')),
                        DataColumn(label: Text('ETAT')),
                        DataColumn(label: Text('ACTIONS')),
                      ],
                      rows: users.map((user) {
                        bool isActive = user['active'] == 1;
                        return DataRow(cells: [
                          DataCell(Text(user['uid'].toString())),
                          DataCell(Text(user['name'])),
                          DataCell(Text(user['email'])),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: isActive ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isActive ? "Active" : "Disabled",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                // Toggle Active Button
                                IconButton(
                                  icon: Icon(isActive ? Icons.toggle_on : Icons.toggle_off),
                                  color: isActive ? Colors.green : Colors.grey,
                                  onPressed: () => _handleToggleActive(user['uid'], user['active']),
                                ),
                                // Delete Button
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () => _handleDelete(user['uid']),
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Manage Users is index 2
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) { // Admin Profile
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminProfile()));
          }
          if (index == 1) { // Pizza List
             Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
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