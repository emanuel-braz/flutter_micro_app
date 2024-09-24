import 'package:flutter/material.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';

class MicroAppList extends StatefulWidget {
  final List<MicroBoardApp> microApps;
  final void Function()? updateView;

  const MicroAppList(
      {super.key, required this.microApps, required this.updateView});

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
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.microApps.length,
                  itemBuilder: (context, index) {
                    final microApp = widget.microApps[index];
                    return ListTile(
                      onTap: () {
                        setState(() {
                          pages = microApp.pages;
                        });
                      },
                      title: Text(microApp.name),
                    );
                  },
                ),
              ),
              Expanded(
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
