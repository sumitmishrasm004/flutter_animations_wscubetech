 import 'dart:io';

import 'package:flutter_animations/note_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class AppDataBase{
  // for singleton data classes
 AppDataBase._();

 static final AppDataBase db = AppDataBase._();

  Database? _database;
  static final NOTE_TABLE = 'note';
  static final NOTE_COLUMN_ID = 'note_id';
  static final NOTE_COLUMN_TITLE = 'title';
  static final NOTE_COLUMN_DESC = 'desc';

  Future<Database> getDB() async{
    if(_database != null){
      return _database!;
    } else {
      return await initDB();
    }
  }

 Future<Database> initDB() async{
  Directory documentDirectory = await getApplicationDocumentsDirectory();
  var dbPath = join(documentDirectory.path,'noteDb.db');

  return openDatabase(
    dbPath,
    version: 1,
    onCreate: (db,version){
      // Create Table here
      db.execute("Create table $NOTE_TABLE ( $NOTE_COLUMN_ID integer primary key autoincrement, $NOTE_COLUMN_TITLE text, $NOTE_COLUMN_DESC text )");
    }
    );
 }

 Future<bool> addNote(NoteModel noteModel) async{
  var db = await getDB();
  int rowsEffect = await db.insert(NOTE_TABLE, noteModel.toMap());
  return rowsEffect > 0;
 }

 Future<List<NoteModel>> fetchAllNotes()async {
  var db = await getDB();
  List<Map<String,dynamic>> notes = await db.query(NOTE_TABLE);
  List<NoteModel> noteModel = notes.map((note) => NoteModel.fromMap(note)).toList();
  return noteModel;
 }

 Future<bool> updateNote(NoteModel noteModel) async{
  var db = await getDB();
  int count = await db.update(AppDataBase.NOTE_TABLE, noteModel.toMap(),where: '$NOTE_COLUMN_ID = ${noteModel.note_id}');
  return count > 0;
 }

 Future<bool> deleteNote(int id) async{
  var db = await getDB();
  int count = await db.delete(NOTE_TABLE, where: '$NOTE_COLUMN_ID = ?', whereArgs: ['$id']);
  return count > 0;
 }

}