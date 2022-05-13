import 'package:flutter/material.dart';

FloatingActionButton getHomeButton(BuildContext context) {
  return FloatingActionButton.extended(
    onPressed: () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    },
    label: const Text("Go back to home"),
    icon: const Icon(Icons.home_rounded),
    backgroundColor: Colors.deepPurpleAccent,
  );
}