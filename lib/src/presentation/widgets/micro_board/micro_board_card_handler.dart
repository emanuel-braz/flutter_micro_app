import 'package:flutter/material.dart';

import '../../../entities/micro_board/micro_board_handler.dart';
import '../../../utils/constants/constants.dart';

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
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  child: Text(title,
                      style: TextStyle(fontSize: 18, color: titleColor)),
                ),
                Spacer(),
                Chip(
                  backgroundColor: titleColor ?? Theme.of(context).primaryColor,
                  label: Text(widgetHandlers.length.toString(),
                      style: TextStyle(fontSize: 14, color: Colors.grey[200])),
                )
              ],
            ),
            Divider(
              thickness: 2,
            ),
            ...widgetHandlers
                .map((e) => MicroBoardHandlerCardItem(
                      e,
                      conflictingChannels: conflictingChannels,
                    ))
                .toList(),
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(3, 3),
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
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
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
                      label: Text(_microBoardHandler.type),
                      backgroundColor:
                          _microBoardHandler.type == Constants.notTyped
                              ? Colors.amber
                              : Colors.blue[200],
                    ),
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
                                          : null),
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
