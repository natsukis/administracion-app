import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:administracion/model/product.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();

  String tblSales = "sales";
  String colId = "id";
  String colArticle = "article";
  String colDescription = "description";
  String colPrice = "price";
  String colDate = "date";
  String colQuantity = "quantity";
  String colMethod = "method";

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "administration.db";
    var dbExpenses = await openDatabase(path, version: 1, onCreate: _create);
    return dbExpenses;
  }

  void _create(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblSales($colId INTEGER PRIMARY KEY, $colArticle TEXT, " +
            "$colDescription TEXT, $colPrice INTEGER, $colQuantity INTEGER, $colDate TEXT, $colMethod TEXT)");
  }

  Future<int> insertProduct(Product product) async {
    Database db = await this.db;
    var result = await db.insert(tblSales, product.toMap());
    return result;
  }

  Future<List> getProduct() async {
    Database db = await this.db;
    var result =
        await db.rawQuery("SELECT * FROM $tblSales order by $colArticle ASC");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("Select count (*) from $tblSales"));
    return result;
  }

  Future<int> updateProduct(Product product) async {
    Database db = await this.db;
    var result = await db.update(tblSales, product.toMap(),
        where: "$colId = ?", whereArgs: [product.id]);
    return result;
  }

  Future<int> deleteProduct(int id) async {
    int result;
    Database db = await this.db;
    result = await db.rawDelete('DELETE FROM $tblSales WHERE $colId = $id');
    return result;
  }
}
