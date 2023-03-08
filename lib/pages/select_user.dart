import 'package:flutter/material.dart';
import 'package:parking_app/pages/admin.dart';
import 'package:parking_app/pages/insert_ticket.dart';

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
        backgroundColor: Colors.white60,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('lib/assets/logo-tondo.png'),
        ),
        title: Text(
          "Seleziona il tipo di utenza",
          style: TextStyle(color: Colors.blue[900]),
        ),
        centerTitle: true,
      ),
      body: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900]),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InsertTicketPage(false)),
                    );
                  },
                  child: const Text("UTENTE", style: TextStyle(fontSize: 20))),
              const SizedBox(height: 30),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900]),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminView()),
                    );
                  },
                  child: const Text("ADMIN", style: TextStyle(fontSize: 20))),
            ],
          ),
        ),
      ),
    );
  }
}
