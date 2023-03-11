import 'package:flutter/material.dart';
import 'package:parking_app/pages/error.dart';
import 'package:parking_app/widget/3em_banner.dart';

import '../controller/database_api.dart';
import '../kayboard-ticket/keyboard.dart';
import '../main.dart';
import 'insert_targa.dart';

class InsertTicketPage extends StatefulWidget {
  bool showKeyboard;
  InsertTicketPage(this.showKeyboard, {Key? key}) : super(key: key);

  @override
  State<InsertTicketPage> createState() => _InsertTicketPageState();
}

FocusNode ticketFocus = FocusNode();

class _InsertTicketPageState extends State<InsertTicketPage> {
  @override
  void initState() {
    super.initState();
    formKeyTicket = GlobalKey<FormState>();
    ticketFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: WillPopScope(
        onWillPop: () async {
          return !widget.showKeyboard;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TreEMbanner(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      "lib/assets/ticket-tutorial.png",
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                    ),
                    Form(
                      key: formKeyTicket,
                      child: TextFormField(
                        controller: ticketController,
                        textAlign: TextAlign.center,
                        showCursor: false,
                        maxLines: 1,
                        focusNode: ticketFocus,
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
                          errorStyle: const TextStyle(fontSize: 30),
                          labelText: "Inserisci il ticket",
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 30,
                            color: Color(0xff000000),
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(12, 8, 12, 8),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Inserisci il ticket";
                          }

                          if (RegExp(r'^[0-9]*$').hasMatch(value) &&
                              value.length == 4) {
                            return null;
                          } else {
                            ticketController.clear();
                            ticketFocus.requestFocus();
                            return "Inserisci il ticket correttamente";
                          }
                        },
                        onFieldSubmitted: (value) async {
                          if (formKeyTicket.currentState!.validate()) {
                            var list =
                                await getOnlyTicketApi(ticketController.text);
                            if (list.isEmpty) {
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                  builder: (context) => TargaInsertPage(
                                      widget.showKeyboard,
                                      ticketController.text)));
                            } else {
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                  builder: (context) => ErrorPage(
                                        message: "Il ticket è gia esistente",
                                      )));
                            }
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
            ],
          ),
        ),
      ),
    );
  }
}
