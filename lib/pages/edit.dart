import 'package:flutter/material.dart';
import 'package:parking_app/controller/database_api.dart';

import '../model/db_model.dart';
import 'admin.dart';

class EditPage extends StatefulWidget {
  TargaModel targaModel;

  EditPage({required this.targaModel, Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController targaController = TextEditingController();
  TextEditingController uscitaController = TextEditingController();
  TextEditingController entrtaController = TextEditingController();
  TextEditingController ticketController = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      targaController.text = widget.targaModel.targa;
      entrtaController.text = widget.targaModel.dataEntrata;
      ticketController.text =
          widget.targaModel.ticket == "null" ? "" : widget.targaModel.ticket;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        title: SizedBox(
          width: 300,
          child: Image.asset(
            'lib/assets/logo-3.png',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
            color: Colors.blue[900],
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AdminView()));
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AdminView()));
          return true;
        },
        child: SingleChildScrollView(
          child: Form(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: targaController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text(
                          'Targa',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: entrtaController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text(
                          'Data Entrata',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: ticketController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text(
                          'Ticket',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900]),
                      onPressed: () async {
                        if (targaController.text.isNotEmpty &&
                            entrtaController.text.isNotEmpty) {
                          await updateFullTargaApi(
                              id: widget.targaModel.id,
                              dataEntrata: entrtaController.text,
                              targa: targaController.text,
                              ticket: ticketController.text.isEmpty == true
                                  ? "null"
                                  : ticketController.text);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Dati aggiornati correttamente"),
                          ));
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AdminView()));
                        } else {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Attenzione!'),
                                    content: const Text(
                                        'I campi TARGA e DATA ENTRATA sono obbligatori.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ));
                        }
                      },
                      child: const Text("Salva")),
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
