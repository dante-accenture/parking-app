import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../model/db_model.dart';
import '../pages/error.dart';

String baseUrl = "https://apidbpark.000webhostapp.com/api";

// inserisce una targa con la data di entrata
Future<void> inserTargaApi(String targa, String dataEntrata,
    [String? dataUscita]) async {
  late http.Response response;
  if (dataUscita == null) {
    response = await http.post(
      Uri.parse('$baseUrl/insert.php'),
      headers: {"Access-Control-Allow-Origin": "*"},
      body: {
        "targa": targa,
        "dataEntrata": dataEntrata,
      },
    ).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        return http.Response('TimeOut', 408);
      },
    );
  } else {
    response = await http.post(
      Uri.parse('$baseUrl/insert.php'),
      headers: {"Access-Control-Allow-Origin": "*"},
      body: {
        "targa": targa,
        "dataEntrata": dataEntrata,
        "dataUscita": dataUscita,
      },
    ).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        return http.Response('TimeOut', 408);
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
    headers: {"Access-Control-Allow-Origin": "*"},
    body: {
      "id": "$id",
    },
  ).timeout(
    const Duration(seconds: 3),
    onTimeout: () {
      return http.Response('TimeOut', 408);
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
    headers: {"Access-Control-Allow-Origin": "*"},
    body: {
      "id": "$id",
      "dataUscita": dataUscita,
    },
  ).timeout(
    const Duration(seconds: 3),
    onTimeout: () {
      return http.Response('TimeOut', 408);
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
    required String ticket,
    required String targa}) async {
  http.Response response;

  if (dataUscita == null) {
    response = await http.post(
      Uri.parse('$baseUrl/update.php'),
      headers: {"Access-Control-Allow-Origin": "*"},
      body: {
        "id": "$id",
        "targa": targa,
        "dataEntrata": dataEntrata,
        "ticket": ticket,
      },
    ).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        return http.Response('TimeOut', 408);
      },
    );
  } else {
    response = await http.post(
      Uri.parse('$baseUrl/update.php'),
      headers: {"Access-Control-Allow-Origin": "*"},
      body: {
        "id": "$id",
        "targa": targa,
        "dataEntrata": dataEntrata,
        "dataUscita": dataUscita,
        "ticket": ticket,
      },
    ).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        return http.Response('TimeOut', 408);
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
    headers: {"Access-Control-Allow-Origin": "*"},
  ).timeout(
    const Duration(seconds: 3),
    onTimeout: () {
      return http.Response('TimeOut', 408);
    },
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
      ticket: row["ticket"] ?? "null",
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
    headers: {
      "Access-Control-Allow-Origin": "*",
      "user-agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
    },
    body: {
      "targa": targa,
    },
  ).timeout(
    const Duration(seconds: 3),
    onTimeout: () {
      return http.Response('TimeOut', 408);
    },
  );

  List<dynamic> results = jsonDecode(response.body);

  for (Map<String, dynamic> row in results) {
    TargaModel targa = TargaModel(
      targa: row["targa"],
      dataEntrata: row["dataEntrata"],
      id: row["id"],
      dataUscita: row["dataUscita"] ?? "null",
      ticket: row["ticket"] ?? "null",
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

// ottieni tutte le targhr con lo stesso ticket
Future<List<TargaModel>> getOnlyTicketApi(String ticket) async {
  List<TargaModel> list = [];

  http.Response response = await http.post(
    Uri.parse('$baseUrl/get-ticket.php'),
    headers: {
      "Access-Control-Allow-Origin": "*",
      "user-agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
    },
    body: {
      "ticket": ticket,
    },
  ).timeout(
    const Duration(seconds: 3),
    onTimeout: () {
      return http.Response('TimeOut', 408);
    },
  );

  print(response.statusCode);

  if (response.statusCode != 200) {
    navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) =>
            ErrorPage(message: "Errore nell controllare il ticket")));
  }

  List<dynamic> results = jsonDecode(response.body);

  for (Map<String, dynamic> row in results) {
    TargaModel targa = TargaModel(
      targa: row["targa"],
      dataEntrata: row["dataEntrata"],
      id: row["id"],
      dataUscita: row["dataUscita"] ?? "null",
      ticket: row["ticket"] ?? "null",
    );
    list.add(targa);
  }

  return list;
}

// inserisci una targa associata al ticket
Future<void> insertAPIticket(String targa, String ticket) async {
  DateTime now = DateTime.now();
  String actualDate =
      "${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}:${now.second}";

  var results = await getOnlyTicketApi(ticket);

  // ticket gia esistente
  if (results.isNotEmpty) {
    navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) =>
            ErrorPage(message: "Il ticket è gia esistente!")));
  } else {
    // inserisci targa con ticket
    http.Response response = await http.post(
      Uri.parse('$baseUrl/insert-ticket.php'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "user-agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
      },
      body: {
        "ticket": ticket,
        "targa": targa,
        "dataEntrata": actualDate,
      },
    ).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        return http.Response('{TimeOut}', 408);
      },
    );

    print(response.statusCode);

    if (response.statusCode != 200) {
      navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) =>
              ErrorPage(message: "Errore nell inserire il ticket")));
    }
  }
}
