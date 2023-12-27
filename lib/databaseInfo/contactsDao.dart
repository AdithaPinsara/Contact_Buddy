import 'package:Contacts_Buddy/databaseInfo/databaseInformation.dart';

import '../models/contacts.dart';

class Contactsdao {
  Future<List<Contacts>> allContacts() async {
    var db = await DatabaseInformation.databaseAccess();
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM contacts ORDER BY contacts_name COLLATE NOCASE ASC");
    return List.generate(maps.length, (index) {
      var mapItem = maps[index];
      return Contacts(mapItem["contacts_id"], mapItem["contacts_name"],
          mapItem["contacts_number"]);
    });
  }

  Future<void> addContacts(String contactsName, int contactsNumber) async {
    var db = await DatabaseInformation.databaseAccess();

    var newContact = Map<String, dynamic>();
    newContact["contacts_name"] = contactsName;
    newContact["contacts_number"] = contactsNumber;

    await db.insert("contacts", newContact);
  }

  Future<void> updateContacts(
      int contactsId, String contactsName, int contactsNumber) async {
    var db = await DatabaseInformation.databaseAccess();

    var updatedContact = Map<String, dynamic>();
    updatedContact["contacts_name"] = contactsName;
    updatedContact["contacts_number"] = contactsNumber;

    await db.update("contacts", updatedContact,
        where: "contacts_id=?", whereArgs: [contactsId]);
  }

  Future<void> deleteContacts(int contactsId) async {
    var db = await DatabaseInformation.databaseAccess();
    await db
        .delete("contacts", where: "contacts_id=?", whereArgs: [contactsId]);
  }

  Future<List<Contacts>> searchContacts(String searchText) async {
    var db = await DatabaseInformation.databaseAccess();
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM contacts WHERE contacts_name like '%$searchText%'");
    return List.generate(maps.length, (index) {
      var mapItem = maps[index];

      return Contacts(mapItem["contacts_id"], mapItem["contacts_name"],
          mapItem["contacts_number"]);
    });
  }
}
