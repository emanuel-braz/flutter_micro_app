import 'package:flutter/material.dart';
import 'package:fma_devtools_extension/src/models/micro_board_webview.dart';

class MicroBoardWebviewControllersCard extends StatelessWidget {
  final List<MicroBoardWebview> webviewControllers;
  final String title;
  final Color? titleColor;

  const MicroBoardWebviewControllersCard({
    required this.webviewControllers,
    required this.title,
    this.titleColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardTheme.color;
    final textColor = Theme.of(context).textTheme.bodyMedium!.color;

    return Card(
      margin: EdgeInsets.all(4),
      color: cardColor,
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
                  label: Text(webviewControllers.length.toString(),
                      style: TextStyle(fontSize: 14, color: textColor)),
                )
              ],
            ),
            if (webviewControllers.isNotEmpty)
              Divider(
                thickness: 2,
              ),
            ...webviewControllers.map((e) => _MicroBoardCardItem(e)),
          ],
        ),
      ),
    );
  }
}

class _MicroBoardCardItem extends StatelessWidget {
  final MicroBoardWebview _webviewController;

  const _MicroBoardCardItem(this._webviewController);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: primaryColor,
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
              _webviewController.parentName ?? '',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_webviewController.name != null)
                      Text(
                        _webviewController.name ?? '',
                        style: TextStyle(color: Colors.grey[800], fontSize: 16),
                      ),
                    if (_webviewController.description != null)
                      Text(
                        _webviewController.description ?? '',
                        style: TextStyle(color: Colors.grey[800], fontSize: 14),
                      ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
