import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parking_app/pages/edit.dart';
import 'package:parking_app/pages/select_user.dart';

import 'model/db_model.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MaterialApp(
        title: '3EM Parking',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          "/": (context) => const SelectUserPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == "/edit") {
            final args = settings.arguments as TargaModel;

            return MaterialPageRoute(
              builder: (context) {
                return EditPage(targaModel: args);
              },
            );
          }
          return null;
        });
  }
}
