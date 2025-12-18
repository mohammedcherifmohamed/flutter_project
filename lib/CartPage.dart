import 'package:flutter/material.dart';
import 'package:flutter_project/Cart.dart';
import 'package:flutter_project/DB.dart';
import 'package:flutter_project/OrderHistoryPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  
  @override
  void initState() {
    super.initState();
    _checkAccess();
  }

  Future<void> _checkAccess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? type = prefs.getString('type');
    if (type == 'admin') {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Admins cannot order!")));
       Navigator.pop(context);
    }
  }

  Future<void> _submitOrder() async {
    if (Cart().items.isEmpty) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? uid = prefs.getInt('uid'); 

    if (uid == null) {
        String? email = prefs.getString('email');
        if (email != null) {
            var user = await getUserByEmail(email);
            if (user != null) {
                uid = user['uid'];
            }
        }
    }

    if (uid == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: User not found")));
        return;
    }

    try {
        String date = DateTime.now().toString().substring(0, 16);
        int cid = await insertCommand(uid, date);
        for (var item in Cart().items) {
            await insertCommandInfo(cid, item.pid, item.quantity, item.price);
            await updateStock(item.pid, item.quantity);
        }

        Cart().clear();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order Saved Successfully!")));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderHistoryPage()));

    } catch (e) {
        print("Order Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error saving order: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Cart().items.isEmpty 
      ? Center(child: Text("Cart is empty"))
      : Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.orange.shade100),
                        children: [
                          Padding(padding: EdgeInsets.all(8), child: Text("Pizza", style: TextStyle(fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8), child: Text("Qty", style: TextStyle(fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8), child: Text("Price", style: TextStyle(fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8), child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
                        ]
                      ),
                      ...Cart().items.map((item) {
                        return TableRow(
                          children: [
                            Padding(padding: EdgeInsets.all(8), child: Text(item.title)),
                            Padding(padding: EdgeInsets.all(8), child: Text("${item.quantity}")),
                             Padding(padding: EdgeInsets.all(8), child: Text("${item.price}")),
                            Padding(padding: EdgeInsets.all(8), child: Text("${item.price * item.quantity}")),
                          ]
                        );
                      }).toList()
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Amount:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("DA ${Cart().totalPrice}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text("Save Order", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
    );
  }
}
