import 'package:flutter/material.dart';
import 'package:project/login_page.dart';
import 'package:project/new_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key});

  @override
  Widget build(BuildContext context) {
    //bool isLoggedIn = true; // Replace with your login logic
    // Check if the user is logged in
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'img/bg_landing.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'img/SRI_JAYA_ONLINE_1_-removebg-preview.png',
                    width: 180,
                    height: 180,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Sri Jaya Online',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewPage()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        }
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => NewPage()),
                        // );
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(16.0),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 198, 64, 255),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
