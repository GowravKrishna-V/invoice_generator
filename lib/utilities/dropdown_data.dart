import 'package:flutter/material.dart';

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(
        child: Text(
          "Draft",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        value: "Draft"),
    DropdownMenuItem(
        child: Text(
          "Paid",
          style: TextStyle(
            color: Colors.green,
          ),
        ),
        value: "Paid"),
    DropdownMenuItem(
        child: Text(
          "Overdue",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        value: "Overdue"),
    DropdownMenuItem(
        child: Text(
          "Onhold",
          style: TextStyle(color: Colors.blue),
        ),
        value: "Onhold"),
  ];
  return menuItems;
}
