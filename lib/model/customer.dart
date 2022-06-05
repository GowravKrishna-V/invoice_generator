class Customer {
  final String name;
  final String address;

  const Customer({
    required this.name,
    required this.address,
  });
  Customer.fromMap(Map<String, dynamic> json)
      : name = json['name'],
        address = json['address'];

  Map<String, dynamic> toMap() => {
        'name': name,
        'address': address,
      };
}
