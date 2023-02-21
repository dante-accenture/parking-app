import 'package:flutter/material.dart';
import 'package:parking_app/pages/admin.dart';
import 'package:parking_app/pages/home.dart';

class SelectUserPage extends StatefulWidget {
  const SelectUserPage({Key? key}) : super(key: key);

  @override
  State<SelectUserPage> createState() => _SelectUserPageState();
}

class _SelectUserPageState extends State<SelectUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleziona il tipo di utenza"),
        centerTitle: true,
      ),
      body: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeParking(false)),
                );
              }, child: const Text("UTENTE", style: TextStyle(fontSize: 20))),
              const SizedBox(height: 30),
              ElevatedButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminView()),
                );
              }, child: const Text("ADMIN", style: TextStyle(fontSize: 20))),
            ],
          ),
        ),
      ),
    );
  }
}
