import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:invoice_generator/api/pdf_api.dart';
import 'package:invoice_generator/api/pdf_invoice_api.dart';
import 'package:invoice_generator/model/invoice.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({Key? key, required this.invoice}) : super(key: key);
  final Invoice invoice;
  Widget setStatus() {
    if (invoice.info.status == "Overdue") {
      return Row(
        children: [
          Icon(
            Icons.circle,
            size: 15,
            color: Color(0xffEA5455),
          ),
          Text(
            invoice.info.status,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xffEA5455),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      );
    } else if (invoice.info.status == "Paid") {
      return Row(
        children: [
          Icon(
            Icons.circle,
            size: 15,
            color: Colors.green,
          ),
          Text(
            invoice.info.status,
            style: TextStyle(
              fontSize: 15,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      );
    } else if (invoice.info.status == "Onhold") {
      return Row(
        children: [
          Icon(
            Icons.circle,
            size: 15,
            color: Colors.blue,
          ),
          Text(
            invoice.info.status,
            style: TextStyle(
              fontSize: 15,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      );
    } else {
      return Row(
        children: [
          Icon(
            Icons.circle,
            size: 15,
            color: Colors.grey,
          ),
          Text(
            invoice.info.status,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final pdfFile = await PdfInvoiceApi.generate(invoice, "id");
        PdfApi.openFile(pdfFile);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffFFB400),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(
                0.2,
                3.0,
              ),
              blurRadius: 7.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  invoice.customer.name,
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xff2D4059),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xffF6F6F6),
                  ),
                  padding: EdgeInsets.all(3),
                  child: setStatus(),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              invoice.info.description,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xffF6F6F6),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "${invoice.info.date.day}/${invoice.info.date.month}/${invoice.info.date.year}",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xffF6F6F6),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
