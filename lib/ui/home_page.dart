import 'dart:io';

import 'package:flutter/material.dart';
import 'package:agendadecontatos/helpers/contact_helper.dart';
import 'package:agendadecontatos/ui/contact_page.dart';
//import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelp contactHelp = ContactHelp();
  List<Contact> contacts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getAllContacts();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        }
      )
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].img != null ?
                      FileImage(File(contacts[index].img!)) :
                      AssetImage("images/person.png") as ImageProvider,
                      fit: BoxFit.cover
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   Text(contacts[index].name ?? "",
                      style: TextStyle(fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                    ),
                    Text(contacts[index].email ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(contacts[index].phone ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                ])
              ),
            ]),
          ),
        ),
        onTap: () {
          //_showContactPage(contact: contacts[index]);
          _showOption(context, index);
        },
      );
    }

    void _showOption(BuildContext context, int index) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FlatButton(
                          onPressed: (){},
                          child: Text("Ligar", style: TextStyle(color: Colors.red, fontSize: 20.0),)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FlatButton(
                          onPressed: (){
                            Navigator.pop(context);
                            _showContactPage(contact: contacts[index]);
                          },
                          child: Text("Editar", style: TextStyle(color: Colors.red, fontSize: 20.0),)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FlatButton(
                          onPressed: (){
                            contactHelp.deleteContact(contacts[index].id!);
                            setState(() {
                              contacts.removeAt(index);
                              Navigator.pop(context);
                            });
                          },
                          child: Text("Excluir", style: TextStyle(color: Colors.red, fontSize: 20.0),)
                      ),
                    )
                  ],

                ),
              );
            }
          );
        }
      );
    }

    void _showContactPage({Contact? contact}) async {
      final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context)=> ContactPage(contact: contact,))
      );
      if(recContact != null) {
        if(contact != null) {
          await contactHelp.updateContact(recContact);
        } else {
          await contactHelp.saveContact(recContact);
        }
        _getAllContacts();
      }
    }

    void _getAllContacts() {
      contactHelp.getAllContacts().then((list) {
        setState(() {
          contacts = list;
        });
      });
    }
  }
