import 'package:devtools_app_shared/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

import '../../controllers/fma_controller.dart';

class MicroAppList extends StatefulWidget {
  const MicroAppList({super.key});

  @override
  State<MicroAppList> createState() => _MicroAppListState();
}

class _MicroAppListState extends State<MicroAppList> {
  List<MicroBoardRoute> pages = [];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Micro Apps',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Pages',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
          ],
        ),
        Expanded(
          child: SplitPane(
            axis: Axis.horizontal,
            initialFractions: const [0.3, 0.7],
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: isDark
                          ? Colors.black87
                          : Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
                child: ValueListenableBuilder(
                    valueListenable: FmaController(),
                    builder: (context, value, child) {
                      return ListView.builder(
                        itemCount: value.microBoardData.microApps.length,
                        itemBuilder: (context, index) {
                          final microApp =
                              value.microBoardData.microApps[index];
                          return ListTile(
                            onTap: () {
                              setState(() {
                                pages = microApp.pages;
                              });
                            },
                            title: Text(microApp.name),
                          );
                        },
                      );
                    }),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: isDark
                          ? Colors.black87
                          : Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
                child: ListView.builder(
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return Card(
                      color: isDark
                          ? Colors.black
                          : Theme.of(context).secondaryHeaderColor,
                      child: ListTile(
                        title: Text(page.route,
                            style: Theme.of(context).textTheme.titleLarge),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (page.description.isNotEmpty)
                              Text(page.description),
                            if (page.widget.isNotEmpty)
                              Text(page.widget,
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
