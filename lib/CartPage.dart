import 'package:flutter/material.dart';
import 'package:flutter_project/OrderSuccessPage.dart';
import 'package:flutter_project/OrderHistoryPage.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Static data for the assignments
  final List<Map<String, dynamic>> _cartItems = [
    {
      'name': 'Pizza Margherita',
      'quantity': 2,
      'price': 12.5,
    },
    {
      'name': 'Pizza Pepperoni',
      'quantity': 1,
      'price': 15.0,
    },
    {
      'name': 'Pizza 4 Fromages',
      'quantity': 1,
      'price': 14.0,
    },
  ];

  double get _totalAmount {
    double total = 0;
    for (var item in _cartItems) {
      total += (item['quantity'] as int) * (item['price'] as double);
    }
    return total;
  }

  void _submitOrder() {
    // Navigate to Interface 08 (OrderHistoryPage)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OrderHistoryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier (Interface 07)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Votre Commande',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Cart Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Nom Pizza')),
                    DataColumn(label: Text('Qte')),
                    DataColumn(label: Text('Prix')),
                    DataColumn(label: Text('Total')),
                  ],
                  rows: _cartItems.map((item) {
                    final total = (item['quantity'] as int) * (item['price'] as double);
                    return DataRow(cells: [
                      DataCell(Text(item['name'])),
                      DataCell(Text(item['quantity'].toString())),
                      DataCell(Text('${item['price']} €')),
                      DataCell(Text('$total €')),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            const Divider(),
            // Summary Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Somme Globale:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$_totalAmount €',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
            ),
            // Checkout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitOrder,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Enregistrer la commande',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
