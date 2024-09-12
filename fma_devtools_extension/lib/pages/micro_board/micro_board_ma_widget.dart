import 'package:flutter/material.dart';

import '../../src/models/micro_board_app.dart';
import 'micro_board_card_handlers.dart';
import 'micro_board_card_routes.dart';

class MicroBoardItemWidget extends StatelessWidget {
  final MicroBoardApp app;
  final List<String> conflictingChannels;
  const MicroBoardItemWidget(this.app,
      {required this.conflictingChannels, super.key});

  @override
  Widget build(BuildContext context) {
    final description = app.description ?? '';

    return Card(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '<${app.type}>',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(left: 4, right: 4, top: 0),
              child: Text(
                app.name,
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            if (description.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4, top: 0, bottom: 4),
                child: Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            MicroBoardCardRoutes(app: app),
            MicroBoardCardHandlers(
                app: app, conflictingChannels: conflictingChannels),
          ],
        ),
      ),
    );
  }
}
