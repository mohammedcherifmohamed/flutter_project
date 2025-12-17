import 'package:flutter/material.dart';
import 'package:flutter_project/DB.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? uid = prefs.getInt('uid');

    // Fallback if uid is not in prefs (e.g. login before fix applied)
    if (uid == null) {
        String? email = prefs.getString('email');
        if (email != null) {
            var user = await getUserByEmail(email);
            if (user != null) {
                uid = user['uid'];
            }
        }
    }

    if (uid != null) {
        try {
            List<Map<String, dynamic>> data = await getUserOrders(uid);
            setState(() {
                orders = data;
                isLoading = false;
            });
        } catch (e) {
            print("Error fetching orders: $e");
            setState(() { isLoading = false; });
        }
    } else {
        setState(() { isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading 
      ? Center(child: CircularProgressIndicator()) 
      : orders.isEmpty
        ? Center(child: Text("Aucune commande existe")) // Req: "Aucune commande existe"
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnWidths: const {
                        0: FlexColumnWidth(1), // ID
                        1: FlexColumnWidth(3), // Date
                        2: FlexColumnWidth(2), // Nbr Pizzas
                        3: FlexColumnWidth(2), // Total
                    },
                    children: [
                         TableRow(
                            decoration: BoxDecoration(color: Colors.blue.shade100),
                            children: [
                                Padding(padding: EdgeInsets.all(8), child: Text("ID", style: TextStyle(fontWeight: FontWeight.bold))),
                                Padding(padding: EdgeInsets.all(8), child: Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
                                Padding(padding: EdgeInsets.all(8), child: Text("Pizzas", style: TextStyle(fontWeight: FontWeight.bold))),
                                Padding(padding: EdgeInsets.all(8), child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
                            ]
                         ),
                         ...orders.map((order) {
                             return TableRow(
                                 children: [
                                     Padding(padding: EdgeInsets.all(8), child: Text("${order['cid']}")),
                                     Padding(padding: EdgeInsets.all(8), child: Text("${order['date']}")),
                                     Padding(padding: EdgeInsets.all(8), child: Text("${order['pizza_count']}")),
                                     Padding(padding: EdgeInsets.all(8), child: Text("DA ${order['total_price']}")),
                                 ]
                             );
                         }).toList()
                    ],
                ),
            ),
        ),
    );
  }
}
