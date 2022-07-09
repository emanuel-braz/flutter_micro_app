import 'package:flutter/material.dart';
import 'package:flutter_micro_app/src/entities/micro_board/micro_board_handler.dart';
import 'package:flutter_micro_app/src/utils/constants/constants.dart';

class HandlersWidget extends StatelessWidget {
  final List<MicroBoardHandler> widgetHandlers;
  final String title;
  final Color? titleColor;
  const HandlersWidget(
      {required this.widgetHandlers,
      required this.title,
      this.titleColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4),
      color: Colors.grey[200],
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
              ],
            ),
            Divider(
              thickness: 2,
            ),
            ...widgetHandlers
                .map((e) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                            shadowColor: Colors.blue[200],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Chip(
                                    label: Text(e.type),
                                    backgroundColor:
                                        e.type == Constants.notTyped
                                            ? Colors.amber
                                            : Colors.blue[200],
                                  ),
                                  Wrap(
                                    spacing: 4,
                                    runSpacing: 0,
                                    children: e.channels
                                        .map((e) => Chip(
                                              label: Text(e),
                                              backgroundColor:
                                                  Colors.green[200],
                                            ))
                                        .toList(),
                                  )
                                ],
                              ),
                            ))
                      ],
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
