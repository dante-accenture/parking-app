import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:parking_app/controller/database_api.dart';
import 'package:parking_app/pages/insert_ticket.dart';
import '../model/db_model.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  late Future<List<TargaModel>> targhe;

  @override
  void initState() {
    super.initState();

    setState(() {
      targhe = getTargheApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        title: Container(
          width: 300,
          child: Image.asset(
            'lib/assets/logo-3.png',
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InsertTicketPage(true)));
              },
              color: Colors.blue[900],
              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: targhe,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return DataTable2(
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 600,
                    columns: const [
                      DataColumn2(
                        label: Text('Targa', style: TextStyle(fontSize: 20)),
                        size: ColumnSize.L,
                      ),
                      DataColumn(
                        label: Text('Data Entrata',
                            style: TextStyle(fontSize: 20)),
                      ),
                      DataColumn(
                        label:
                            Text('Data Uscita', style: TextStyle(fontSize: 20)),
                      ),
                      DataColumn(
                        label: Text('Modifica', style: TextStyle(fontSize: 20)),
                      ),
                      DataColumn(
                        label: Text('Elimina', style: TextStyle(fontSize: 20)),
                      ),
                    ],
                    rows:
                        List<DataRow>.generate(snapshot.data!.length, (index) {
                      return DataRow(
                        cells: [
                          DataCell(Text(snapshot.data![index].targa,
                              style: const TextStyle(fontSize: 20))),
                          DataCell(Text(snapshot.data![index].dataEntrata,
                              style: const TextStyle(fontSize: 20))),
                          DataCell(Text(
                              snapshot.data![index].dataUscita! == "null"
                                  ? "N/D"
                                  : snapshot.data![index].dataUscita!,
                              style: const TextStyle(fontSize: 20))),
                          DataCell(
                              const Text("Clicca per modificare",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 20)),
                              showEditIcon: true, onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, "/edit",
                                arguments: snapshot.data![index]);
                          }),
                          DataCell(
                              Row(
                                children: const [
                                  Expanded(
                                    child: Text("Clicca per eliminare",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ],
                              ), onTap: () async {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title:
                                          const Text('Azione irreversibile!'),
                                      content: const Text(
                                          "Vuoi eliminare questa targa?\nL'azione non è reversibile"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Annulla'),
                                          child: const Text('Annulla'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await deleteTargaApi(
                                              snapshot.data![index].id,
                                            );

                                            Navigator.pop(context);

                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AdminView()));
                                          },
                                          child: const Text('ELIMINA'),
                                        ),
                                      ],
                                    ));
                          })
                        ],
                      );
                    }));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
