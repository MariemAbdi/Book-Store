import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {

  //Create Tables
  static Future<void> createTables(sql.Database database) async {
    //BOOKS TABLE
    await database.execute("""CREATE TABLE BOOKS(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        genre TEXT,
        year INTEGER,
        author TEXT,
        price REAL,
        image TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);

    //CART TABLE
    await database.execute("""CREATE TABLE CART(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        book INTEGER,
        quantity INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }


  //Open Database & Create Tables
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'myDB.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create New Book
  static Future<int> createBook(String title, String? description, String? genre, int? year, String? author, double? price, String? image) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'description': description, 'genre': genre, 'year': year, 'author': author, 'price': price, 'image': image};
    final id = await db.insert('BOOKS', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //Cart Table Row Count
  static getCount()async{
    final db = await SQLHelper.db();
    return sql.Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM CART'));
  }


  // Add To Cart
  static Future<int> insertToCart(int? book, int? quantity) async {
    final db = await SQLHelper.db();

    final data = {'book': book, 'quantity': quantity};
    final id = await db.insert('CART', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read All The Books
  static Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await SQLHelper.db();
    return db.query('BOOKS', orderBy: "title");
  }

  // Read The Cart Items
  static Future<List<Map<String, dynamic>>> getCart() async {
    final db = await SQLHelper.db();
    return db.query('CART', orderBy: "id");
  }

  // Read A Single Book By Id
  static getBook(int id) async {
    final db = await SQLHelper.db();
    return db.query('BOOKS', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Read A Single Cart Item By Id
  static Future<List<Map<String, dynamic>>> getCartItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('CART', where: "book = ?", whereArgs: [id], limit: 1);
  }

  // Update A Book By Id
  static Future<int> updateBook(int id, String title, String? description, String? genre, int? year, String? author, double? price, String? image) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'genre': genre,
      'year': year,
      'author': author,
      'price': price,
      'image': image,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('BOOKS', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Update Cart Item By Id
  static Future<int> updateCart(int id, int? book, int? quantity) async {
    final db = await SQLHelper.db();

    final data = {
      'book': book,
      'quantity': quantity,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('CART', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete One Item From Cart
  static Future<void> deleteItemFromCart(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("CART", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  // Delete One Book
  static Future<void> deleteBook(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("BOOKS", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  //Delete All The Books
  static Future<void> deleteBooks() async {
    final db = await SQLHelper.db();
    try {
      await db.delete("BOOKS");
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  //Delete Everything From The Cart
  static Future<void> deleteCart() async {
    final db = await SQLHelper.db();
    try {
      await db.delete("CART");
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}