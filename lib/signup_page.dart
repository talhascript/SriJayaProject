import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:project/.dart';
import 'package:project/auth_g.dart';
import 'package:project/landing_Page.dart';
import 'package:project/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project/new_page.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  // @override
  // void initState() {
  //   username.text = ""; //innitail value of text field
  //   name.text = "";
  //   email.text = "";
  //   password.text = "";
  //   confirmPassword.text = "";
  //   super.initState();
  // }

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
            height: h * 0.32,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("img/SIGN UP.png"), fit: BoxFit.cover)),
            child: Column(
              children: [
                SizedBox(height: h * 0.18),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("img/avatar.png"),
                  backgroundColor: Colors.white60,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
                left: 15,
                bottom: 10,
                right: 20,
                top: 10), //You can use EdgeInsets like above
            margin:
                const EdgeInsets.only(left: 15, bottom: 40, right: 20, top: 10),
            child: Column(
              children: [
                TextField(
                  controller: name,
                  //  hintText: 'PLACE HOLDER TEXT'
                  decoration: InputDecoration(
                      hintText: "Enter Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular((50)))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: email,
                  //  hintText: 'PLACE HOLDER TEXT'
                  decoration: InputDecoration(
                      hintText: "Enter Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular((50)))),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 17, 0, 0),
                  child: TextField(
                    controller: password,
                    // labelText: 'PLACE HOLDER TEXT FOR PASSWORD'
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Enter Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular((50)))),
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   width: w * 0.5,
          //   height: h * 0.07,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(40),
          //     image: const DecorationImage(
          //         image: AssetImage("img/button2.jpg"), fit: BoxFit.cover),
          //   ),
          //   child: const Center(
          //     child: Text(
          //       "Sign Up",
          //       style: TextStyle(color: Colors.white, fontSize: 30),
          //     ),
          //   ),
          // ),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: email.text, password: password.text)
                  .then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              }).onError((error, stackTrace) {
                print("Error");
              });
            },
            child: const FittedBox(
              child: Text(
                'Sign Up',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: w * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Container(
              child: Column(
                children: [
                  Text(
                    "Or Log In using Google",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: GestureDetector(
              onTap: () async {
                await Auth_service().signInWithGoogle();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewPage()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 226, 224, 246), // Replace with your desired background color
                  borderRadius: BorderRadius.circular(
                      8), // Adjust the radius to change the shape
                ),
                padding:
                    EdgeInsets.all(8), // Adjust the padding as per your design
                child: Image.asset(
                  "img/googleLogo.png",
                  width: 270, // Adjust the width and height as per your design
                  height: 45,
                ),
              ),
            ),
          ),
          SizedBox(
            height: h * 0.02,
          ),
          GestureDetector(
            child: RichText(
              text: TextSpan(
                  text: "Already have an SJO account?",
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  children: [
                    TextSpan(
                        text: "Log In",
                        style: TextStyle(color: Colors.grey[900], fontSize: 16))
                  ]),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
