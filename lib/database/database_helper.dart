import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/modelUser.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE users (
        user_id $idType,
        user_name $textType,
        user_display_name $textType,
        user_email $textType,
        user_contact $textType
      )
    ''');
  }

  // Insert a user into the database
  Future<int> insertUser(ModelUser user) async {
    final db = await instance.database;

    return await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Retrieve all users from the database
  Future<List<ModelUser>> getAllUsers() async {
    final db = await instance.database;
    final maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return ModelUser.fromMap(maps[i]);
    });
  }

  // Retrieve a user by user ID
  Future<ModelUser?> getUserById(int userId) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return ModelUser.fromMap(maps.first);
    }
    return null;
  }

  // Retrieve a user by email
  Future<ModelUser?> getUserByEmail(String email) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'user_email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return ModelUser.fromMap(maps.first);
    }
    return null;
  }

  // Check if the users table is empty
  Future<bool> isUsersTableEmpty() async {
    final db = await instance.database;
    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM users'));
    return count == 0;
  }

  // Clear all data from the users table
  Future<void> clearUsersTable() async {
    final db = await instance.database;
    await db.delete('users');
  }

  // Close the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
