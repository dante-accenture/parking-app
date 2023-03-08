import 'package:flutter/material.dart';

class InsertTicketPage extends StatefulWidget {
  bool canPop;
  InsertTicketPage(this.canPop, {Key? key}) : super(key: key);

  @override
  State<InsertTicketPage> createState() => _InsertTicketPageState();
}

class _InsertTicketPageState extends State<InsertTicketPage> {
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
          return widget.canPop;
        },
        child: Placeholder(),
      ),
    );
  }
}
