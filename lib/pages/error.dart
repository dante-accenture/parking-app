import 'package:flutter/material.dart';
import 'package:parking_app/widget/3em_banner.dart';

class ErrorPage extends StatefulWidget {
  String message;
  ErrorPage({required this.message, Key? key}) : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pop(context);
    });

    return Scaffold(
      body: Column(
        children: [
          const TreEMbanner(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 200),
                const Text(
                  "ERRORE NELL OPERAZIONE!",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "MESSAGGIO: ${widget.message}",
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const Text(
                  "Contatta il personale per ulteriori istruzioni",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  "Ritorno all operazione in 5 secondi",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
