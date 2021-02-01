import 'dart:async';

import 'package:digimobile/models/db_model.dart';
import 'package:digimobile/models/mask_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBService {

  // Singleton
  DBService._();
  static final DBService db = DBService._();

  // Database
  final String _databaseName = 'stream_database.db';

  // Masks records
  final String masksTableName = 'masks';
  final String masksFieldmaskID = 'mask_id';
  final String masksFieldtype = 'type';
  final String masksFieldremainingTime = 'remaining_time';
  final String masksFieldwashingCounter = 'washing_counter';

  // Orders records
  final String ordersTableName = 'orders';
  final String ordersFieldorderID = 'order_id';
  final String ordersFielddate = 'date';
  final String ordersFieldnumberOfChirurgical = 'number_chirurgical';
  final String ordersFieldnumberOfReusable = 'number_reusable';

  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE $masksTableName("
              "$masksFieldmaskID INTEGER PRIMARY KEY AUTOINCREMENT, "
              "$masksFieldtype TEXT, "
              "$masksFieldremainingTime INTEGER, "
              "$masksFieldwashingCounter INTEGER)",
        );
        db.execute(
          "CREATE TABLE $ordersTableName("
              "$ordersFieldorderID INTEGER PRIMARY KEY AUTOINCREMENT, "
              "$ordersFielddate TEXT, "
              "$ordersFieldnumberOfChirurgical INTEGER, "
              "$ordersFieldnumberOfReusable INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<void> insert(DBModel genericObject, String tableName) async {
    final Database database = await _getDatabase();
    await database.insert(
      tableName,
      genericObject.toDB(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(DBModel genericObject, String tableName) async {
    final Database database = await _getDatabase();
    await database.update(
      tableName,
      genericObject.toDB(),
      where: "${genericObject.getIDFieldName()} = ?",
      whereArgs: [genericObject.getID()],
    );
  }

  Future<Mask> retrieveMaskSpecific(String id) async {

    final Database database = await _getDatabase();

    List<String> columnsToSelect = [
      this.masksFieldmaskID,
      this.masksFieldtype,
      this.masksFieldremainingTime,
      this.masksFieldwashingCounter
    ];
    String whereString = '${this.masksFieldmaskID} = ?';
    List<dynamic> whereArguments = [id];
    List<Map> result = await database.query(
        this.masksTableName,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);

    if (result.isNotEmpty){
      // Get the unique result
      var row = result[0];
      return Mask.fromDB(
          id: row[this.masksFieldmaskID],
          type: row[this.masksFieldtype],
          remainingTime: row[this.masksFieldremainingTime],
          washingCounter: row[this.masksFieldwashingCounter]);
    } else {
      return null;
    }
  }
}