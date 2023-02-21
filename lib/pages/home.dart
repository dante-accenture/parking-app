import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:parking_app/controller/database.dart';

import 'error.dart';

class HomeParking extends StatefulWidget {
  bool canPop;

  HomeParking(this.canPop, {super.key});

  @override
  State<HomeParking> createState() => _HomeParkingState();
}

class _HomeParkingState extends State<HomeParking> {
  TextEditingController targaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FocusNode focus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Parcheggio",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return widget.canPop;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 30),
              const Text("ATTENZIONE A METTERE LA TARGA!",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: targaController,
                  textAlign: TextAlign.center,
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
                      fontSize: 24,
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
                    if (_formKey.currentState!.validate()) {
                      focus.requestFocus();
                      targaController.clear();

                      try {
                        await checkTarga(targaController.text);

                      } on MySqlException catch (e) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ErrorPage(message: e.message)));
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text("Premi INVIO per confermare",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            ],
          ),
        ),
      ),
    );
  }
}
