import 'package:flutter/material.dart';
import 'package:invoice_generator/components/invoice_card.dart';
import 'package:invoice_generator/screens/invoice_create.dart';
import 'package:invoice_generator/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future getData() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: const [
                    InvoiceCard(
                        invoiceNumber: "1",
                        amount: 0.69,
                        customerName: "Raj",
                        status: "Overdue"),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceGenerator(),
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
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ProfilePage())),
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
