import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'plant_database.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE plant (
            plantID INTEGER PRIMARY KEY,
            plantName TEXT,
            plantScientific TEXT,
            plantImage TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE plantComponent (
            componetID INTEGER PRIMARY KEY,
            componentName TEXT,
            componentIcon TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE LandUse (
            LandUseID INTEGER PRIMARY KEY,
            plantID INTEGER,
            componetID INTEGER,
            LandUseTypeName TEXT,
            LandUseDescription TEXT,
            FOREIGN KEY (plantID) REFERENCES plant(plantID),
            FOREIGN KEY (componetID) REFERENCES plantComponent(componetID)
          )
        ''');
        await _insertInitialData(db);
      },
      version: 1,
    );
  }

  Future<void> _insertInitialData(Database db) async {
    // Sample plant data
    await db.insert('plant', {
      'plantID': 101001,
      'plantName': 'Mango',
      'plantScientific': 'Mangifera indica',
      'plantImage': 'assets/images/mango.jpeg',
    });

    await db.insert('plant', {
      'plantID': 101002,
      'plantName': 'Neem',
      'plantScientific': 'Azadirachta indica',
      'plantImage': 'assets/images/neem.jpg',
    });

    // Sample components and land use data
    await db.insert('plantComponent', {
      'componetID': 122001,
      'componentName': 'Leaf',
      'componentIcon': 'assets/icons/leaf_icon.png',
    });

    await db.insert('LandUse', {
      'LandUseID': 301001,
      'plantID': 101001,
      'componetID': 122001,
      'LandUseTypeName': 'Food',
      'LandUseDescription': 'Mango is consumed as fruit.',
    });
  }

  Future<List<Map<String, dynamic>>> getPlants() async {
    return await _database!.query('plant');
  }

  Future<Map<String, dynamic>> getPlantById(int plantId) async {
  if (_database == null) {
    await initDatabase();
  }

  // ทำการ query ข้อมูลเมื่อฐานข้อมูลพร้อมแล้ว
  final result = await _database!.query(
    'plant',
    where: 'plantID = ?',
    whereArgs: [plantId],
  );

  return result.first;
}

  Future<List<Map<String, dynamic>>> getComponentsByPlantId(int plantId) async {
    return await _database!.query(
      'plantComponent',
      where: 'componetID IN (SELECT componetID FROM LandUse WHERE plantID = ?)',
      whereArgs: [plantId],
    );
  }

  Future<List<Map<String, dynamic>>> getLandUsesByPlantId(int plantId) async {
    return await _database!.query(
      'LandUse',
      where: 'plantID = ?',
      whereArgs: [plantId],
    );
  }
}
