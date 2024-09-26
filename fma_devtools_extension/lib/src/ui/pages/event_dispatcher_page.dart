import 'dart:convert';

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

import '../../controllers/fma_controller.dart';

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
    return ValueListenableBuilder(
        valueListenable: FmaController(),
        builder: (context, value, child) {
          final allChannels = <String>{};

          for (var app in value.microBoardData.microApps) {
            final handlers = app.handlers;
            for (var handler in handlers) {
              allChannels.addAll(handler.channels);
            }
          }

          for (var handler in value.microBoardData.orphanHandlers) {
            allChannels.addAll(handler.channels);
          }

          for (var handler in value.microBoardData.widgetHandlers) {
            allChannels.addAll(handler.channels);
          }

          return Scaffold(
              appBar: AppBar(
                title: const Text('Micro App Event Dispatcher'),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return allChannels.where((String option) {
                          return option
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onFieldSubmitted) {
                        controller.addListener(() {
                          _txtChannels.text = controller.value.text;
                        });

                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Channel',
                            hintText: 'Comma separated channels',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          onFieldSubmitted: (value) {
                            onFieldSubmitted();
                          },
                        );
                      },
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
        });
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
    final payload = _jsonTryDecode(_txtPayload.text);
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

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Event dispatched!'),
    ));
  }

  _jsonTryDecode(String payload) {
    try {
      return jsonDecode(payload);
    } catch (_) {
      return payload;
    }
  }
}
