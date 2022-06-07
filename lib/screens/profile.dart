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
            gstNumber: taxNumber.text,
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
  TextEditingController taxNumber = TextEditingController();
  bool status = false;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(shrinkWrap: true, children: [
            Column(
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
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = snapshot.data!.name,
                                enabled: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: "Company Name",
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = snapshot.data!.address,
                                enabled: false,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: "Address",
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: TextEditingController()
                                  ..text = snapshot.data!.gstNumber,
                                enabled: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelText: "GST Number",
                                ),
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
                              width: 200,
                              child: TextField(
                                controller: taxNumber,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  hintText: 'GST Number',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 110,
                              child: ElevatedButton(
                                onPressed: () => {
                                  if (fromAddress.text.isNotEmpty &&
                                      fromCompany.text.isNotEmpty &&
                                      taxNumber.text.isNotEmpty)
                                    {_postData()}
                                },
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
          ]),
        ),
      ),
    );
  }

  Future<String?> dialog() {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: const Text("Edit"),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xffEA5455),
                            onPrimary: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: const Color(0xffEA5455),
                              onPrimary: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Done")),
                    )
                  ],
                )
              ],
              content: Builder(
                builder: (context) {
                  return SizedBox(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                        height: 5,
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
                        height: 5,
                      ),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: taxNumber,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'GST Number',
                          ),
                        ),
                      ),
                    ]),
                  );
                },
              ),
            ));
  }
}
