import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _pnameController = TextEditingController();
  final TextEditingController _imgController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void dispose() {
    _pnameController.dispose();
    _imgController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _modelController.dispose();
    _brandController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _addProduct() async {
    final String pname = _pnameController.text;
    final String img = _imgController.text;
    final int price = int.tryParse(_priceController.text) ?? 0;
    final String description = _descriptionController.text;
    final String model = _modelController.text;
    final String brand = _brandController.text;
    final String category = _categoryController.text;

    final productData = {
      'pname': pname,
      'img': img,
      'price': price,
      'description': description,
      'model': model,
      'brand': brand,
      'category': category,
    };

    try {
      await FirebaseFirestore.instance.collection('products').add(productData);
      // Product added successfully
      Navigator.pop(context); // Go back to the previous page
    } catch (error) {
      // Error occurred while adding the product
      print('Error adding product: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _pnameController,
              decoration: InputDecoration(labelText: 'Product Name',),
            ),
            TextField(
              controller: _imgController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _modelController,
              decoration: InputDecoration(labelText: 'Model'),
            ),
            TextField(
              controller: _brandController,
              decoration: InputDecoration(labelText: 'Brand'),
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Add Product',style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}