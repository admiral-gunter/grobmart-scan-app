import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../helper/database_helper.dart';

class DropdownSearchWidget extends StatefulWidget {
  @override
  _DropdownSearchWidgetState createState() => _DropdownSearchWidgetState();
}

class _DropdownSearchWidgetState extends State<DropdownSearchWidget> {
  final TextEditingController _controller = TextEditingController();
  dynamic _selectedCustomer;
  List<dynamic> customers = [];

  // Async function to fetch customers data
  Future<void> fetchCustomers() async {
    // Simulate an async fetch operation, replace this with your actual data fetching logic
    final e = await DatabaseHelper.instance.getCustomers();

    setState(() {
      customers = e;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCustomers(); // Load customers data when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return customers.isEmpty // Check if the data is still loading
        ? CircularProgressIndicator() // Show a loading indicator while data is being fetched
        : TypeAheadField<dynamic>(
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
                return customer['name']
                    .toLowerCase()
                    .contains(query.toLowerCase());
              });
            },
            itemBuilder: (BuildContext context, dynamic customer) {
              return ListTile(
                title: Text(customer['name']),
              );
            },
            onSuggestionSelected: (dynamic customer) {
              setState(() {
                _selectedCustomer = customer;
                _controller.text = customer['name'];
              });
            },
          );
  }
}
