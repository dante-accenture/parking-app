import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import '../main.dart';
import '../pages/error.dart';
import 'database_api.dart';

Future<void> downloadFileCSV() async {
  String? dir;

  if (Platform.isAndroid) {
    dir = await FilesystemPicker.open(
      title: 'Seleziona la cartella dove salvare il file',
      context: navigatorKey.currentContext!,
      rootDirectory: Directory("/storage/emulated/0"),
      fsType: FilesystemType.folder,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );
  } else {
    await getDownloadsDirectory().then((value) => dir = value!.path);
  }

  // get directory

  if (dir == null) {
    return;
  }

  // create file
  DateTime now = DateTime.now();
  String actualDate = "${now.day}-${now.month}-${now.year}";
  var file = File('$dir/targhe-$actualDate.csv');

  // get the csv from API
  http.Response response = await http.post(
    Uri.parse('$baseUrl/db2csv.php'),
    headers: {
      "Access-Control-Allow-Origin": "*",
      "user-agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
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
            ErrorPage(message: "Errore nella creazione del file")));
  }

  await file.writeAsString(response.body);

  Alert(
    context: navigatorKey.currentContext!,
    type: AlertType.success,
    title: "File salvato!",
    desc: "Il file è stato salvato in $dir",
    buttons: [
      DialogButton(
        child: const Text("OK"),
        onPressed: () {
          Navigator.pop(navigatorKey.currentContext!);
        },
      ),
    ],
  ).show();
}
