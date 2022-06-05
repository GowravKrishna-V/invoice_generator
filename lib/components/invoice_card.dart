import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:invoice_generator/model/invoice.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard(
      {Key? key,
      required this.invoiceNumber,
      required this.customerName,
      required this.amount,
      required this.status})
      : super(key: key);
  final String invoiceNumber;
  final String customerName;
  final double amount;
  final String status;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
                  invoiceNumber,
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
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 15,
                        color: Color(0xffEA5455),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xffEA5455),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              customerName,
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
              amount.toString(),
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
