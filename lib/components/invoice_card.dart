import 'package:flutter/material.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              const Text(
                "Invoice Number",
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
                      "Overdue",
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
          const Text(
            "Customer Name",
            style: TextStyle(
              fontSize: 20,
              color: Color(0xffF6F6F6),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          const Text(
            "Amount",
            style: TextStyle(
              fontSize: 20,
              color: Color(0xffF6F6F6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
