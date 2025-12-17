import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

late Database database ;

Future<void> initDB() async {
  print("DB initialized");
  print(await getDatabasesPath());

   database = await  openDatabase(

       join(await getDatabasesPath(), 'database.db'),
    onCreate:(db,version) async {
    await db.execute(
      'create table IF NOT EXISTS users ('
          'uid integer primary key,'
          ' name text , email text ,'
          ' pass varchar(50),'
          ' type TEXT ,'
          'active integer'
          ')',
    );
    },

    version:1,
  );

}
  Future<void> insertUser (
      String name,
      String email,
      String password,
      String type,
      bool active,
  )async{
  print("inserting ... ");
    await database.insert(
      'users',
      {
        'name': name,
        'email': email,
        'pass': password,
        'type': type,
        'active': active ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,

    );
  }
  
  Future<List<Map<String, dynamic>>> getUsers() async{
  print("geting users ..");
  List <Map<String,dynamic >>   results = await database.rawQuery("SELECT * FROM users");
  return results ;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    List<Map<String, dynamic>> results = await database.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<void> deleteAllUsers() async {
    print("Deleting all users...");
    await database.delete('users');
  }
