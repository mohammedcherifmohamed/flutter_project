import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/DB.dart';
import 'package:flutter_project/HomePage.dart';

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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.pizzaData == null) {
          // ADD MODE
          await insertPizza(
            _titleController.text,
            _descriptionController.text,
            _imageController.text,
            double.parse(_priceController.text),
            _oldPriceController.text.isEmpty ? null : double.parse(_oldPriceController.text),
            _qteStockController.text.isEmpty ? 0 : int.parse(_qteStockController.text),
            _isVeg,
            _natureController.text,
            _optionsController.text.isEmpty ? '{}' : _optionsController.text,
          );
           setState(() {
            _isError = false;
            _message = "Pizza ajoutée avec succès !";
          });
        } else {
          // EDIT MODE
          await updatePizza(
            widget.pizzaData!['pid'],
            _titleController.text,
            _descriptionController.text,
            _imageController.text,
            double.parse(_priceController.text),
            _oldPriceController.text.isEmpty ? null : double.parse(_oldPriceController.text),
            _qteStockController.text.isEmpty ? 0 : int.parse(_qteStockController.text),
            _isVeg,
            _natureController.text,
            _optionsController.text.isEmpty ? '{}' : _optionsController.text,
          );
           setState(() {
            _isError = false;
            _message = "Pizza modifiée avec succès !";
          });
        }
      } catch (e) {
         setState(() {
          _isError = true;
          _message = "Erreur: $e";
        });
      }
    } else {
       setState(() {
        _isError = true;
        _message = "Veuillez corriger les erreurs dans le formulaire.";
      });
    }
  }

  void _goToPizzaPage() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
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
