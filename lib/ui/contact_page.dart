import 'dart:io';

import 'package:flutter/material.dart';
import 'package:agendadecontatos/helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {

  final Contact? contact;

  const ContactPage({Key? key, this.contact}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _homeFocus = FocusNode();

  bool _userEdited = false;

  Contact? _editContact;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.contact == null) {
      _editContact = Contact();
    } else {
      _editContact = Contact.fromMap(widget.contact!.toMap());

      _nameController.text = _editContact!.name!;
      _emailController.text = _editContact!.email!;
      _phoneController.text = _editContact!.phone!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editContact!.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_editContact!.name! != null && _editContact!.name!.isNotEmpty) {
            Navigator.pop(context, _editContact);
          } else {
            FocusScope.of(context).requestFocus(_homeFocus);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: _editContact!.img != null
                          ? FileImage(File(_editContact!.img!))
                          : const AssetImage("images/person.png") as ImageProvider

                  ),
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              focusNode: _homeFocus,
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editContact?.name = text;
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
              onChanged: (text) {
                _userEdited = true;
                _editContact?.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Phone"),
              onChanged: (text) {
                _userEdited = true;
                _editContact?.phone = text;
              },
              keyboardType: TextInputType.phone,
            )
          ],
        ),
      ),
    );
  }
}
