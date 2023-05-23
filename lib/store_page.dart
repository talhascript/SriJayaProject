import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/cart_page.dart';
import 'package:project/product_page.dart';
import 'package:project/profile_page.dart';
import 'package:project/login_page.dart';
import 'package:project/about_us_page.dart';

class StorePage extends StatefulWidget {
  final String currentUserDisplayName;

  StorePage({required this.currentUserDisplayName});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int _currentIndex = 0;
  List<Widget> _pages = [];
  String searchCategory = '';
  String searchBrand = '';

  @override
  void initState() {
    super.initState();
    _pages = [
      StorePage(currentUserDisplayName: widget.currentUserDisplayName), // Home page widget
      CartPage(), // Cart page widget
      ProfilePage(), // Profile page widget
    ];
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut(); // Sign out the user
    await GoogleSignIn().signOut(); // (Optional) Sign out from Google as well
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _openProductPage(DocumentSnapshot productSnapshot) {
    final productData = productSnapshot.data() as Map<String, dynamic>;
    final productName = productData['pname'];
    final productImage = productData['img'];
    final productCategory = productData['catagory'];
    final productBrand = productData['brand'];
    final productDescription = productData['description'];
    final productPrice = productData['price'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPage(
          name: productName,
          image: productImage,
          category: productCategory,
          brand: productBrand,
          description: productDescription,
          price: productPrice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello! ${widget.currentUserDisplayName} Happy Shopping'),
        automaticallyImplyLeading: false,
        
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by category or brand',
              ),
              onChanged: (value) {
                setState(() {
                  searchCategory = value;
                });
              },
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final products = snapshot.data!.docs;
                  final filteredProducts = products.where((product) {
                    final productData = product.data() as Map<String, dynamic>;
                    final category = productData['catagory'].toString().toLowerCase();
                    final brand = productData['brand'].toString().toLowerCase();
                    final searchCategoryLower = searchCategory.toLowerCase();
                    return category.contains(searchCategoryLower) ||
                        brand.contains(searchCategoryLower);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index].data() as Map<String, dynamic>;
                      final model = product['model'];
                      final brand = product['brand'];
                      final category = product['catagory'];
                      final price = product['price'];
                      final image = product['img'];
                      final pname = product['pname'];

                      return Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(
                            '$pname',
                            style: TextStyle(fontSize: 24),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => _openProductPage(filteredProducts[index]),
                                child: Image.network(image, width: 300, height: 300),
                              ),
                              Text('Brand: $brand', style: TextStyle(fontSize: 17)),
                              Text('Model: $model', style: TextStyle(fontSize: 17)),
                              Text(
                                'Price: RM $price',
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                                textAlign: TextAlign.end,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error retrieving products data');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Navigate to the corresponding page based on the index
          switch (index) {
            case 0:
              // Home page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StorePage(
                    currentUserDisplayName: widget.currentUserDisplayName,
                  ),
                ),
              );
              break;
            case 1:
              // Cart page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
              break;
            case 2:
              // Profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
      ),
      drawer: AppDrawer(logoutCallback: _logout),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final Function logoutCallback;

  AppDrawer({required this.logoutCallback});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            color: Colors.purple,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
              child: Center(
                child: Text(
                  'More Functionalities!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(
              'About Us',
              style: TextStyle(fontSize: 21),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutUsPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text(
              'Chat With the Store',
              style: TextStyle(fontSize: 21),
            ),
            onTap: () {
              // Handle Chat With the Store tap
            },
          ),
          ListTile(
            leading: Icon(Icons.school),
            title: Text(
              'Student Verification',
              style: TextStyle(fontSize: 21),
            ),
            onTap: () {
              // Handle Student Verification tap
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Log Out',
              style: TextStyle(fontSize: 21),
            ),
            onTap: () => logoutCallback(context), // Call the logout function
          ),
        ],
      ),
    );
  }
}