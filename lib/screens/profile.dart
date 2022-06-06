import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invoice_generator/auth_gate.dart';
import 'package:invoice_generator/model/supplier.dart';
import 'package:invoice_generator/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future _postData() async {
    await FirebaseFirestore.instance.collection("Suppliers").add(Supplier(
            uid: userId,
            name: fromCompany.text,
            address: fromAddress.text,
            mailAddress: FirebaseAuth.instance.currentUser!.email.toString())
        .toMap());
    setState(() {
      status = true;
    });
  }

  Future<Supplier> getSupplier() async {
    late Supplier supplier;
    await FirebaseFirestore.instance
        .collection('Suppliers')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
      supplier = Supplier.fromMap(snapshot.docs.first.data());
    });
    return supplier;
  }

  TextEditingController fromCompany = TextEditingController();
  TextEditingController fromAddress = TextEditingController();
  bool status = false;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome, ",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                FirebaseAuth.instance.currentUser!.email.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color(0xffEA5455),
                ),
                child: Center(
                  child: Text(
                    FirebaseAuth.instance.currentUser!.email
                        .toString()[0]
                        .toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder<Supplier>(
                  future: getSupplier(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            snapshot.data!.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            snapshot.data!.address,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: 110,
                            child: ElevatedButton(
                              onPressed: (() => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    ),
                                  )),
                              child: const Text("Home"),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          SizedBox(
                            width: 200,
                            child: TextField(
                              controller: fromCompany,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: 'Company Name',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 200,
                            child: TextField(
                              controller: fromAddress,
                              maxLines: 5,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: 'Address',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 110,
                            child: ElevatedButton(
                              onPressed: () => _postData(),
                              child: const Text("Submit"),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xffEA5455),
                    onPrimary: const Color(0xffF6F6F6),
                  ),
                  onPressed: () => {
                    _signOut(),
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => AuthGate()))
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.exit_to_app),
                      Text("Sign out"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// (FirebaseAuth.instance.currentUser!.displayName == null)
//                   ? SizedBox(
//                       width: 200,
//                       child: TextField(
//                         onChanged: (value) => FirebaseAuth.instance.currentUser!
//                             .updateDisplayName(value),
//                         keyboardType: TextInputType.text,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           hintText: 'Company Name',
//                         ),
//                       ),
//                     )
//                   : SizedBox(
//                       width: 200,
//                       child: TextField(
//                         enabled: false,
//                         onChanged: (value) => FirebaseAuth.instance.currentUser!
//                             .updateDisplayName(value),
//                         keyboardType: TextInputType.text,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           label: Text(FirebaseAuth
//                               .instance.currentUser!.displayName
//                               .toString()),
//                         ),
//                       ),
//                     ),