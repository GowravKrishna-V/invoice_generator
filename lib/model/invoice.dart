import 'package:invoice_generator/model/customer.dart';
import 'package:invoice_generator/model/supplier.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
  Invoice.fromMap(Map<String, dynamic> json)
      : info = json['info'],
        supplier = json['supplier'],
        customer = json['customer'],
        items = json['items'];

  Map<String, dynamic> toMap() => {
        'info': info.toMap(),
        'supplier': supplier.toMap(),
        'date': customer.toMap(),
        'items': items.map((e) => e.toMap()).toList(),
      };
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;
  final String status;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
    required this.status,
  });
  InvoiceInfo.fromMap(Map<String, dynamic> json)
      : description = json['description'],
        number = json['number'],
        date = json['date'],
        dueDate = json['duedate'],
        status = json['status'];

  Map<String, dynamic> toMap() => {
        'description': description,
        'number': number,
        'date': date,
        'duedate': dueDate,
        'status': status,
      };
}

class InvoiceItem {
  final String description;
  final DateTime date;
  final int quantity;
  final double vat;
  final double unitPrice;

  const InvoiceItem({
    required this.description,
    required this.date,
    required this.quantity,
    required this.vat,
    required this.unitPrice,
  });

  InvoiceItem.fromMap(Map<String, dynamic> json)
      : description = json['description'],
        date = json['date'],
        quantity = json['quantity'],
        vat = json['vat'],
        unitPrice = json['unitprice'];

  Map<String, dynamic> toMap() => {
        'description': description,
        'date': date,
        'quantity': quantity,
        'vat': vat,
        'unitprice': unitPrice,
      };
}
