import 'package:appointment/appointmentClass.dart';
import 'package:appointment/data.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseVersion = 1;
  static final _databaseName = "apptDB";

  static final table = 'userTable';
  static final String idColumn = 'id';
  static final String nameColumn = 'userName';
  static final String passwordColumn = 'password';
  static final String emailColumn = 'email';

  static final appointmentTable = 'appointmentTable';
  static final String apptNameColumn = 'name';
  static final String apptDateColumn = 'date';
  static final String apptFromTimeColumn = 'fromTime';
  static final String apptToTimeColumn = 'toTime';
  static final String description = 'description';

  /* Future<Database> Create() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    print(path);
    Database database = await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'create table appiontment(id integer primary key,username text,password text,confirmpassword text,fromTime integer,toTime integer,date text,description text )');
      await db.execute(
          'create table userdetails(id integer primary key,name text,email text,password text)');
     },).onError((error, stackTrace) {
       print(path);
       print("database didn't created beacause ===$error");
       return Future.value();

    });


   return database;

  }*/

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database ?? await _initDatabase();
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database ?? await _initDatabase();
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<bool> insertDetails(user objDetail) async {
    final Database db = await _initDatabase();
    await db.execute(
        '''INSERT INTO $table ( $nameColumn, $passwordColumn, $emailColumn ) VALUES('${objDetail.userName}',
     '${objDetail.password}', '${objDetail.email}')''');
    print("inserted!!");
    return true;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (  
            $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
            $nameColumn TEXT NOT NULL,
            $passwordColumn TEXT NOT NULL,
            $emailColumn TEXT NOT NULL
          )
          ''');
    await db.execute(
        '''INSERT INTO $table (  $nameColumn, $passwordColumn, $emailColumn ) VALUES( 'ziya patel', ' 1234', 'ziyz@gmil.com')''');
    // Create appointment table
    await db.execute('''
          CREATE TABLE $appointmentTable (  
            $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
            $apptNameColumn TEXT NOT NULL,
            $apptDateColumn TEXT NOT NULL,
            $emailColumn TEXT NOT NULL,
            $apptFromTimeColumn TEXT NOT NULL,
            $apptToTimeColumn TEXT NOT NULL,
            $description TEXT NOT NULL
          )
          ''');

    // await db.execute('''INSERT INTO $appointmentTable ($apptNameColumn, $apptDateColumn, $emailColumn, $app ) VALUES( 'ziya patel', ' 1234', 'ziyz@gmil.com')''');
  }

  Future<bool> findUserExist(String email) async {
    final Database db = await _initDatabase();
    var result = await db
        .rawQuery('''SELECT * FROM $table where $emailColumn = ? ''', [email]);
    if (result.isEmpty) {
      print("user not exist!!!!!!");
      return false;
    } else {
      print("user exist!!!!!!");
      return true;
    }
  }

  Future login(String email, String password) async {
    final Database db = await _initDatabase();
    var result = await db.rawQuery(
        '''SELECT * FROM $table where $emailColumn = ? and $passwordColumn = ? ''',
        [email, password]);
    if (result.length > 0) {
      print("user exist login successfully!!!!!!");
      return new user.fromJson(result.first);
    }
    return null;
  }

  Future<bool> insertAppointment(appointment objDetail) async {
    final Database db = await _initDatabase();
    await db.execute(
        '''INSERT INTO $appointmentTable ( $idColumn, $apptNameColumn, $apptDateColumn, $emailColumn, $apptFromTimeColumn, $apptToTimeColumn, $description ) VALUES(${objDetail.id},'${objDetail.name}','${objDetail.date}', '${objDetail.email}', 
            '${objDetail.fromTime}', '${objDetail.toTime}', '${objDetail.description}')''');
    print("Appointment inserted!!");
    return true;
  }

  Future<List<appointment>> queryAllRows() async {
    final Database db = await _initDatabase();
    DateTime now = new DateTime.now();
    var formatter = new DateFormat('yyyy-M-dd');
    String formattedDate = formatter.format(now);
   // print("date---------------------------$formattedDate");


    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'select * from $appointmentTable where $apptDateColumn <= ?',
        [formattedDate]);
    return List.generate(maps.length, (i) {
      //print(i);
      return appointment(
        //id: maps[i]['id'],
        name: maps[i]['name'],
        date: maps[i]['date'],
        email: maps[i]['email'],
        fromTime: maps[i]['fromTime'],
        toTime: maps[i]['toTime'],
        description: maps[i]['description'],
      );
    });
  }

  //order by
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = DatabaseHelper._database!;
    return db.query('appointmentTable', orderBy: "date");
  }

  Future<List> dateselect(String date) async {
    final Database db = await _initDatabase();
    List list1 = await db.rawQuery("SELECT * FROM $appointmentTable where $apptDateColumn = $date");
    print('${date}');
    return list1;
  }
}
