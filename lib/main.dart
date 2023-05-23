import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

import 'admin_page.dart';
import 'landing_page.dart';
import 'new_page.dart';
import 'store_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var isLogin = false;
  var email = '';

  checkIfLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
          email = user.email ?? '';
        });
      }
    });
  }

  Future<String> getCurrentUserDisplayName() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userSnapshot;
    try {
      userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return userSnapshot.get('name') ?? 'User';
    } catch (e) {
      print('Error fetching user data: $e');
      return 'Unknown';
    }
  }

  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget homeWidget;
    if (isLogin) {
      if (email == 'admin123@gmail.com') {
        homeWidget = AdminPage();
      } else {
        homeWidget = FutureBuilder<String>(
          future: getCurrentUserDisplayName(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return StorePage(currentUserDisplayName: snapshot.data!);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        );
      }
    } else {
      homeWidget = LandingPage();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: homeWidget,
    );
  }
}