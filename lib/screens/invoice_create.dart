import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/model/customer.dart';
import 'package:invoice_generator/model/invoice.dart';
import 'package:invoice_generator/model/supplier.dart';
import 'package:invoice_generator/utilities/dropdown_data.dart';
import 'package:invoice_generator/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InvoiceGenerator extends StatefulWidget {
  const InvoiceGenerator({Key? key}) : super(key: key);
  @override
  State<InvoiceGenerator> createState() => _InvoiceGeneratorState();
}

class _InvoiceGeneratorState extends State<InvoiceGenerator> {
  bool check = false;
  String selectedValue = "Draft";
  TextEditingController toCompany = TextEditingController();
  TextEditingController toAddress = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController prodName = TextEditingController();
  TextEditingController prodQuantity = TextEditingController();
  TextEditingController gst = TextEditingController();
  TextEditingController prodCost = TextEditingController();
  List<InvoiceItem> products = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffEA5455),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    )),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xffF6F6F6),
                  onPrimary: const Color(0xffEA5455),
                ),
                child: const Text("Cancel"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                child: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xffF6F6F6),
                  onPrimary: const Color(0xffEA5455),
                ),
                onPressed: () async {
                  check = checkStatus(
                      toAddress.text,
                      toCompany.text,
                      dateController.text,
                      descController.text,
                      products.isNotEmpty);
                  if (check == true) {
                    final date = DateTime.now();
                    final dueDate = date
                        .add(Duration(days: int.parse(dateController.text)));
                    late Supplier supplier;
                    await FirebaseFirestore.instance
                        .collection('Suppliers')
                        .where('uid',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .get()
                        .then((snapshot) {
                      supplier = Supplier.fromMap(snapshot.docs.first.data());
                    });
                    FirebaseFirestore.instance
                        .collection('Invoices')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection(
                            '${FirebaseAuth.instance.currentUser!.email}')
                        .add(Invoice(
                          supplier: supplier,
                          customer: Customer(
                            name: toCompany.text,
                            address: toAddress.text,
                          ),
                          info: InvoiceInfo(
                            date: date,
                            dueDate: dueDate,
                            description: descController.text,
                            number: supplier.gstNumber,
                            status: selectedValue,
                          ),
                          items: products,
                        ).toMap());

                    dateController.clear();
                    toAddress.clear();
                    toCompany.clear();
                    descController.clear();
                    products.clear();
                    selectedValue = "Draft";
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  } else {
                    fieldDialog();
                  }
                  setState(() {
                    check = false;
                  });
                },
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Status: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 58, vertical: 1),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade500)),
                    child: DropdownButton(
                      value: selectedValue,
                      items: dropdownItems,
                      borderRadius: BorderRadius.circular(10),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Expires in: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: dateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Number of days',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "To: ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: toCompany,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'Company Name',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: toAddress,
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'Address',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Description: ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: descController,
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Description',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "GST: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: gst,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'GST Percent',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...products
                .map(
                  (item) => Card(
                    color: const Color(0xffEA5455),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              item.description,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(
                                  "Quantity: ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Text(
                                item.quantity.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(
                                  "Price: ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Text(
                                item.unitPrice.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(
                                  "GST: ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Text(
                                item.vat.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          )
                        ]),
                  ),
                )
                .toList(),
            ElevatedButton(
              onPressed: () => {
                dialog(),
              },
              child: const Text("Add items"),
              style: ElevatedButton.styleFrom(
                  primary: const Color(0xffFFB400),
                  onPrimary: Color(0xff2D4059)),
            ),
          ],
        ),
      ),
    );
  }

  Future fieldDialog() {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        title: Column(
          children: [
            Icon(Icons.error_rounded, size: 40, color: Colors.red),
            SizedBox(
              height: 5,
            ),
            Text("Alert"),
          ],
        ),
        actions: [
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xffEA5455), onPrimary: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"),
              ),
            ),
          ),
        ],
        content: Text(
          "Please check the fields or add atleast a single item",
          textAlign: TextAlign.center,
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
              title: const Text("Add Items"),
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
                            setState(() {
                              products.add(
                                InvoiceItem(
                                  description: prodName.text,
                                  date: DateTime.now(),
                                  quantity: int.parse(prodQuantity.text),
                                  vat: double.parse(gst.text),
                                  unitPrice: double.parse(prodCost.text),
                                ),
                              );
                            });

                            prodName.clear();
                            prodQuantity.clear();
                            prodCost.clear();
                            Navigator.pop(context);
                          },
                          child: const Text("Ok")),
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
                        height: 50,
                        child: TextField(
                          controller: prodName,
                          decoration: InputDecoration(
                            hintText: 'Product Name',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: TextField(
                          controller: prodQuantity,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Quantity',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: TextField(
                          controller: prodCost,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Price',
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

bool checkStatus(String toCompany, String toAddress, String dateController,
    String descController, bool products) {
  if ((toCompany != "") &&
      (toAddress != "") &&
      (dateController != "") &&
      (descController != "") &&
      (products == true)) {
    return true;
  }
  return false;
}

// ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: products.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Card(
//                     color: const Color(0xffFFB400),
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 4),
//                             child: Text(
//                               products[index].description,
//                               style: const TextStyle(
//                                 color: Color(0xff2D4059),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 23,
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               const Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 4),
//                                 child: Text(
//                                   "Quantity: ",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 (products[index].quantity).toString(),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               const Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 4),
//                                 child: Text(
//                                   "Price: ",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 (products[index].unitPrice).toString(),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               const Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 4),
//                                 child: Text(
//                                   "VAT: ",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 (products[index].vat).toString(),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ],
//                           )
//                         ]),
//                   );
//                 }),