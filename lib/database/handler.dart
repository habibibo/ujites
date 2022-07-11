import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ujites/model/profile.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'ujites.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE profiles(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL,address TEXT NOT NULL, birth TEXT NOT NULL, height INTEGER NOT NULL, weight INTEGER NOT NULL, photo TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  DatabaseHandler._privateConstructor();
  static final DatabaseHandler instance = DatabaseHandler._privateConstructor();

  Future<int> insertProfile(inputUser) async {
    int result = 0;
    final Database db = await initializeDB();
    return await db.insert("profiles", inputUser);
  }

  Future<List<Profile>> getProfiles() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('profiles');
    return queryResult.map((e) => Profile.fromMap(e)).toList();
  }

  Future<dynamic> getProfilesId(id) async {
    final Database db = await initializeDB();
    var queryResult = await db.rawQuery("SELECT * FROM profiles where id = $id limit 1");
    return queryResult.toList();
  }

  Future<dynamic> updateProfile(id,updateUser) async {
    final Database db = await initializeDB();
    String getname = updateUser['name'].toString();
    String getaddress = updateUser['address'].toString();
    String getbirth = updateUser['birth'].toString();
    int getheight = updateUser['height'];
    int getweight = updateUser['weight'];
    String getphoto = updateUser['photo'].toString();
    
    if(getphoto == "-"){
      var queryResult = await db.rawUpdate("update profiles set name = ? , address = ? , birth = ? , height = ? , weight = ? where id = ?",[getname,getaddress,getbirth,getheight,getweight,id]);
    }else{
      var queryResult = await db.rawUpdate("update profiles set name = ? , address = ? , birth = ? , height = ? , weight = ? , photo = ? where id = ?",[getname,getaddress,getbirth,getheight,getweight,getphoto,id]);
    }
  }

  Future<void> deleteProfile(int id) async {
    final db = await initializeDB();
    await db.delete(
      'profiles',
      where: "id = ?",
      whereArgs: [id],
    );
  }

}