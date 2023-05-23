import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Sri Jaya Online',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'At Sri Jaya Online, we strive to provide you with a seamless shopping experience from the comfort of your home. With our app, you can browse through a wide range of products, add them to your cart, and securely make your purchase.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Our Mission',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Our mission is to offer a wide range of top-notch electronic products at competitive prices. We strive to keep up with the latest technology trends and provide our customers with the best options available in the market.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'If you have any questions, concerns, or inquiries, please feel free to reach out to us. We have a dedicated customer support team ready to assist you.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Phone: 123-456-7890',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Email: info@srijayatechshop.com',
              style: TextStyle(fontSize: 18),
            ),
             Text(
              'Shop Address: 41, Jalan Kebudayaan 2, Taman Universiti, 81300 Skudai, Johor ',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}