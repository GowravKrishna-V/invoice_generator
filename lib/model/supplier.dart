import 'dart:convert';

class Supplier {
  final String uid;
  final String name;
  final String address;
  final String mailAddress;

  const Supplier(
      {required this.uid,
      required this.name,
      required this.address,
      required this.mailAddress});

  Supplier.fromMap(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        address = json['address'],
        mailAddress = json['email'];

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'address': address,
        'email': mailAddress,
      };
}
