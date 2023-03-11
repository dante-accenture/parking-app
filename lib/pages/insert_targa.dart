import 'package:flutter/material.dart';
import 'package:parking_app/widget/3em_banner.dart';

import '../controller/database_api.dart';
import '../kayboard-targa/keyboard.dart';
import '../main.dart';
import 'admin.dart';

class TargaInsertPage extends StatefulWidget {
  bool showKeyboard;
  String ticket;

  TargaInsertPage(this.showKeyboard, this.ticket, {super.key});

  @override
  State<TargaInsertPage> createState() => _TargaInsertPageState();
}

class _TargaInsertPageState extends State<TargaInsertPage> {
  FocusNode focus = FocusNode();

  @override
  void initState() {
    super.initState();
    focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const TreEMbanner(),
          const Text(
            "INSERIRE NUMERO DI TARGA:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 45,
            ),
          ),
          Form(
            key: formKeyTarga,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: targaController,
                textAlign: TextAlign.center,
                showCursor: false,
                maxLines: 1,
                focusNode: focus,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 35,
                  color: Color(0xff000000),
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide:
                        const BorderSide(color: Color(0xff000000), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide:
                        const BorderSide(color: Color(0xff000000), width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  errorStyle: const TextStyle(fontSize: 30),
                  labelText: "Inserisci la targa",
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 25,
                    color: Color(0xff000000),
                  ),
                  filled: false,
                  contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Inserisci la targa";
                  }

                  if (RegExp(r'^[a-zA-Z0-9]*$').hasMatch(value)) {
                    return null;
                  } else {
                    targaController.clear();
                    focus.requestFocus();
                    return "Inserisci la targa correttamente";
                  }
                },
                onFieldSubmitted: (value) async {
                  if (formKeyTarga.currentState!.validate()) {
                    await insertAPIticket(targaController.text, widget.ticket);
                    targaController.clear();
                    navigatorKey.currentState!.pop();
                    navigatorKey.currentState!.pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const AdminView()));
                  }
                },
              ),
            ),
          ),
          const Text("Premi INVIO per confermare e CANC. per eliminare",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          widget.showKeyboard == false
              ? const SizedBox.shrink()
              : VirtualKeyboard(),
        ],
      ),
    );
  }
}
