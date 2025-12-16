import 'package:flutter/material.dart';
// import 'HomePage.dart'; // Assuming Interface 02 might be related to Home or a separate Pizza List page

class PizzaFormPage extends StatefulWidget {
  final Map<String, dynamic>? pizzaData; // Pass data to simulate edit mode

  const PizzaFormPage({Key? key, this.pizzaData}) : super(key: key);

  @override
  _PizzaFormPageState createState() => _PizzaFormPageState();
}

class _PizzaFormPageState extends State<PizzaFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _oldPriceController = TextEditingController();
  final TextEditingController _qteStockController = TextEditingController();
  final TextEditingController _natureController = TextEditingController();
  final TextEditingController _optionsController = TextEditingController(); // JSON string

  bool _isVeg = false;
  String? _message;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    // Simulate "Edit" mode if pizzaData is provided
    if (widget.pizzaData != null) {
      _titleController.text = widget.pizzaData!['title'] ?? '';
      _descriptionController.text = widget.pizzaData!['desc'] ?? '';
      _imageController.text = widget.pizzaData!['img'] ?? '';
      _priceController.text = widget.pizzaData!['price']?.toString() ?? '';
      _oldPriceController.text = widget.pizzaData!['old_price']?.toString() ?? '';
      _qteStockController.text = widget.pizzaData!['QteStock']?.toString() ?? '';
      _natureController.text = widget.pizzaData!['nature'] ?? '';
      _optionsController.text = widget.pizzaData!['options']?.toString() ?? '{}';
      _isVeg = widget.pizzaData!['isVeg'] ?? false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _priceController.dispose();
    _oldPriceController.dispose();
    _qteStockController.dispose();
    _natureController.dispose();
    _optionsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        // Static success message
        _isError = false;
        _message = widget.pizzaData == null
            ? "Pizza ajoutée avec succès !"
            : "Pizza modifiée avec succès !";
      });
      // Here you would normally handle the logic
    } else {
       setState(() {
        _isError = true;
        _message = "Veuillez corriger les erreurs dans le formulaire.";
      });
    }
  }

  void _goToPizzaPage() {
    // Redirect to Interface 02 (Mock navigation)
    // Navigator.pushNamed(context, '/pizzaPage'); 
    print("Navigating to Pizza Page (Interface 02)");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Navigation vers la page Pizza...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pizzaData == null ? 'Ajouter Pizza' : 'Modifier Pizza'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_message != null)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: _isError ? Colors.red[100] : Colors.green[100],
                  child: Text(
                    _message!,
                    style: TextStyle(
                      color: _isError ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 16),
              
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) => value!.isEmpty ? 'Ce champ est requis' : null,
              ),
              const SizedBox(height: 10),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 10),

              // Image URL
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 10),

              // Prices in a Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Prix'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Requis' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _oldPriceController,
                      decoration: const InputDecoration(labelText: 'Ancien Prix'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Stock
              TextFormField(
                controller: _qteStockController,
                decoration: const InputDecoration(labelText: 'Quantité en Stock'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // Nature
              TextFormField(
                controller: _natureController,
                decoration: const InputDecoration(labelText: 'Nature (ex: Piquante, ... )'),
              ),
              const SizedBox(height: 10),

              // Options (JSON)
              TextFormField(
                controller: _optionsController,
                decoration: const InputDecoration(
                  labelText: 'Options (JSON)',
                  hintText: '{"taille": "XL", "supplément": "infos"}',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 10),

              // IsVeg Checkbox
              CheckboxListTile(
                title: const Text('Végétarienne ?'),
                value: _isVeg,
                onChanged: (val) {
                  setState(() {
                    _isVeg = val ?? false;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Action Buttons
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange, // Pizza theme color?
                ),
                child: Text(widget.pizzaData == null ? 'Ajouter' : 'Modifier'),
              ),
              
              const SizedBox(height: 10),
              
              TextButton(
                onPressed: _goToPizzaPage,
                 style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Aller vers page pizza"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
