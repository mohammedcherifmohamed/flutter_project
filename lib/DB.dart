import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert'; // For JSON

late Database database;

Future<void> initDB() async {
  print("DB initialized");
  String path = await getDatabasesPath();
  print(path);

      database = await openDatabase(
    join(path, 'database.db'),
    onCreate: (db, version) async {
      print("Creating tables...");
      // 1. Users Table
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

      // 2. Pizza Table
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

      // 3. Command Table
      await db.execute(
        'CREATE TABLE IF NOT EXISTS command ('
        'cid INTEGER PRIMARY KEY AUTOINCREMENT, '
        'date TEXT, '
        'uid INTEGER, '
        'FOREIGN KEY (uid) REFERENCES users (uid)'
        ')',
      );

      // 4. CommandInfo Table
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

      // --- SEEDING ---
      print("Seeding data...");

      // Admin Account
      await db.insert('users', {
        'name': 'Admin',
        'email': 'admin@gmail.com',
        'pass': '1Aa@azer',
        'type': 'admin',
        'active': 1
      });

      // User Account
      await db.insert('users', {
        'name': 'User',
        'email': 'user@gmail.com',
        'pass': '1Aa@azer',
        'type': 'user',
        'active': 1
      });

      // Pizza 1: Mexican
      await db.insert('pizza', {
        'title': 'Mexican',
        'desc': 'Spicy mexican pizza with chili',
        'img': 'assets/salta3burger.png', // Placeholder
        'price': 12.0,
        'old_price': 15.0,
        'QteStock': 10,
        'isVeg': 0,
        'nature': 'Spicy',
        'options': jsonEncode({'calories': 300, 'protein': 20, 'fat': 10, 'carbs': 50}),
        'archive': 1
      });

      // Pizza 2: Vegetarian
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

       // Pizza 3: Cheese
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

      // Pizza 4: Margarita
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
         // Create Pizza Table
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

        // Create Command Table
        await db.execute(
          'CREATE TABLE IF NOT EXISTS command ('
          'cid INTEGER PRIMARY KEY AUTOINCREMENT, '
          'date TEXT, '
          'uid INTEGER, '
          'FOREIGN KEY (uid) REFERENCES users (uid)'
          ')',
        );

        // Create CommandInfo Table
        await db.execute(
          'CREATE TABLE IF NOT EXISTS commandinfo ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'Qte INTEGER, '
          'price REAL, '
          'pid INTEGER, '
          'FOREIGN KEY (pid) REFERENCES pizza (pid)'
          ')',
        );

         // Helper to seed pizza if empty (optional, but good for migration)
         // Pizza 1: Mexican
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

        // Pizza 2: Vegetarian
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

         // Pizza 3: Cheese
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

        // Pizza 4: Margarita
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
        // Fix commandinfo table to include cid if it was missed or recreate it
        // Check if column exists first to avoid duplicate column error
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

// USER METHODS

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

// UPDATE USER METHOD (for Interface 04/05)
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

// ADMIN Management Methods
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
  // Filter out users where type is explicitly 'admin'
  // Note: Depending on case sensitivity, usually 'admin'.
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
            'archive': 1 // Default active
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

// 1. Insert Command (Header)
Future<int> insertCommand(int uid, String date) async {
    print("Creating order for user $uid on $date");
    return await database.insert('command', {
        'uid': uid,
        'date': date
    });
}

// 2. Insert Command Info (Details)
Future<void> insertCommandInfo(int cid, int pid, int qte, double price) async {
    print("Adding item to order $cid: pid=$pid, qte=$qte");
    await database.insert('commandinfo', {
        'cid': cid,
        'pid': pid,
        'Qte': qte,
        'price': price
    });
}

// 3. Update Stock
Future<void> updateStock(int pid, int quantityToRemove) async {
    print("Reducing stock for pizza $pid by $quantityToRemove");
    // This is a bit unsafe without transactions but sufficient for this level
    // Better query: UPDATE pizza SET QteStock = QteStock - ? WHERE pid = ?
    await database.rawUpdate(
        'UPDATE pizza SET QteStock = QteStock - ? WHERE pid = ?',
        [quantityToRemove, pid]
    );
}

// 4. Get User Orders
Future<List<Map<String, dynamic>>> getUserOrders(int uid) async {
    print("Fetching orders for user $uid");
    // We need: cid, date, count(pizzas), total_price
    // Using a raw query with JOIN and GROUP BY
    // Note: price in commandinfo is the unit price or total item price? 
    // Usually unit price. So total is sum(price * qte).
    
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