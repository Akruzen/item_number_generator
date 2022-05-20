/// Program by Omkar Phadke, Pune Institute of Computer Technology, in May 2022

import 'package:flutter/material.dart';

FloatingActionButton getHomeButton(BuildContext context) {
  return FloatingActionButton(
    child: const Icon(Icons.home_rounded),
    onPressed: () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    },
    backgroundColor: Colors.deepPurpleAccent,
  );
}