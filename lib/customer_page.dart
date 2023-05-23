import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            if (documents.isNotEmpty) {
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final customer = documents[index];
                  final customerId = customer.id;
                  final name = customer['name'];
                  final address = customer['address'];
                  final phoneNumber = customer['phoneNumber'];

                  return Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(
                        name,
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address: $address',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Phone Number: $phoneNumber',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, customerId);
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No users found'),
              );
            }
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String customerId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Customer'),
          content: Text('Are you sure you want to delete this customer?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteCustomer(customerId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCustomer(String customerId) {
    FirebaseFirestore.instance.collection('users').doc(customerId).delete();
  }
}
