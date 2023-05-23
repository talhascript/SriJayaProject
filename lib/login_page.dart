import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/store_page.dart';

import 'admin_page.dart';
import 'forgot_password_page.dart';
import 'new_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<String> getCurrentUserDisplayName() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userSnapshot;
    try {
      userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return userSnapshot.get('name');
    } catch (e) {
      print('Error fetching user data: $e');
      return 'Unknown';
    }
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Store the context in a variable
      BuildContext context = this.context;

      if (userCredential.user?.email == 'admin123@gmail.com') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else {
        String currentUserDisplayName = await getCurrentUserDisplayName();
        if (currentUserDisplayName != 'Unknown') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StorePage(currentUserDisplayName: currentUserDisplayName)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NewPage()),
          );
        }
      }
    } catch (error) {
      // Handle login error
      print('Login Error: $error');
      // Show an error dialog or display a message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: w,
            height: h * 0.33,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("img/SRI JAYA ONLINE.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 15,
              bottom: 40,
              right: 20,
              top: 10,
            ),
            margin: const EdgeInsets.only(
              left: 15,
              bottom: 40,
              right: 20,
              top: 10,
            ),
            child: Column(
              children: [
                const Text(
                  "WELCOME",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text(
                    "Log in to your SJO account",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Enter Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(120, 15, 0, 0),
                  child: GestureDetector(
                    child: Text(
                      "Forgot your password?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ForgotPasswordPage(),
                    )),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _login,
            child: const FittedBox(
              child: Text(
                'Log In',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: w * 0.08,
          ),
          GestureDetector(
            child: RichText(
              text: TextSpan(
                text: "Don't have an SJO account? ",
                style: TextStyle(color: Colors.grey[500], fontSize: 20),
                children: [
                  TextSpan(
                    text: "Create",
                    style: TextStyle(color: Colors.grey[900], fontSize: 20),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}