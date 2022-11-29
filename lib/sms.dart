import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:trabajo_moviles/main.dart';

void main() => runApp(SmsApp());

class SmsApp extends StatefulWidget {
  @override
  _SmsAppState createState() => _SmsAppState();
}

class _SmsAppState extends State<SmsApp> {
  late TextEditingController _controllerPeople, _controllerMessage;
  String? _message, body;
  List<String> people = [];
  bool sendDirect = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _controllerPeople = TextEditingController();
    _controllerMessage = TextEditingController();
  }

  Future<void> _sendSMS(List<String> recipients) async {
    try {
      String _result = await sendSMS(
        message: _controllerMessage.text,
        recipients: recipients,
        sendDirect: sendDirect,
      );
      setState(() => _message = _result);
    } catch (error) {
      print(error);
      setState(() => _message = error.toString());
    }
  }

  Widget _phoneTile(String name) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
            top: BorderSide(color: Colors.grey.shade300),
            left: BorderSide(color: Colors.grey.shade300),
            right: BorderSide(color: Colors.grey.shade300),
          )),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => people.remove(name)),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    name,
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Mensajeria'),
          ),
          body: ListView(
            children: <Widget>[
              if (people.isEmpty)
                const SizedBox(height: 0)
              else
                SizedBox(
                  height: 90,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          List<Widget>.generate(people.length, (int index) {
                        return _phoneTile(people[index]);
                      }),
                    ),
                  ),
                ),
              ListTile(
                leading: const Icon(Icons.people),
                title: TextField(
                  controller: _controllerPeople,
                  decoration: const InputDecoration(
                      labelText: 'Agregar número de telefono'),
                  keyboardType: TextInputType.number,
                  onChanged: (String value) => setState(() {}),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _controllerPeople.text.isEmpty
                      ? null
                      : () => setState(() {
                            people.add(_controllerPeople.text.toString());
                            _controllerPeople.clear();
                          }),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.message),
                title: TextField(
                  decoration:
                      const InputDecoration(labelText: 'Escribir el mensaje'),
                  controller: _controllerMessage,
                  onChanged: (String value) => setState(() {}),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Theme.of(context).colorScheme.secondary),
                    padding: MaterialStateProperty.resolveWith(
                        (states) => const EdgeInsets.symmetric(vertical: 16)),
                  ),
                  onPressed: () {
                    _send();
                  },
                  child: Text(
                    'SEND',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ),
              Visibility(
                visible: _message != null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          _message ?? 'No Data',
                          maxLines: null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyApp()));
            },
            tooltip: 'Volver',
            child: const Icon(Icons.arrow_back),
          ),
        ));
  }

  void _send() {
    if (people.isEmpty) {
      setState(() => _message = 'Complete los campos');
    } else {
      _sendSMS(people);
    }
  }
}
