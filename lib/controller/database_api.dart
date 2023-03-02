import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../model/db_model.dart';
import '../pages/error.dart';

String baseUrl = "https://apidbpark.iceiy.com";

// inserisce una targa con la data di entrata
Future<void> inserTargaApi(String targa, String dataEntrata,
    [String? dataUscita]) async {
  late http.Response response;
  if (dataUscita == null) {
    response = await http.post(
      Uri.parse('$baseUrl/insert.php'),
      body: {
        "targa": targa,
        "dataEntrata": dataEntrata,
      },
    );
  } else {
    response = await http.post(
      Uri.parse('$baseUrl/insert.php'),
      body: {
        "targa": targa,
        "dataEntrata": dataEntrata,
        "dataUscita": dataUscita,
      },
    );
  }

  if (response.statusCode != 200) {
    navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) =>
            ErrorPage(message: "Errore nell inserire la targa")));
  }
}

// elimina una targa tramite l'ID
Future<void> deleteTargaApi(int id) async {
  http.Response response = await http.post(
    Uri.parse('$baseUrl/delete.php'),
    body: {
      "id": "$id",
    },
  );

  if (response.statusCode != 200) {
    navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) =>
            ErrorPage(message: "Errore nell inserire la targa")));
  }
}

// aggiorna la data di uscita di una targa dato l'ID
Future<void> updateTargaApi(int id, String dataUscita) async {
  http.Response response = await http.post(
    Uri.parse('$baseUrl/update-uscita.php'),
    body: {
      "id": "$id",
      "dataUscita": dataUscita,
    },
  );

  if (response.statusCode != 200) {
    navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) =>
            ErrorPage(message: "Errore nell inserire la targa")));
  }
}

// aggiorna una targa completamente
Future<void> updateFullTargaApi(
    {required int id,
    String? dataUscita,
    required String dataEntrata,
    required String targa}) async {
  http.Response response;

  if (dataUscita == null) {
    response = await http.post(
      Uri.parse('$baseUrl/update.php'),
      body: {
        "id": "$id",
        "targa": targa,
        "dataEntrata": dataEntrata,
      },
    );
  } else {
    response = await http.post(
      Uri.parse('$baseUrl/update.php'),
      body: {
        "id": "$id",
        "targa": targa,
        "dataEntrata": dataEntrata,
        "dataUscita": dataUscita,
      },
    );
  }

  if (response.statusCode != 200) {
    navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) =>
            ErrorPage(message: "Errore nell inserire la targa")));
  }
}

// ritorna tutte le targhe dal database
Future<List<TargaModel>> getTargheApi() async {
  List<TargaModel> list = [];

  http.Response response = await http.post(
    Uri.parse('$baseUrl/read.php'),
  );

  if (response.statusCode != 200) {
    navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) =>
            ErrorPage(message: "Errore nell inserire la targa")));
  }

  List<dynamic> results = jsonDecode(response.body);

  for (Map<String, dynamic> row in results) {
    TargaModel targa = TargaModel(
      targa: row["targa"],
      dataEntrata: row["dataEntrata"],
      id: row["id"],
      dataUscita: row["dataUscita"] ?? "null",
    );
    list.add(targa);
  }

  return list;
}

// ritorna tutte le righe con la targa data dal database
Future<List<TargaModel>> getOnlyTargheApi(String targa) async {
  List<TargaModel> list = [];

  http.Response response = await http.post(
    Uri.parse('$baseUrl/get-targhe.php'),
    body: {
      "targa": targa,
    },
  );

  List<dynamic> results = jsonDecode(response.body);

  for (Map<String, dynamic> row in results) {
    TargaModel targa = TargaModel(
      targa: row["targa"],
      dataEntrata: row["dataEntrata"],
      id: row["id"],
      dataUscita: row["dataUscita"] ?? "null",
    );
    list.add(targa);
  }

  return list;
}

// controlla se una trga è gia uscita
Future<void> checkTargaApi(String targaDaControllare) async {
  DateTime now = DateTime.now();
  String actualDate =
      "${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}:${now.second}";

  // ritorna righe con quella targa
  var results = await getOnlyTargheApi(targaDaControllare);
  bool lastIsFilled = false;

  if (results.isNotEmpty) {
    debugPrint("Targhe trovate");
    // per ogni targa trovata
    for (var row in results) {
      String targa = row.targa;
      String? dataUscita = row.dataUscita;
      int id = row.id;

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
        await updateTargaApi(id, actualDate);
        debugPrint("targa aggiornata");
        lastIsFilled = false;
        return;
      }
    }
    // non sono presenti date da aggiornare
    if (lastIsFilled == true) {
      await inserTargaApi(targaDaControllare.toUpperCase(), actualDate);
      debugPrint("targa inserita");
    }
  } else {
    // nessuna targa trovata, inserisce la targa
    await inserTargaApi(targaDaControllare.toUpperCase(), actualDate);
  }
}
