import 'dart:convert';

import 'package:baseapp/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _phoneNumberController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixText: '+91 ',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      } else if (!_isValidPhoneNumber(value)) {
                        return 'Please enter a valid phone number';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _saveContact();
                      FocusScope.of(context).unfocus();
                    },
                    child: Text('Save Contact'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _printContacts();
                      FocusScope.of(context).unfocus();
                    },
                    child: Text('Print Contacts'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveContact() {
    if (_formKey.currentState?.validate() ?? false) {
      _saveContactToSharedPreferences();
    }
  }

  void _saveContactToSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String name = _nameController.text;
    final String phoneNumber = _phoneNumberController.text;

    // Retrieve the existing list of contacts
    List<Contact> contacts = _getContacts(prefs);

    // Add the new contact to the list
    contacts.add(Contact(name: name, phoneNumber: phoneNumber));

    // Save the updated list of contacts to SharedPreferences
    await prefs.setStringList(
      'contacts',
      contacts.map((contact) => json.encode(contact.toJson())).toList(),
    );

    // Optionally, you can show a success message or navigate to another screen.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contact saved successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  List<Contact> _getContacts(SharedPreferences prefs) {
    List<String>? contactsJson = prefs.getStringList('contacts') ?? [];
    return contactsJson.map((jsonString) {
      Map<String, dynamic> json = jsonDecode(jsonString);
      return Contact.fromJson(json);
    }).toList();
  }

  bool _isValidPhoneNumber(String input) {
    // Regular expression for a valid Indian phone number
    // This example allows for the phone number to be entered with or without the '+91' prefix.
    final RegExp phoneRegExp = RegExp(r'^(\+91)?[1-9]\d{9}$');
    return phoneRegExp.hasMatch(input);
  }

  void _printContacts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the list of contacts
    List<Contact> contacts = _getContacts(prefs);

    // Print the contact information to the console
    contacts.forEach((contact) {
      print('Name: ${contact.name}, Phone Number: ${contact.phoneNumber}');
    });
  }
}
