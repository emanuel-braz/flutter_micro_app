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
    return Card(
      margin: EdgeInsets.all(4),
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Routes', style: TextStyle(fontSize: 18)),
                ),
                Spacer(),
                Chip(
                  backgroundColor: Theme.of(context).primaryColor,
                  label: Text(pages.length.toString(),
                      style: TextStyle(fontSize: 14, color: Colors.grey[200])),
                )
              ],
            ),
            Divider(
              thickness: 2,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: pages
                  .map((e) => Container(
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
                      margin:
                          EdgeInsets.only(left: 4, right: 4, top: 6, bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              e.widget.isNotEmpty ? e.widget : "Widget",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                          if (e.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 4),
                              child: Text(
                                e.description,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[100]),
                              ),
                            ),
                          Container(
                            padding: EdgeInsets.all(8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(
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
                                      color: Colors.grey[700]),
                                ),
                                Expanded(child: Text(e.route)),
                              ],
                            ),
                          )
                        ],
                      )))
                  .toList(),
            ),
            SizedBox(
              height: 6,
            )
          ],
        ),
      ),
    );
  }
}
