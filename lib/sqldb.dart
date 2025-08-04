import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBanimals {
  final int id;
  final String foodName;
  final String petname;
  final String toxicityLevel;
  final String symptoms;
  final String ingredient;

  const DBanimals({
    required this.id,
    required this.petname,
    required this.foodName,
    required this.toxicityLevel,
    required this.symptoms,
    required this.ingredient,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'food': foodName,
      'pet': petname,
      'Toxicity_Level': toxicityLevel,
      'Symptoms': symptoms,
      'Ingredient_Causing_Toxicity': ingredient
    };
  }

  @override
  String toString() {
    return 'DBanimals{id: $id,foodName: $foodName, pet: $petname ,Toxicity_Level: $toxicityLevel,Symptoms: $symptoms,Ingredient_Causing_Toxicity: $ingredient}';
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  final Map<String, List<DBanimals>> _cache = {};
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('animalhealth.db');
    return _database!;
  }

  Future _createDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE toxic_pet_foods (id INTEGER PRIMARY KEY AUTOINCREMENT,food TEXT NOT NULL,pet TEXT NOT NULL,Toxicity_Level TEXT NOT NULL,Symptoms TEXT NOT NULL,Ingredient_Causing_Toxicity TEXT NOT NULL)',
    );
  }

  Future<void> insertDB(DBanimals dbCursor) async {
    final db = await database;
    await db.insert(
      'toxic_pet_foods',
      dbCursor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DBanimals>> getDBData() async {
    final db = await database;
    final dogMaps = await db.query('toxic_pet_foods');
    print('Raw database content: $dogMaps');

    final List<Map<String, Object?>> dbMaps = await db.query('toxic_pet_foods');
    return dbMaps.map((dbMap) {
      return DBanimals(
        id: dbMap['id'] as int,
        petname: dbMap['pet'] as String,
        foodName: dbMap['food'] as String,
        toxicityLevel: dbMap['Toxicity_Level'] as String,
        symptoms: (dbMap['Symptoms'] as String).replaceAll('and ', ', '),
        ingredient: dbMap['Ingredient_Causing_Toxicity'] as String,
      );
    }).toList();
  }

  Future<void> updateDB(DBanimals dbCursor) async {
    final db = await database;
    await db.update('toxic_pet_foods', dbCursor.toMap(),
        where: 'id = ?', whereArgs: [dbCursor.id]);
  }

  Future<void> deleteDbElement(int id) async {
    final db = await database;
    await db.delete('toxic_pet_foods', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<DBanimals>> getDBDataByPet(String petType) async {
    // Check cache first
    if (_cache.containsKey(petType)) {
      print('Using cached data for $petType');
      return _cache[petType]!;
    }

    print('Fetching data from database for $petType');
    final db = await database;
    final List<Map<String, Object?>> dbMaps = await db.query(
      'toxic_pet_foods',
      where: 'pet = ?',
      whereArgs: [petType],
    );

    final results = dbMaps.map((dbMap) {
      return DBanimals(
        id: dbMap['id'] as int,
        petname: dbMap['pet'] as String,
        foodName: dbMap['food'] as String,
        toxicityLevel: dbMap['Toxicity_Level'] as String,
        symptoms: (dbMap['Symptoms'] as String).replaceAll('and ', ', '),
        ingredient: dbMap['Ingredient_Causing_Toxicity'] as String,
      );
    }).toList();

    // Store in cache
    _cache[petType] = results;
    return results;
  }

  // Method to clear cache if needed (e.g., after database updates)
  void clearCache() {
    _cache.clear();
    print('Cache cleared');
  }

  // Method to clear cache for a specific pet type
  void clearCacheForPet(String petType) {
    _cache.remove(petType);
    print('Cache cleared for $petType');
  }

  // Add these methods to your DatabaseHelper class

  Future<void> _createPetProfileTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS pet_profiles (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      species TEXT NOT NULL,
      breed TEXT NOT NULL,
      gender TEXT NOT NULL,
      age TEXT NOT NULL,
      weight TEXT NOT NULL,
      color TEXT NOT NULL,
      owner TEXT NOT NULL,
      adoption_date TEXT NOT NULL,
      image_url TEXT NOT NULL,
      medical_notes TEXT,
      vaccination_history TEXT,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL
    )
  ''');
  }

// Update your _initDB method to include pet profile table creation
  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    final exists = await databaseExists(path);

    if (!exists) {
      print("Database doesn't exist. Copying from assets...");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data =
          await rootBundle.load(join('assets', 'databases', dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      print("Database copied successfully");
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final db = await openDatabase(
      path,
      version: 2, // Increment version for schema update
      onCreate: (db, version) async {
        await _createDB(db, version);
        await _createPetProfileTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createPetProfileTable(db);
        }
      },
    );

    return db;
  }

// Pet Profile CRUD operations
  Future<int> insertPetProfile(PetProfile profile) async {
    final db = await database;
    return await db.insert(
      'pet_profiles',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PetProfile>> getAllPetProfiles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pet_profiles');
    return List.generate(maps.length, (i) => PetProfile.fromMap(maps[i]));
  }

  Future<PetProfile?> getPetProfile(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pet_profiles',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PetProfile.fromMap(maps.first);
    }
    return null;
  }

  Future<PetProfile?> getFirstPetProfile() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pet_profiles',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return PetProfile.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updatePetProfile(PetProfile profile) async {
    final db = await database;
    await db.update(
      'pet_profiles',
      profile.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  Future<void> deletePetProfile(int id) async {
    final db = await database;
    await db.delete(
      'pet_profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

// Add this to your DBanimals class file
class PetProfile {
  final int? id;
  final String name;
  final String species;
  final String breed;
  final String gender;
  final String age;
  final String weight;
  final String color;
  final String owner;
  final String adoptionDate;
  final String imageUrl;
  final String medicalNotes;
  final String vaccinationHistory;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PetProfile({
    this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.age,
    required this.weight,
    required this.color,
    required this.owner,
    required this.adoptionDate,
    required this.imageUrl,
    required this.medicalNotes,
    required this.vaccinationHistory,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'breed': breed,
      'gender': gender,
      'age': age,
      'weight': weight,
      'color': color,
      'owner': owner,
      'adoption_date': adoptionDate,
      'image_url': imageUrl,
      'medical_notes': medicalNotes,
      'vaccination_history': vaccinationHistory,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory PetProfile.fromMap(Map<String, dynamic> map) {
    return PetProfile(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      species: map['species'] ?? '',
      breed: map['breed'] ?? '',
      gender: map['gender'] ?? '',
      age: map['age'] ?? '',
      weight: map['weight'] ?? '',
      color: map['color'] ?? '',
      owner: map['owner'] ?? '',
      adoptionDate: map['adoption_date'] ?? '',
      imageUrl: map['image_url'] ?? '',
      medicalNotes: map['medical_notes'] ?? '',
      vaccinationHistory: map['vaccination_history'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] ?? 0),
    );
  }

  PetProfile copyWith({
    int? id,
    String? name,
    String? species,
    String? breed,
    String? gender,
    String? age,
    String? weight,
    String? color,
    String? owner,
    String? adoptionDate,
    String? imageUrl,
    String? medicalNotes,
    String? vaccinationHistory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PetProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      color: color ?? this.color,
      owner: owner ?? this.owner,
      adoptionDate: adoptionDate ?? this.adoptionDate,
      imageUrl: imageUrl ?? this.imageUrl,
      medicalNotes: medicalNotes ?? this.medicalNotes,
      vaccinationHistory: vaccinationHistory ?? this.vaccinationHistory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
