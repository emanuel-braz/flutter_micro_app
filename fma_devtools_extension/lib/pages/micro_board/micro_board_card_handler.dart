import 'package:flutter/material.dart';

import '../../src/models/micro_board_handler.dart';
import 'constants.dart';

class MicroBoardHandlerCard extends StatelessWidget {
  final List<MicroBoardHandler> widgetHandlers;
  final String title;
  final Color? titleColor;
  final List<String> conflictingChannels;
  const MicroBoardHandlerCard(
      {required this.widgetHandlers,
      required this.title,
      this.titleColor,
      required this.conflictingChannels,
      super.key});

  @override
  Widget build(BuildContext context) {
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
                  child: Text(title,
                      style: TextStyle(fontSize: 18, color: titleColor)),
                ),
                const Spacer(),
                Chip(
                  backgroundColor: titleColor ?? Theme.of(context).primaryColor,
                  label: Text(widgetHandlers.length.toString(),
                      style: TextStyle(fontSize: 14, color: Colors.grey[200])),
                )
              ],
            ),
            if (widgetHandlers.isNotEmpty)
              const Divider(
                thickness: 2,
              ),
            ...widgetHandlers.map((e) => MicroBoardHandlerCardItem(
                  e,
                  conflictingChannels: conflictingChannels,
                )),
          ],
        ),
      ),
    );
  }
}

class MicroBoardHandlerCardItem extends StatelessWidget {
  final MicroBoardHandler _microBoardHandler;
  final List<String> conflictingChannels;
  const MicroBoardHandlerCardItem(
    this._microBoardHandler, {
    required this.conflictingChannels,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              _microBoardHandler.parentName,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Chip(
                      label: Text(_microBoardHandler.type,
                          style: const TextStyle(
                            color: Colors.black,
                          )),
                      backgroundColor:
                          _microBoardHandler.type == Constants.notTyped
                              ? Colors.amber
                              : Colors.blue[200],
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 0,
                      children: _microBoardHandler.channels
                          .map((e) => Chip(
                                label: Text(
                                  e,
                                  style: TextStyle(
                                      color: conflictingChannels.contains(e)
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                backgroundColor: conflictingChannels.contains(e)
                                    ? Colors.red
                                    : Colors.green[200],
                              ))
                          .toList(),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
