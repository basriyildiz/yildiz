import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:yildiz_metal/models/maliyet.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String _maliyetTablo = "maliyet";
  String _columnID = "id";
  String _columnMalzemeAdlari = "malzeme_adi";
  String _columnKgBrut = "kg_brut";
  String _columnKgFiyat = "kg_fiyat";
  String _columnFireOrani = "fire_orani";
  String _columnKgNet = "kg_net";
  String _columnToplamTutar = "toplam_tutar";
  String _columnIscilikMaliyeti = "iscilik";
  String _columnKgToplam = "kg_toplam";
  String _columnOrtFire = "ort_fire";
  String _columnTutarToplami = "tutar_toplami";
  String _columnNetMamul = "net_mamul";

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
    String dbPath = join(kloser.path, "maliyet_verileri.db");
    print("Db pathi : $dbPath");

    var maliyetDB = openDatabase(dbPath, version: 1, onCreate: _createDB);
    return maliyetDB;
  }

  FutureOr<void> _createDB(Database db, int version) async {
    print("Create DB çalıştı");

    await db.execute(
        "CREATE TABLE $_maliyetTablo ($_columnID INTEGER PRIMARY KEY AUTOINCREMENT, $_columnMalzemeAdlari TEXT, $_columnKgBrut DOUBLE,$_columnKgFiyat, DOUBLE, $_columnFireOrani DOUBLE, $_columnKgNet DOUBLE, $_columnToplamTutar DOUBLE, $_columnIscilikMaliyeti DOUBLE, $_columnKgToplam DOUBLE, $_columnOrtFire DOUBLE, $_columnTutarToplami DOUBLE, $_columnNetMamul DOUBLE )");
  }

  Future<int> maliyetEkle(Maliyet maliyet) async {
    var db = await _getDatabase();
    var sonuc = await db.insert(
        _maliyetTablo, maliyet.dbyeYazmakIcinMapeDonustur(),
        nullColumnHack: "$_columnID");
    return sonuc;
  }

  Future<List> tumMaliyetler() async {
    var db = await _getDatabase();
    var sonuc = await db.query(_maliyetTablo, orderBy: "$_columnID ASC");
    return sonuc;
  }

  Future<int> maliyetiGuncelle(Maliyet maliyet) async {
    var db = await _getDatabase();
    var sonuc = await db.update(
      _maliyetTablo,
      maliyet.dbyeYazmakIcinMapeDonustur(),
      where: "$_columnID = ?",
      whereArgs: [maliyet.id],
    );
    return sonuc;
  }

  Future<int> maliyetSil(int id) async {
    var db = await _getDatabase();
    var sonuc = await db.delete(
      _maliyetTablo,
      where: "$_columnID = ?",
      whereArgs: [id],
    );
    return sonuc;
  }

  Future<int> tumMaliyetTablosunuSil() async {
    var db = await _getDatabase();
    var sonuc = await db.delete(_maliyetTablo);
    return sonuc;
  }
}
