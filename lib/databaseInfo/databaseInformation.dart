import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInformation {
  static const String databaseName = "contacts.db";

  static Future<Database> databaseAccess() async {
    String databasePath = join(await getDatabasesPath(), databaseName);

    if (await databaseExists(databasePath)) {
      //Checking whether there is a database or not
      if (kDebugMode) {
        print("The database already exists. There is no need to copy it");
      }
    } else {
      //importing database from asset
      ByteData data = await rootBundle.load("database/$databaseName");
      //Byte conversion of database for copying
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      //Copying the database.
      await File(databasePath).writeAsBytes(bytes, flush: true);
      if (kDebugMode) {
        print("Database copied");
      }
    }
    //open the database.
    return openDatabase(databasePath);
  }
}
