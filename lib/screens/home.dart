import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/components/invoice_card.dart';
import 'package:invoice_generator/model/invoice.dart';
import 'package:invoice_generator/screens/invoice_create.dart';
import 'package:invoice_generator/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Invoice>> getInvoices() async {
    List<Invoice> invoices = [];
    await FirebaseFirestore.instance
        .collection('Invoices')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('${FirebaseAuth.instance.currentUser!.email}')
        .get()
        .then((snapshot) {
      invoices = snapshot.docs
          .map<Invoice>((doc) => Invoice.fromMap(doc.data()))
          .toList();
    }).catchError((e) {
      print(e);
    });
    return invoices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Invoice>>(
            future: getInvoices(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                    children: snapshot.data!
                        .map((invoice) => InvoiceCard(
                              invoice: invoice,
                            ))
                        .toList());
              } else {
                return const Center(child: CircularProgressIndicator());
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
