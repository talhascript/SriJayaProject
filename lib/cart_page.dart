import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('cart');
  CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: cartCollection.where('userId', isEqualTo: userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final cartItems = snapshot.data!.docs;

            if (cartItems.isEmpty) {
              return Center(
                child: Text('Cart is empty'),
              );
            }

            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                final productName = cartItem['productName'] as String;
                int quantity = cartItem['quantity'] ?? 1;

                return FutureBuilder<QuerySnapshot>(
                  future: productsCollection
                      .where('pname', isEqualTo: productName)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final productDocs = snapshot.data!.docs;

                      if (productDocs.isNotEmpty) {
                        final productData = productDocs.first.data();

                        if (productData != null &&
                            productData is Map<String, dynamic>) {
                          final productModel = productData['model'] as String;
                          final productPrice = productData['price'] as int;

                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text(
                                '$productName',
                                style: TextStyle(fontSize: 18),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Model: $productModel',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'Price: $productPrice',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (quantity > 1) {
                                          quantity--;
                                          _updateQuantity(
                                            cartItem.reference,
                                            quantity,
                                          );
                                        }
                                      });
                                    },
                                  ),
                                  Text('$quantity'),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        quantity++;
                                        _updateQuantity(
                                          cartItem.reference,
                                          quantity,
                                        );
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _removeFromCart(cartItem.reference);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                    }

                    return SizedBox();
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error retrieving cart data');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _buyItems,
        label: Text('Buy'),
        icon: Icon(Icons.shopping_cart),
      ),
    );
  }

  Future<void> _updateQuantity(
    DocumentReference cartItemRef,
    int quantity,
  ) async {
    await cartItemRef.update({'quantity': quantity});
  }

  Future<void> _removeFromCart(DocumentReference cartItemRef) async {
    await cartItemRef.delete();
  }

  Future<void> _buyItems() async {
    // Get the current user's ID
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Get the cart items for the current user
    QuerySnapshot cartSnapshot =
        await cartCollection.where('userId', isEqualTo: userId).get();

    // Get the total price
    int totalPrice = 0;
    List<String> productIds = [];

    for (QueryDocumentSnapshot cartItem in cartSnapshot.docs) {
      final productName = cartItem['productName'] as String;
      int quantity = cartItem['quantity'] ?? 1;

      QuerySnapshot productSnapshot = await productsCollection
          .where('pname', isEqualTo: productName)
          .get();

      if (productSnapshot.docs.isNotEmpty) {
        final productData = productSnapshot.docs.first.data();

        if (productData != null && productData is Map<String, dynamic>) {
          final productPrice = productData['price'] as int;
          final productId = productSnapshot.docs.first.id;

          productIds.add(productId);

          final itemPrice = productPrice * quantity;
          totalPrice += itemPrice;
        }
      }
    }

    // Delete the cart items for the current user
    for (QueryDocumentSnapshot cartItem in cartSnapshot.docs) {
      await cartItem.reference.delete();
    }

    // Add the order to the 'requested' collection
    await FirebaseFirestore.instance.collection('requested').add({
      'userId': userId,
      'productIds': productIds,
      'quantity': cartSnapshot.docs.length,
      'totalPrice': totalPrice,
      'status': 'pending',
    });

    // Navigate to the ordered page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderedPage()),
    );
  }
}

class OrderedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Placed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 64,
              color: Colors.green,
            ),
            SizedBox(height: 16),
            Text(
              'Your order has been placed successfully!',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}