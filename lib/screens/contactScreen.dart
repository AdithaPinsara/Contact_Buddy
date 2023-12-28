import 'package:Contacts_Buddy/databaseInfo/contactsDao.dart';
import 'package:Contacts_Buddy/models/contacts.dart';
import 'package:Contacts_Buddy/screens/addEditContactsScreen.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  Future<List<Contacts>> allContactsShow() async {
    var contactsList = await Contactsdao().allContacts();
    return contactsList;
  }

  bool searching = false;
  var searchText = '';

  Future<List<Contacts>> contactsSearch(String searchText) async {
    var contactsList = await Contactsdao().searchContacts(searchText);
    return contactsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.person,
          size: 40.0,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: SizedBox(
          height: 50,
          child: TextField(
            onChanged: (searchResult) {
              setState(() {
                searchText = searchResult;
                searching = true;
              });
            },
            style: const TextStyle(fontSize: 20.0),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 2.0),
                hintText: "Search contacts",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0))),
          ),
        ),
      ),
      body: FutureBuilder<List<Contacts>>(
        future: searching ? contactsSearch(searchText) : allContactsShow(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var contactsList = snapshot.data;
            if (contactsList!.isEmpty) {
              return const Center(
                child: Text("No contact data found",
                    style: TextStyle(fontSize: 20)),
              );
            }
            return ListView.builder(
              itemCount: contactsList!.length,
              itemBuilder: (context, index) {
                var contact = contactsList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEditContactsScreen(
                                  isUpdate: true,
                                  contact: contact,
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: SizedBox(
                      height: 50,
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Image.asset("images/user.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                contact.contacts_name,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
                // child: Text("No contact data found",
                //     style: TextStyle(fontSize: 20)),
                );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFf0178c8),
        tooltip: "Add new contact",
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddEditContactsScreen(
                        isUpdate: false,
                        contact: null,
                      )));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40.0,
        ),
      ),
    );
  }
}
