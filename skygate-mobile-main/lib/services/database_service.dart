import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Local SQLite storage.
///
/// Opens databases lazily under the application documents directory and caches
/// them by file name, so several tables can share one connection. Table
/// creation stays with the caller through [onCreate]: the service owns the
/// connection, features own their schema.
///
/// ```dart
/// await DatabaseService.instance.open(
///   name: 'classes.db',
///   onCreate: (db, version) => db.execute('CREATE TABLE classes(...)'),
/// );
/// await DatabaseService.instance.insert('classes.db', 'classes', row);
/// ```
class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  final Map<String, Database> _databases = <String, Database>{};

  /// Opens (or returns the already open) database file [name].
  ///
  /// [onCreate] runs once, when the file is first created; [onUpgrade] runs
  /// when [version] is raised above the stored one.
  Future<Database> open({
    required String name,
    int version = 1,
    FutureOr<void> Function(Database db, int version)? onCreate,
    FutureOr<void> Function(Database db, int oldVersion, int newVersion)?
        onUpgrade,
  }) async {
    final existing = _databases[name];
    if (existing != null && existing.isOpen) return existing;

    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, name);

    final database = await openDatabase(
      path,
      version: version,
      onCreate: onCreate == null ? null : (db, v) async => onCreate(db, v),
      onUpgrade: onUpgrade == null
          ? null
          : (db, oldVersion, newVersion) async =>
              onUpgrade(db, oldVersion, newVersion),
    );

    return _databases[name] = database;
  }

  /// The open connection for [name].
  ///
  /// Throws [StateError] when [open] has not been awaited for that file yet.
  Database db(String name) {
    final database = _databases[name];
    if (database == null) {
      throw StateError(
        'Database "$name" is not open. Call DatabaseService.instance.open() first.',
      );
    }
    return database;
  }

  Future<int> insert(
    String name,
    String table,
    Map<String, Object?> values, {
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace,
  }) {
    return db(name).insert(table, values, conflictAlgorithm: conflictAlgorithm);
  }

  /// Inserts [rows] in a single transaction.
  Future<void> insertAll(
    String name,
    String table,
    List<Map<String, Object?>> rows, {
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace,
  }) async {
    final database = db(name);
    await database.transaction((txn) async {
      final batch = txn.batch();
      for (final row in rows) {
        batch.insert(table, row, conflictAlgorithm: conflictAlgorithm);
      }
      await batch.commit(noResult: true);
    });
  }

  Future<List<Map<String, Object?>>> query(
    String name,
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) {
    return db(name).query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// Queries [table] and maps every row through [mapper].
  Future<List<T>> queryAs<T>(
    String name,
    String table,
    T Function(Map<String, Object?> row) mapper, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    final rows = await query(
      name,
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
    return rows.map(mapper).toList();
  }

  Future<int> update(
    String name,
    String table,
    Map<String, Object?> values, {
    required String where,
    required List<Object?> whereArgs,
  }) {
    return db(name).update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String name,
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) {
    return db(name).delete(table, where: where, whereArgs: whereArgs);
  }

  /// Deletes every row of [table] without dropping it.
  Future<int> clearTable(String name, String table) =>
      db(name).delete(table);

  Future<List<Map<String, Object?>>> rawQuery(
    String name,
    String sql, [
    List<Object?>? arguments,
  ]) {
    return db(name).rawQuery(sql, arguments);
  }

  Future<void> execute(String name, String sql, [List<Object?>? arguments]) =>
      db(name).execute(sql, arguments);

  Future<void> close(String name) async {
    await _databases.remove(name)?.close();
  }

  Future<void> closeAll() async {
    for (final database in _databases.values) {
      await database.close();
    }
    _databases.clear();
  }

  /// Closes and deletes the database file. Used on logout / full reset.
  Future<void> deleteDatabaseFile(String name) async {
    await close(name);
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, name);
    if (io.File(path).existsSync()) {
      await deleteDatabase(path);
    }
  }
}
