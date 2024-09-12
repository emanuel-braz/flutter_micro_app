import 'package:flutter/material.dart';

import '../../src/models/micro_board_app.dart';
import 'constants.dart';

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
    final handlers = app.handlers ?? [];

    return Card(
      margin: EdgeInsets.all(4),
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
                  child: Text('Handlers', style: TextStyle(fontSize: 18)),
                ),
                Spacer(),
                Chip(
                  backgroundColor: Theme.of(context).primaryColor,
                  label: Text(handlers.length.toString(),
                      style: TextStyle(fontSize: 14, color: Colors.grey[200])),
                )
              ],
            ),
            if (handlers.isNotEmpty)
              Divider(
                thickness: 2,
              ),
            ...handlers.map((e) {
              final channels = List.from(e.channels);
              final conflicts = List.from(conflictingChannels);
              channels.removeWhere((item) => !conflicts.contains(item));
              final containsConflict = channels.isNotEmpty;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadowColor: Colors.blue[200],
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chip(
                        label: Text(e.type),
                        backgroundColor: e.type == Constants.notTyped
                            ? Colors.amber
                            : Colors.blue[200],
                      ),
                      Wrap(
                        spacing: 4,
                        runSpacing: 0,
                        children: e.channels
                            .map((e) => Chip(
                                label: Text(
                                  e,
                                  style: TextStyle(
                                      color: containsConflict
                                          ? Colors.white
                                          : null),
                                ),
                                backgroundColor: containsConflict
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
