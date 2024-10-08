import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

class MicroBoardCardHandlers extends StatelessWidget {
  final List<String> conflictingChannels;
  const MicroBoardCardHandlers({
    required this.conflictingChannels,
    super.key,
    required this.app,
  });

  final MicroBoardApp app;

  @override
  Widget build(BuildContext context) {
    final handlers = app.handlers;

    return Card(
      margin: const EdgeInsets.all(4),
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Handlers',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[900],
                      )),
                ),
                const Spacer(),
                Chip(
                  backgroundColor: Theme.of(context).primaryColor,
                  label: Text(handlers.length.toString(),
                      style: TextStyle(fontSize: 14, color: Colors.grey[200])),
                )
              ],
            ),
            if (handlers.isNotEmpty)
              const Divider(
                thickness: 2,
              ),
            ...handlers.map((e) {
              final channels = List.from(e.channels);
              final conflicts = List.from(conflictingChannels);
              channels.removeWhere((item) => !conflicts.contains(item));

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadowColor: Colors.blue[200],
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chip(
                        label: Text(e.type,
                            style: const TextStyle(color: Colors.black)),
                        backgroundColor: e.type == Constants.notTyped
                            ? Colors.amber
                            : Colors.blue[200],
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        runSpacing: 0,
                        children: e.channels
                            .map((e) => Chip(
                                label: Text(
                                  e,
                                  style: TextStyle(
                                      color: conflicts.contains(e)
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                backgroundColor: conflicts.contains(e)
                                    ? Colors.red
                                    : Colors.green[200]))
                            .toList(),
                      )
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
