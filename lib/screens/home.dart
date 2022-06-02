import 'package:flutter/material.dart';
import 'package:invoice_generator/components/invoice_card.dart';
import 'package:invoice_generator/screens/invoice_create.dart';
import 'package:invoice_generator/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);

  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: const [
            InvoiceCard(),
            InvoiceCard(),
            InvoiceCard(),
          ],
        ),
      ),
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceGenerator(user: user),
                )),
            backgroundColor: Color(0xffEA5455),
            child: const Icon(
              Icons.add,
              size: 30,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(user: user))),
            backgroundColor: Color(0xffEA5455),
            child: const Icon(
              Icons.person,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
