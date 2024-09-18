import 'package:flutter/material.dart';

class ModalExamplePage extends PopupRoute {
  final String title;
  final String subTitle;

  ModalExamplePage(String description, this.subTitle, {required this.title});

  @override
  Widget buildPage(
      BuildContext context, Animation animation, Animation secondaryAnimation) {
    return AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                title,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CLOSE MODAL'),
            ),
          ],
        ));
  }

  @override
  Color? get barrierColor => Colors.black26;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}

class PopupExamplePage extends StatelessWidget {
  final String title;

  const PopupExamplePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                title,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CLOSE MODAL'),
            ),
          ],
        ));
  }
}
