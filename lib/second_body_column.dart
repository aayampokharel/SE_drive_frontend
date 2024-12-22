import 'package:flutter/material.dart';

class SecondBodyColumn extends StatefulWidget {
  String headingValue;
  SecondBodyColumn(this.headingValue);

  @override
  State<SecondBodyColumn> createState() => _SecondBodyColumnState();
}

class _SecondBodyColumnState extends State<SecondBodyColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Center(child: Text(widget.headingValue)),
    ]);
  }
}
