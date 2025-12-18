import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_project/Cart.dart'; 

class ProductDetails extends StatefulWidget {
  final Map<String, dynamic> pizza;

  const ProductDetails({super.key, required this.pizza});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Map<String, dynamic>? options;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    try {
      if (widget.pizza['options'] != null) {
        options = jsonDecode(widget.pizza['options']);
      }
    } catch (e) {
      print("Error decoding options: $e");
    }
  }

  void _addToCart() {
    Cart().add(
      widget.pizza['pid'],
      widget.pizza['title'],
      widget.pizza['price'],
      widget.pizza['img'] ?? "assets/salta3burger.png",
      quantity
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added to Cart!")));
    Navigator.pop(context);
  }

  void _incrementQuantity() {
    if (quantity < widget.pizza['QteStock']) {
      setState(() {
        quantity++;
      });
    } else {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Max stock reached")));
    }
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasDiscount = widget.pizza['old_price'] != null && (widget.pizza['old_price'] is num) && widget.pizza['old_price'] > 0;
    
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Image.asset(
              widget.pizza['img'] ?? "assets/salta3burger.png",
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Container(color: Colors.grey, child: Icon(Icons.broken_image, size: 50)),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
           Positioned(
            top: 40,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.orange),
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Items in cart: ${Cart().itemCount}")));
                },
              ),
            ),
           ),
           Positioned(
             top: 35,
             right: 15,
             child: Container(
               padding: EdgeInsets.all(4),
               decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
               child: Text("${Cart().itemCount}", style: TextStyle(color: Colors.white, fontSize: 12)),
             ),
           ),

          Positioned(
            top: 280,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.pizza['title'] ?? "Pizza Name",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                                Text(
                                    "DA ${widget.pizza['price']}",
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange),
                                ),
                                if (hasDiscount)
                                    Text(
                                        "DA ${widget.pizza['old_price']}",
                                        style: TextStyle(fontSize: 14, decoration: TextDecoration.lineThrough, color: Colors.grey),
                                    ),
                            ],
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                     Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        Text(" 4.5 ", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("(243 reviews)", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Description",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.pizza['desc'] ?? "No description available.",
                      style: TextStyle(color: Colors.grey, height: 1.5),
                    ),
                     SizedBox(height: 20),
                    if (options != null) ...[
                        Text(
                        "Nutritional Info",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: options!.entries.map((e) => 
                                Chip(
                                    label: Text("${e.key}: ${e.value}"),
                                    backgroundColor: Colors.orange.withOpacity(0.1),
                                )
                            ).toList(),
                        )
                    ],
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _decrementQuantity, 
                          icon: Icon(Icons.remove_circle_outline)
                        ),
                        Text(
                          "$quantity", 
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        ),
                        IconButton(
                          onPressed: _incrementQuantity, 
                          icon: Icon(Icons.add_circle_outline)
                        ),
                         Text(
                          " (Stock: ${widget.pizza['QteStock']})", 
                          style: TextStyle(color: Colors.grey)
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Ajouter carte", 
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
