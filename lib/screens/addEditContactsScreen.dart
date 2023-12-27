import 'package:Contacts_Buddy/databaseInfo/contactsDao.dart';
import 'package:Contacts_Buddy/models/contacts.dart';
import 'package:Contacts_Buddy/screens/contactScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddEditContactsScreen extends StatefulWidget {
  Contacts? contact;
  bool isUpdate;
  AddEditContactsScreen(
      {Key? key, required this.isUpdate, required this.contact})
      : super(key: key);

  @override
  State<AddEditContactsScreen> createState() => _AddEditContactsScreenState();
}

class _AddEditContactsScreenState extends State<AddEditContactsScreen> {
  var tfContactsName = TextEditingController();
  var tfContactsNumber = TextEditingController();

  Future<void> regContacts(String contacts_name, int contacts_number) async {
    await Contactsdao().addContacts(contacts_name, contacts_number);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ContactScreen()));
  }

  Future<void> contactsDelete(int contacts_id) async {
    await Contactsdao().deleteContacts(contacts_id);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ContactScreen()));
  }

  Future<void> contactsUpdate(
      int contacts_id, String contacts_name, int contacts_number) async {
    await Contactsdao()
        .updateContacts(contacts_id, contacts_name, contacts_number);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ContactScreen()));
  }

  @override
  void initState() {
    var cont = widget.contact;
    if (widget.isUpdate && cont != null) {
      tfContactsName.text = cont.contacts_name;
      tfContactsNumber.text = cont.contacts_number.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: widget.isUpdate
              ? const Icon(Icons.arrow_back)
              : const Icon(CupertinoIcons.xmark),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          (widget.isUpdate && widget.contact != null)
              ? IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 40.0,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                "Do you want to delete ${widget.contact!.contacts_name}?"),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text("Ok"),
                                onPressed: () {
                                  setState(() {
                                    contactsDelete(widget.contact!.contacts_id);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ContactScreen()));
                                  });
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                  },
                )
              : Container(),
          IconButton(
            icon: const Icon(
              Icons.check,
              size: 28,
            ),
            onPressed: !widget.isUpdate
                ? () {
                    regContacts(
                        tfContactsName.text, int.parse(tfContactsNumber.text));
                    Navigator.pop(context);
                  }
                : () {
                    contactsUpdate(widget.contact!.contacts_id,
                        tfContactsName.text, int.parse(tfContactsNumber.text));
                    Navigator.pop(context);
                  },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Image.asset("images/user.png", width: 100),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
              child: SizedBox(
                height: 60,
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller: tfContactsName,
                  style: const TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Enter contact name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
              child: SizedBox(
                height: 60,
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: tfContactsNumber,
                  style: const TextStyle(fontSize: 20.0),
                  decoration: InputDecoration(
                      labelText: "Number",
                      counterText: '',
                      hintText: "Enter contact number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
