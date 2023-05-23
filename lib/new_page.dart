// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:project/login_page.dart';

// class NewPage extends StatelessWidget {
  
//   NewPage({Key? key});

//   @override
//   Widget build(BuildContext context) {
    

    
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('APP TESTER 10000'),
//       ),
//       body: Center(
//         child: Text('Welcome ${FirebaseAuth.instance.currentUser?.email}'),
        
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Container(
//           height: 50.0,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               ElevatedButton(
//                 onPressed: () async {
//                   await FirebaseAuth.instance.signOut(); // Sign out the user
//                   await GoogleSignIn().signOut(); // (Optional) Sign out from Google as well
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginPage()),
//                   );
//                 },
//                 child: Text(
//                   "LOG OUT",
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// } // END TEST PAGE

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:project/login_page.dart';
import 'package:project/store_page.dart';

class NewPage extends StatefulWidget {
  NewPage({Key? key}) : super(key: key);

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    // All form fields are valid, proceed with submission
    var name = _nameController.text;
    var pnumber = _contactNumberController.text;
    var address = _addressController.text;

    createUser(name: name, phoneNumber: pnumber, address: address);

    // Retrieve the current user's name from Firestore
    String currentUserDisplayName = await getCurrentUserDisplayName();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StorePage(
          currentUserDisplayName: currentUserDisplayName,
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(33.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Name:',
                style: TextStyle(fontSize: 25.0),
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(hintText: 'Enter your name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Contact Number:',
                style: TextStyle(fontSize: 25.0),
              ),
              TextFormField(
                controller: _contactNumberController,
                decoration:
                    InputDecoration(hintText: 'Enter your contact number'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your contact number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Address:',
                style: TextStyle(fontSize: 25.0),
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(hintText: 'Enter your address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 80.0,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    'Continue to Store',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all(Size(200, 50)),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.all(16.0),
                    ),
                  ),
                ),
                
              ),
              
            ],
          ),
          
        ),
      ),
    );
  }
  
void createUser({required String name, required String phoneNumber, required String address}) {
  // Get the current user's UID
  String userId = FirebaseAuth.instance.currentUser!.uid;

  // Create a map with the user information
  Map<String, dynamic> user = {
    'name': name,
    'phoneNumber': phoneNumber,
    'address': address,
  };

  // Get a reference to the user document in the "users" collection
  DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

  // Check if the document already exists
  userRef.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      // If the document exists, update the fields without overwriting the entire document
      userRef.set(user, SetOptions(merge: true))
          .then((value) {
            print('User updated successfully');
          })
          .catchError((error) {
            print('Failed to update user: $error');
          });
    } else {
      // If the document doesn't exist, create a new document with the UID as the document name
      userRef.set(user)
          .then((value) {
            print('User added successfully');
          })
          .catchError((error) {
            print('Failed to add user: $error');
          });
    }
  }).catchError((error) {
    print('Failed to check user document: $error');
  });
}

Future<String> getCurrentUserDisplayName() async {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  DocumentSnapshot userSnapshot;
  try {
    userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    print(userSnapshot.get('name'));
  } catch (e) {
    print('Error fetching user data: $e');
    return 'Unknown';
  }

  if (userSnapshot.exists) {
    String name = userSnapshot.get('name');
    print(name);
    return name;
  } else {
    return 'Unknown';
  }
}




} //SUCCESS

