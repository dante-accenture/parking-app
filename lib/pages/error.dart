import 'package:flutter/material.dart';


class ErrorPage extends StatefulWidget {
  String message;
  ErrorPage({required this.message, Key? key}) : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ERRORE"),
        centerTitle: true,

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("ERRORE NELL OPERAZIONE!", style: TextStyle(color: Colors.red, fontSize: 35, fontWeight: FontWeight.bold)),
            Text("MESSAGGIO: ${widget.message}", style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const Text("Contatta il personale per ulteriori istruzioni", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}
