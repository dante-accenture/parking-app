import 'package:flutter/material.dart';

import '../kayboard-ticket/keyboard.dart';
import '../main.dart';
import 'insert_targa.dart';

class InsertTicketPage extends StatefulWidget {
  bool showKeyboard;
  InsertTicketPage(this.showKeyboard, {Key? key}) : super(key: key);

  @override
  State<InsertTicketPage> createState() => _InsertTicketPageState();
}

class _InsertTicketPageState extends State<InsertTicketPage> {
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
      appBar: AppBar(
        backgroundColor: Colors.white60,
        elevation: 4,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: SizedBox(
          width: 300,
          child: Image.asset(
            'lib/assets/logo-3.png',
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return !widget.showKeyboard;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  "lib/assets/ticket-tutorial.png",
                  width: 230,
                  height: 230,
                ),
                Form(
                  key: formKeyTicket,
                  child: TextFormField(
                    controller: ticketController,
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
                        borderSide: const BorderSide(
                            color: Color(0xff000000), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: const BorderSide(
                            color: Color(0xff000000), width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      errorStyle: const TextStyle(fontSize: 30),
                      labelText: "Inserisci il ticket",
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
                        return "Inserisci il ticket";
                      }

                      if (RegExp(r'^[0-9]*$').hasMatch(value)) {
                        return null;
                      } else {
                        ticketController.clear();
                        focus.requestFocus();
                        return "Inserisci il ticket correttamente";
                      }
                    },
                    onFieldSubmitted: (value) async {
                      if (formKeyTicket.currentState!.validate()) {
                        navigatorKey.currentState!.push(MaterialPageRoute(
                            builder: (context) => TargaInsertPage(
                                widget.showKeyboard, ticketController.text)));
                      }
                    },
                  ),
                ),
                const SizedBox(height: 5),
                widget.showKeyboard == false
                    ? const SizedBox.shrink()
                    : VirtualKeyboard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
