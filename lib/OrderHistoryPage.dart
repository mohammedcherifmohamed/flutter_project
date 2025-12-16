import 'package:flutter/material.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  // Static data for orders
  // Using a list that we can modify to test the empty state
  List<Map<String, dynamic>> _orders = [
    {
      'id': 'CMD-001',
      'date': '2023-10-25',
      'pizzaCount': 3,
      'totalPrice': 45.5,
    },
    {
      'id': 'CMD-002',
      'date': '2023-10-28',
      'pizzaCount': 1,
      'totalPrice': 15.0,
    },
    {
      'id': 'CMD-003',
      'date': '2023-11-02',
      'pizzaCount': 2,
      'totalPrice': 28.0,
    },
  ];

  void _toggleEmptyState() {
    setState(() {
      if (_orders.isEmpty) {
        _orders = [
          {
            'id': 'CMD-001',
            'date': '2023-10-25',
            'pizzaCount': 3,
            'totalPrice': 45.5,
          },
          {
            'id': 'CMD-002',
            'date': '2023-10-28',
            'pizzaCount': 1,
            'totalPrice': 15.0,
          },
        ];
      } else {
        _orders = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Commandes (Interface 08)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Toggle Empty State (Top Secret Debug Button)',
            onPressed: _toggleEmptyState,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _orders.isEmpty
            ? const Center(
                child: Text(
                  'Aucune commande existe',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   const Text(
                    'Historique des commandes',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Commande ID')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Nbr Pizza')),
                          DataColumn(label: Text('Prix Total')),
                        ],
                        rows: _orders.map((order) {
                          return DataRow(cells: [
                            DataCell(Text(order['id'])),
                            DataCell(Text(order['date'])),
                            DataCell(Text(order['pizzaCount'].toString())),
                            DataCell(Text('${order['totalPrice']} €')),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
