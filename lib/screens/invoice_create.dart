import 'package:flutter/material.dart';
import 'package:invoice_generator/api/pdf_api.dart';
import 'package:invoice_generator/api/pdf_invoice_api.dart';
import 'package:invoice_generator/model/customer.dart';
import 'package:invoice_generator/model/invoice.dart';
import 'package:invoice_generator/model/supplier.dart';
import 'package:invoice_generator/utilities/dropdown_data.dart';
import 'package:invoice_generator/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InvoiceGenerator extends StatefulWidget {
  const InvoiceGenerator({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  State<InvoiceGenerator> createState() => _InvoiceGeneratorState();
}

class _InvoiceGeneratorState extends State<InvoiceGenerator> {
  String selectedValue = "Draft";
  TextEditingController toCompany = TextEditingController();
  TextEditingController toAddress = TextEditingController();
  TextEditingController fromCompany = TextEditingController();
  TextEditingController fromAddress = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController prodName = TextEditingController();
  TextEditingController prodQuantity = TextEditingController();
  TextEditingController prodVat = TextEditingController();
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
                      builder: (context) => HomePage(
                        user: widget.user,
                      ),
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
                child: const Text('Invoice PDF'),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xffF6F6F6),
                  onPrimary: const Color(0xffEA5455),
                ),
                onPressed: () async {
                  final date = DateTime.now();
                  final dueDate =
                      date.add(Duration(days: int.parse(dateController.text)));

                  final invoice = Invoice(
                    supplier: Supplier(
                      name: fromCompany.text,
                      address: fromAddress.text,
                      paymentInfo: 'https://paypal.me/sarahfieldzz',
                    ),
                    customer: Customer(
                      name: toCompany.text,
                      address: toAddress.text,
                    ),
                    info: InvoiceInfo(
                      date: date,
                      dueDate: dueDate,
                      description: descController.text,
                      number: '${DateTime.now().year}-9999',
                    ),
                    items: products,
                  );

                  final pdfFile = await PdfInvoiceApi.generate(invoice);

                  PdfApi.openFile(pdfFile);
                },
              ),
            ),
          ],
        ),
        body: ListView(
          shrinkWrap: true,
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
                      "From: ",
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
                        height: 20,
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
            ElevatedButton(
              onPressed: () => dialog(),
              child: const Text("Add items"),
              style: ElevatedButton.styleFrom(primary: const Color(0xffEA5455)),
            ),
          ],
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
                            products.add(
                              InvoiceItem(
                                description: prodName.text,
                                date: DateTime.now(),
                                quantity: int.parse(prodQuantity.text),
                                vat: double.parse(prodVat.text),
                                unitPrice: double.parse(prodCost.text),
                              ),
                            );
                            prodName.clear();
                            prodQuantity.clear();
                            prodVat.clear();
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
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return SizedBox(
                    height: height - 570,
                    width: width - 400,
                    child: Column(children: [
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
                        height: 50,
                        width: 200,
                        child: TextField(
                          controller: prodVat,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Value added tax',
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
