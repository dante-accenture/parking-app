import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../model/db_model.dart';
import '../pages/error.dart';

// crea la connessione al database
Future<MySqlConnection> getDBConn() async {
  var settings = ConnectionSettings(
    host: 'sql7.freesqldatabase.com',
    port: 3306,
    user: 'sql7599760',
    password: '2ShBY1PEuA',
    db: 'sql7599760',
  );
  try {
    var conn = await MySqlConnection.connect(settings);
    return conn;
  } on SocketException {
    navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => ErrorPage(
            message: "Le impostazioni del database non sono corrette.")));
    return await MySqlConnection.connect(settings);
  }
}

// inserisce una targa con la data di entrata
Future<void> inserTarga(String targa, String dataEntrata,
    [String? dataUscita]) async {
  var conn = await getDBConn();

  await conn.query(
      'INSERT INTO targhe (targa, dataEntrata, dataUscita) values (?, ?, ?)',
      [targa, dataEntrata, dataUscita]);
  await conn.close();
}

// elimina una targa tramite l'ID
Future<void> deleteTarga(int id) async {
  var conn = await getDBConn();

  await conn.query('DELETE FROM targhe WHERE id=?', [id]);
  await conn.close();
}

// aggiorna la data di uscita di una targa dato l'ID
Future<void> updateTarga(int id, String dataUscita) async {
  var conn = await getDBConn();

  await conn
      .query('UPDATE targhe SET dataUscita=? where id=?', [dataUscita, id]);
  await conn.close();
}

// aggiorna una targa completamente
Future<void> updateFullTarga(
    {required int id,
    String? dataUscita,
    required String dataEntrata,
    required String targa}) async {
  var conn = await getDBConn();

  await conn.query(
      'UPDATE targhe SET targa=?, dataEntrata=?, dataUscita=? where id=?',
      [targa, dataEntrata, dataUscita, id]);
  await conn.close();
}

// ritorna tutte le targhe dal database
Future<List<TargaModel>> getTarghe() async {
  var conn = await getDBConn();
  List<TargaModel> list = [];

  var results = await conn.query('SELECT * FROM targhe');

  for (var row in results) {
    String targa = row[1].toString();
    String dataUscita = row[3].toString();
    String dataEntrata = row[2].toString();
    int id = row[0];

    list.add(TargaModel(
        targa: targa,
        dataEntrata: dataEntrata,
        dataUscita: dataUscita,
        id: id));
  }
  await conn.close();

  return list;
}

// controlla se una trga è gia uscita
Future<void> checkTarga(String targaDaControllare) async {
  var conn = await getDBConn();
  DateTime now = DateTime.now();
  String actualDate =
      "${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}:${now.second}";

  // ritorna righe con quella targa
  var results = await conn
      .query('SELECT * FROM targhe WHERE targa=?', [targaDaControllare]);
  bool lastIsFilled = false;

  if (results.isNotEmpty) {
    debugPrint("Targhe trovate");
    // per ogni targa trovata
    for (var row in results) {
      String targa = row[1].toString();
      String dataUscita = row[3].toString();
      int id = row[0];

      // controlla se la targa corrisponde e la data di uscita è gia settata
      if (targa.toUpperCase() == targaDaControllare.toUpperCase() &&
          dataUscita != "null") {
        debugPrint("targa Gia esistente e riempita");
        // non fare nulla
        lastIsFilled = true;
      } else
      // targa corrisponde e la data di uscita non è settata
      if (targa.toUpperCase() == targaDaControllare.toUpperCase() &&
          dataUscita == "null") {
        // aggiorna la targa
        await updateTarga(id, actualDate);
        debugPrint("targa aggiornata");
        lastIsFilled = false;
        return;
      }
    }
    // non sono presenti date da aggiornare
    if (lastIsFilled == true) {
      await inserTarga(targaDaControllare.toUpperCase(), actualDate);
      debugPrint("targa inserita");
    }
  } else {
    // nessuna targa trovata, inserisce la targa
    await inserTarga(targaDaControllare.toUpperCase(), actualDate);
  }
  await conn.close();
}
