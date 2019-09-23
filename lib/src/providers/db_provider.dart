import 'dart:io';

import 'package:flutter_lector_qr/src/models/scan_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDB();

      return _database;
    }
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Scans('
            'id INTEGER PRIMARY KEY,'
            'tipo TEXT,'
            'valor TEXT'
            ')');
      },
    );
  }

  //CREAR REGISTROS RAW
  nuevoScanRaw(ScanModel nuevoScan) async {
    final db = await database;

    final res = await db.rawInsert(
        "INSERT INTO Scans(id,tipo,valor) VALUES(${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.valor}')");

    return res;
  }

  //CREAR REGISTROS JSON
  nuevoScan(ScanModel nuevoScan) async {
    final db = await database;

    final res = await db.insert('Scans', nuevoScan.toJson());
  print("esto vale res: "+res.toString());
    return res;
  }

  //SELECT - Obtener informacion
  Future<ScanModel> getScanId(int id) async {
    final db = await database;

    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  //SELECT - Obtener todos
  Future<List<ScanModel>> getAllScans() async {
    final db = await database;

    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty
        ? res.map((elemento) => ScanModel.fromJson(elemento)).toList()
        : [];

    return list;
  }

  //SELECT - Obtener por tipo 

  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;

    final res = await db.rawQuery("SELECT * from Scans WHERE tipo = '$tipo'");

    List<ScanModel> list = res.isNotEmpty
        ? res.map((elemento) => ScanModel.fromJson(elemento)).toList()
        : [];

    return list;
  }

  //ACTULIZAR REGISTROS
  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;

    final res = await db.update('Scans', nuevoScan.toJson());

    return res;
  }
  
    //ELIMINAR REGISTROS
  Future<int> deleteScan(int id) async {
    final db = await database;

    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res;
  }

      //ELIMINAR REGISTROS
  Future<int> deleteAll() async {
    final db = await database;

    final res = await db.rawDelete('DELETE FROM Scans');

    return res;
  }

}
