import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/add_product_page.dart';

import 'edit_products_page.dart';

class StoreProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Products'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data!.docs;

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final productData =
                    products[index].data() as Map<String, dynamic>;
                final pname = productData['pname'];
                final catagory = productData['catagory'];
                final brand = productData['brand'];
                final model = productData['model'];
                final price = productData['price'];
                final productId = products[index].id;

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(pname,style: TextStyle(fontSize: 18),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Text('Catagory: $catagory',style: TextStyle(fontSize: 18)),
                        Text('Brand: $brand',style: TextStyle(fontSize: 18)),
                        Text('Model: $model',style: TextStyle(fontSize: 18)),
                        Text('Price: $price',style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProductPage(productId: productId),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteProduct(productId);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
        },
        child: Text('Add Product',style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Future<void> _deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();
      // Product deleted successfully
    } catch (error) {
      // Error occurred while deleting the product
    }
  }
}