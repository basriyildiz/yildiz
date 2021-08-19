import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:yildiz_metal/models/analiz.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String _analizTablo = "analiz";
  String _columnID = "id";
  String _columnMalzemeAdlari = "malzeme_adi";
  String _columnKgler = "kgler";
  String _columnAlasimlar = "alasimlar";
  String _columnKgToplam = "kg_toplam";
  String _columnAnalizOrani = "analiz_orani";

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      print("null oluştu if");
      return _databaseHelper!;
    } else {
      print("null değil else");
      return _databaseHelper!;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      print("Getdatabse if'e girdi database = null");
      _database = await _initializeDatabase();
      return _database!;
    } else {
      print("Getdatabse else girdi database null değil");
      return _database!;
    }
  }

  _initializeDatabase() async {
    Directory kloser = await getApplicationDocumentsDirectory();
    String dbPath = join(kloser.path, "analiz_verileri.db");
    print("Db pathi : $dbPath");

    var analizDB = openDatabase(dbPath, version: 1, onCreate: _createDB);
    return analizDB;
  }

  FutureOr<void> _createDB(Database db, int version) async {
    print("Create DB çalıştı");

    await db.execute(
        "CREATE TABLE $_analizTablo ($_columnID INTEGER PRIMARY KEY AUTOINCREMENT, $_columnMalzemeAdlari TEXT, $_columnKgler DOUBLE,$_columnAlasimlar DOUBLE, $_columnKgToplam DOUBLE, $_columnAnalizOrani DOUBLE )");
  }

  Future<int> analizEkle(Analiz analiz) async {
    var db = await _getDatabase();
    var sonuc = await db.insert(
        _analizTablo, analiz.dbyeYazmakIcinMapeDonustur(),
        nullColumnHack: "$_columnID");
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> tumAnalizler() async {
    var db = await _getDatabase();
    var sonuc = await db.query(_analizTablo, orderBy: "$_columnID ASC");
    return sonuc;
  }

  Future<int> analiziGuncelle(Analiz analiz) async {
    var db = await _getDatabase();
    var sonuc = await db.update(
      _analizTablo,
      analiz.dbyeYazmakIcinMapeDonustur(),
      where: "$_columnID = ?",
      whereArgs: [analiz.id],
    );
    return sonuc;
  }

  Future<int> analizSil(int id) async {
    var db = await _getDatabase();
    var sonuc = await db.delete(
      _analizTablo,
      where: "$_columnID = ?",
      whereArgs: [id],
    );
    return sonuc;
  }

  Future<int> tumAnalizTablosunuSil() async {
    var db = await _getDatabase();
    var sonuc = await db.delete(_analizTablo);
    return sonuc;
  }
}
