import 'dart:convert';

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

class EventDispatcher extends StatefulWidget {
  const EventDispatcher({super.key});

  @override
  State<EventDispatcher> createState() => _EventDispatcherState();
}

class _EventDispatcherState extends State<EventDispatcher> {
  final TextEditingController _txtChannels = TextEditingController();
  final TextEditingController _txtEventName = TextEditingController();
  final TextEditingController _txtPayload = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Micro App Event Dispatcher'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _txtChannels,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Channels*',
                  hintText: 'Comma separated channels',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _txtEventName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Event name',
                  hintText: 'optional',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _txtPayload,
                maxLines: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Payload',
                  hintText: 'JSON or String payload',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _dispatch,
                  child: const Text('Send Event'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _txtChannels.clear();
                    _txtEventName.clear();
                    _txtPayload.clear();
                  },
                  child: const Text('Clear'),
                ),
              ],
            )
          ],
        ));
  }

  Future<void> _dispatch() async {
    if (_txtChannels.text.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Channels is required!',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final channels = _txtChannels.text.trim().split(',');
    final payload = _txtPayload.text;
    final eventName = _txtEventName.text.trim();

    final event = {
      "channels": channels,
      "payload": payload,
      "name": eventName,
    };

    serviceManager.callServiceExtensionOnMainIsolate(
        'ext.dev.emanuelbraz.fma.devtoolsToExtensionMicroAppEvent',
        args: {
          'event': jsonEncode(event),
        });

    // show snackbar
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Event dispatched!'),
    ));
  }
}
