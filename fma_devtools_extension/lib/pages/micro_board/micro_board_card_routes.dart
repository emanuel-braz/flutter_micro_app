import 'package:flutter/material.dart';

import '../../src/models/micro_board_app.dart';

class MicroBoardCardRoutes extends StatelessWidget {
  const MicroBoardCardRoutes({
    super.key,
    required this.app,
  });

  final MicroBoardApp app;

  @override
  Widget build(BuildContext context) {
    final pages = app.pages ?? [];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDark ? Colors.grey[800] : Theme.of(context).secondaryHeaderColor;
    final textColor = isDark ? Colors.grey[100] : Colors.grey[900];

    return Card(
      margin: const EdgeInsets.all(4),
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Routes',
                      style: TextStyle(fontSize: 18, color: Colors.grey[900])),
                ),
                const Spacer(),
                Chip(
                  backgroundColor: Theme.of(context).primaryColor,
                  label: Text(pages.length.toString(),
                      style: TextStyle(fontSize: 14, color: Colors.grey[200])),
                )
              ],
            ),
            const Divider(
              thickness: 2,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: pages.map((page) {
                return Container(
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
                    margin: const EdgeInsets.only(
                        left: 4, right: 4, top: 6, bottom: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Text(
                            page.name.isNotEmpty
                                ? page.name
                                : page.widget.isNotEmpty
                                    ? page.widget
                                    : "Widget",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                        if (page.description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 4),
                            child: Text(
                              page.description,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[100]),
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: cardColor,
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'route: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor),
                              ),
                              Expanded(
                                  child: Text(page.route,
                                      style: TextStyle(color: textColor))),
                            ],
                          ),
                        )
                      ],
                    ));
              }).toList(),
            ),
            const SizedBox(
              height: 6,
            )
          ],
        ),
      ),
    );
  }
}
