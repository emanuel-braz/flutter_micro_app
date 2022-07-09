import 'package:flutter/material.dart';
import 'package:flutter_micro_app/src/entities/micro_board/micro_board_app.dart';
import 'package:flutter_micro_app/src/utils/constants/constants.dart';

class MicroBoardItemWidget extends StatelessWidget {
  final MicroBoardApp app;
  const MicroBoardItemWidget(this.app, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                app.name,
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '<${app.type}>',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            if (app.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  app.description,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            Card(
              margin: EdgeInsets.all(4),
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text('Base Route:', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 4),
                        Chip(
                          label: Text(app.route),
                          backgroundColor: Colors.blueGrey[200],
                        )
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Wrap(
                      spacing: 4,
                      runSpacing: 0,
                      children: app.pages
                          .map((e) => Chip(
                              backgroundColor: Colors.blueGrey[350],
                              label: Text(
                                  '/${e.route}${e.widget.isNotEmpty ? "<${e.widget}>" : ""}')))
                          .toList(),
                    )
                  ],
                ),
              ),
            ),
            Card(
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
                          child:
                              Text('Handlers', style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    ...app.handlers
                        .map((e) => Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Card(
                                    shadowColor: Colors.blue[200],
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                        Colors.green[200]))
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
            ),
          ],
        ),
      ),
    );
  }
}
