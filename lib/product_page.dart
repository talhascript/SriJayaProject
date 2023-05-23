import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/cart_page.dart';
import 'package:project/profile_page.dart';
import 'package:project/login_page.dart';
import 'package:project/about_us_page.dart';

class ProductPage extends StatelessWidget {
  final String name;
  final String image;
  final String category;
  final String brand;
  final String description;
  final int price;

  ProductPage({
    required this.name,
    required this.image,
    required this.category,
    required this.brand,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(image),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Category: $category',
              style: TextStyle(fontSize: 22),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Brand: $brand',
              style: TextStyle(fontSize: 22),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Price: RM $price',
              style: TextStyle(fontSize: 22),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Description: $description',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  addToCart(context);
                },
                child: Text('Add to Cart'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addToCart(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;

    if (userId != null) {
      final cartItem = {
        'userId': userId,
        'productName': name,
        'quantity': 1, // Default quantity is 1
      };

      try {
        await FirebaseFirestore.instance.collection('cart').add(cartItem);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Item added to cart'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error adding item to cart: $e');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to add item to cart. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}