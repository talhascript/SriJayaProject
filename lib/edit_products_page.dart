import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProductPage extends StatefulWidget {
  final String productId;

  EditProductPage({required this.productId});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final TextEditingController _pnameController = TextEditingController();
  final TextEditingController _imgController = TextEditingController();
  final TextEditingController _catagoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch the product data and populate the text fields
    _fetchProductDetails();
  }

  @override
  void dispose() {
    _pnameController.dispose();
    _imgController.dispose();
    _catagoryController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _fetchProductDetails() async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (snapshot.exists) {
        final productData = snapshot.data() as Map<String, dynamic>;
        _pnameController.text = productData['pname'] ?? '';
        _imgController.text = productData['img'] ?? '';
        _catagoryController.text = productData['catagory'] ?? '';
        _brandController.text = productData['brand'] ?? '';
        _modelController.text = productData['model'] ?? '';
        _priceController.text = productData['price'].toString() ?? '';
      }
    } catch (error) {
      print('Error fetching product details: $error');
    }
  }

  void _updateProduct() async {
    final String pname = _pnameController.text;
    final String img = _imgController.text;
    final String catagory = _catagoryController.text;
    final String brand = _brandController.text;
    final String model = _modelController.text;
    final int price = int.tryParse(_priceController.text) ?? 0;

    final productData = {
      'pname': pname,
      'img': img,
      'catagory': catagory,
      'brand': brand,
      'model': model,
      'price': price,
    };

    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .update(productData);
      // Product updated successfully
      Navigator.pop(context); // Go back to the previous page
    } catch (error) {
      // Error occurred while updating the product
      print('Error updating product: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _pnameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _imgController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: _catagoryController,
              decoration: InputDecoration(labelText: 'Catagory'),
            ),
            TextField(
              controller: _brandController,
              decoration: InputDecoration(labelText: 'Brand'),
            ),
            TextField(
              controller: _modelController,
              decoration: InputDecoration(labelText: 'Model'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateProduct,
              child: Text('Update Product',style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}