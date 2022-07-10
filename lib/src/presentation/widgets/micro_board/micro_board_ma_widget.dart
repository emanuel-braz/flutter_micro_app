import 'package:flutter/material.dart';

import '../../../entities/micro_board/micro_board_app.dart';
import 'micro_board_card_handlers.dart';
import 'micro_board_card_routes.dart';

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
            if (app.description.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4, top: 0, bottom: 4),
                child: Text(
                  app.description,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            MicroBoardCardRoutes(app: app),
            MicroBoardCardHandlers(app: app),
          ],
        ),
      ),
    );
  }
}
