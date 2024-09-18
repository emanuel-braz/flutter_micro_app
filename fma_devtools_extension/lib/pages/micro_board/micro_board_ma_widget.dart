import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

import 'micro_board_card_handlers.dart';
import 'micro_board_card_routes.dart';

class MicroBoardItemWidget extends StatelessWidget {
  final MicroBoardApp app;
  final List<String> conflictingChannels;

  const MicroBoardItemWidget(this.app,
      {required this.conflictingChannels, super.key});

  @override
  Widget build(BuildContext context) {
    final description = app.description;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.grey[100] : Colors.grey[800];

    return Card(
      color: isDark ? Colors.grey[800] : Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '<${app.type}>',
              style: TextStyle(
                fontSize: 12,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4, top: 0),
              child: Text(
                app.name,
                style: TextStyle(fontSize: 24, color: textColor),
              ),
            ),
            if (description.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.only(left: 4, right: 4, top: 0, bottom: 4),
                child: Text(
                  description,
                  style: TextStyle(fontSize: 14, color: textColor),
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
