import 'package:flutter/material.dart';
import 'package:parking_app/controller/database_api.dart';
import 'package:parking_app/pages/insert_ticket.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../main.dart';
import '../pages/insert_targa.dart';
import 'input_control.dart';
import 'layout.dart';

class VirtualKeyboard extends StatefulWidget {
  @override
  _VirtualKeyboardState createState() => _VirtualKeyboardState();
}

class _VirtualKeyboardState extends State<VirtualKeyboard> {
  final _inputControl = VirtualKeyboardControl();

  @override
  void initState() {
    super.initState();
    _inputControl.register();
  }

  @override
  void dispose() {
    _inputControl.unregister();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      canRequestFocus: false,
      child: TextFieldTapRegion(
        child: Container(
          color: Colors.blue[900],
          height: MediaQuery.of(context).size.height / 2,
          child: ValueListenableBuilder<TextInputLayout>(
              valueListenable: _inputControl.layout,
              builder: (_, layout, __) {
                return Column(
                  children: [
                    for (final keys in layout.keys)
                      Expanded(
                        child: ValueListenableBuilder<bool>(
                            valueListenable: _inputControl.attached,
                            builder: (_, attached, __) {
                              return VirtualKeyboardRow(
                                keys: keys,
                                enabled: attached,
                                onInput: _handleKeyPress,
                              );
                            }),
                      ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  void _handleKeyPress(String key) {
    _inputControl.processInput(key);
  }
}

class VirtualKeyboardRow extends StatelessWidget {
  final bool _enabled;
  final List<String> _keys;
  final ValueSetter<String> _onInput;

  VirtualKeyboardRow({
    required bool enabled,
    required List<String> keys,
    required ValueSetter<String> onInput,
  })  : _enabled = enabled,
        _keys = keys,
        _onInput = onInput;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final key in _keys)
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: RawMaterialButton(
                onPressed: _enabled
                    ? key == "CANC."
                        ? () => handleBackspace()
                        : key == "INVIO"
                            ? () => handleEnter()
                            : () => handleInput(key)
                    : null,
                child: Center(
                    child: Text(key,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color:
                                key == "CANC." ? Colors.red : Colors.white))),
              ),
            ),
          ),
      ],
    );
  }
}

void handleBackspace() {
  final controller = ticketController;
  if (controller.text.isNotEmpty) {
    controller.text = controller.text.substring(0, controller.text.length - 1);
  }
}

void handleEnter() async {
  if (RegExp(r'^[0-9]*$').hasMatch(ticketController.text) &&
      ticketController.text.length == 4) {
    var list = await getOnlyTicketApi(ticketController.text);
    if (list.isNotEmpty) {
      ticketController.clear();
      Alert(
        context: navigatorKey.currentContext!,
        type: AlertType.error,
        title: "ERRORE",
        desc: "Il ticket è gia stato inserito e non è più valido",
        buttons: [],
        closeIcon: const SizedBox.shrink(),
      ).show();
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.pushReplacement(navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => InsertTicketPage(true)));
      });
    } else {
      navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => TargaInsertPage(true, ticketController.text)));
    }
  } else {
    ticketController.clear();
    Alert(
      context: navigatorKey.currentContext!,
      type: AlertType.error,
      title: "ERRORE",
      desc: "Il ticket inserito non è corretto",
      buttons: [],
      closeIcon: const SizedBox.shrink(),
    ).show();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => InsertTicketPage(true)));
    });
  }
}

void handleInput(String key) {
  ticketController.text += key;
  ticketController.selection.end;
}
