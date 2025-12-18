import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert'; 

late Database database;

Future<void> initDB() async {
  print("DB initialized");
  String path = await getDatabasesPath();
  print(path);

      database = await openDatabase(
    join(path, 'database.db'),
    onCreate: (db, version) async {
      print("Creating tables...");
      await db.execute(
        'CREATE TABLE IF NOT EXISTS users ('
        'uid INTEGER PRIMARY KEY AUTOINCREMENT, '
        'name TEXT, '
        'email TEXT, '
        'pass VARCHAR(50), '
        'type TEXT, '
        'active INTEGER'
        ')',
      );

      await db.execute(
        'CREATE TABLE IF NOT EXISTS pizza ('
        'pid INTEGER PRIMARY KEY AUTOINCREMENT, '
        'title TEXT, '
        'desc TEXT, '
        'img TEXT, '
        'price REAL, '
        'old_price REAL, '
        'QteStock INTEGER, '
        'isVeg INTEGER, '
        'nature TEXT, '
        'options TEXT, '
        'archive INTEGER DEFAULT 1'
        ')',
      );

      await db.execute(
        'CREATE TABLE IF NOT EXISTS command ('
        'cid INTEGER PRIMARY KEY AUTOINCREMENT, '
        'date TEXT, '
        'uid INTEGER, '
        'FOREIGN KEY (uid) REFERENCES users (uid)'
        ')',
      );

      await db.execute(
        'CREATE TABLE IF NOT EXISTS commandinfo ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'Qte INTEGER, '
        'price REAL, '
        'pid INTEGER, '
        'cid INTEGER, ' 
        'FOREIGN KEY (pid) REFERENCES pizza (pid), '
        'FOREIGN KEY (cid) REFERENCES command (cid)'
        ')',
      );

      print("Seeding data...");

      await db.insert('users', {
        'name': 'Admin',
        'email': 'admin@gmail.com',
        'pass': '1Aa@azer',
        'type': 'admin',
        'active': 1
      });

      await db.insert('users', {
        'name': 'User',
        'email': 'user@gmail.com',
        'pass': '1Aa@azer',
        'type': 'user',
        'active': 1
      });

      await db.insert('pizza', {
        'title': 'Mexican',
        'desc': 'Spicy mexican pizza with chili',
        'img': 'assets/salta3burger.png',
        'price': 12.0,
        'old_price': 15.0,
        'QteStock': 10,
        'isVeg': 0,
        'nature': 'Spicy',
        'options': jsonEncode({'calories': 300, 'protein': 20, 'fat': 10, 'carbs': 50}),
        'archive': 1
      });

      await db.insert('pizza', {
        'title': 'Vegetarian',
        'desc': 'Fresh veggies cheese',
        'img': 'assets/salta3burger.png',
        'price': 10.0,
        'old_price': 12.0,
        'QteStock': 15,
        'isVeg': 1,
        'nature': 'Healthy',
        'options': jsonEncode({'calories': 250, 'protein': 10, 'fat': 5, 'carbs': 40}),
        'archive': 1
      });

      await db.insert('pizza', {
        'title': '4 Cheese',
        'desc': 'Mozzarella, Cheddar, Blue, Parmesan',
        'img': 'assets/salta3burger.png',
        'price': 11.0,
        'old_price': 14.0,
        'QteStock': 8,
        'isVeg': 1,
        'nature': 'Cheesy',
        'options': jsonEncode({'calories': 400, 'protein': 18, 'fat': 20, 'carbs': 45}),
        'archive': 1
      });

      await db.insert('pizza', {
        'title': 'Margarita',
        'desc': 'Classic tomato and basil',
        'img': 'assets/salta3burger.png',
        'price': 9.0,
        'old_price': 10.0,
        'QteStock': 20,
        'isVeg': 1,
        'nature': 'Classic',
        'options': jsonEncode({'calories': 220, 'protein': 8, 'fat': 8, 'carbs': 35}),
        'archive': 1
      });

    },
    onUpgrade: (db, oldVersion, newVersion) async {
      print("Upgrading DB from $oldVersion to $newVersion");
      if (oldVersion < 2) {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS pizza ('
          'pid INTEGER PRIMARY KEY AUTOINCREMENT, '
          'title TEXT, '
          'desc TEXT, '
          'img TEXT, '
          'price REAL, '
          'old_price REAL, '
          'QteStock INTEGER, '
          'isVeg INTEGER, '
          'nature TEXT, '
          'options TEXT, '
          'archive INTEGER DEFAULT 1'
          ')',
        );

        await db.execute(
          'CREATE TABLE IF NOT EXISTS command ('
          'cid INTEGER PRIMARY KEY AUTOINCREMENT, '
          'date TEXT, '
          'uid INTEGER, '
          'FOREIGN KEY (uid) REFERENCES users (uid)'
          ')',
        );

        await db.execute(
          'CREATE TABLE IF NOT EXISTS commandinfo ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'Qte INTEGER, '
          'price REAL, '
          'pid INTEGER, '
          'FOREIGN KEY (pid) REFERENCES pizza (pid)'
          ')',
        );

        await db.insert('pizza', {
          'title': 'Mexican',
          'desc': 'Spicy mexican pizza with chili',
          'img': 'assets/salta3burger.png', 
          'price': 12.0,
          'old_price': 15.0,
          'QteStock': 10,
          'isVeg': 0,
          'nature': 'Spicy',
          'options': jsonEncode({'calories': 300, 'protein': 20, 'fat': 10, 'carbs': 50}),
          'archive': 1
        });

        await db.insert('pizza', {
          'title': 'Vegetarian',
          'desc': 'Fresh veggies cheese',
          'img': 'assets/salta3burger.png',
          'price': 10.0,
          'old_price': 12.0,
          'QteStock': 15,
          'isVeg': 1,
          'nature': 'Healthy',
          'options': jsonEncode({'calories': 250, 'protein': 10, 'fat': 5, 'carbs': 40}),
          'archive': 1
        });

        await db.insert('pizza', {
          'title': '4 Cheese',
          'desc': 'Mozzarella, Cheddar, Blue, Parmesan',
          'img': 'assets/salta3burger.png',
          'price': 11.0,
          'old_price': 14.0,
          'QteStock': 8,
          'isVeg': 1,
          'nature': 'Cheesy',
          'options': jsonEncode({'calories': 400, 'protein': 18, 'fat': 20, 'carbs': 45}),
          'archive': 1
        });

        await db.insert('pizza', {
          'title': 'Margarita',
          'desc': 'Classic tomato and basil',
          'img': 'assets/salta3burger.png',
          'price': 9.0,
          'old_price': 10.0,
          'QteStock': 20,
          'isVeg': 1,
          'nature': 'Classic',
          'options': jsonEncode({'calories': 220, 'protein': 8, 'fat': 8, 'carbs': 35}),
          'archive': 1
        });
      }

      if (oldVersion < 3) {
        var columns = await db.rawQuery('PRAGMA table_info(commandinfo)');
        bool hasCid = columns.any((column) => column['name'] == 'cid');
        
        if (!hasCid) {
           await db.execute('ALTER TABLE commandinfo ADD COLUMN cid INTEGER REFERENCES command(cid)');
        }
      }
    },
    version: 3,
  );
}


Future<void> insertUser(
    String name, String email, String password, String type, bool active) async {
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

Future<List<Map<String, dynamic>>> getUsers() async {
  print("getting users ..");
  List<Map<String, dynamic>> results = await database.rawQuery("SELECT * FROM users");
  return results;
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

Future<void> updateUser(int uid, {String? name, String? email, String? password}) async {
  print("Updating user $uid...");
  Map<String, dynamic> updateData = {};
  
  if (name != null) updateData['name'] = name;
  if (email != null) updateData['email'] = email;
  if (password != null && password.isNotEmpty) updateData['pass'] = password;

  if (updateData.isNotEmpty) {
    await database.update(
      'users',
      updateData,
      where: 'uid = ?',
      whereArgs: [uid],
    );
  }
}

Future<void> deleteUser(int uid) async {
  print("Deleting user $uid...");
  await database.delete('users', where: 'uid = ?', whereArgs: [uid]);
}

Future<void> toggleUserStatus(int uid, int active) async {
  print("Setting user $uid active status to $active...");
  await database.update(
    'users',
    {'active': active},
    where: 'uid = ?',
    whereArgs: [uid],
  );
}

Future<List<Map<String, dynamic>>> getRegularUsers() async {
  print("Fetching regular users...");
  return await database.query(
    'users',
    where: 'type != ?',
    whereArgs: ['admin'],
  );
}

// ============== PIZZA METHODS ===============

Future<List<Map<String, dynamic>>> getPizzas() async {
    print("Fetching active pizzas...");
    return await database.query(
        'pizza',
        where: 'archive = ?',
        whereArgs: [1]
    );
}

Future<void> insertPizza(
    String title,
    String desc,
    String img,
    double price,
    double? oldPrice,
    int qteStock,
    bool isVeg,
    String nature,
    String optionsJson
) async {
    print("Inserting pizza: $title");
    await database.insert(
        'pizza',
        {
            'title': title,
            'desc': desc,
            'img': img,
            'price': price,
            'old_price': oldPrice,
            'QteStock': qteStock,
            'isVeg': isVeg ? 1 : 0,
            'nature': nature,
            'options': optionsJson,
            'archive': 1 
        }
    );
}

Future<void> updatePizza(
    int pid,
    String title,
    String desc,
    String img,
    double price,
    double? oldPrice,
    int qteStock,
    bool isVeg,
    String nature,
    String optionsJson
) async {
    print("Updating pizza: $pid");
    await database.update(
        'pizza',
        {
            'title': title,
            'desc': desc,
            'img': img,
            'price': price,
            'old_price': oldPrice,
            'QteStock': qteStock,
            'isVeg': isVeg ? 1 : 0,
            'nature': nature,
            'options': optionsJson
        },
        where: 'pid = ?',
        whereArgs: [pid]
    );
}

Future<void> archivePizza(int pid) async {
    print("Archiving pizza: $pid");
    await database.update(
        'pizza',
        {'archive': 0},
        where: 'pid = ?',
        whereArgs: [pid]
    );
}

// ============== ORDERING METHODS ===============

Future<int> insertCommand(int uid, String date) async {
    print("Creating order for user $uid on $date");
    return await database.insert('command', {
        'uid': uid,
        'date': date
    });
}

Future<void> insertCommandInfo(int cid, int pid, int qte, double price) async {
    print("Adding item to order $cid: pid=$pid, qte=$qte");
    await database.insert('commandinfo', {
        'cid': cid,
        'pid': pid,
        'Qte': qte,
        'price': price
    });
}

Future<void> updateStock(int pid, int quantityToRemove) async {
    print("Reducing stock for pizza $pid by $quantityToRemove");
    await database.rawUpdate(
        'UPDATE pizza SET QteStock = QteStock - ? WHERE pid = ?',
        [quantityToRemove, pid]
    );
}

Future<List<Map<String, dynamic>>> getUserOrders(int uid) async {
    print("Fetching orders for user $uid");
    
    return await database.rawQuery('''
        SELECT c.cid, c.date, 
               CAST(SUM(ci.Qte) as INTEGER) as pizza_count, 
               SUM(ci.price * ci.Qte) as total_price
        FROM command c
        JOIN commandinfo ci ON c.cid = ci.cid
        WHERE c.uid = ?
        GROUP BY c.cid, c.date
        ORDER BY c.cid DESC
    ''', [uid]);
}