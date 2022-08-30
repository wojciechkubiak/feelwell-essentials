import 'package:flutter/material.dart';

class ScaffoldWrapper extends StatelessWidget {
  final String title;
  final Widget body;

  const ScaffoldWrapper({Key? key, required this.title, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.grey)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: body,
    );
  }
}
