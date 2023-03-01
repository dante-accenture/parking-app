import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../controller/database.dart';
import '../main.dart';
import '../pages/error.dart';
import '../pages/home.dart';
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
                            : () => _onInput(key)
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
  final controller = targaController;
  if (controller.text.isNotEmpty) {
    final value = controller.value;
    final selection = controller.selection;

    // erase selection vs. previous char
    final start = selection.isCollapsed ? selection.start - 1 : selection.start;
    final text = value.text.replaceRange(start, selection.end, '');

    controller.value = value.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: start),
    );
  }
}

void handleEnter() async {
  if (formKey.currentState!.validate()) {
    try {
      await checkTarga(targaController.text);
      targaController.clear();
      Alert(
        context: navigatorKey.currentContext!,
        type: AlertType.success,
        title: "TARGA INSERITA!!",
        desc: "Targa inserita correttamente.",
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(navigatorKey.currentContext!),
            width: 120,
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    } on MySqlException catch (e) {
      navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => ErrorPage(message: e.message)));
    }
  }
}
