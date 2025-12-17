import 'package:flutter/material.dart';
import 'dart:convert';

class ProductDetails extends StatefulWidget {
  final Map<String, dynamic> pizza;

  const ProductDetails({super.key, required this.pizza});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;
  Map<String, dynamic> options = {};

  @override
  void initState() {
    super.initState();
    // Decode options JSON
    try {
      if (widget.pizza['options'] != null) {
        options = jsonDecode(widget.pizza['options']);
      }
    } catch (e) {
      print("Error decoding options: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasDiscount = widget.pizza['old_price'] != null && widget.pizza['old_price'] > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.orange.shade100, // Background placeholder
                  child: Image.asset(
                    widget.pizza['img'] ?? "assets/salta3burger.png",
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: 80, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.favorite_border, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pizza['title'] ?? 'Pizza Name',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "DA ${widget.pizza['price']}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                      if (hasDiscount) ...[
                        SizedBox(width: 10),
                        Text(
                          "DA ${widget.pizza['old_price']}",
                          style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 20),
                  // Render Options
                  if (options.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text("Nutritional Info / Options:", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: options.entries.map((entry) {
                                return Column(
                                    children: [
                                        Text(entry.key.toUpperCase(), style: TextStyle(color: Colors.grey, fontSize: 12)),
                                        Text(entry.value.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                );
                            }).toList(),
                        ),
                        Divider(height: 30),
                    ]
                  ),
                  
                  Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 5),
                  Text(
                    widget.pizza['desc'] ?? 'No description available.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1)],
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Row(
                children: [
                    IconButton(
                        onPressed: () {
                            if (quantity > 1) setState(() => quantity--);
                        },
                        icon: Icon(Icons.remove_circle_outline, color: Colors.grey),
                    ),
                    Text("$quantity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                        onPressed: () {
                            setState(() => quantity++);
                        },
                        icon: Icon(Icons.add_circle, color: Colors.orange),
                    ),
                ],
             ),
             ElevatedButton(
                 onPressed: () {
                     // Add to cart logic (Interface 07 later)
                 },
                 style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.orange,
                     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
                 ),
                 child: Text("Add to Cart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
             )
          ],
        ),
      ),
    );
  }
}
