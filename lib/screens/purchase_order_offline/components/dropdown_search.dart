import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../helper/database_helper.dart';

class Customer {
  final int id;
  final String name;

  Customer({required this.id, required this.name});

  @override
  String toString() {
    return name;
  }
}

class DropdownSearchWidget extends StatefulWidget {
  @override
  _DropdownSearchWidgetState createState() => _DropdownSearchWidgetState();
}

class _DropdownSearchWidgetState extends State<DropdownSearchWidget> {
  final TextEditingController _controller = TextEditingController();
  Customer? _selectedCustomer;

  List<dynamic> customers = [
    Customer(id: 1, name: 'Customer 1'),
    Customer(id: 2, name: 'Customer 2'),
    Customer(id: 3, name: 'Customer 3'),
  ];
  //

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<dynamic>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Customer',
          labelStyle: TextStyle(
            color: Colors.black87,
            fontSize: 17,
          ),
        ),
        style: TextStyle(
          color: Colors.black87,
          fontSize: 17,
        ),
      ),
      suggestionsCallback: (String query) {
        return customers.where((customer) {
          return customer.name.toLowerCase().contains(query.toLowerCase());
        });
      },
      itemBuilder: (BuildContext context, dynamic customer) {
        return ListTile(
          title: Text(customer.name),
        );
      },
      onSuggestionSelected: (dynamic customer) {
        setState(() {
          _selectedCustomer = customer;
          _controller.text = customer.name;
        });
      },
    );
  }
}
